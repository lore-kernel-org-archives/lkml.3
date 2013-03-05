Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab3CESIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:08:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59706 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab3CESGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:06:45 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Michal Marek <mmarek@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kbuild@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>
Subject: [PATCH V2 REPOST] kbuild: create an "include chroot" for DT bindings
Date: Tue,  5 Mar 2013 11:06:37 -0700
Message-Id: <1362506797-21905-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The recent dtc+cpp support allows header files and C pre-processor
defines/macros to be used when compiling device tree files. These
headers will typically define various constants that are part of the
device tree bindings.

The original patch which set up the dtc+cpp include path only considered
using those headers from device tree files. However, most are also
useful for kernel code which needs to interpret the device tree.

In both the DT files and the kernel, I'd like to include the DT-related
headers in the same way, for example, <dt-bindings/gpio/tegra-gpio.h>.
That will simplify any text which discusses the DT header locations.

Creating a <dt-bindings/> for kernel source to use is as simple as
placing files into include/dt-bindings/.

However, when compiling DT files, the include path should be restricted
so that only the dt-bindings path is available; arbitrary kernel headers
shouldn't be exposed. For this reason, create a specific include
directory for use by dtc+cpp, and symlink dt-bindings from there to the
actual location of include/dt-bindings/. For want of a better location,
place this "include chroot" into the existing dts/ directory.

arch/*/boot/dts/include/dt-bindings -> ../../../../../include/dt-bindings

Some headers used by device tree files may not be useful to the kernel;
they may be used simply to aid in constructing the DT file (e.g. macros
to create a node), but not define any information that the kernel needs
to share. These may be placed directly into arch/*/boot/dts/ along with
the DT files themselves.

Cc: Hiroshi Doyu <hdoyu@nvidia.com>
Acked-by: Michal Marek <mmarek@suse.cz>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Grant, Rob,

This is a pre-requisite for people to convert their *.dts files to use
cpp, and hence is likely to be useful for a number of ARM subarch trees.
Perhaps this patch can be placed into a standalone topic branch in the
DT repo so we can all merge it. Assuming this patch is OK, I would also
repost the patches that create common headers defining IRQ, and GPIO
flags, which would place files into the new include/dt-bindings
directory.

v2:
* Leave arch/*/boot/dts in dtc include path, for any headers that are
  only included by *.dts and don't need to be shared by the kernel.
* Fix pathname in commit description.
---
 arch/arm/boot/dts/include/dt-bindings |    1 +
 scripts/Makefile.lib                  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
 create mode 120000 arch/arm/boot/dts/include/dt-bindings

diff --git a/arch/arm/boot/dts/include/dt-bindings b/arch/arm/boot/dts/include/dt-bindings
new file mode 120000
index 0000000..08c00e4
--- /dev/null
+++ b/arch/arm/boot/dts/include/dt-bindings
@@ -0,0 +1 @@
+../../../../../include/dt-bindings
\ No newline at end of file
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 07125e6..af35521 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -158,7 +158,7 @@ ld_flags       = $(LDFLAGS) $(ldflags-y)
 
 dtc_cpp_flags  = -Wp,-MD,$(depfile) -nostdinc                            \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts                   \
-		 -I$(srctree)/arch/$(SRCARCH)/include/dts                \
+		 -I$(srctree)/arch/$(SRCARCH)/boot/dts/include           \
 		 -undef -D__DTS__
 
 # Finds the multi-part object the current object will be linked into
-- 
1.7.10.4

