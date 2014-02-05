Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaBEUGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:55118 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbaBEUGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eddie Wai <eddie.wai@broadcom.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 124/213] bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload
Date: Wed, 5 Feb 2014 15:01:19 -0500
Message-ID: <1391630568-49251-125-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d6532207116307eb7ecbfa7b9e02c53230096a50 upstream.

This patch fixes the following kernel panic invoked by uninitialized fields
in the chip initialization for the 1G bnx2 iSCSI offload.

One of the bits in the chip initialization is being used by the latest
firmware to control overflow packets.  When this control bit gets enabled
erroneously, it would ultimately result in a bad packet placement which would
cause the bnx2 driver to dereference a NULL ptr in the placement handler.

This can happen under certain stress I/O environment under the Linux
iSCSI offload operation.

This change only affects Broadcom's 5709 chipset.

Unable to handle kernel NULL pointer dereference at 0000000000000008 RIP:
 [<ffffffff881f0e7d>] :bnx2:bnx2_poll_work+0xd0d/0x13c5
Pid: 0, comm: swapper Tainted: G     ---- 2.6.18-333.el5debug #2
RIP: 0010:[<ffffffff881f0e7d>]  [<ffffffff881f0e7d>] :bnx2:bnx2_poll_work+0xd0d/0x13c5
RSP: 0018:ffff8101b575bd50  EFLAGS: 00010216
RAX: 0000000000000005 RBX: ffff81007c5fb180 RCX: 0000000000000000
RDX: 0000000000000ffc RSI: 00000000817e8000 RDI: 0000000000000220
RBP: ffff81015bbd7ec0 R08: ffff8100817e9000 R09: 0000000000000000
R10: ffff81007c5fb180 R11: 00000000000000c8 R12: 000000007a25a010
R13: 0000000000000000 R14: 0000000000000005 R15: ffff810159f80558
FS:  0000000000000000(0000) GS:ffff8101afebc240(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000000201000 CR4: 00000000000006a0
Process swapper (pid: 0, threadinfo ffff8101b5754000, task ffff8101afebd820)
Stack:  000000000000000b ffff810159f80000 0000000000000040 ffff810159f80520
 ffff810159f80500 00cf00cf8008e84b ffffc200100939e0 ffff810009035b20
 0000502900000000 000000be00000001 ffff8100817e7810 00d08101b575bea8
Call Trace:
 <IRQ>  [<ffffffff8008e0d0>] show_schedstat+0x1c2/0x25b
 [<ffffffff881f1886>] :bnx2:bnx2_poll+0xf6/0x231
 [<ffffffff8000c9b9>] net_rx_action+0xac/0x1b1
 [<ffffffff800125a0>] __do_softirq+0x89/0x133
 [<ffffffff8005e30c>] call_softirq+0x1c/0x28
 [<ffffffff8006d5de>] do_softirq+0x2c/0x7d
 [<ffffffff8006d46e>] do_IRQ+0xee/0xf7
 [<ffffffff8005d625>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff801a5780>] acpi_processor_idle_simple+0x1c5/0x341
 [<ffffffff801a573d>] acpi_processor_idle_simple+0x182/0x341
 [<ffffffff801a55bb>] acpi_processor_idle_simple+0x0/0x341
 [<ffffffff80049560>] cpu_idle+0x95/0xb8
 [<ffffffff80078b1c>] start_secondary+0x479/0x488

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 18352ff82101..cb288b7542e4 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1184,6 +1184,9 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
 	int rc = 0;
 	u64 mask64;
 
+	memset(&iscsi_init, 0x00, sizeof(struct iscsi_kwqe_init1));
+	memset(&iscsi_init2, 0x00, sizeof(struct iscsi_kwqe_init2));
+
 	bnx2i_adjust_qp_size(hba);
 
 	iscsi_init.flags =
-- 
1.8.5.2

