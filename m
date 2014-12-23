Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaLWHvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:51:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:40625 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbaLWHu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:50:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="503010733"
Message-ID: <54991EDE.5020806@intel.com>
Date: Tue, 23 Dec 2014 15:50:54 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        luto@amacapital.net
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
References: <20141221124640.GA4059@cucamonga.audible.transient.net> <5497C882.4000108@intel.com> <20141222092358.GA3915@cucamonga.audible.transient.net> <5498CA50.8070906@intel.com> <5498CB62.3070901@intel.com> <20141223072659.GA4015@cucamonga.audible.transient.net>
In-Reply-To: <20141223072659.GA4015@cucamonga.audible.transient.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/23 15:26, Jamie Heilman wrote:
> Chen, Tiejun wrote:
>> On 2014/12/23 9:50, Chen, Tiejun wrote:
>>> On 2014/12/22 17:23, Jamie Heilman wrote:
>>>> Chen, Tiejun wrote:
>>>>> On 2014/12/21 20:46, Jamie Heilman wrote:
>>>>>> With v3.19-rc1 when I run qemu-system-x86_64 -machine pc,accel=kvm I
>>>>>> get:
>>>>>>
>>>>>> KVM: entry failed, hardware error 0x80000021
>>>>>
>>>>> Looks some MSR writing issues such a failed entry.
>>>>>
>>>>>> If you're running a guest on an Intel machine without unrestricted mode
>>>>>> support, the failure can be most likely due to the guest entering an
>>>>>> invalid
>>>>>> state for Intel VT. For example, the guest maybe running in big real
>>>>>> mode
>>>>>> which is not supported on less recent Intel processors.
>>>>>>
>>>>>> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000663
>>>>>> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
>>>>>> EIP=0000e05b EFL=00010002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
>>>>>> ES =0000 00000000 0000ffff 00009300
>>>>>> CS =f000 000f0000 0000ffff 00009b00
>>>>>> SS =0000 00000000 0000ffff 00009300
>>>>>> DS =0000 00000000 0000ffff 00009300
>>>>>> FS =0000 00000000 0000ffff 00009300
>>>>>> GS =0000 00000000 0000ffff 00009300
>>>>>> LDT=0000 00000000 0000ffff 00008200
>>>>>> TR =0000 00000000 0000ffff 00008b00
>>>>>> GDT=     00000000 0000ffff
>>>>>> IDT=     00000000 0000ffff
>>>>>> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
>>>>>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>>>>>> DR3=0000000000000000
>>>>>> DR6=00000000ffff0ff0 DR7=0000000000000400
>>>>>> EFER=0000000000000000
>>>>>
>>>>> And I don't see any obvious wrong as well. Any valuable info from dmesg?
>>>>
>>>> With the simple qemu command above, on 3.18.1 I see:
>>>>
>>>> kern.info: kvm: zapping shadow pages for mmio generation wraparound
>>>>
>>>> when I fire up a full guest that's actually useful I get:
>>>>
>>>> kern.info: kvm: zapping shadow pages for mmio generation wraparound
>>>> kern.err: kvm [4073]: vcpu0 disabled perfctr wrmsr: 0xc1 data 0xffff
>>>>
>>>> On 3.18.0-rc3-00042-g34a1cd6 nothing appears in the dmesg, just the
>>>> message I mention above to stderr.  Same thing with a stock
>>>> 3.19.0-rc1.  Once I apply your patch the simple test command produces
>>>> the same zapping shadow pages messages as 3.18.1, and a test guest of
>>>> a Debian Jessie image (w/stock distro kernel) produces the same thing
>>>> with disabled perfctr wrmsr message.  However, it doesn't look like
>>>
>>> Sorry I'm not sure if I understood current status. Looks 3.19-rc1 & my
>>> patch just fix that error above,
>>>
>>> KVM: entry failed, hardware error 0x80000021
>>> ...
>>>
>>> Right?
>>>
>>>> I'm entirely out of the woods, because one of my other guest VMs with a
>>>> custom kernel that works great under 3.18.1 now fails to run.  Nothing
>>>> in dmesg, but here's the stderr:
>>>
>>> But even you revert 34a1cd60d17 or just apply my patch, something else
>>> introduced between 3.18.1 and 3.19-rc1 led this error below, right?
>>>
>>>>
>>>> KVM internal error. Suberror: 1
>>>> emulation failure
>>>> EAX=000de494 EBX=00000000 ECX=00000000 EDX=00000cfd
>>>> ESI=00000059 EDI=00000000 EBP=00000000 ESP=00006fb4
>>>> EIP=000f15c1 EFL=00010016 [----AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
>>>> ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>>>> CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
>>>> SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>>>> DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>>>> FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>>>> GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>>>> LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
>>>> TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
>>>> GDT=     000f6be8 00000037
>>>> IDT=     000f6c26 00000000
>>>> CR0=60000011 CR2=00000000 CR3=00000000 CR4=00000000
>>>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>>>> DR3=0000000000000000
>>>> DR6=00000000ffff0ff0 DR7=0000000000000400
>>>> EFER=0000000000000000
>>>> Code=e8 ae fc ff ff 89 f2 a8 10 89 d8 75 0a b9 41 15 ff ff ff d1 <5b>
>>>> 5e c3 5b 5e e9 76 ff ff ff b0 11 e6 20 e6 a0 b0 08 e6 21 b0 70 e6 a1
>>>> b0 04 e6 21 b0 02
>>>>
>>>> FWIW, I get the same thing with 34a1cd60d17 reverted.  Maybe there are
>>>> two bugs, maybe there's more to this first one.  I can repro this
>>>
>>> So if my understanding is correct, this is probably another bug. And
>>> especially, I already saw the same log in another thread, "Cleaning up
>>> the KVM clock". Maybe you can continue to `git bisect` to locate that
>>> bad commit.
>>>
>>
>> Looks just now Andy found that commit,
>> 0e60b0799fedc495a5c57dbd669de3c10d72edd2 "kvm: change memslot sorting rule
>> from size to GFN", maybe you can try to revert this to try yours again.
>
> That doesn't revert cleanly for me, and I don't have much time to

Yeah, I guess all associated commits should be reverted gradually.

> fiddle with it until the 24th---so checked out the commit before it
> (d4ae84a0), applied your patch, built, and yes, everything works fine

Thanks for your test.

I think I can submit this patch to fix one of yours problems and I'd 
like to add you as Reported-by & Tested-by.

Then we can step into another issue. And I'm trying to fetch 3.19-rc1 
(because I'm always working on kvm/next.) to take a look at that but 
maybe Paolo is already going on that.

Tiejun

> at that point.  I'll probably have time for another full bisection
> later, assuming things aren't ironed out already by then.
>
