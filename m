Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3CNKhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab3CNKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 37/88] nfsd: add get_uint for u32's
Date: Thu, 14 Mar 2013 10:35:30 +0000
Message-Id: <1363257381-15900-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a007c4c3e943ecc054a806c259d95420a188754b upstream.

I don't think there's a practical difference for the range of values
these interfaces should see, but it would be safer to be unambiguous.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/export.c             |  6 +++---
 include/linux/sunrpc/cache.h | 16 ++++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index ba23349..1114463 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -398,7 +398,7 @@ fsloc_parse(char **mesg, char *buf, struct nfsd4_fs_locations *fsloc)
 	int migrated, i, err;
 
 	/* listsize */
-	err = get_int(mesg, &fsloc->locations_count);
+	err = get_uint(mesg, &fsloc->locations_count);
 	if (err)
 		return err;
 	if (fsloc->locations_count > MAX_FS_LOCATIONS)
@@ -456,7 +456,7 @@ static int secinfo_parse(char **mesg, char *buf, struct svc_export *exp)
 		return -EINVAL;
 
 	for (f = exp->ex_flavors; f < exp->ex_flavors + listsize; f++) {
-		err = get_int(mesg, &f->pseudoflavor);
+		err = get_uint(mesg, &f->pseudoflavor);
 		if (err)
 			return err;
 		/*
@@ -465,7 +465,7 @@ static int secinfo_parse(char **mesg, char *buf, struct svc_export *exp)
 		 * problem at export time instead of when a client fails
 		 * to authenticate.
 		 */
-		err = get_int(mesg, &f->flags);
+		err = get_uint(mesg, &f->flags);
 		if (err)
 			return err;
 		/* Only some flags are allowed to differ between flavors: */
diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index f5fd616..dd2bb84 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -228,6 +228,22 @@ static inline int get_int(char **bpp, int *anint)
 	return 0;
 }
 
+static inline int get_uint(char **bpp, unsigned int *anint)
+{
+	char buf[50];
+	int len = qword_get(bpp, buf, sizeof(buf));
+
+	if (len < 0)
+		return -EINVAL;
+	if (len == 0)
+		return -ENOENT;
+
+	if (kstrtouint(buf, 0, anint))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * timestamps kept in the cache are expressed in seconds
  * since boot.  This is the best for measuring differences in
-- 
1.8.1.2

