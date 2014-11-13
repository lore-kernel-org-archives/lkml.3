Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaKMTZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:20 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:37860 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974AbaKMTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:16 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 04/16] dcache: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:10 -0500
Message-Id: <1415906662-4576-5-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 fs/dcache.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a6c5d7e..27b8b5b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -230,8 +230,7 @@ static inline int dentry_cmp(const struct dentry *dentry, const unsigned char *c
 	 * early because the data cannot match (there can
 	 * be no NUL in the ct/tcount data)
 	 */
-	cs = ACCESS_ONCE(dentry->d_name.name);
-	smp_read_barrier_depends();
+	cs = lockless_dereference(dentry->d_name.name);
 	return dentry_string_cmp(cs, ct, tcount);
 }
 
@@ -2714,10 +2713,8 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 {
 	const char *dname = ACCESS_ONCE(name->name);
-	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
-
-	smp_read_barrier_depends();
+	u32 dlen = lockless_dereference(name->len);
 
 	*buflen -= dlen + 1;
 	if (*buflen < 0)
-- 
1.9.1

