Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaLPCUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:20:19 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:57682 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaLPCUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:20:17 -0500
From: Chris Packham <chris.packham@alliedtelesis.co.nz>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: jdl@jdl.com, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] dtc: Use quotes to include header files
Date: Tue, 16 Dec 2014 15:13:24 +1300
Message-Id: <1418696004-12829-1-git-send-email-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.2.0.rc0
In-Reply-To: <7947240.7yktm8fT2X@wuerfel>
References: <7947240.7yktm8fT2X@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in arch and driver code that needs early access to the
flattened device tree it is necessary to add specific CFLAGS so that
when scripts/dtc/libfdt/libfdt.h is included the C preprocessor is able
to locate the libfdt versions of libfdt_env.h and fdt.h without
generating an error.

We already provide an alternative linux-specific
version of libfdt_env.h and directly include scripts/dtc/libfdt/fdt.h
so the inclusion by scripts/dtc/libfdt/libfdt.h is a no-op thanks to the
inclusion guards.

By using quotes in scripts/dtc/libfdt/libfdt.h it picks up fdt.h and
libfdt_env.h from the source directory without needing to add CFLAGS for
the sources that happen to include linux/libfdt.h.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
Hi,

This probably should come via git://git.jdl.com/software/dtc.git however
this appears to be inaccessible at the moment. Is this still the
canonical source for the device tree compiler and libfdt or has it been
moved? How much deviation from the canonical source are we prepared to
live with in the kernel?

This came up on the arm-LKML[1]. Basically in the name of backwards
compatibility I need to add a .dt_fixup to add some required nodes to
the flattened device tree prior to the tree being un-flattened and
processed. This is a trick powerpc makes use of fairly extensively and
there are a few other instances of this.

For the files that include linux/libfdt.h we currently also have to
specify additional CFLAGS to satisfy the CPP.
    
  $ git grep '<linux/libfdt.h>'
  arch/mips/cavium-octeon/octeon-platform.c:#include <linux/libfdt.h>
  arch/mips/cavium-octeon/setup.c:#include <linux/libfdt.h>
  arch/mips/mti-sead3/sead3-setup.c:#include <linux/libfdt.h>
  arch/powerpc/kernel/prom.c:#include <linux/libfdt.h>
  drivers/firmware/efi/libstub/fdt.c:#include <linux/libfdt.h>
  drivers/of/fdt.c:#include <linux/libfdt.h>
  drivers/of/fdt_address.c:#include <linux/libfdt.h>

  $ git grep -e '-I.*dtc/libfdt'
  arch/mips/cavium-octeon/Makefile:CFLAGS_octeon-platform.o = -I$(src)/../../../scripts/dtc/libfdt
  arch/mips/cavium-octeon/Makefile:CFLAGS_setup.o = -I$(src)/../../../scripts/dtc/libfdt
  arch/mips/mti-sead3/Makefile:CFLAGS_sead3-setup.o = -I$(src)/../../../scripts/dtc/libfdt
  arch/powerpc/kernel/Makefile:CFLAGS_prom.o              = -I$(src)/../../../scripts/dtc/libfdt
  drivers/firmware/efi/libstub/Makefile:CFLAGS_fdt.o += -I$(srctree)/scripts/dtc/libfdt/
  drivers/of/Makefile:CFLAGS_fdt.o = -I$(src)/../../scripts/dtc/libfdt
  drivers/of/Makefile:CFLAGS_fdt_address.o = -I$(src)/../../scripts/dtc/libfdt
  lib/Makefile:   $(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
    
Simply by switching to using quotes we can avoid having this extra step.

Assuming that this patch is acceptable a follow on clean up would be to
remove the instances of CFLAGS_... listed above.

Regards,
Chris
--
[1] - http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310840.html

 scripts/dtc/libfdt/libfdt.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/dtc/libfdt/libfdt.h b/scripts/dtc/libfdt/libfdt.h
index 73f4975..ea1ddcd 100644
--- a/scripts/dtc/libfdt/libfdt.h
+++ b/scripts/dtc/libfdt/libfdt.h
@@ -51,8 +51,8 @@
  *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <libfdt_env.h>
-#include <fdt.h>
+#include "libfdt_env.h"
+#include "fdt.h"
 
 #define FDT_FIRST_SUPPORTED_VERSION	0x10
 #define FDT_LAST_SUPPORTED_VERSION	0x11
-- 
2.2.0.rc0

