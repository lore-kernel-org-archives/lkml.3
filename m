Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaE3Lnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:43:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389AbaE3Lnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:43:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>
Subject: [PATCH 0/2] x86, fix smp_num_siblings calculation and usage
Date: Fri, 30 May 2014 07:43:03 -0400
Message-Id: <1401450185-23061-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo, this is what I'm going to send upstream tomorrow.  FYI.

P.

----8<---

I have a system on which I have disabled threading in the BIOS, and I am booting
the kernel with the option "idle=poll".

The kernel displays

process: WARNING: polling idle and HT enabled, performance may degrade

which is incorrect -- I've already disabled HT.

This warning is issued here:

void select_idle_routine(const struct cpuinfo_x86 *c)
{
        if (boot_option_idle_override == IDLE_POLL && smp_num_siblings > 1)
                pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");

>From my understanding of the other areas of kernel that use
smp_num_siblings, the value is supposed to be the the number of threads
per core.

The value of smp_num_siblings is incorrect.  In theory, it should be 1 but it
is reported as 2.  When I looked into how smp_num_siblings is calculated I
found the following call sequence in the kernel:

start_kernel ->
        check_bugs ->
                identify_boot_cpu ->
                                identify_cpu ->
                                        c_init = init_intel
                                                init_intel ->
                                                        detect_extended_topology
                                                        (sets value)

                                        OR

                                        c_init = init_amd
                                                init_amd -> amd_detect_cmp
                                                             -> amd_get_topology
                                                                (sets value)
                                                         -> detect_ht()
                                        ...		    (sets value)
                                        detect_ht()
                                        (also sets value)

ie) it is set three times in some cases and is overwritten by the call
to detect_ht() from identify_cpu() in all cases.

It should be noted that nothing in the identify_cpu() path or the cpu_up()
path requires smp_num_siblings to be set, prior to the final call to
detect_ht().

For x86 boxes, smp_num_siblings is set to a value read in a CPUID call in
detect_ht().  This value is the *factory defined* value in all cases; even
if HT is disabled in BIOS the value still returns 2 if the CPU supports
HT.  AMD also reports the factory defined value in all cases.

That is, even with threading disabled,

crash> p smp_num_siblings
smp_num_siblings = $1 = 0x2

on processors that support multi-threading.

smp_num_siblings should be calculated a single time on cpu 0 to determine
whether or not the system is multi-threaded or not.

On a system with HT enabled,

crash> p smp_num_siblings
smp_num_siblings = $1 = 0x2

On a system with HT disabled,

crash> p smp_num_siblings
smp_num_siblings = $1 = 0x1

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Borislav Petkov <bp@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Prarit Bhargava (2):
  x86, Clean up smp_num_siblings calculation
  x86, Calculate smp_num_siblings once

 arch/x86/kernel/cpu/amd.c      |    1 -
 arch/x86/kernel/cpu/common.c   |   23 +++++++++++------------
 arch/x86/kernel/cpu/topology.c |    2 +-
 arch/x86/kernel/smpboot.c      |   10 +++++++---
 4 files changed, 19 insertions(+), 17 deletions(-)

-- 
1.7.9.3

