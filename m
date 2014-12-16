Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaLPGg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:36:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaLPGg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:36:27 -0500
Message-ID: <548FD2E8.5030307@suse.com>
Date: Tue, 16 Dec 2014 07:36:24 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: jongman.heo@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to
 use cache mode translation tables")
References: <1700772815.47681418711378276.JavaMail.weblogic@epmlwas09d>
In-Reply-To: <1700772815.47681418711378276.JavaMail.weblogic@epmlwas09d>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 07:29 AM, Jongman Heo wrote:
>>
>> ------- Original Message -------
>> Sender : Juergen Gross<jgross@suse.com>
>> Date : 2014-12-16 14:14 (GMT+09:00)
>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>
>> On 12/16/2014 05:40 AM, Jongman Heo wrote:
>>>> ------- Original Message -------
>>>> Sender : Juergen Gross
>>>> Date : 2014-12-15 20:52 (GMT+09:00)
>>>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>>>
>>>> On 12/15/2014 08:52 AM, Jongman Heo wrote:
>>>>>> ------- Original Message -------
>>>>>> Sender : Juergen Gross
>>>>>> Date : 2014-12-15 14:04 (GMT+09:00)
>>>>>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>>>>>
>>>>>> On 12/14/2014 06:07 AM, ÇãÁ¾¸¸ wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.
>>>>>>>
>>>>>>> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
>>>>>>> Author: Juergen Gross
>>>>>>> Date:   Mon Nov 3 14:02:03 2014 +0100
>>>>>>>
>>>>>>>         x86: Enable PAT to use cache mode translation tables
>>>>>>>
>>>>>>> Unfortunately I can't see any console log.
>>>>>>
>>>>>> Hmm, weird. Could you provide some more information?
>>>>>>
>>>>>> Kernel config, hardware used, /proc/cpuinfo of working kernel?
>>>>>> Anything you see with earlyprintk enabled?
>>>>>>
>>>>>>
>>>>>> Juergen
>>>>>
>>>>> (Sorry for resending this email, previous one bounced from mailing list due to HTML format)
>>>>>
>>>>> Hi,
>>>>>
>>>>> I'm using Fedora 21, with custom built kernel.
>>>>> Host PC is windows 7 64-bit, and running VMWare workstation 10 for guest Fedora Linux.
>>>>>
>>>>> With earlyprintk, just following message is printed.
>>>>>
>>>>>      early console in setup code
>>>>>
>>>>> and nothing more...
>>>>
>>>> Can you try attached diagnostic patch, please? I suspect a problem
>>>> regarding VMWares PAT emulation...
>>>>
>>>>
>>>> Juergen
>>>
>>> Hi,
>>>
>>> With the commit reverted, the patch doesn't apply.
>>
>> Sure.
>>
>>> Without revert, kernel (patch applied) doesn't boot and I can't see any message.
>>
>> What are your kernel parameters? There must be some message with the
>> diagnostic patch, as the first pr_info() is called before any other
>> part of the critical patch is becoming active. Could it be you have
>> instructed the kernel to be "quiet"? I'd recommend:
>>
>> earlyprintk=vga ignore_loglevel
>>
>> and no quiet. I don't know VMWare settings, so may be you can use
>> earlyprintk=ttyS0 instead of vga.
>>
>>>
>>> Let me show you my PAT values (the commit reverted)
>>>
>>> # dmesg | grep PAT
>>> [    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
>>> [    0.314631] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
>>> [    0.314703] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
>>> [    0.314780] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
>>> [    0.314852] x86 PAT enabled: cpu 4, old 0x0, new 0x7010600070106
>>> [    0.314923] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
>>> [    0.314997] x86 PAT enabled: cpu 6, old 0x0, new 0x7010600070106
>>> [    0.315069] x86 PAT enabled: cpu 7, old 0x0, new 0x7010600070106
>>> [    0.315142] x86 PAT enabled: cpu 5, old 0x0, new 0x7010600070106
>>
>> These are the expected values. But these values are the ones which are
>> written, not the ones which have been read from the PAT MSR again.
>>
>> Without applying the critical patch you could add:
>>
>> rdmsrl(MSR_IA32_CR_PAT, pat);
>> printk(KERN_INFO "PAT read: cpu %d, 0x%Lx\n", smp_processor_id(), pat);
>>
>> at the end of pat_init() to verify VMWare is handling reads of the PAT
>> MSR properly.
>>
>> Juergen
>>
> 
> Hi,
> 
> With earlyprintk=vga, I can see the log.
> But due to call trace, I can't see what the pat value is.
> 
> Call chain is as follows.
> 
>    i386_start_kernel -> start_kernel -> setup_arch ->
>    mtrr_bp_init -> get_mtrr_state -> pat_init ->
>    pat_init_cache_mode_entry -> update_cache_mode_entry ->
>    early_idt_handler -> dump_stack
> 
> So, I blocked update_cache_mode_entry() call like below...
> 
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -182,11 +182,12 @@ void pat_init_cache_modes(void)
>          u64 pat;
>   
>          rdmsrl(MSR_IA32_CR_PAT, pat);
> +       pr_info("read pat %0llx\n", pat);
>          pat_msg[32] = 0;
>          for (i = 7; i >= 0; i--) {
>                  cache = pat_get_cache_mode((pat >> (i * 8)) & 7,
>                                             pat_msg + 4 * i);
> -               update_cache_mode_entry(i, cache);
> +               //update_cache_mode_entry(i, cache);
>          }
>          pr_info("PAT configuration [0-7]: %s\n", pat_msg);
>   }
> @@ -238,9 +239,13 @@ void pat_init(void)
>                  rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
>   
>          wrmsrl(MSR_IA32_CR_PAT, pat);
> +       pr_info("about to write pat %0llx\n", pat);
>   
>          if (boot_cpu)
>                  pat_init_cache_modes();
> +
> +       rdmsrl(MSR_IA32_CR_PAT, pat);
> +       printk(KERN_INFO "PAT read: cpu %d, 0x%Lx\n", smp_processor_id(), pat);
>   }
>   
> 
> Then boot is fine, and PAT values are as follows.
> 
> 
> # dmesg|grep -i "pat "
> [    0.000000] about to write pat 7010600070106
> [    0.000000] read pat 0
> [    0.000000] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.000000] PAT read: cpu 0, 0x0
> [    0.320559] about to write pat 7010600070106
> [    0.320876] read pat 0
> [    0.321090] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.321260] PAT read: cpu 5, 0x0
> [    0.321403] about to write pat 7010600070106
> [    0.321818] read pat 0
> [    0.322033] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.322205] PAT read: cpu 6, 0x0
> [    0.322334] about to write pat 7010600070106
> [    0.322417] read pat 0
> [    0.322479] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.322573] PAT read: cpu 0, 0x0
> [    0.322703] about to write pat 7010600070106
> [    0.323012] read pat 0
> [    0.323228] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.323400] PAT read: cpu 1, 0x0
> [    0.323537] about to write pat 7010600070106
> [    0.323833] read pat 0
> [    0.324055] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.324224] PAT read: cpu 7, 0x0
> [    0.324362] about to write pat 7010600070106
> [    0.324662] read pat 0
> [    0.324877] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.325048] PAT read: cpu 2, 0x0
> [    0.325185] about to write pat 7010600070106
> [    0.325483] read pat 0
> [    0.325695] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.325863] PAT read: cpu 4, 0x0
> [    0.325997] about to write pat 7010600070106
> [    0.326288] read pat 0
> [    0.326507] PAT configuration [0-7]: UC  UC  UC  UC  UC  UC  UC  UC
> [    0.326677] PAT read: cpu 3, 0x0

Okay, so VMWare doesn't seem to return the correct PAT MSR value.

I suggest you try "nopat" as kernel option. This should disable all the
PAT handling and VMWare can't wreck the kernel this way.

I'll write a patch which detects this VMWare bug by checking the PAT
value after writing it.

Thanks for reporting that case,


Juergen

