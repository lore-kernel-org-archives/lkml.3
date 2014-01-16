Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaAPE3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:29:09 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64500 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaAPE3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:29:07 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
Subject: [RESEND PATCH v3] MODSIGN: Fix including certificate twice when the signing_key.x509 already exists
Date: Thu, 16 Jan 2014 12:27:23 +0800
Message-Id: <1389846443-21270-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun-Yi Lee <jlee@suse.com>

This issue was found in devel-pekey branch on linux-modsign.git tree.
The x509_certificate_list includes certificate twice when the
signing_key.x509 already exists.
We can reproduce this issue by making kernel twice, the build log of
second time looks like this:

...
  CHK     kernel/config_data.h
  CERTS   kernel/x509_certificate_list
  - Including cert /ramdisk/working/joey/linux-modsign/signing_key.x509
  - Including cert signing_key.x509
...

Actually the build path was the same with the srctree path when building
kernel. It causes the size of bzImage increased by packaging
certificates twice.

Originally this patch was signed and merged to devel-pekey in David
Howells's linux-modsign git:

http://lwn.net/Articles/540288/

git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git
tags/pekey-20130221

But it is missed in mainline kernel.

v3:
Using realpath to compare current file path with source tree patch.
Thanks for Rusty Russell's suggestion.

v2:
Using '$(shell /bin/pwd)' instead of '$(shell pwd)' for more reliable
between different shells

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Marek <mmarek@suse.com>
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 kernel/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..1d671b1 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -136,7 +136,10 @@ $(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
 #
 ###############################################################################
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
-X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
+X509_CERTIFICATES-y := $(wildcard *.x509)
+ifneq ($(realpath .), $(realpath $(srctree)))
+X509_CERTIFICATES-y += $(wildcard $(srctree)/*.x509)
+endif
 X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += $(objtree)/signing_key.x509
 X509_CERTIFICATES-raw := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
 				$(or $(realpath $(CERT)),$(CERT))))
-- 
1.6.4.2

