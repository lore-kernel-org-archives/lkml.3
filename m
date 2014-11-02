Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaKBUxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:53:15 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36410 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaKBUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:53:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8+gPUhyQpMfBnFrqYqszPXkIWaTTDJcs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3D28B60FD09
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: kbuild: Fix forced rebuild after 'make dtbs'
Date: Sun,  2 Nov 2014 20:52:29 +0000
Message-Id: <1414961549-31666-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <CACRpkdYmJWy1_vs0tWRA7SvkQnvbXXKqf7pHpH5b5tZ6vR+KJg@mail.gmail.com>
References: <CACRpkdYmJWy1_vs0tWRA7SvkQnvbXXKqf7pHpH5b5tZ6vR+KJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch:

  f4d4ffc03efc kbuild: dtbs_install: new make target

was added the kernel tree, Linus Walleij noticed that 'make dtbs' forced
a following 'make zImage' to rebuild the entire tree, even though
nothing had changed.  His report:

  After this patch a while back I have observed the following behaviour
  of the kernel build:

  make zImage
  make zImage
  -> incremental build, just relink

  make zImage
  make dtbs
  make zImage
  -> The whole kernel gets rebuilt

  So now if I happen to recompile my device trees, I suddenly want
  the entire zImage to be rebuilt to? It's by definition not changes
  that affect the kernel build :-(

  I noticed this because my build scripts calls make dtbs && make
  zImage, and started to rebuild absolutely everything all the time.

To fix this, we make only the dtbs_install target depend on the prepare
target.  It's needed to make sure KERNELVERSION is calculated prior to
installing.

Fixes: f4d4ffc03efc: ("kbuild: dtbs_install: new make target")
Reported-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Note: I've no idea if this is a 100% correct solution or not.  I know it's
definitely better than what we have currently.  If there is another way to
guarantee KERNELVERSION is set other than depending on 'prepare', I'd love to
hear it.

thx,

Jason.

 arch/arm/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 034a94904d69..ae1c278128f8 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -312,7 +312,9 @@ $(INSTALL_TARGETS):
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
 PHONY += dtbs dtbs_install
-dtbs dtbs_install: prepare scripts
+dtbs: scripts
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
+dtbs_install: prepare scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
 
 # We use MRPROPER_FILES and CLEAN_FILES now
-- 
2.1.3

