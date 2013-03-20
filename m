Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3CTXQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:16:12 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42496 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3CTXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:16:11 -0400
Message-ID: <514A4337.6080100@gmail.com>
Date: Wed, 20 Mar 2013 16:16:07 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Huacai Chen <chenhc@lemote.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>
Subject: Re: [PATCH V2 02/02] MIPS: Init new mmu_context for each possible
 CPU to avoid memory corruption
References: <1363524614-3823-1-git-send-email-chenhc@lemote.com>
In-Reply-To: <1363524614-3823-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 05:50 AM, Huacai Chen wrote:
> Currently, init_new_context() only for each online CPU, this may cause
> memory corruption when CPU hotplug and fork() happens at the same time.
> To avoid this, we make init_new_context() cover each possible CPU.
>
> Scenario:
> 1, CPU#1 is being offline;
> 2, On CPU#0, do_fork() call dup_mm() and copy a mm_struct to the child;
> 3, On CPU#0, dup_mm() call init_new_context(), since CPU#1 is offline
>     and init_new_context() only covers the online CPUs, child has the
>     same asid as its parent on CPU#1 (however, child's asid should be 0);
> 4, CPU#1 is being online;
> 5, Now, if both parent and child run on CPU#1, memory corruption (e.g.
>     segfault, bus error, etc.) will occur.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>


We were seeing the same crashes, this patch set seems to fix the problem.

Acked-by: David Daney <david.daney@cavium.com>

> ---
>   arch/mips/include/asm/mmu_context.h |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
> index e81d719..49d220c 100644
> --- a/arch/mips/include/asm/mmu_context.h
> +++ b/arch/mips/include/asm/mmu_context.h
> @@ -133,7 +133,7 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>   {
>   	int i;
>
> -	for_each_online_cpu(i)
> +	for_each_possible_cpu(i)
>   		cpu_context(i, mm) = 0;
>
>   	return 0;
>

