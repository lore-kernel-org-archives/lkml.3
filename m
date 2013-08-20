Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3HTDOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:14:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47635 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3HTDOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:14:12 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5212DEC8.9000609@jp.fujitsu.com>
Date: Tue, 20 Aug 2013 12:13:12 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        bhelgaas@google.com, Jingbai Ma <jingbai.ma@hp.com>
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
References: <5200BFB3.2050202@jp.fujitsu.com> <520A10A3.5080303@hp.com> <520B4A22.2030800@hp.com> <87ob90839p.fsf@xmission.com> <5211831B.6090704@jp.fujitsu.com> <a2ff8170-41ad-42f6-9015-850dbe14983d@email.android.com> <20130819154626.39403f5b@hananiah.suse.cz>
In-Reply-To: <20130819154626.39403f5b@hananiah.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/19 22:46), Petr Tesarik wrote:
> On Sun, 18 Aug 2013 19:59:53 -0700
> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
>>
>>
>>
>>>
>>> Sorry Eric, I'm not clear to what you mean by ``short one core''...
>>> Which are you suggesting? Disabling BSP if crash happens on AP is
>>> reasonable?
>>> Or restricting cpus to a single one only just as the current kdump
>>> configuration is reasonable?
>>
>> I am suggesting we start every cpu except the BSP from the AP we started on.
>>
>> N-1 cpus seems like a good tradeoff between performance and reliability for those who need it.
>
> FWIW a large customers of ours is fine with such a limitation. And I
> have already tested this approach manually (starting the kdump kernel
> with maxcpus=1 and hot-plugging the remaining APs from user-space).
>

This is a workaround I suggested previously on this mailing list?
The additional merits of disabling BSP in kernel-side on the 2nd kernel is:

- We can assign memory for BSP to another CPU that is available. It's more
   efficient in memory consumption. It's the same reason why distro uses nr_cpus=1
   instead of maxcpus=1. If we don't disable BSP, we allocate some amount of memory
   for BSP in kernel-space although we never use it. 2nd kernel should have as small
   amount of memory as possible.

- Remove BSP from hot-plugging target CPUes. Keeping BSP after crash happens on AP
   means keeping a potential risk of triggering system hang from user-space.
   Can remove awkward configuration to hot-add APs from user-space while avoiding BSP.
   This seems less important than the above.

On practical configuraiton, it's necessary to decide how many cpus we should use
on the 2nd kernel for trade-off of performance and acceptable amount of memory
for additional CPUes. I think it would simply be the number of disks and the number
of threads of makedumpfile in most cases.

> Now that this approach is in line with upstream efforts, I'm going to
> test it on some more machines and see if there are any troubles.
>
> @Hatayama-san:
>> BTW, I have question that does normal kdump work well if crash happens
>> on some AP? I wonder the same issue could happen on the 2nd kernel.
>
> I'm not sure what you mean. Normal kdump starts with "maxcpus=1", and
> yes, that works even if the secondary kernel is booted from an AP. OTOH
> I suspect that not having any BSP in the system may be the cause of some
> mysterious random reboots and/or hangs experienced by some customers.
>
> I'll try setting the BSP flag on the boot CPU unconditionally and see
> if it makes any difference.
>
> Petr Tesarik
>

Ma saw a hang when he tried to reboot his HP systems on the 1st kernel
under the condition that BSP flag was unset on any existing CPUs. I
thought the condition is similar to the 2nd kernel after crash happens
on AP in the sense that there is no BSP in online CPUs. If the hang he saw
was caused by running reboot on the CPU without BSP flag, I guess the same
situation could already happen on only-1-cpu configuration now.

-- 
Thanks.
HATAYAMA, Daisuke

