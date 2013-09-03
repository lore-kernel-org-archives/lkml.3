Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab3ICMpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:45:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37205 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3ICMpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:45:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
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
References: <20130819081220.24406.15846.stgit@yunodevel>
	<20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com>
	<871u5or7qn.fsf@tw-ebiederman.twitter.com>
	<20130820142740.GO239280@redhat.com> <5215CDEF.30004@hitachi.com>
	<20130822131137.GL5564@redhat.com> <521C1FFF.5060203@hitachi.com>
	<20130827133355.GM239280@redhat.com> <878uzir80g.fsf@xmission.com>
	<5224014C.2070801@hitachi.com> <87ob8aix0u.fsf@xmission.com>
	<5225C1DF.1030301@hitachi.com>
Date: Tue, 03 Sep 2013 05:44:51 -0700
In-Reply-To: <5225C1DF.1030301@hitachi.com> (Yoshihiro YUNOMAE's message of
	"Tue, 03 Sep 2013 20:02:55 +0900")
Message-ID: <87ob8agjlo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/BE8si2MaWs6WgjnZdtwCgn2GDzJUqYkI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2808]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from deadlocking of ioapic_lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> writes:

> (2013/09/03 9:12), Eric W. Biederman wrote:
>>>>> Then again looking at the output of the latest dmesg, it seems the IO APIC
>>>>> is initialized way before the tsc is calibrated.  So I am not sure what
>>>>> needed to get done or what interrupts are needed before the IO APIC gets
>>>>> initialized.
>>>>
>>>> The practical issue is that jiffies was calibrated off of the PIT timer
>>>> if I recall.  But that is all old news.
>>>
>>> Are the jiffies calibration codes calibrate_delay()?
>>> It seems that the jiffies calibration have not used PIT in 2005
>>> according to 8a9e1b0.
>> 
>> Exactly.  That was the original reason why we put in the code to
>> disable the IOAPIC and the local apic.  There might have been other
>> reasons but that was the primary.
>
> Thanks, but I have still a question for jiffies calibration.
>
> When kernel boots, calibrate_delay_direct() will be called in
> calibrate_delay() for calculating loops_per_jiffy.  Then,
> calibrate_delay_direct() waits until jiffies is incremented.
> I think this means PIT or HPET is still used for the calibration.
> Is there something wrong with my understanding?
> If wrong, how is jiffies incremented?

Things have definitely changed, and I believe part of what you are
seeing is the path when things are not calibrated by an arch specific
means.

Ulimately the issue was not that we waited (or possibly still wait) for
a timer interrupt to calibrate the delay loop.  The problem was that we
had initialized the interrupt controller in PIC mode (when the kernel
did not later use the interrupt controller in PIC mode) to receive the
interrupt.

The actual impetus for getting the last of the bugs shaken out is that
we have subarchitectures on x86 that do no support interrupt controllers
in PIC mode at all.

Recently the code seems to get reorganized every other year and I loose
track of the details of which piece of code is doing what, but the
general gist remains.

The key thing to look for is that we initialize the interrupt
controllers in apic mode before we receive interrupts.  That is really
the only thing that matters, and for a long time the calibration of the
delay loop was the one notable exception.

> OK. In order to judge whether a kernel version as crashdump kernel is
> usable or not, I want to understand why we can remove disable_IO_APIC
> in detail.

That sounds like responsible engineering.

>> At the same time it has always been the targets kernel's responsibility
>> to sort out the hardware devices unless it can't possibily do it.  And
>> apics for the longest time were very very hard to reset in the target
>> kernel, but now that they are not.  It makes sense for time permitting
>> to remove the now unnecessary code in the crashing kernel.  Because
>> ultimately the less code we have the fewer possible ways we can fail
>> in a known broken kernel.
>
> Yes, I agree with you.

Eric

