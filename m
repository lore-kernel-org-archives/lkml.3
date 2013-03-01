Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3CAURI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:17:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3CATpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Carlos Maiolino <cmaiolino@redhat.com>
Subject: [ 50/77] ext4: release sysfs kobject when failing to enable quotas on mount
Date: Fri,  1 Mar 2013 11:44:35 -0800
Message-Id: <20130301194357.253765741@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 72ba74508b2857e71d65fc93f0d6b684492fc740 upstream.

In addition, print the error returned from ext4_enable_quotas()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4008,7 +4008,7 @@ no_journal:
 	    !(sb->s_flags & MS_RDONLY)) {
 		err = ext4_enable_quotas(sb);
 		if (err)
-			goto failed_mount7;
+			goto failed_mount8;
 	}
 #endif  /* CONFIG_QUOTA */
 
@@ -4035,6 +4035,10 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+#ifdef CONFIG_QUOTA
+failed_mount8:
+	kobject_del(&sbi->s_kobj);
+#endif
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
@@ -5005,9 +5009,9 @@ static int ext4_enable_quotas(struct sup
 						DQUOT_USAGE_ENABLED);
 			if (err) {
 				ext4_warning(sb,
-					"Failed to enable quota (type=%d) "
-					"tracking. Please run e2fsck to fix.",
-					type);
+					"Failed to enable quota tracking "
+					"(type=%d, err=%d). Please run "
+					"e2fsck to fix.", type, err);
 				return err;
 			}
 		}


