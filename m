Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaA1NGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:06:30 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59251 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaA1NG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:06:27 -0500
From: Michel Lespinasse <walken@google.com>
To: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: [PATCH 1/2] firmware: fix google/gsmi duplicate efivars_sysfs_init()
Date: Tue, 28 Jan 2014 05:06:21 -0800
Message-Id: <1390914382-3285-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390914382-3285-1-git-send-email-walken@google.com>
References: <1390914382-3285-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting in commit e14ab23dde12b80db4c94b684a2e485b72b16af3,
efivars_sysfs_init() is called both by itself as an init function,
and by drivers/firmware/google/gsmi.c gsmi_init().

This results in runtime warnings such as the following:
[    5.651330] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one+0xbd/0xe0()
[    5.657699] sysfs: cannot create duplicate filename '/firmware/gsmi/vars'

Fixing this by removing the redundant efivars_sysfs_init() call in
gsmi_init().

Tested: booted, checked that /firmware/gsmi/vars was still present and
showed the expected contents.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 drivers/firmware/google/gsmi.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index e5a67b24587a..f1ab05ea56bb 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -892,13 +892,6 @@ static __init int gsmi_init(void)
 		goto out_remove_sysfs_files;
 	}
 
-	ret = efivars_sysfs_init();
-	if (ret) {
-		printk(KERN_INFO "gsmi: Failed to create efivars files\n");
-		efivars_unregister(&efivars);
-		goto out_remove_sysfs_files;
-	}
-
 	register_reboot_notifier(&gsmi_reboot_notifier);
 	register_die_notifier(&gsmi_die_notifier);
 	atomic_notifier_chain_register(&panic_notifier_list,
-- 
1.8.5.3
