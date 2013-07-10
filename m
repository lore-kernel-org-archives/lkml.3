Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3GJTcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:32:08 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:39187 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3GJTcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:32:05 -0400
Message-ID: <51DDB6BC.5060203@mentor.com>
Date: Wed, 10 Jul 2013 20:32:12 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, "Moseley, Drew" <drew_moseley@mentor.com>
Subject: Building CONFIG_SAMPLES separately.
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 10 Jul 2013 19:32:03.0048 (UTC) FILETIME=[27760E80:01CE7DA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was wondering if there is a reason the modules under the samples
directory only build if you use the command make uImage modules?

I have created a patch so that they compile if you enable CONFIG_SAMPLES
and then build the kernel separately, i.e.
make uImage
make modules

This two step approach is how the kernel is built if you use bitbake in
yocto, currently it does not output the kernel module object file for
the sample modules.

This is the patch I am considering:

diff --git a/Makefile b/Makefile
index 29339b4..1acd69f 100644
--- a/Makefile
+++ b/Makefile
@@ -772,9 +772,6 @@ vmlinux: scripts/link-vmlinux.sh $(vmlinux-deps) FORCE
 ifdef CONFIG_HEADERS_CHECK
        $(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-       $(Q)$(MAKE) $(build)=samples
-endif
 ifdef CONFIG_BUILD_DOCSRC
        $(Q)$(MAKE) $(build)=Documentation
 endif
@@ -943,6 +940,9 @@ all: modules

 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
+ifdef CONFIG_SAMPLES
+       $(Q)$(MAKE) $(build)=samples
+endif
        $(Q)$(AWK) '!x[$$0]++'
$(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
        @$(kecho) '  Building modules, stage 2.';
        $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost


Thank you for any help or advice,
Jim Baxter
