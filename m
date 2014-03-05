Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaCEKuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:50:23 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33099 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaCEKuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:50:20 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 0/2] hibernation support on ARM
Date: Wed,  5 Mar 2014 02:50:03 -0800
Message-Id: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches adding support for hibernation on ARM
 - ARM hibernation / suspend-to-disk
 - Change soft_restart to use non-tracing raw_local_irq_disable

Patches based on v3.14-rc5 tag, verified hibernation on beaglebone black on a
branch based on 3.13 merged with initial omap support from Russ Dill which
can be found here (includes v1 patchset):
http://git.linaro.org/git-ro/people/sebastian.capella/linux.git hibernation_3.13_russMerge

[PATCH v7 1/2] ARM: avoid tracers in soft_restart
 arch/arm/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 Use raw_local_irq_disable in place of local_irq_disable to avoid
 infinite abort recursion while tracing. (unchanged since v3)

[PATCH v7 2/2] ARM hibernation / suspend-to-disk
 arch/arm/include/asm/memory.h |    1 +
 arch/arm/kernel/Makefile      |    1 +
 arch/arm/kernel/hibernate.c   |  108 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/Kconfig           |    5 ++
 include/linux/suspend.h       |    2 +
 5 files changed, 117 insertions(+)

 Adds support for ARM based hibernation


Additional notes:
-----------------

There are two checkpatch warnings added by this patch.  These follow
behavior in existing hibernation implementations on other platforms.


    WARNING: externs should be avoided in .c files
    #120: FILE: arch/arm/kernel/hibernate.c:24:
    +extern const void __nosave_begin, __nosave_end;

  This extern is picking up the linker nosave region definitions, only
  used in hibernate.  Follows same extern line used mips, powerpc, s390,
  sh, sparc, x86 & unicore32

    WARNING: externs should be avoided in .c files
    #200: FILE: arch/arm/kernel/hibernate.c:104:
    +	extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);

  This extern is used in the arch/arm/ in hibernate, process and bL_switcher


Changes in v7:
--------------
* remove use of RELOC_HIDE macro
* remove unused #includes
* fixup comment for arch_restore_image
* ensure alignment of resume stack on 8 byte boundary

Changes in v6:
--------------
* Simplify static variable names

Changes in v5:
--------------
* Fixed checkpatch warning on trailing whitespace

Changes in v4:
--------------
* updated comment for soft_restart with review feedback
* dropped freeze_processes patch which was queued separately 
  to 3.14 by Rafael Wysocki:
  https://lkml.org/lkml/2014/2/25/683

Changes in v3:
--------------
* added comment to use of soft_restart
* drop irq disable soft_restart patch
* add patch to avoid tracers in soft_restart by using raw_local_irq_*

Changes in v2:
--------------
* Removed unneeded flush_thread, use of __naked and cpu_init.
* dropped Cyril Chemparathy <cyril@ti.com> from Cc: list as 
  emails are bouncing.

Thanks,

Sebastian Capella


