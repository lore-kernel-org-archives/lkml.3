Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaDDSij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:38:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaDDSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:38:38 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: jkc@redhat.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] Staging: unisys: verify that a control channel exists
Date: Fri,  4 Apr 2014 14:38:24 -0400
Message-Id: <1396636704-18542-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code didn't verify that a control channel exists before trying to
use it. It caused NULL ptr derefs which were easy to trigger by an
unpriviliged user simply by reading the proc file, causing:

[   68.161404] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   68.162442] IP: visorchannel_read (drivers/staging/unisys/visorchannel/visorchannel_funcs.c:225)
[   68.163165] PGD 5ca21067 PUD 5ca20067 PMD 0
[   68.163712] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   68.164390] Dumping ftrace buffer:
[   68.164793]    (ftrace buffer empty)
[   68.165220] Modules linked in:
[   68.165601] CPU: 0 PID: 7915 Comm: cat Tainted: G        W     3.14.0-next-20140403-sasha-00012-gef5fa7d-dirty #373
[   68.166821] task: ffff88006e8c3000 ti: ffff88005ca30000 task.ti: ffff88005ca30000
[   68.167689] RIP: visorchannel_read (drivers/staging/unisys/visorchannel/visorchannel_funcs.c:225)
[   68.168683] RSP: 0018:ffff88005ca31e58  EFLAGS: 00010282
[   68.169302] RAX: ffff88005ca10000 RBX: ffff88005ca31e97 RCX: 0000000000000001
[   68.170019] RDX: ffff88005ca31e97 RSI: 0000000000000bd6 RDI: 0000000000000000
[   68.170019] RBP: ffff88005ca31e78 R08: 0000000000000000 R09: 0000000000000000
[   68.170019] R10: ffff880000000000 R11: 0000000000000001 R12: 0000000000000001
[   68.170019] R13: 0000000000000bd6 R14: 0000000000000000 R15: 0000000000008000
[   68.170019] FS:  00007f0e8c041700(0000) GS:ffff88007be00000(0000) knlGS:0000000000000000
[   68.170019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   68.170019] CR2: 0000000000000000 CR3: 000000006efe9000 CR4: 00000000000006b0
[   68.170019] Stack:
[   68.170019]  ffff88005ca31f50 ffff88005ca10000 000000000060e000 ffff88005ca31f50
[   68.170019]  ffff88005ca31ec8 ffffffff83e6f983 ffff8800780db810 0000000000008000
[   68.170019]  ffff88005ca31ec8 ffff88006da5f908 ffff8800780db800 000000000060e000
[   68.170019] Call Trace:
[   68.170019] proc_read_toolaction (drivers/staging/unisys/visorchipset/visorchipset_main.c:2541)
[   68.170019] proc_reg_read (fs/proc/inode.c:211)
[   68.170019] vfs_read (fs/read_write.c:408)
[   68.170019] SyS_read (fs/read_write.c:519 fs/read_write.c:511)
[   68.170019] tracesys (arch/x86/kernel/entry_64.S:749)
[   68.170019] Code: 00 00 66 66 66 66 90 55 48 89 e5 48 83 ec 20 48 89 5d e0 48 89 d3 4c 89 65 e8 49 89 cc 4c 89 6d f0 49 89 f5 4c 89 75 f8 49 89 fe <48> 8b 3f e8 4f f9 ff ff 85 c0 0f 88 97 00 00 00 4d 85 ed 0f 85
[   68.170019] RIP visorchannel_read (drivers/staging/unisys/visorchannel/visorchannel_funcs.c:225)
[   68.170019]  RSP <ffff88005ca31e58>
[   68.170019] CR2: 0000000000000000

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 .../staging/unisys/visorchipset/visorchipset_main.c  |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 8252ca1..257c6e5 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -2414,6 +2414,9 @@ proc_read_installer(struct file *file, char __user *buf,
 	char *vbuf;
 	loff_t pos = *offset;
 
+	if (!ControlVm_channel)
+		return -ENODEV;
+
 	if (pos < 0)
 		return -EINVAL;
 
@@ -2463,6 +2466,9 @@ proc_write_installer(struct file *file,
 	U16 remainingSteps;
 	U32 error, textId;
 
+	if (!ControlVm_channel)
+		return -ENODEV;
+
 	/* Check to make sure there is no buffer overflow */
 	if (count > (sizeof(buf) - 1))
 		return -EINVAL;
@@ -2524,6 +2530,9 @@ proc_read_toolaction(struct file *file, char __user *buf,
 	char *vbuf;
 	loff_t pos = *offset;
 
+	if (!ControlVm_channel)
+		return -ENODEV;
+
 	if (pos < 0)
 		return -EINVAL;
 
@@ -2562,6 +2571,9 @@ proc_write_toolaction(struct file *file,
 	char buf[3];
 	U8 toolAction;
 
+	if (!ControlVm_channel)
+		return -ENODEV;
+
 	/* Check to make sure there is no buffer overflow */
 	if (count > (sizeof(buf) - 1))
 		return -EINVAL;
@@ -2601,6 +2613,9 @@ proc_read_bootToTool(struct file *file, char __user *buf,
 	char *vbuf;
 	loff_t pos = *offset;
 
+	if (!ControlVm_channel)
+		return -ENODEV;
+
 	if (pos < 0)
 		return -EINVAL;
 
@@ -2639,6 +2654,9 @@ proc_write_bootToTool(struct file *file,
 	int inputVal;
 	ULTRA_EFI_SPAR_INDICATION efiSparIndication;
 
+	if (!ControlVm_channel)
+		return -ENODEV;
+
 	/* Check to make sure there is no buffer overflow */
 	if (count > (sizeof(buf) - 1))
 		return -EINVAL;
-- 
1.7.10.4

