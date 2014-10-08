Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbaJHNEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:04:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099AbaJHNEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:04:00 -0400
From: Michal Marek <mmarek@suse.cz>
To: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] X.509: Fix certificate gathering again
Date: Wed,  8 Oct 2014 15:03:29 +0200
Message-Id: <1412773409-29102-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d7ec435f (X.509: Fix certificate gathering) fixed the issue of
changing .x509.list, but in the CONFIG_MODULE_SIG=y case, it assumed
that $(objtree) is an absolute path. Commit 7e1c0477 (kbuild: Use
relative path for $(objtree)) broke this assumption and we get
uncecessary rebuilds again. Instead of prepending the absolute path and
stripping it again, just check if $(srctree) and $(objtree) are
different directories and add $(srctree)/*.x509 only in such case.

Fixes: 7e1c047 (kbuild: Use relative path for $(objtree))
Cc: stable@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 kernel/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index dc5c775..7cf32cf 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -123,11 +123,12 @@ $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 #
 ###############################################################################
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
-X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
-X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += $(objtree)/signing_key.x509
-X509_CERTIFICATES-raw := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
-				$(or $(realpath $(CERT)),$(CERT))))
-X509_CERTIFICATES := $(subst $(realpath $(objtree))/,,$(X509_CERTIFICATES-raw))
+X509_CERTIFICATES-y := $(wildcard *.x509)
+ifneq ($(objtree),$(srctree))
+X509_CERTIFICATES-y += $(wildcard $(srctree)/*.x509)
+endif
+X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += signing_key.x509
+X509_CERTIFICATES := $(sort $(X509_CERTIFICATES-y))
 
 ifeq ($(X509_CERTIFICATES),)
 $(warning *** No X.509 certificates found ***)
-- 
1.8.4.5

