Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3GXOJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:09:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45884 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab3GXOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:07:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "steve" <sanpatr1@in.ibm.com>,
        "Steve French" <smfrench@gmail.com>,
        "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>,
        "Steve French" <smfrench@us.ibm.com>,
        "Jeff Layton" <jlayton@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.576040293@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [46/85] Handle big endianness in NTLM (ntlmv2) authentication
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifs_unicode.h | 8 ++++----
 fs/cifs/cifsencrypt.c  | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

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
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -394,7 +394,7 @@ static int calc_ntlmv2_hash(struct cifs_
 	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
-	wchar_t *user;
+	__le16 *user;
 	wchar_t *domain;
 	wchar_t *server;
 
@@ -419,7 +419,7 @@ static int calc_ntlmv2_hash(struct cifs_
 		return rc;
 	}
 
-	/* convert ses->user_name to unicode and uppercase */
+	/* convert ses->user_name to unicode */
 	len = strlen(ses->user_name);
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
@@ -427,7 +427,7 @@ static int calc_ntlmv2_hash(struct cifs_
 		rc = -ENOMEM;
 		return rc;
 	}
-	len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
+	len = cifs_strtoUCS(user, ses->user_name, len, nls_cp);
 	UniStrupr(user);
 
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,

