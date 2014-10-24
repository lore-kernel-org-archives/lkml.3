Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaJXGQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:16:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:14197 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbaJXGP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:15:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="619636762"
From: Kweh Hock Leong <hock.leong.kweh@intel.com>
To: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: [PATCH v1 2/3] firmware loader: fix hung task warning dump
Date: Fri, 24 Oct 2014 14:18:21 +0800
Message-Id: <1414131502-13886-3-git-send-email-hock.leong.kweh@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

When using request_firmware_nowait() with FW_ACTION_NOHOTPLUG param to
expose user helper interface, if the user do not react immediately, after
120 seconds there will be a hung task warning message dumped as below:

[ 3000.784235] INFO: task kworker/0:0:8259 blocked for more than 120 seconds.
[ 3000.791281]       Tainted: G            E 3.16.0-rc1-yocto-standard #41
[ 3000.798082] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3000.806072] kworker/0:0     D cd0075c8     0  8259      2 0x00000000
[ 3000.812765] Workqueue: events request_firmware_work_func
[ 3000.818253]  cd375e18 00000046 0000000e cd0075c8 000000f0 cd40ea00 cd375fec 1b883e89
[ 3000.826374]  0000026b cd40ea00 80000000 00000001 cd0075c8 00000000 cd375de4 c119917f
[ 3000.834492]  cd563360 cd375df4 c119a0ab cd563360 00000000 cd375e24 c119a1d6 00000000
[ 3000.842616] Call Trace:
[ 3000.845252]  [<c119917f>] ? kernfs_next_descendant_post+0x3f/0x50
[ 3000.851543]  [<c119a0ab>] ? kernfs_activate+0x6b/0xc0
[ 3000.856790]  [<c119a1d6>] ? kernfs_add_one+0xd6/0x130
[ 3000.862047]  [<c15fdb02>] schedule+0x22/0x60
[ 3000.866548]  [<c15fd195>] schedule_timeout+0x175/0x1d0
[ 3000.871887]  [<c119b391>] ? __kernfs_create_file+0x71/0xa0
[ 3000.877574]  [<c119bb9a>] ? sysfs_add_file_mode_ns+0xaa/0x180
[ 3000.883533]  [<c15fe84f>] wait_for_completion+0x6f/0xb0
[ 3000.888961]  [<c1065200>] ? wake_up_process+0x40/0x40
[ 3000.894219]  [<c13cb600>] _request_firmware+0x750/0x9f0
[ 3000.899666]  [<c1382a7f>] ? n_tty_receive_buf2+0x1f/0x30
[ 3000.905200]  [<c13cba02>] request_firmware_work_func+0x22/0x50
[ 3000.911235]  [<c10550d2>] process_one_work+0x122/0x380
[ 3000.916571]  [<c1055859>] worker_thread+0xf9/0x470
[ 3000.921555]  [<c1055760>] ? create_and_start_worker+0x50/0x50
[ 3000.927497]  [<c1055760>] ? create_and_start_worker+0x50/0x50
[ 3000.933448]  [<c105a5ff>] kthread+0x9f/0xc0
[ 3000.937850]  [<c15ffd40>] ret_from_kernel_thread+0x20/0x30
[ 3000.943548]  [<c105a560>] ? kthread_worker_fn+0x100/0x100

This patch change the wait_for_completion() function call to
wait_for_completion_interruptible() function call for solving the issue.

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 drivers/base/firmware_class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b2fe40b..c241454b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -908,7 +908,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
 
-	wait_for_completion(&buf->completion);
+	retval = wait_for_completion_interruptible(&buf->completion);
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
 	if (!buf->data)
@@ -985,7 +985,7 @@ static int sync_cached_firmware_buf(struct firmware_buf *buf)
 			break;
 		}
 		mutex_unlock(&fw_lock);
-		wait_for_completion(&buf->completion);
+		ret = wait_for_completion_interruptible(&buf->completion);
 		mutex_lock(&fw_lock);
 	}
 	mutex_unlock(&fw_lock);
-- 
1.7.9.5

