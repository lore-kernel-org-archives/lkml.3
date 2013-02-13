Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3BMAQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:16:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49976 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab3BMAQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:16:36 -0500
Date: Wed, 13 Feb 2013 01:16:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, AMD: Enable WC+ memory type on family 10
 processors
Message-ID: <20130213001626.GA30512@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
	hpa@zytor.com, linux-kernel@vger.kernel.org,
	boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
	linux-tip-commits@vger.kernel.org
References: <1359495169-23278-1-git-send-email-ostr@amd64.org>
 <tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two issues I got with this one, see below.

On Thu, Jan 31, 2013 at 02:45:06PM -0800, tip-bot for Boris Ostrovsky wrote:
> Commit-ID:  f0322bd341fd63261527bf84afd3272bcc2e8dd3
> Gitweb:     http://git.kernel.org/tip/f0322bd341fd63261527bf84afd3272bcc2e8dd3
> Author:     Boris Ostrovsky <boris.ostrovsky@amd.com>
> AuthorDate: Tue, 29 Jan 2013 16:32:49 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 31 Jan 2013 13:35:38 -0800
> 
> x86, AMD: Enable WC+ memory type on family 10 processors
> 
> In some cases BIOS may not enable WC+ memory type on family 10
> processors, instead converting what would be WC+ memory to CD type.
> On guests using nested pages this could result in performance
> degradation. This patch enables WC+.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
> Link: http://lkml.kernel.org/r/1359495169-23278-1-git-send-email-ostr@amd64.org
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h |  1 +
>  arch/x86/kernel/cpu/amd.c             | 21 ++++++++++++++++-----
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 433a59f..158cde9 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -173,6 +173,7 @@
>  #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
>  #define MSR_AMD64_OSVW_STATUS		0xc0010141
>  #define MSR_AMD64_DC_CFG		0xc0011022
> +#define MSR_AMD64_BU_CFG2		0xc001102a
>  #define MSR_AMD64_IBSFETCHCTL		0xc0011030
>  #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
>  #define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index dd4a5b6..721ef32 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -698,13 +698,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  	if (c->x86 > 0x11)
>  		set_cpu_cap(c, X86_FEATURE_ARAT);
>  
> -	/*
> -	 * Disable GART TLB Walk Errors on Fam10h. We do this here
> -	 * because this is always needed when GART is enabled, even in a
> -	 * kernel which has no MCE support built in.
> -	 */
>  	if (c->x86 == 0x10) {
>  		/*
> +		 * Disable GART TLB Walk Errors on Fam10h. We do this here
> +		 * because this is always needed when GART is enabled, even in a
> +		 * kernel which has no MCE support built in.
>  		 * BIOS should disable GartTlbWlk Errors themself. If
>  		 * it doesn't do it here as suggested by the BKDG.
>  		 *
> @@ -718,6 +716,19 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  			mask |= (1 << 10);
>  			wrmsrl_safe(MSR_AMD64_MCx_MASK(4), mask);
>  		}
> +
> +		/*
> +		 * On family 10h BIOS may not have properly enabled WC+ support,
> +		 * causing it to be converted to CD memtype. This may result in
> +		 * performance degradation for certain nested-paging guests.
> +		 * Prevent this conversion by clearing bit 24 in
> +		 * MSR_AMD64_BU_CFG2.
> +		 */
> +		if (c->x86 == 0x10) {

This family check is redundant, we're already in a 0x10 if-branch
above. Boris had sent a second version which doesn't have that check:
http://marc.info/?l=linux-kernel&m=135949774114910 but I don't know how this
other version has gotten in.

@hpa: maybe replace - patch is still at the top of tip:x86/cpu?

> +			rdmsrl(MSR_AMD64_BU_CFG2, value);
> +			value &= ~(1ULL << 24);
> +			wrmsrl(MSR_AMD64_BU_CFG2, value);
> +		}
>  	}
>  
>  	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);

However, the more serious issue is that that same kernel #GPs when
booted in kvm. It seems it cannot stomach that specific MSR, see the
second "<-- trapping instruction" below and that BU_CFG2 MSR landing in
%ecx in the line before that.

Oh, and this happens only with the kvm executable (/usr/bin/kvm) in
debian testing. If I use qemu from git, it passes over init_amd just
fine.

Hmmm..

[    0.018000] general protection fault: 0000 [#1] PREEMPT SMP 
[    0.018000] Modules linked in:
[    0.018000] CPU 0 
[    0.018000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc6+ #3 Bochs Bochs
[    0.018000] RIP: 0010:[<ffffffff81581a48>]  [<ffffffff81581a48>] init_amd+0x4d6/0x50d
[    0.018000] RSP: 0000:ffffffff81813ed8  EFLAGS: 00010246
[    0.018000] RAX: 0000000000000000 RBX: 0000000000726f73 RCX: 00000000c001102a
[    0.018000] RDX: ffffffff8268b021 RSI: 00000000fffffffb RDI: 0000000000000005
[    0.018000] RBP: ffffffff81813f28 R08: 0000000000000000 R09: 0000000000000000
[    0.018000] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8189e140
[    0.018000] R13: ffffffff81af82e0 R14: ffff88007ffd0300 R15: 0000000000000000
[    0.018000] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    0.018000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.018000] CR2: ffff88000268c000 CR3: 000000000181e000 CR4: 00000000000006b0
[    0.018000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.018000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.018000] Process swapper/0 (pid: 0, threadinfo ffffffff81812000, task ffffffff81823440)
[    0.018000] Stack:
[    0.018000]  ffff88007d02d300 ffff88007d032000 ffffffff817689ca 0000000000000001
[    0.018000]  0000001000000001 0000000000726f73 ffffffff8189e140 ffffffff81af82e0
[    0.018000]  ffff88007ffd0300 0000000000000000 ffffffff81813f48 ffffffff81580773
[    0.018000] Call Trace:
[    0.018000]  [<ffffffff81580773>] identify_cpu+0x245/0x3c3
[    0.018000]  [<ffffffff81a816a9>] identify_boot_cpu+0x10/0x3c
[    0.018000]  [<ffffffff81a8194c>] check_bugs+0x9/0x2d
[    0.018000]  [<ffffffff81a7cd10>] start_kernel+0x2c5/0x2e1
[    0.018000]  [<ffffffff81a7c84a>] ? repair_env_string+0x5e/0x5e
[    0.018000]  [<ffffffff81a7c57c>] x86_64_start_reservations+0x2a/0x2c
[    0.018000]  [<ffffffff81a7c646>] x86_64_start_kernel+0xc8/0xcc
[    0.018000] Code: 0f 32 31 f6 85 f6 75 17 48 c1 e2 20 0d 00 04 00 00 48 09 d0 48 89 c2 48 c1 ea 20 0f 30 31 c0 41 80 3c 24 10 75 1c b9 2a 10 01 c0 <0f> 32 48 c1 e2 20 25 ff ff ff fe 48 09 d0 48 89 c2 48 c1 ea 20 
[    0.018000] RIP  [<ffffffff81581a48>] init_amd+0x4d6/0x50d
[    0.018000]  RSP <ffffffff81813ed8>
[    0.019000] ---[ end trace 12a5c70bed5abe42 ]---
[    0.020000] Kernel panic - not syncing: Attempted to kill the idle task!

[ 0.018000] Code: 0f 32 31 f6 85 f6 75 17 48 c1 e2 20 0d 00 04 00 00 48 09 d0 48 89 c2 48 c1 ea 20 0f 30 31 c0 41 80 3c 24 10 75 1c b9 2a 10 01 c0 <0f> 32 48 c1 e2 20 25 ff ff ff fe 48 09 d0 48 89 c2 48 c1 ea 20 
All code
========
   0:*  0f 32                   rdmsr       <-- trapping instruction
   2:   31 f6                   xor    %esi,%esi
   4:   85 f6                   test   %esi,%esi
   6:   75 17                   jne    0x1f
   8:   48 c1 e2 20             shl    $0x20,%rdx
   c:   0d 00 04 00 00          or     $0x400,%eax
  11:   48 09 d0                or     %rdx,%rax
  14:   48 89 c2                mov    %rax,%rdx
  17:   48 c1 ea 20             shr    $0x20,%rdx
  1b:   0f 30                   wrmsr  
  1d:   31 c0                   xor    %eax,%eax
  1f:   41 80 3c 24 10          cmpb   $0x10,(%r12)
  24:   75 1c                   jne    0x42
  26:   b9 2a 10 01 c0          mov    $0xc001102a,%ecx
  2b:*  0f 32                   rdmsr       <-- trapping instruction
  2d:   48 c1 e2 20             shl    $0x20,%rdx
  31:   25 ff ff ff fe          and    $0xfeffffff,%eax
  36:   48 09 d0                or     %rdx,%rax
  39:   48 89 c2                mov    %rax,%rdx
  3c:   48 c1 ea 20             shr    $0x20,%rdx


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
