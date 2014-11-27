Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaK0Pik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:38:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaK0Pib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:38:31 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] kbuild: Automatically remove stale <linux/version.h> file
Date: Thu, 27 Nov 2014 16:38:09 +0100
Message-Id: <1417102689-19040-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 3.7, the file moved from include/linux/ to
include/generated/uapi/linux/. The path in the #include directive
remained the same for compatibility reasons, but this created a problem
when bisecting. Commit 9c8cdb71 (kbuild: unconditionally clobber
include/linux/version.h on distclean) fixes this, provided the user does
make distclean between builds. Better not rely on the user and delete
the stale file each time make is invoked.

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0032d1c..fc7a6d3 100644
--- a/Makefile
+++ b/Makefile
@@ -480,6 +480,7 @@ asm-generic:
 # of make so .config is not included in this case either (for *config).
 
 version_h := include/generated/uapi/linux/version.h
+old_version_h := include/linux/version.h
 
 no-dot-config-targets := clean mrproper distclean \
 			 cscope gtags TAGS tags help %docs check% coccicheck \
@@ -1004,6 +1005,7 @@ endef
 
 $(version_h): $(srctree)/Makefile FORCE
 	$(call filechk,version.h)
+	$(Q)rm -f $(old_version_h)
 
 include/generated/utsrelease.h: include/config/kernel.release FORCE
 	$(call filechk,utsrelease.h)
@@ -1172,7 +1174,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer include/linux/version.h
+		  signing_key.x509.signer
 
 # clean - Delete most, but leave enough to build external modules
 #
-- 
2.1.2

