Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3KDXOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 18:14:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33639 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab3KDXOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 18:14:22 -0500
Message-ID: <1383606829.15186.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: randconfig build error with next-20131104, in security/integrity
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org
Date: Mon, 04 Nov 2013 18:13:49 -0500
In-Reply-To: <CA+r1Zhir86Mdmps5N1awK7mJxf1CWgkr-RDKYVhmpj_3+oYyYQ@mail.gmail.com>
References: <CA+r1Zhir86Mdmps5N1awK7mJxf1CWgkr-RDKYVhmpj_3+oYyYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110423-9332-0000-0000-0000020B35B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-04 at 11:29 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> security/integrity/digsig.c:70:5: error: redefinition of ‘integrity_init_keyring
> ’
>  int integrity_init_keyring(const unsigned int id)
>      ^
> In file included from security/integrity/digsig.c:22:0:
> security/integrity/integrity.h:149:12: note: previous definition of
> ‘integrity_init_keyring’ was here
>  static int integrity_init_keyring(const unsigned int id)
>             ^
> security/integrity/integrity.h:149:12: warning:
> ‘integrity_init_keyring’ defined but not used [-Wunused-function]
> make[2]: *** [security/integrity/digsig.o] Error 1

Thanks!  The following patch should resolve these errors.

Subject: [PATCH] ima: fix random config build error

Define stub integrity_init_keyring() definition based on
CONFIG_INTEGRITY_SIGNATURE, not CONFIG_INTEGRITY_ASYMMETRIC_KEYS.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/integrity.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index b9e7c13..a3c678c 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -123,6 +123,7 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 			    const char *digest, int digestlen);
 
+int integrity_init_keyring(const unsigned int id);
 #else
 
 static inline int integrity_digsig_verify(const unsigned int id,
@@ -132,24 +133,22 @@ static inline int integrity_digsig_verify(const unsigned int id,
 	return -EOPNOTSUPP;
 }
 
+static int integrity_init_keyring(const unsigned int id)
+{
+	return 0;
+}
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int asymmetric_verify(struct key *keyring, const char *sig,
 		      int siglen, const char *data, int datalen);
 
-int integrity_init_keyring(const unsigned int id);
 #else
 static inline int asymmetric_verify(struct key *keyring, const char *sig,
 				    int siglen, const char *data, int datalen)
 {
 	return -EOPNOTSUPP;
 }
-
-static int integrity_init_keyring(const unsigned int id)
-{
-	return 0;
-}
 #endif
 
 #ifdef CONFIG_INTEGRITY_AUDIT
-- 
1.8.1.4



