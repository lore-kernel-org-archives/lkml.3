Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3HMGeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:34:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab3HMGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, Jeff Layton <jlayton@redhat.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Scott Lovenberg <scott.lovenberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: [ 11/17] cifs: extend the buffer length enought for sprintf() using
Date: Mon, 12 Aug 2013 23:35:57 -0700
Message-Id: <20130813063502.630391496@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsencrypt.c |    2 +-
 fs/cifs/cifsglob.h    |    1 +
 fs/cifs/connect.c     |    7 ++++---
 fs/cifs/sess.c        |    6 +++---
 4 files changed, 9 insertions(+), 7 deletions(-)

--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -369,7 +369,7 @@ find_domain_name(struct cifs_ses *ses, c
 		if (blobptr + attrsize > blobend)
 			break;
 		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
-			if (!attrsize)
+			if (!attrsize || attrsize >= CIFS_MAX_DOMAINNAME_LEN)
 				break;
 			if (!ses->domainName) {
 				ses->domainName =
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -38,6 +38,7 @@
 #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
 #define MAX_SERVER_SIZE 15
 #define MAX_SHARE_SIZE 80
+#define CIFS_MAX_DOMAINNAME_LEN 256 /* max domain name length */
 #define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
 #define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */
 
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1698,7 +1698,8 @@ cifs_parse_mount_options(const char *mou
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnlen(string, 256) == 256) {
+			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
+					== CIFS_MAX_DOMAINNAME_LEN) {
 				printk(KERN_WARNING "CIFS: domain name too"
 						    " long\n");
 				goto cifs_parse_mount_err;
@@ -2356,8 +2357,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 #ifdef CONFIG_KEYS
 
-/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
-#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
+/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
+#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
 
 /* Populate username and pw fields from keyring if possible */
 static int
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -198,7 +198,7 @@ static void unicode_domain_string(char *
 		bytes_ret = 0;
 	} else
 		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
-					    256, nls_cp);
+					    CIFS_MAX_DOMAINNAME_LEN, nls_cp);
 	bcc_ptr += 2 * bytes_ret;
 	bcc_ptr += 2;  /* account for null terminator */
 
@@ -256,8 +256,8 @@ static void ascii_ssetup_strings(char **
 
 	/* copy domain */
 	if (ses->domainName != NULL) {
-		strncpy(bcc_ptr, ses->domainName, 256);
-		bcc_ptr += strnlen(ses->domainName, 256);
+		strncpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
+		bcc_ptr += strnlen(ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
 	} /* else we will send a null domain name
 	     so the server will default to its own domain */
 	*bcc_ptr = 0;


