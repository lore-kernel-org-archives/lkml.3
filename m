Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162877Ab3DEUnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:43:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42118 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162806Ab3DEUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:42:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, hpa@zytor.com, konrad@kernel.org
Subject: [RFC PATCH] axe the store_gdt() pvops call. (v1)
Date: Fri,  5 Apr 2013 16:42:20 -0400
Message-Id: <1365194544-14648-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long long time ago (way back in October 2012), when I posted the patches
that would make it possible to do ACPI S3 with Xen, Peter pointed out that:
"excellent set of pvops calls that should be nukable to Kingdom Come. There
is no reason, ever, to read the IDT and GDT from the kernel... the kernel
already knows what they should be!"

http://lkml.indiana.edu/hypermail/linux/kernel/1210.2/01555.html

Merge windows happens, bugs happen, and only this week I was able to carve
out some time to dig a bit in this. I started with the GDT and found
out that we can remove it. My fear was that ACPI S3 would break but fortunatly
it has its own mechanism for reloading the GDT (and as the 32-bit
patch shows - it has an redundant one as well!). Tested on 32 bit and
64-bit kernels - doing ACPI S3 and hibernate as well. The machines
were ThinkPad T61 and an Asus M5A97.

This RFC patch does the removal of the store_gdt() and as well some of
the 32-bit ACPI S3 code. Please review at your leisure.

The patches are also visible at:
 
 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/for-hpa-3.10

 arch/x86/include/asm/paravirt.h       |  4 ----
 arch/x86/include/asm/paravirt_types.h |  2 +-
 arch/x86/include/asm/suspend_32.h     |  1 -
 arch/x86/include/asm/suspend_64.h     |  3 ---
 arch/x86/kernel/acpi/sleep.c          |  2 +-
 arch/x86/kernel/acpi/wakeup_32.S      |  3 ---
 arch/x86/kernel/doublefault_32.c      |  2 +-
 arch/x86/kernel/paravirt.c            |  1 -
 arch/x86/kvm/vmx.c                    |  2 +-
 arch/x86/power/cpu.c                  | 13 +++++++------
 arch/x86/xen/enlighten.c              |  1 -
 11 files changed, 11 insertions(+), 23 deletions(-)

Konrad Rzeszutek Wilk (3):
      x86/gdt/64-bit: store/load GDT for ACPI S3 or hibernate/resume path is not needed.
      x86/gdt/i386: store/load GDT for ACPI S3 or hibernation/resume path is not needed
      x86/xen/store_gdt: Remove the pvops variant of store_gdt.

konrad@kernel.org (1):
      x86/wakeup/sleep:  Use pvops functions for changing GDT entries.

