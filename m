Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3IKE7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3IKE5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:06 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=XgSMBJCyeFcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=J9L4q4xwTgcA:10 a=40MIqcmNAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Da1No7cPAAAA:8 a=h7UUX0lOYpQWgwAsNMoA:9 a=6z04QOUsx9AA:10 a=-tENaG0q7zQA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=5bqIMkYVwbkOX2ff:21 a=LxpLiuDEYup16QK9:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.812919139@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>, Jeff Layton <jlayton@redhat.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Scott Lovenberg <scott.lovenberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: [184/251] cifs: extend the buffer length enought for sprintf() using
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0184-cifs-extend-the-buffer-length-enought-for-sprintf-us.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

[ Upstream commit 057d6332b24a4497c55a761c83c823eed9e3f23b ]

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
CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/cifs/cifsencrypt.c |    2 +-
 fs/cifs/cifsglob.h    |    1 +
 fs/cifs/connect.c     |    7 ++++---
 fs/cifs/sess.c        |    6 +++---
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 9caf0c6..c6828ae 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -369,7 +369,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		if (blobptr + attrsize > blobend)
 			break;
 		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
-			if (!attrsize)
+			if (!attrsize || attrsize >= CIFS_MAX_DOMAINNAME_LEN)
 				break;
 			if (!ses->domainName) {
 				ses->domainName =
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 977dc0e..4af59dc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -42,6 +42,7 @@
 #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
 #define MAX_SERVER_SIZE 15
 #define MAX_SHARE_SIZE 80
+#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
 #define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
 #define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 487db09..8239cba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1611,7 +1611,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnlen(string, 256) == 256) {
+			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
+					== CIFS_MAX_DOMAINNAME_LEN) {
 				printk(KERN_WARNING "CIFS: domain name too"
 						    " long\n");
 				goto cifs_parse_mount_err;
@@ -2298,8 +2299,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 #ifdef CONFIG_KEYS
 
-/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
-#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
+/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
+#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
 
 /* Populate username and pw fields from keyring if possible */
 static int
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 382c06d..673db0b 100644
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
1.7.10.4


