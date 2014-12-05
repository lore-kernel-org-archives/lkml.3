Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaLEFIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:08:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaLEFIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:08:49 -0500
Message-ID: <54813DB2.5060002@redhat.com>
Date: Fri, 05 Dec 2014 00:08:02 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steve Capper <steve.capper@linaro.org>
CC: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com> <547C36DB.7060903@hitachi.com> <547F242D.1060705@redhat.com> <547F94B0.1000902@linaro.org> <547FB5DD.901@redhat.com>
In-Reply-To: <547FB5DD.901@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 08:16 PM, William Cohen wrote:
> On 12/03/2014 05:54 PM, David Long wrote:
>> On 12/03/14 09:54, William Cohen wrote:
>>> On 12/01/2014 04:37 AM, Masami Hiramatsu wrote:
>>>> (2014/11/29 1:01), Steve Capper wrote:
>>>>> On 27 November 2014 at 06:07, Masami Hiramatsu
>>>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>>> (2014/11/27 3:59), Steve Capper wrote:
>>>>>>> The crash is extremely easy to reproduce.
>>>>>>>
>>>>>>> I've not observed any missed events on a kprobe on an arm64 system
>>>>>>> that's still alive.
>>>>>>> My (limited!) understanding is that this suggests there could be a
>>>>>>> problem with how missed events from a recursive call to memcpy are
>>>>>>> being handled.
>>>>>>
>>>>>> I think so too. BTW, could you bisect that? :)
>>>>>>
>>>>>
>>>>> I can't bisect, but the following functions look suspicious to me
>>>>> (again I'm new to kprobes...):
>>>>> kprobes_save_local_irqflag
>>>>> kprobes_restore_local_irqflag
>>>>>
>>>>> I think these are breaking somehow when nested (i.e. from a recursive probe).
>>>>
>>>> Agreed. On x86, prev_kprobe has old_flags and saved_flags, this
>>>> at least must have saved_irqflag and save/restore it in
>>>> save/restore_previous_kprobe().
>>>>
>>>> What about adding this?
>>>>
>>>>   struct prev_kprobe {
>>>>       struct kprobe *kp;
>>>>       unsigned int status;
>>>> +    unsigned long saved_irqflag;
>>>>   };
>>>>
>>>> and
>>>>
>>>>   static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
>>>>   {
>>>>       kcb->prev_kprobe.kp = kprobe_running();
>>>>       kcb->prev_kprobe.status = kcb->kprobe_status;
>>>> +    kcb->prev_kprobe.saved_irqflag = kcb->saved_irqflag;
>>>>   }
>>>>
>>>>   static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
>>>>   {
>>>>       __this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
>>>>       kcb->kprobe_status = kcb->prev_kprobe.status;
>>>> +    kcb->saved_irqflag = kcb->prev_kprobe.saved_irqflag;
>>>>   }
>>>>
>>>>
>>>
>>> I have noticed with the aarch64 kprobe patches and recent kernel I can get the machine to end up getting stuck and printing out endless strings of
>>>
>>> [187694.855843] Unexpected kernel single-step exception at EL1
>>> [187694.861385] Unexpected kernel single-step exception at EL1
>>> [187694.866926] Unexpected kernel single-step exception at EL1
>>> [187694.872467] Unexpected kernel single-step exception at EL1
>>> [187694.878009] Unexpected kernel single-step exception at EL1
>>> [187694.883550] Unexpected kernel single-step exception at EL1
>>>
>>> I can reproduce this pretty easily on my machine with functioncallcount.stp from https://sourceware.org/systemtap/examples/profiling/functioncallcount.stp and the following steps:
>>>
>>> # stap -p4 -k -m mm_probes -w functioncallcount.stp "*@mm/*.c" -c "sleep 1"
>>> # staprun mm_probes.ko -c "sleep 1"
>>>
>>> -Will
>>
>> I did a fresh checkout and build of systemtap and tried the above.  I'm not yet seeing this problem.  It does remind me of the problem we saw before debug exception handling in entry.S was patched in v3.18-rc1, but you say you are using recent kernel sources.
>>
> 
> Hi Dave,
> 
> I saw this problem with a 3.18.0-rc5 based kernel.  Today I built a kernel based on  3.18.0-0.rc6.git0.1.x1 with the patches and I didn't see the problem with the unexpected kernel single-step exception.  I am not sure if maybe there was some problem function being probed in the 3.18.0-rc5 kernel but not with the 3.18.0-rc6 kernel or maybe some difference in the config between the kernels. It seemed wiser to mention it.
> 

I saw this problem with the 3.18.0-rc6 kernel today. Note that this kernel did not have the patch for save_irqflag masami suggested above.  It seems to be an intermittent problem and doesn't occur every time.  The particular systemtap test that is triggering the problem installs a lot of probe points and this could be triggering some problem with nested kprobes.

-Will
