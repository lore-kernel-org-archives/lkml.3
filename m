Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886Ab3ICLDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:03:17 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37246 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3ICLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:03:15 -0400
X-AuditID: 85900ec0-d1d29b9000001514-4c-5225c1efc405
Message-ID: <5225C1DF.1030301@hitachi.com>
Date: Tue, 03 Sep 2013 20:02:55 +0900
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
References: <20130819081220.24406.15846.stgit@yunodevel> <20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com> <871u5or7qn.fsf@tw-ebiederman.twitter.com> <20130820142740.GO239280@redhat.com> <5215CDEF.30004@hitachi.com> <20130822131137.GL5564@redhat.com> <521C1FFF.5060203@hitachi.com> <20130827133355.GM239280@redhat.com> <878uzir80g.fsf@xmission.com> <5224014C.2070801@hitachi.com> <87ob8aix0u.fsf@xmission.com>
In-Reply-To: <87ob8aix0u.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 9:12), Eric W. Biederman wrote:
>>>> Then again looking at the output of the latest dmesg, it seems the IO APIC
>>>> is initialized way before the tsc is calibrated.  So I am not sure what
>>>> needed to get done or what interrupts are needed before the IO APIC gets
>>>> initialized.
>>>
>>> The practical issue is that jiffies was calibrated off of the PIT timer
>>> if I recall.  But that is all old news.
>>
>> Are the jiffies calibration codes calibrate_delay()?
>> It seems that the jiffies calibration have not used PIT in 2005
>> according to 8a9e1b0.
> 
> Exactly.  That was the original reason why we put in the code to
> disable the IOAPIC and the local apic.  There might have been other
> reasons but that was the primary.

Thanks, but I have still a question for jiffies calibration.

When kernel boots, calibrate_delay_direct() will be called in
calibrate_delay() for calculating loops_per_jiffy.  Then,
calibrate_delay_direct() waits until jiffies is incremented.
I think this means PIT or HPET is still used for the calibration.
Is there something wrong with my understanding?
If wrong, how is jiffies incremented?

>>> The kernel startup path has been fixed for years, and disable_IO_APIC in
>>> crash_kexec has always been a bug work-around for deficiencies in the
>>> kernel's start up path (not part of the guaranteed interface).
>>> Furthermore every real system configuration I have encountered used the
>>> same kernel version for the crashdump kernel and the production kernel.
>>> So we should be good.
>>
>> We also will be use the kdump(crashdump) kernel as the production
>> kernel. Should I only care for the current kernel?
> 
> For this particular issue yes.
> 
> In general it is important for there to be a stable interface between
> the two kernels just so you are not required to use the same kernel
> version, and so there is the possibility of using something besides a
> linux kernel.

OK. In order to judge whether a kernel version as crashdump kernel is
usable or not, I want to understand why we can remove disable_IO_APIC
in detail.

> At the same time it has always been the targets kernel's responsibility
> to sort out the hardware devices unless it can't possibily do it.  And
> apics for the longest time were very very hard to reset in the target
> kernel, but now that they are not.  It makes sense for time permitting
> to remove the now unnecessary code in the crashing kernel.  Because
> ultimately the less code we have the fewer possible ways we can fail
> in a known broken kernel.

Yes, I agree with you.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


