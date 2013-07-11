Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab3GKOra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:47:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3GKOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 31/98] Handle big endianness in NTLM (ntlmv2) authentication
Date: Thu, 11 Jul 2013 15:24:01 +0100
Message-Id: <1373552708-15235-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@us.ibm.com>

commit fdf96a907c1fbb93c633e2b7ede3b8df26d6a4c0 upstream.

This is RH bug 970891
Uppercasing of username during calculation of ntlmv2 hash fails
because UniStrupr function does not handle big endian wchars.

Also fix a comment in the same code to reflect its correct usage.

[To make it easier for stable (rather than require 2nd patch) fixed
this patch of Shirish's to remove endian warning generated
by sparse -- steve f.]

Reported-by: steve <sanpatr1@in.ibm.com>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/cifs_unicode.h | 8 ++++----
 fs/cifs/cifsencrypt.c  | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index a513a54..f2b2ffd 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -323,14 +323,14 @@ UniToupper(register wchar_t uc)
 /*
  * UniStrupr:  Upper case a unicode string
  */
-static inline wchar_t *
-UniStrupr(register wchar_t *upin)
+static inline __le16 *
+UniStrupr(register __le16 *upin)
 {
-	register wchar_t *up;
+	register __le16 *up;
 
 	up = upin;
 	while (*up) {		/* For all characters */
-		*up = UniToupper(*up);
+		*up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
 		up++;
 	}
 	return upin;		/* Return input pointer */
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 63c460e..6d0c62a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -394,7 +394,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
-	wchar_t *user;
+	__le16 *user;
 	wchar_t *domain;
 	wchar_t *server;
 
@@ -419,7 +419,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		return rc;
 	}
 
-	/* convert ses->user_name to unicode and uppercase */
+	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
@@ -429,7 +429,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	}
 
 	if (len) {
-		len = cifs_strtoUTF16((__le16 *)user, ses->user_name, len, nls_cp);
+		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
 		UniStrupr(user);
 	} else {
 		memset(user, '\0', 2);
-- 
1.8.1.2

