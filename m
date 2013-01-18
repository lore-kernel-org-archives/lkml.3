Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3ARUYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:24:38 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55219 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3ARUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:24:37 -0500
MIME-Version: 1.0
From: Matt Sealey <matt@genesi-usa.com>
Date: Fri, 18 Jan 2013 14:24:15 -0600
Message-ID: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
Subject: Compilation problem with drivers/staging/zsmalloc when !SMP on ARM
To: Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I wonder if anyone can shed some light on this linking problem I have
right now. If I configure my kernel without SMP support (it is a very
lean config for i.MX51 with device tree support only) I hit this error
on linking:

  MODPOST 216 modules
  LZMA    arch/arm/boot/compressed/piggy.lzma
  AS      arch/arm/boot/compressed/lib1funcs.o
ERROR: "v7wbi_flush_kern_tlb_range"
[drivers/staging/zsmalloc/zsmalloc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

I am wondering if someone who is far better versed in the mm code can
tell me exactly what would end up calling this function and why it
would only be in the kernel at all if SMP was enabled - all I can see
right now is that it is PROBABLY something resulting from this code
and comment inside the zsmalloc driver:

/*
 * By default, zsmalloc uses a copy-based object mapping method to access
 * allocations that span two pages. However, if a particular architecture
 * 1) Implements local_flush_tlb_kernel_range() and 2) Performs VM mapping
 * faster than copying, then it should be added here so that
 * USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use page table
 * mapping rather than copying
 * for object mapping.
*/
#if defined(CONFIG_ARM)
#define USE_PGTABLE_MAPPING
#endif

And of course, once USE_PGTABLE_MAPPING is enabled,
local_flush_tlb_kernel_range being used is the actual culprit here.

But the question is, for the ARM guys, shouldn't
local_flush_tlb_kernel_range actually be defined in the kernel build,
even without SMP, even if it would be architecturally a no-op on UP
systems, and then CONFIG_SMP_ON_UP would catch this case?

If not, then the fix is obvious, the check inside zsmalloc for
CONFIG_ARM should be fixed to check specifically for
local_flush_tlb_kernel_range definition as well, or for CONFIG_SMP as
well, or the non-presence of CONFIG_SMP_ON_UP or something?

The build cases I have tested are basically CONFIG_SMP +
CONFIG_SMP_ON_UP (since it's a single-core Cortex-A8) and without
CONFIG_SMP (since it's a Cortex-A8..) using imx_v7_defconfig and
imx_v6_v7_defconfig alike and making the appropriate adjustments.
Trying to compile it with CONFIG_SMP without CONFIG_SMP_ON_UP makes no
sense on my target system - but essentially it only links with
CONFIG_SMP.

I got no clue what I am looking at in arch/arm/mm and related, so I am
unsure precisely how I should proceed in patching it with the intent
it goes upstream.. or what the real implication of this kind of memory
management actually is on SMP vs. UP systems, but the intended
functionality of local_flush_tlb_kernel_range seems like it should
exist even on UP, to me.

--
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
