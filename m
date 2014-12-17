Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaLQJoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:44:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLQJoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:44:37 -0500
Message-ID: <54915050.8070307@redhat.com>
Date: Wed, 17 Dec 2014 10:43:44 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>
CC: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 26/35] [PATCH 26/36] powerpc: Replace __get_cpu_var uses
References: <20140817173023.439660246@linux.com> <20140817173036.985604442@linux.com> <20140826181444.GJ31659@mtj.dyndns.org> <5490AD09.3000807@suse.de>
In-Reply-To: <5490AD09.3000807@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/12/2014 23:07, Alexander Graf wrote:
> On 26.08.14 20:14, Tejun Heo wrote:
>> On Sun, Aug 17, 2014 at 12:30:49PM -0500, Christoph Lameter wrote:
>>> __get_cpu_var() is used for multiple purposes in the kernel source. One of
>>> them is address calculation via the form &__get_cpu_var(x).  This calculates
>>> the address for the instance of the percpu variable of the current processor
>>> based on an offset.
>>>
>>> Other use cases are for storing and retrieving data from the current
>>> processors percpu area.  __get_cpu_var() can be used as an lvalue when
>>> writing data or on the right side of an assignment.
>> ...
>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> CC: Paul Mackerras <paulus@samba.org>
>>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>> (Please disregard the ones I posted for v1 of the patch series)
>>
>> Applied to percpu/for-3.18-consistent-ops with the fix up patch rolled
>> in.  Please let me know if this patch should be routed differently.
>> Note that this patch was to be applied to percpu/for-3.17 but delayed
>> due to build issues caused by cpumask_var_t.
> 
> Unfortunately this commit breaks e500v2 builds with KVM enabled:
> 
>   arch/powerpc/kvm/e500.c: In function "local_sid_setup_one":
>   arch/powerpc/kvm/e500.c:81:29: error: macro "__this_cpu_write"
> requires 2 arguments, but only 1 given
>   arch/powerpc/kvm/e500.c:81:3: error: unknown type name "__this_cpu_write"
>   arch/powerpc/kvm/e500.c:81:47: error: expected "=", ",", ";", "asm" or
> "__attribute__" before ")" token
>   arch/powerpc/kvm/e500.c:82:8: error: request for member "val" in
> something not a structure or union
>   arch/powerpc/kvm/e500.c:83:8: error: request for member "pentry" in
> something not a structure or union
> 
> Looking at the offending line of code I'm not surprised:
> 
> -               __get_cpu_var(pcpu_sids).entry[sid] = entry;
> +               __this_cpu_write(pcpu_sids)entry[sid], entry);
> 
> This doesn't quite look like valid C to me. The patch below fixes the
> build error for me. Please check whether it's correct and if so apply it
> directly to the tree.

I can also ask Linus to squash it in the merge.

Paolo

> 
> 
> Alex
> 
> 
> From: Alexander Graf <agraf@suse.de>
> Date: Tue, 16 Dec 2014 23:04:01 +0100
> Subject: [PATCH] KVM: PPC: E500: Compile fix in this_cpu_write
> 
> Commit 69111bac42f5 (powerpc: Replace __get_cpu_var uses) introduced compile
> breakage to the e500 target by introducing invalid automatically created C
> syntax.
> 
> Fix up the breakage and make the code compile again.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> 
> diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
> index 1609584..e1cb588 100644
> --- a/arch/powerpc/kvm/e500.c
> +++ b/arch/powerpc/kvm/e500.c
> @@ -78,7 +78,7 @@ static inline int local_sid_setup_one(struct id *entry)
> 
>  	sid = __this_cpu_inc_return(pcpu_last_used_sid);
>  	if (sid < NUM_TIDS) {
> -		__this_cpu_write(pcpu_sids)entry[sid], entry);
> +		__this_cpu_write(pcpu_sids.entry[sid], entry);
>  		entry->val = sid;
>  		entry->pentry = this_cpu_ptr(&pcpu_sids.entry[sid]);
>  		ret = sid;
> 
