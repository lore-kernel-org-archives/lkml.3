Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3KWCkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 21:40:09 -0500
Received: from plane.gmane.org ([80.91.229.3]:48767 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab3KWCkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 21:40:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Linux 3.13-rc1 is out
Date: Sat, 23 Nov 2013 02:32:29 +0000 (UTC)
Message-ID: <loom.20131123T032923-567@post.gmane.org>
References: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com> <m3li0gndnk.fsf@carbon.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 210.94.41.89 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/6.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; MS-RTC LM 8; .NET4.0C))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Cloos <cloos <at> jhcloos.com> writes:

> 
> This combination:
> 
> # CONFIG_SYSTEM_TRUSTED_KEYRING is not set
> CONFIG_TRUSTED_KEYS=m
> 
> (acquired by oldconfig and N to system keyring)
> 
> fails with:
> 
> Pass 2
>   CC [M]  crypto/asymmetric_keys/x509_rsakey-asn1.o
>   CC [M]  crypto/asymmetric_keys/x509_cert_parser.o
>   CC [M]  crypto/asymmetric_keys/x509_public_key.o
> crypto/asymmetric_keys/x509_public_key.c: In 
function ‘x509_key_preparse’:
> crypto/asymmetric_keys/x509_public_key.c:237:35: 
error: ‘system_trusted_keyring’
> undeclared (first use in this function)
>    ret = x509_validate_trust(cert, system_trusted_keyring);
>                                    ^
> crypto/asymmetric_keys/x509_public_key.c:237:35: note: each undeclared 
identifier is reported
> only once for each function it appears in
> make[2]: *** [crypto/asymmetric_keys/x509_public_key.o] Error 1
> make[1]: *** [crypto/asymmetric_keys] Error 2
> make: *** [crypto] Error 2
> 
> Perhaps include/keys/system_keyring.h should have a definition for
> system_trusted_keyring in the #ifndef CONFIG_SYSTEM_TRUSTED_KEYRING
> case (which may entail just removing the #ifdef).
> 
> Commits b56e5a17b6b9acd1 and 09fbc47373826d67 are relevant.
> 
> -JimC

I have same problem too.

Using following band-aid patch (though I'm not sure it's correct), build 
is ok;

--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -67,6 +67,7 @@ int integrity_digsig_verify(const unsigned int id, const 
char *sig, int siglen,
        return -EOPNOTSUPP;
 }
 
+#ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 int integrity_init_keyring(const unsigned int id)
 {
        const struct cred *cred = current_cred();
@@ -84,3 +85,4 @@ int integrity_init_keyring(const unsigned int id)
                        keyring_name[id], PTR_ERR(keyring[id]));
        return 0;
 }
+#endif

But, I encounter another build issue;

  CC      crypto/asymmetric_keys/x509_public_key.o
crypto/asymmetric_keys/x509_public_key.c: In function 
â€˜x509_key_preparseâ€™:
crypto/asymmetric_keys/x509_public_key.c:237:35: error: 
â€˜system_trusted_keyringâ€™ undeclared (first use in this function)
   ret = x509_validate_trust(cert, system_trusted_keyring);
                                   ^
crypto/asymmetric_keys/x509_public_key.c:237:35: note: each undeclared 
identifier is reported only once for each function it appears in
make[2]: *** [crypto/asymmetric_keys/x509_public_key.o] Error 1
make[1]: *** [crypto/asymmetric_keys] Error 2
make: *** [crypto] Error 2


Looks like it's caused by following combination...

# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_X509_CERTIFICATE_PARSER=y


Jongman Heo

