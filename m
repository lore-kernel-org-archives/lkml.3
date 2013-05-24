Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab3EXI5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:57:45 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:43768 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760087Ab3EXI5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:57:43 -0400
From: Vahram Martirosyan <vmartirosyan@gmail.com>
To: Dave Kleikamp <shaggy@kernel.org>
Cc: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        spruce-project@linuxtesting.org, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] jfs: Log shutdown error in jfs_freeze() function
Date: Fri, 24 May 2013 13:57:13 +0500
Message-Id: <1369385833-6852-2-git-send-email-vahram.martirosyan@linuxtesting.org>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org>
References: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function jfs_freeze() the log is shut down through lmLogShutdown() call.
When the "nointegrity" mount option is enabled, the log is actually not
initialized. As a result the freeze operation in that case brings to a
kernel OOPS.

The solution is to check if the "nointegrity" option is enabled and if it is not
then shut the log down. 

May be this is not the best solution, but at least it fixes the OOPS.

Found by Linux File System Verification project (linuxtesting.org)

Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
---
 fs/jfs/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index a3d424d..9788970 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -615,10 +615,12 @@ static int jfs_freeze(struct super_block *sb)
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		txQuiesce(sb);
-		rc = lmLogShutdown(log);
-		if (rc != 0) {
-			jfs_err("lmLogShutdown failed with return code %d", rc);
-			return rc;
+		if (!log->no_integrity) {
+			rc = lmLogShutdown(log);
+			if (rc != 0) {
+				jfs_err("lmLogShutdown failed with return code %d", rc);
+				return rc;
+			}
 		}
 		rc = updateSuper(sb, FM_CLEAN);
 		if (rc != 0) {
-- 
1.8.2.3

