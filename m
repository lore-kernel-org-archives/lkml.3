Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaEUS3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:29:33 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:19306 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbaEUS3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:29:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYLAMXvfFNbsHTp/2dsb2JhbABZgwmrBQQBAQEBAQEFAYM6lnaBDBd0glMTHCMYgQIkE4hFAdZihVWIeYRHAQOPPYowAYsViA+DOjs
Date: Wed, 21 May 2014 20:29:29 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Dave <shaggy@kernel.org>
Subject: [PATCH 1/1] fs/jfs/super.c: convert simple_str to kstr
Message-Id: <20140521202929.00437eb6cf5290b51102bb18@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces obsolete simple_str functions by kstr

use kstrtouint for
-uid_t ( __kernel_uid32_t )
-gid_t ( __kernel_gid32_t )
-jfs_sb_info->umask
-jfs_sb_info->minblks_trim
(all unsigned int)

newLVSize is s64 -> use kstrtol

Current parse_options behaviour stays the same ie it doesn't return kstr
rc but just 0 if function failed (parse_options callsites
return -EINVAL when there's anything wrong).

Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jfs/super.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 97f7fda..fe09e5d 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -273,7 +273,10 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 		case Opt_resize:
 		{
 			char *resize = args[0].from;
-			*newLVSize = simple_strtoull(resize, &resize, 0);
+			int rc = kstrtoll(resize, 0, newLVSize);
+
+			if (rc)
+				return 0;
 			break;
 		}
 		case Opt_resize_nosize:
@@ -327,7 +330,11 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 		case Opt_uid:
 		{
 			char *uid = args[0].from;
-			uid_t val = simple_strtoul(uid, &uid, 0);
+			uid_t val;
+			int rc = kstrtouint(uid, 0, &val);
+
+			if (rc)
+				return 0;
 			sbi->uid = make_kuid(current_user_ns(), val);
 			if (!uid_valid(sbi->uid))
 				goto cleanup;
@@ -337,7 +344,11 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 		case Opt_gid:
 		{
 			char *gid = args[0].from;
-			gid_t val = simple_strtoul(gid, &gid, 0);
+			gid_t val;
+			int rc = kstrtouint(gid, 0, &val);
+
+			if (rc)
+				return 0;
 			sbi->gid = make_kgid(current_user_ns(), val);
 			if (!gid_valid(sbi->gid))
 				goto cleanup;
@@ -347,7 +358,10 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 		case Opt_umask:
 		{
 			char *umask = args[0].from;
-			sbi->umask = simple_strtoul(umask, &umask, 8);
+			int rc = kstrtouint(umask, 8, &sbi->umask);
+
+			if (rc)
+				return 0;
 			if (sbi->umask & ~0777) {
 				pr_err("JFS: Invalid value of umask\n");
 				goto cleanup;
@@ -380,10 +394,13 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
 		{
 			struct request_queue *q = bdev_get_queue(sb->s_bdev);
 			char *minblks_trim = args[0].from;
+			int rc;
 			if (blk_queue_discard(q)) {
 				*flag |= JFS_DISCARD;
-				sbi->minblks_trim = simple_strtoull(
-					minblks_trim, &minblks_trim, 0);
+				rc = kstrtouint(minblks_trim, 0,
+					       &sbi->minblks_trim);
+				if (rc)
+					return 0;
 			} else {
 				pr_err("JFS: discard option " \
 					"not supported on device\n");
-- 
1.9.1

