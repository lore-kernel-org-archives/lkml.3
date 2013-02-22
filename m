Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3BVGd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:33:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:11991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab3BVGd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:33:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="290462386"
Message-ID: <51271130.10406@intel.com>
Date: Fri, 22 Feb 2013 14:33:20 +0800
From: xtu4 <xiaobing.tu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chao.bi@intel.com, faouazx.tenoutit@intel.com,
        olivierx.stoltz-douchet@intel.com, yanmin.zhang@intel.com
Subject: [patch] hsi : Avoid race condition between HSI controller and HSI
 client when system restart and power down
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid race condition between HSI controller and HSI client when system 
restart and power down


hsi_isr_tasklet disabled in HSI_controller exit, but before HSI 
controller exit,
HSI client will cleanup, this cleanup will destroy the spinlock used by the
hsi_isr_tasklet,so if after HSI client cleanup, there still such tasklet 
running,
issue will happend. here is the issue stack as below.
hsi-ctrl: WAKEf514b000: f9a800e5 00000010 60000006 00000000 013f5bf9 
582bf9b8 3d565244
hsi-dlp: TTY device close request (mmgr, 133)
hsi-dlp: port shutdown request
mdm_ctrl: Unexpected RESET_OUT 0x0
BUG: spinlock bad magic on CPU#3, zygote/137
lock: f53a0fbc, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Pid: 137, comm: zygote Tainted: G         C  3.0.34-141888-g9e0a6fb #1
Call Trace:
  [<c185c92c>] ? printk+0x1d/0x1f
  [<c1860826>] spin_bug+0xa4/0xac
  [<c14a5d6d>] do_raw_spin_lock+0x7d/0x170
  [<c1866c86>] ? _raw_spin_unlock_irqrestore+0x26/0x50
  [<c1866afc>] _raw_spin_lock_irqsave+0x2c/0x40
  [<c12325d0>] complete+0x20/0x60
  [<c1866c86>] ? _raw_spin_unlock_irqrestore+0x26/0x50
  [<c1576ff9>] dlp_ctrl_complete_tx+0x29/0x40
  [<c1570164>] hsi_isr_tasklet+0x394/0x11a0
  [<c12709f5>] ? sched_clock_cpu+0xe5/0x150
  [<c1251a39>] tasklet_hi_action+0x59/0x120
  [<c12500d8>] ? it_real_fn+0x18/0xb0
  [<c12522ab>] __do_softirq+0x9b/0x220
  [<c1252210>] ? remote_softirq_receive+0x110/0x110
Change-Id: I6a0ca0c14409bfc4cd7a2767a4f203c171ece007
Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
Signed-off-by: chao bi <chao.bi@intel.com>
---
  drivers/hsi/clients/dlp_ctrl.c  |    4 ++++
  drivers/hsi/clients/dlp_flash.c |    5 ++++-
  drivers/hsi/clients/dlp_net.c   |    4 ++++
  drivers/hsi/clients/dlp_trace.c |    1 -
  drivers/hsi/clients/dlp_tty.c   |    5 ++++-
  5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/hsi/clients/dlp_ctrl.c b/drivers/hsi/clients/dlp_ctrl.c
index b09f9e6..e980f0c 100644
--- a/drivers/hsi/clients/dlp_ctrl.c
+++ b/drivers/hsi/clients/dlp_ctrl.c
@@ -394,6 +394,8 @@ static void dlp_ctrl_complete_tx(struct hsi_msg *msg)
      struct dlp_command *dlp_cmd = msg->context;
      struct dlp_channel *ch_ctx = dlp_cmd->channel;

+    if (dlp_drv.channels[DLP_CHANNEL_CTRL] == NULL)
+        return;
      dlp_cmd->status = (msg->status == HSI_STATUS_COMPLETED) ? 0 : -EIO;

      /* Command done, notify the sender */
@@ -433,6 +435,8 @@ static void dlp_ctrl_complete_rx(struct hsi_msg *msg)
      unsigned long flags;
      int hsi_channel, elp_channel, ret, response, msg_complete, state;

+    if (dlp_drv.channels[DLP_CHANNEL_CTRL] == NULL)
+        return;
      /* Copy the reponse */
      memcpy(&params,
             sg_virt(msg->sgt.sgl), sizeof(struct dlp_command_params));
diff --git a/drivers/hsi/clients/dlp_flash.c 
b/drivers/hsi/clients/dlp_flash.c
index 885b73a..b333d74 100644
--- a/drivers/hsi/clients/dlp_flash.c
+++ b/drivers/hsi/clients/dlp_flash.c
@@ -42,7 +42,6 @@
   */
  #define DLP_FLASH_NB_RX_MSG 10

-
  /*
   * struct flashing_driver - HSI Modem flashing driver protocol
   *
@@ -259,6 +258,8 @@ static struct hsi_msg *dlp_boot_rx_dequeue(struct 
dlp_channel *ch_ctx)
  */
  static void dlp_flash_complete_tx(struct hsi_msg *msg)
  {
+    if (dlp_drv.channels[DLP_CHANNEL_FLASH] == NULL)
+        return;
      /* Delete the received msg */
      dlp_pdu_free(msg, -1);
  }
@@ -274,6 +275,8 @@ static void dlp_flash_complete_rx(struct hsi_msg *msg)
      struct dlp_flash_ctx *flash_ctx = ch_ctx->ch_data;
      int ret;

+    if (dlp_drv.channels[DLP_CHANNEL_FLASH] == NULL)
+        return;
      if (msg->status != HSI_STATUS_COMPLETED) {
          pr_err(DRVNAME ": Invalid msg status: %d (ignored)\n",
                  msg->status);
diff --git a/drivers/hsi/clients/dlp_net.c b/drivers/hsi/clients/dlp_net.c
index f3ca817..0c3e672 100644
--- a/drivers/hsi/clients/dlp_net.c
+++ b/drivers/hsi/clients/dlp_net.c
@@ -158,6 +158,8 @@ static void dlp_net_complete_tx(struct hsi_msg *pdu)
      struct dlp_net_context *net_ctx = ch_ctx->ch_data;
      struct dlp_xfer_ctx *xfer_ctx = &ch_ctx->tx;

+    if (dlp_drv.channels[ch_ctx->hsi_channel] == NULL)
+            return;
      /* TX done, free the skb */
      dev_kfree_skb(msg_param->skb);

@@ -197,6 +199,8 @@ static void dlp_net_complete_rx(struct hsi_msg *pdu)
      unsigned int *ptr;
      unsigned long flags;

+    if (dlp_drv.channels[ch_ctx->hsi_channel] == NULL)
+        return;
      /* Pop the CTRL queue */
      write_lock_irqsave(&xfer_ctx->lock, flags);
      dlp_hsi_controller_pop(xfer_ctx);
diff --git a/drivers/hsi/clients/dlp_trace.c 
b/drivers/hsi/clients/dlp_trace.c
index fa91985..0067798 100644
--- a/drivers/hsi/clients/dlp_trace.c
+++ b/drivers/hsi/clients/dlp_trace.c
@@ -84,7 +84,6 @@ static unsigned int log_dropped_data;
  module_param_named(log_dropped_data, log_dropped_data, int, S_IRUGO | 
S_IWUSR);
  #endif

-
  /*
   *
   */
diff --git a/drivers/hsi/clients/dlp_tty.c b/drivers/hsi/clients/dlp_tty.c
index 7774484..47f6697 100644
--- a/drivers/hsi/clients/dlp_tty.c
+++ b/drivers/hsi/clients/dlp_tty.c
@@ -68,7 +68,6 @@ struct dlp_tty_context {
      struct work_struct    do_tty_forward;
  };

-
  /**
   * Push as many RX PDUs  as possible to the controller FIFO
   *
@@ -337,6 +336,8 @@ static void dlp_tty_complete_tx(struct hsi_msg *pdu)
      int wakeup, avail, pending;
      unsigned long flags;

+    if (dlp_drv.channels[DLP_CHANNEL_TTY] == NULL)
+        return;
      /* Recycle or Free the pdu */
      write_lock_irqsave(&xfer_ctx->lock, flags);
      dlp_pdu_delete(xfer_ctx, pdu);
@@ -375,6 +376,8 @@ static void dlp_tty_complete_rx(struct hsi_msg *pdu)
      unsigned long flags;
      int ret;

+    if (dlp_drv.channels[DLP_CHANNEL_TTY] == NULL)
+        return;
      /* Check the received PDU header & seq_num */
      ret = dlp_pdu_header_check(xfer_ctx, pdu);
      if (ret == -EINVAL) {
-- 
1.7.6

