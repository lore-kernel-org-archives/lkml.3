Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaIYJf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:35:57 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:37826 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbaIYJfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:35:55 -0400
Message-ID: <5423E1F7.5010000@nexus-software.ie>
Date: Thu, 25 Sep 2014 10:35:51 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Quark: Flush TLB via CR3 not CR4.PGE in setup_arch()
References: <1411578452-4609-1-git-send-email-pure.logic@nexus-software.ie> <20140925045755.GA20431@gmail.com>
In-Reply-To: <20140925045755.GA20431@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 41ead8d..1d2396a 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -879,7 +879,10 @@ void __init setup_arch(char **cmdline_p)
>>   			KERNEL_PGD_PTRS);
>>
>>   	load_cr3(swapper_pg_dir);
>> -	__flush_tlb_all();
>> +	if (boot_cpu_data.x86 == 5 && boot_cpu_data.x86_model == 9)
>> +		__flush_tlb();
>> +	else
>> +		__flush_tlb_all();
>
> So why not make __flush_tlb_all() Quark-quirk-aware and be done
> with it, instead of having to validate every single
> __flush_tlb_all() user?
>
> Quark breaks the x86 'flush all TLBs' semantics - the way to fix
> it is to restore those semantics, not to sprinkle the breakage
> all around the code ...

Hi Ingo.

We have made __flush_tlb_all() Quark aware - because the previous patch 
we applied to arch/x86/kernel/cpu/intel.c

ee1b5b165c0a2f04d2107e634e51f05d0eb107de

+	if (c->x86 == 5 && c->x86_model == 9) {
+		pr_info("Disabling PGE capability bit\n");
+		setup_clear_cpu_cap(X86_FEATURE_PGE);
+	}

will cause cpu_has_pge() to be false and then the flush_tlb_all code 
will take the path we want __flush_tlb not __flush_tlb_global

static inline void __flush_tlb_all(void)
{
         if (cpu_has_pge)
                 __flush_tlb_global();
         else
                 __flush_tlb();
}

The code in setup_arch runs before the cpu_has_pge bit been clobbered.

The commit you did 02276a3a677d681f0cd227d7111c71fdbce23832 just adds a 
comment to setup_arch to indicate the behaviour we are relying on

setup_arch()
{

load_cr3(swapper_pg_dir);	/* this will flush the TLB on Quark */
__flush_tlb_all();		/*cpu_has_pge() is true at this point*/

......

/* this is where we latch the cpu cabability bits */
early_cpu_init();
}

--
BOD
