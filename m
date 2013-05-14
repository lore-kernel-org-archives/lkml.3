Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3ENMCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:02:32 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49291 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3ENMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:02:31 -0400
X-Nat-Received: from [202.181.97.72]:58532 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368532949.16903
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [3.10-rc1 PATCH] devtmpfs: Fix kmemcheck warning.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201305142102.IHI86995.LFFVOHtOFSJQMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 14 May 2013 21:02:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14052013 #9976473, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below warning.

  WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (ffff88007ae384d8)
  00000000000000000000000000000000d884e37a0088ffff006f665f64657669
   i i i i i i i i i i i i i i i i i i i i i i i i u u u u u u u u
                                                   ^
  RIP: 0010:[<ffffffff81169c2d>]  [<ffffffff81169c2d>] copy_mount_options+0xfd/0x1b0
  RSP: 0000:ffff88007ae37d68  EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff88007ae37da0 RCX: 00000000000000ff
  RDX: ffff88007ae384d8 RSI: 0000000000000000 RDI: ffff88007ad776e0
  RBP: ffff88007ae37d88 R08: 0000000000000000 R09: ffffffff81ca0130
  R10: 000000000007f000 R11: 0000000000080000 R12: 0000000000000920
  R13: 0000000000001000 R14: ffff88007ad77000 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88007b200000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff88007ac28404 CR3: 0000000001c0b000 CR4: 00000000000407f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
   [<ffffffff8116d31d>] SyS_mount+0x6d/0xe0
   [<ffffffff813bddd2>] devtmpfsd+0x62/0x170
   [<ffffffff81065f3e>] kthread+0xee/0x100
   [<ffffffff817a746c>] ret_from_fork+0x7c/0xb0
   [<ffffffffffffffff>] 0xffffffffffffffff

Below patch fixes this warning, but is simpler fix

-	char options[] = "mode=0755";
+	static char options[PAGE_SIZE] = "mode=0755";

better?
--------------------
>From 4e768f2e7ea75786a69baae52469e1662244d933 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 14 May 2013 16:32:05 +0900
Subject: [PATCH] devfs: Fix kmemcheck warning.

The "void __user *data" argument passed to mount() has to be PAGE_SIZE bytes of
initialized memory region.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/base/devtmpfs.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 7413d06..59a2baf 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -375,12 +375,24 @@ static int handle(const char *name, umode_t mode, kuid_t uid, kgid_t gid,
 
 static int devtmpfsd(void *p)
 {
-	char options[] = "mode=0755";
+	char *options;
 	int *err = p;
 	*err = sys_unshare(CLONE_NEWNS);
 	if (*err)
 		goto out;
+	/*
+	 * The options argument has to be PAGE_SIZE bytes of initialized memory
+	 * region, or kmemcheck will complain "read from uninitialized memory"
+	 * because copy_mount_options() tries to copy PAGE_SIZE bytes.
+	 */
+	options = (char *) __get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!options) {
+		*err = -ENOMEM;
+		goto out;
+	}
+	strcpy(options, "mode=0755");
 	*err = sys_mount("devtmpfs", "/", "devtmpfs", MS_SILENT, options);
+	free_page((unsigned long) options);
 	if (*err)
 		goto out;
 	sys_chdir("/.."); /* will traverse into overmounted root */
-- 
1.7.1
