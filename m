Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaFDSCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:02:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35145 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaFDSB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:01:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] init: make rootdelay=N consistent with rootwait behaviour
Date: Wed, 4 Jun 2014 14:01:35 -0400
Message-ID: <1401904895-18791-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently rootdelay=N and rootwait behave differently (aside
from the obvious unbounded wait duration) because they are
at different places in the init sequence.

The difference manifests itself for md devices because the
call to md_run_setup() lives between rootdelay and rootwait,
so if you try to use rootdelay=20 to try and allow a slow
RAID0 array to assemble, you get this:

[    4.526011] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   22.972079] md: Waiting for all devices to be available before autodetect

i.e. you've achieved nothing other than delaying the probing
20s, when what you wanted was a 20s delay _after_ the probing
for md devices was initiated.

Here we move the rootdelay code to be right beside the rootwait
code, so that their behaviour is consistent.

It should be noted that in doing so, the actions based on the
saved_root_name[0] and initrd_load() were previously put on
hold by rootdelay=N and now currently will not be delayed.
However, I think consistent behaviour is more important than
matching historical behaviour of delaying the above two operations.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 init/do_mounts.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 82f22885c87e..b6237c31b0e2 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -539,12 +539,6 @@ void __init prepare_namespace(void)
 {
 	int is_floppy;
 
-	if (root_delay) {
-		printk(KERN_INFO "Waiting %d sec before mounting root device...\n",
-		       root_delay);
-		ssleep(root_delay);
-	}
-
 	/*
 	 * wait for the known devices to complete their probing
 	 *
@@ -571,6 +565,12 @@ void __init prepare_namespace(void)
 	if (initrd_load())
 		goto out;
 
+	if (root_delay) {
+		pr_info("Waiting %d sec before mounting root device...\n",
+			root_delay);
+		ssleep(root_delay);
+	}
+
 	/* wait for any asynchronous scanning to complete */
 	if ((ROOT_DEV == 0) && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
-- 
1.9.1

