Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3BULYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:24:46 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46631 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3BULYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:24:44 -0500
From: Chun-Yi Lee <joeyli.kernel@gmail.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
Subject: [PATCH] MODSIGN: Fix including certificate twice when the signing_key.x509 already exists
Date: Thu, 21 Feb 2013 19:23:49 +0800
Message-Id: <1361445829-23594-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was found in devel-pekey branch on linux-modsign.git tree. The
x509_certificate_list includes certificate twice when the signing_key.x509
already exists.
We can reproduce this issue by making kernel twice, the build log of
second time looks like this:

...
  CHK     kernel/config_data.h
  CERTS   kernel/x509_certificate_list
  - Including cert /ramdisk/working/joey/linux-modsign/signing_key.x509
  - Including cert signing_key.x509
...

Actually the build path was the same with the srctree path when building
kernel. It causes the size of bzImage increased by packaging certificates
twice.

Cc: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Marek <mmarek@suse.com>
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
---
 kernel/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 0ca8c0a..ecbe73f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -142,7 +142,10 @@ $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 #
 ###############################################################################
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
-X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
+X509_CERTIFICATES-y := $(wildcard *.x509)
+ifneq ($(shell pwd), $(srctree))
+X509_CERTIFICATES-y += $(wildcard $(srctree)/*.x509)
+endif
 X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += signing_key.x509
 X509_CERTIFICATES := $(sort $(X509_CERTIFICATES-y))
 
-- 
1.6.4.2

