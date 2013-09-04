Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab3IDJlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:41:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38182 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab3IDJlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:41:08 -0400
X-AuditID: 85900ec0-d0927b9000001514-4b-52270030cb15
Message-ID: <52270022.2050602@hitachi.com>
Date: Wed, 04 Sep 2013 18:40:50 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Ingo Molnar <mingo@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from
 deadlocking of ioapic_lock
References: <20130819081220.24406.15846.stgit@yunodevel> <20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com> <871u5or7qn.fsf@tw-ebiederman.twitter.com> <20130820142740.GO239280@redhat.com> <5215CDEF.30004@hitachi.com> <20130822131137.GL5564@redhat.com> <521C1FFF.5060203@hitachi.com> <20130827133355.GM239280@redhat.com> <878uzir80g.fsf@xmission.com> <5224014C.2070801@hitachi.com> <87ob8aix0u.fsf@xmission.com> <5225C1DF.1030301@hitachi.com> <87ob8agjlo.fsf@xmission.com>
In-Reply-To: <87ob8agjlo.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 21:44), Eric W. Biederman wrote:
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> writes:
> 
>> (2013/09/03 9:12), Eric W. Biederman wrote:
>>>>>> Then again looking at the output of the latest dmesg, it seems the IO APIC
>>>>>> is initialized way before the tsc is calibrated.  So I am not sure what
>>>>>> needed to get done or what interrupts are needed before the IO APIC gets
>>>>>> initialized.
>>>>>
>>>>> The practical issue is that jiffies was calibrated off of the PIT timer
>>>>> if I recall.  But that is all old news.
>>>>
>>>> Are the jiffies calibration codes calibrate_delay()?
>>>> It seems that the jiffies calibration have not used PIT in 2005
>>>> according to 8a9e1b0.
>>>
>>> Exactly.  That was the original reason why we put in the code to
>>> disable the IOAPIC and the local apic.  There might have been other
>>> reasons but that was the primary.
>>
>> Thanks, but I have still a question for jiffies calibration.
>>
>> When kernel boots, calibrate_delay_direct() will be called in
>> calibrate_delay() for calculating loops_per_jiffy.  Then,
>> calibrate_delay_direct() waits until jiffies is incremented.
>> I think this means PIT or HPET is still used for the calibration.
>> Is there something wrong with my understanding?
>> If wrong, how is jiffies incremented?
> 
> Things have definitely changed, and I believe part of what you are
> seeing is the path when things are not calibrated by an arch specific
> means.
> 
> Ulimately the issue was not that we waited (or possibly still wait) for
> a timer interrupt to calibrate the delay loop.  The problem was that we
> had initialized the interrupt controller in PIC mode (when the kernel
> did not later use the interrupt controller in PIC mode) to receive the
> interrupt.
> 
> The actual impetus for getting the last of the bugs shaken out is that
> we have subarchitectures on x86 that do no support interrupt controllers
> in PIC mode at all.

Is one of the subarchitectures Moorestown?

I found the Moorestown patch(05ddafb) which defined
pre_init_apic_IRQ0(). If this function will enable IOAPIC before using
timer(i.e. the function is called before calibrate_delay()), we will
be able to remove disable_IO_APIC. However, this function is a
Moorestown specific code, and normal PCs don't execute it.

I haven't find the generic cord which operates like pre_init_apic_IRQ0()
yet. Please tell me if you remember something.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


