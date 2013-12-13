Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab3LMPp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3LMPpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:45:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/4] X.509: Fix certificate gathering
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.com>,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Dec 2013 15:45:16 +0000
Message-ID: <20131213154516.3155.54604.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131213154508.3155.20275.stgit@warthog.procyon.org.uk>
References: <20131213154508.3155.20275.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reported-by: Linus Torvalds <torvalds@linux-foundation.com>
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

