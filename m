Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab3IHDT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754246Ab3IHDSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Layton" <jlayton@redhat.com>,
        "Chen Gang" <gang.chen@asianux.com>,
        "Scott Lovenberg" <scott.lovenberg@gmail.com>,
        "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>,
        "Steve French" <smfrench@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.992741360@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [052/121] cifs: extend the buffer length enought for sprintf() using
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context in sess.c
 - Drop inapplicable changes to connect.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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
 
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -198,7 +198,7 @@ static void unicode_domain_string(char *
 		bytes_ret = 0;
 	} else
 		bytes_ret = cifs_strtoUCS((__le16 *) bcc_ptr, ses->domainName,
-					  256, nls_cp);
+					  CIFS_MAX_DOMAINNAME_LEN, nls_cp);
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

