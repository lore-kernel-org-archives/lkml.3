Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaFKPk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:40:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbaFKPk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:40:56 -0400
From: Michal Marek <mmarek@suse.cz>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] powerpc: Avoid circular dependency with zImage.%
Date: Wed, 11 Jun 2014 17:40:43 +0200
Message-Id: <1402501243-28213-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <53984D4F.6040808@linux.vnet.ibm.com>
References: <53984D4F.6040808@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rule to create the final images uses a zImage.% pattern.
Unfortunately, this also matches the names of the zImage.*.lds linker
scripts, which appear as a dependency of the final images. This somehow
worked when $(srctree) used to be an absolute path, but now the pattern
matches too much. List only the images from $(image-y) as the target of
the rule, to avoid the circular dependency.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
v2:
  - Filter out duplicates in the target list
  - fix the platform argument to cmd_wrap

 arch/powerpc/boot/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 426dce7..ccc25ed 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -333,8 +333,8 @@ $(addprefix $(obj)/, $(initrd-y)): $(obj)/ramdisk.image.gz
 $(obj)/zImage.initrd.%: vmlinux $(wrapperbits)
 	$(call if_changed,wrap,$*,,,$(obj)/ramdisk.image.gz)
 
-$(obj)/zImage.%: vmlinux $(wrapperbits)
-	$(call if_changed,wrap,$*)
+$(addprefix $(obj)/, $(sort $(filter zImage.%, $(image-y)))): vmlinux $(wrapperbits)
+	$(call if_changed,wrap,$(subst $(obj)/zImage.,,$@))
 
 # dtbImage% - a dtbImage is a zImage with an embedded device tree blob
 $(obj)/dtbImage.initrd.%: vmlinux $(wrapperbits) $(obj)/%.dtb
-- 
1.9.2

