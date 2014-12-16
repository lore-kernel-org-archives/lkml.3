Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbaLPFOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:14:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaLPFOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:14:30 -0500
Message-ID: <548FBFB3.9080708@suse.com>
Date: Tue, 16 Dec 2014 06:14:27 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: jongman.heo@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to
 use cache mode translation tables")
References: <1194554367.45481418704807712.JavaMail.weblogic@epmlwas09d>
In-Reply-To: <1194554367.45481418704807712.JavaMail.weblogic@epmlwas09d>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 05:40 AM, Jongman Heo wrote:
>> ------- Original Message -------
>> Sender : Juergen Gross<jgross@suse.com>
>> Date : 2014-12-15 20:52 (GMT+09:00)
>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>
>> On 12/15/2014 08:52 AM, Jongman Heo wrote:
>>>> ------- Original Message -------
>>>> Sender : Juergen Gross
>>>> Date : 2014-12-15 14:04 (GMT+09:00)
>>>> Title : Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to use cache mode translation tables")
>>>>
>>>> On 12/14/2014 06:07 AM, ÇãÁ¾¸¸ wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.
>>>>>
>>>>> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
>>>>> Author: Juergen Gross
>>>>> Date:   Mon Nov 3 14:02:03 2014 +0100
>>>>>
>>>>>        x86: Enable PAT to use cache mode translation tables
>>>>>
>>>>> Unfortunately I can't see any console log.
>>>>
>>>> Hmm, weird. Could you provide some more information?
>>>>
>>>> Kernel config, hardware used, /proc/cpuinfo of working kernel?
>>>> Anything you see with earlyprintk enabled?
>>>>
>>>>
>>>> Juergen
>>>
>>> (Sorry for resending this email, previous one bounced from mailing list due to HTML format)
>>>
>>> Hi,
>>>
>>> I'm using Fedora 21, with custom built kernel.
>>> Host PC is windows 7 64-bit, and running VMWare workstation 10 for guest Fedora Linux.
>>>
>>> With earlyprintk, just following message is printed.
>>>
>>>     early console in setup code
>>>
>>> and nothing more...
>>
>> Can you try attached diagnostic patch, please? I suspect a problem
>> regarding VMWares PAT emulation...
>>
>>
>> Juergen
> 
> Hi,
> 
> With the commit reverted, the patch doesn't apply.

Sure.

> Without revert, kernel (patch applied) doesn't boot and I can't see any message.

What are your kernel parameters? There must be some message with the
diagnostic patch, as the first pr_info() is called before any other
part of the critical patch is becoming active. Could it be you have
instructed the kernel to be "quiet"? I'd recommend:

earlyprintk=vga ignore_loglevel

and no quiet. I don't know VMWare settings, so may be you can use
earlyprintk=ttyS0 instead of vga.

> 
> Let me show you my PAT values (the commit reverted)
> 
> # dmesg | grep PAT
> [    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
> [    0.314631] x86 PAT enabled: cpu 3, old 0x0, new 0x7010600070106
> [    0.314703] x86 PAT enabled: cpu 1, old 0x0, new 0x7010600070106
> [    0.314780] x86 PAT enabled: cpu 2, old 0x0, new 0x7010600070106
> [    0.314852] x86 PAT enabled: cpu 4, old 0x0, new 0x7010600070106
> [    0.314923] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
> [    0.314997] x86 PAT enabled: cpu 6, old 0x0, new 0x7010600070106
> [    0.315069] x86 PAT enabled: cpu 7, old 0x0, new 0x7010600070106
> [    0.315142] x86 PAT enabled: cpu 5, old 0x0, new 0x7010600070106

These are the expected values. But these values are the ones which are
written, not the ones which have been read from the PAT MSR again.

Without applying the critical patch you could add:

rdmsrl(MSR_IA32_CR_PAT, pat);
printk(KERN_INFO "PAT read: cpu %d, 0x%Lx\n", smp_processor_id(), pat);

at the end of pat_init() to verify VMWare is handling reads of the PAT
MSR properly.

Juergen

