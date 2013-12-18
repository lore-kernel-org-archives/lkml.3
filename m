Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3LRQnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:43:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3LRQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:43:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFy1moQwnV7NVqFyCCZAwXG3z5c8o-mij1isMbv2B0ikNA@mail.gmail.com>
References: <CA+55aFy1moQwnV7NVqFyCCZAwXG3z5c8o-mij1isMbv2B0ikNA@mail.gmail.com> <4197.1386708027@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
        keyrings@linux-nfs.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] KEYS: Miscellaneous fixes
Date: Wed, 18 Dec 2013 16:43:33 +0000
Message-ID: <31378.1387385013@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Could you pull the following fixes for the keyring stuff.
> 
> Pulled. However, I notice that the following issue remains with module
> key signing, and I *think* it was introduced in the -rc1 pull:
> 
>  - start with clean kernel sources
> 
>  - build kernel ("make -j16" or whatever after doing your config)
> 
>  - build kernel again ("make -j" - nothing has changed):
> 
>    ...
>    X.509 certificate list changed
>      CERTS   kernel/x509_certificate_list
>      - Including cert /home/torvalds/v2.6/linux/signing_key.x509
>      AS      kernel/system_certificates.o
>      LD      kernel/built-in.o
>    ...
> 
>    which causes it to relink the kernel.
> 
>  - build kernel yet again, and now finally it doesn't build/link anything.
> 
> So some rule for the certificate list seems to be broken. I'm pretty
> sure this didn't happen in 3.12. Any ideas?

Is this fixed by the attached patch?

David
---
Fix the gathering of certificates from both the source tree and the build tree
to correctly calculate the pathnames of all the certificates.

The problem was that if the default generated cert, signing_key.x509, didn't
exist then it would not have a path attached and if it did, it would have a
path attached.

This means that the contents of kernel/.x509.list would change between the
first compilation in a directory and the second.  After the second it would
remain stable because the signing_key.x509 file exists.

The consequence was that the kernel would get relinked unconditionally on the
second recompilation.  The second recompilation would also show something like
this:

   X.509 certificate list changed
     CERTS   kernel/x509_certificate_list
     - Including cert /home/torvalds/v2.6/linux/signing_key.x509
     AS      kernel/system_certificates.o
     LD      kernel/built-in.o

which is why the relink would happen.


Unfortunately, it isn't a simple matter of just sticking a path on the front
of the filename of the certificate in the build directory as make can't then
work out how to build it.

So the path has to be prepended to the name for sorting and duplicate
elimination and then removed for the make rule if it is in the build tree.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index bbaf7d59c1bb..c23bb0b30293 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -137,9 +137,10 @@ $(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
 ###############################################################################
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
 X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
-X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += signing_key.x509
-X509_CERTIFICATES := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
+X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += $(objtree)/signing_key.x509
+X509_CERTIFICATES-raw := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
 				$(or $(realpath $(CERT)),$(CERT))))
+X509_CERTIFICATES := $(subst $(realpath $(objtree))/,,$(X509_CERTIFICATES-raw))
 
 ifeq ($(X509_CERTIFICATES),)
 $(warning *** No X.509 certificates found ***)

