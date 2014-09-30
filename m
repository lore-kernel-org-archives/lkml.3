Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaI3SBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:01:14 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39143 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaI3SBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:01:08 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        xen-devel@lists.xenproject.org, Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Perier <romain.perier@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [RFC PATCH 00/16] kernel: Add support for poweroff handler call chain
Date: Tue, 30 Sep 2014 11:00:40 -0700
Message-Id: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various drivers implement architecture and/or device specific means to
remove power from the system.  For the most part, those drivers set the
global variable pm_power_off to point to a function within the driver.

This mechanism has a number of drawbacks.  Typically only one scheme
to remove power is supported (at least if pm_power_off is used).
At least in theory there can be multiple means remove power, some of
which may be less desirable.  For example, some mechanisms may only
power off the CPU or the CPU card, while another may power off the
entire system.  Others may really just execute a restart sequence
or drop into the ROM monitor.  Using pm_power_off can also be racy
if the function pointer is set from a driver built as module, as the
driver may be in the process of being unloaded when pm_power_off is
called.  If there are multiple poweroff handlers in the system, removing
a module with such a handler may inadvertently reset the pointer to
pm_power_off to NULL, leaving the system with no means to remove power.

Introduce a system poweroff handler call chain to solve the described
problems.  This call chain is expected to be executed from the
architecture specific machine_power_off() function.  Drivers providing
system poweroff functionality are expected to register with this call chain.
By using the priority field in the notifier block, callers can control
poweroff handler execution sequence and thus ensure that the poweroff
handler with the optimal capabilities to remove power for a given system
is called first.

The poweroff handler is introduced in multiple steps

1) Implement poweroff handler API.
   Patch 01/16.
2) Ensure that pm_power_off is only called from machine_restart.
   Patches 02/16 and 03/16.
3) Implement call to poweroff handler in architecture specific
   machine_restart code.
   Patches 03/16 to 13/16.
4) Convert all drivers to register with poweroff handler
   instead of setting pm_power_off directly.
   Patches 15/16 and 16/16 (examples).
   This can be done in two steps: First convert all drivers which can
   be built as modules, then convert the remaining drivers (possibly after
   unexporting pm_powr_off).
5) Unexport pm_power_off for all architectures,
   and drop it entirely for architectures where it is not really used.
6) [optional] Convert machine specific architecture code to register 
   with poweroff handler instead of setting pm_power_off directly,
   and remove pm_power_off entirely from the system.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Romain Perier <romain.perier@gmail.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>

----------------------------------------------------------------
Guenter Roeck (16):
      kernel: Add support for poweroff handler call chain
      hwmon: (ab8500) Call kernel_power_off instead of pm_power_off
      parisc: support poweroff through poweroff handler call chain
      arm: support poweroff through poweroff handler call chain
      arm64: support poweroff through poweroff handler call chain
      avr32: support poweroff through poweroff handler call chain
      c6x: support poweroff through poweroff handler call chain
      ia64: support poweroff through poweroff handler call chain
      metag: support poweroff through poweroff handler call chain
      mips: support poweroff through poweroff handler call chain
      sh: support poweroff through poweroff handler call chain
      unicore32: support poweroff through poweroff handler call chain
      x86: support poweroff through poweroff handler call chain
      x86/xen: support poweroff through poweroff handler call chain
      power/reset: restart-poweroff: Register with kernel poweroff handler
      mfd: palmas: Register with kernel poweroff handler

 arch/arm/kernel/process.c              |  2 +
 arch/arm64/kernel/process.c            |  2 +
 arch/avr32/kernel/process.c            |  2 +
 arch/c6x/kernel/process.c              |  2 +
 arch/ia64/kernel/process.c             |  2 +
 arch/metag/kernel/process.c            |  2 +
 arch/mips/kernel/reset.c               |  2 +
 arch/parisc/kernel/process.c           |  7 ++-
 arch/sh/kernel/reboot.c                |  2 +
 arch/unicore32/kernel/process.c        |  2 +
 arch/x86/kernel/reboot.c               |  4 ++
 arch/x86/xen/enlighten.c               |  2 +
 drivers/hwmon/ab8500.c                 |  5 ++-
 drivers/mfd/palmas.c                   | 30 +++++++------
 drivers/parisc/power.c                 |  3 +-
 drivers/power/reset/restart-poweroff.c | 24 +++++-----
 include/linux/mfd/palmas.h             |  3 ++
 include/linux/reboot.h                 |  4 ++
 kernel/reboot.c                        | 81 ++++++++++++++++++++++++++++++++++
 19 files changed, 149 insertions(+), 32 deletions(-)
