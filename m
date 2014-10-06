Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaJFVK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:10:28 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63882 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJFVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:10:26 -0400
Message-ID: <5433053F.6020507@amacapital.net>
Date: Mon, 06 Oct 2014 14:10:23 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, wei@redhat.com,
        acme@kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86:  Tone down kernel messages when the
 PMU check fails in a virtual environment
References: <1411617314-24659-1-git-send-email-wei@redhat.com> <tip-cc6cd47e7395bc05c5077009808b820633eb3f18@git.kernel.org>
In-Reply-To: <tip-cc6cd47e7395bc05c5077009808b820633eb3f18@git.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 10:28 PM, tip-bot for Wei Huang wrote:
> Commit-ID:  cc6cd47e7395bc05c5077009808b820633eb3f18
> Gitweb:     http://git.kernel.org/tip/cc6cd47e7395bc05c5077009808b820633eb3f18
> Author:     Wei Huang <wei@redhat.com>
> AuthorDate: Wed, 24 Sep 2014 22:55:14 -0500
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 3 Oct 2014 06:04:41 +0200
> 
> perf/x86: Tone down kernel messages when the PMU check fails in a virtual environment
> 
> PMU checking can fail due to various reasons. On native machine, this
> is mostly caused by faulty hardware and it is reasonable to use
> KERN_ERR in reporting. However, when kernel is running on virtualized
> environment, this checking can fail if virtual PMU is not supported
> (e.g. KVM on AMD host). It is annoying to see an error message on
> splash screen, even though we know such failure is benign on
> virtualized environment.
> 
> This patch checks if the kernel is running in a virtualized environment.
> If so, it will use KERN_INFO in reporting, which reduces the syslog
> priority of them. This patch was tested successfully on KVM.
> 
> Signed-off-by: Wei Huang <wei@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Link: http://lkml.kernel.org/r/1411617314-24659-1-git-send-email-wei@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 918d75f..16c7302 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -243,7 +243,8 @@ static bool check_hw_exists(void)
>  
>  msr_fail:
>  	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
> -	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
> +	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
> +	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
>  

This is bogus.  String concatenation doesn't work like that.

Try "%sFailed...", boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_ERR :
KERN_INFO), etc.

--Andy
