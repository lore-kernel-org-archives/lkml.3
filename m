Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab3HPWjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51574 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3HPWi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 114/133] cifs: extend the buffer length enought for sprintf() using
Date: Fri, 16 Aug 2013 15:34:16 -0700
Message-Id: <1376692475-28413-115-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 057d6332b24a4497c55a761c83c823eed9e3f23b upstream.

For cifs_set_cifscreds() in "fs/cifs/connect.c", 'desc' buffer length
is 'CIFSCREDS_DESC_SIZE' (56 is less than 256), and 'ses->domainName'
length may be "255 + '\0'".

The related sprintf() may cause memory overflow, so need extend related
buffer enough to hold all things.

It is also necessary to be sure of 'ses->domainName' must be less than
256, and define the related macro instead of hard code number '256'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Reviewed-by: Scott Lovenberg <scott.lovenberg@gmail.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/cifsencrypt.c | 2 +-
 fs/cifs/cifsglob.h    | 1 +
 fs/cifs/connect.c     | 7 ++++---
 fs/cifs/sess.c        | 6 +++---
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 6d718c3..5488fe3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -390,7 +390,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		if (blobptr + attrsize > blobend)
 			break;
 		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
-			if (!attrsize)
+			if (!attrsize || attrsize >= CIFS_MAX_DOMAINNAME_LEN)
 				break;
 			if (!ses->domainName) {
 				ses->domainName =
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e6899ce..420141c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -44,6 +44,7 @@
 #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
 #define MAX_SERVER_SIZE 15
 #define MAX_SHARE_SIZE 80
+#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
 #define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
 #define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c70d31a..6771d01 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1660,7 +1660,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnlen(string, 256) == 256) {
+			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
+					== CIFS_MAX_DOMAINNAME_LEN) {
 				printk(KERN_WARNING "CIFS: domain name too"
 						    " long\n");
 				goto cifs_parse_mount_err;
@@ -2321,8 +2322,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 #ifdef CONFIG_KEYS
 
-/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
-#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
+/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
+#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
 
 /* Populate username and pw fields from keyring if possible */
 static int
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 76809f4..0ba9bf7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -198,7 +198,7 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 		bytes_ret = 0;
 	} else
 		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
-					    256, nls_cp);
+					    CIFS_MAX_DOMAINNAME_LEN, nls_cp);
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2;  /* account for null terminator */
 
@@ -256,8 +256,8 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 
 	/* copy domain */
 	if (ses->domainName != NULL) {
-		strncpy(bcc_ptr, ses->domainName, 256);
-		bcc_ptr += strnlen(ses->domainName, 256);
+		strncpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
+		bcc_ptr += strnlen(ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
 	} /* else we will send a null domain name
 	     so the server will default to its own domain */
 	*bcc_ptr = 0;
-- 
1.8.1.2

