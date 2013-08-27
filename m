Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3H0NeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3H0NeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:34:24 -0400
Date: Tue, 27 Aug 2013 09:33:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
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
Subject: Re: Re: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec()
 from deadlocking of ioapic_lock
Message-ID: <20130827133355.GM239280@redhat.com>
References: <20130819081220.24406.15846.stgit@yunodevel>
 <20130819094623.GA30389@gmail.com>
 <5212B31A.6090504@hitachi.com>
 <871u5or7qn.fsf@tw-ebiederman.twitter.com>
 <20130820142740.GO239280@redhat.com>
 <5215CDEF.30004@hitachi.com>
 <20130822131137.GL5564@redhat.com>
 <521C1FFF.5060203@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C1FFF.5060203@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:41:51PM +0900, Yoshihiro YUNOMAE wrote:
> Hi Don,
> 
> Sorry for the late reply.
> 
> (2013/08/22 22:11), Don Zickus wrote:
> >On Thu, Aug 22, 2013 at 05:38:07PM +0900, Yoshihiro YUNOMAE wrote:
> >>>So, I agree with Eric, let's remove the disable_IO_APIC() stuff and keep
> >>>the code simpler.
> >>
> >>Thank you for commenting about my patch.
> >>I didn't know you already have submitted the patches for this deadlock
> >>problem.
> >>
> >>I can't answer definitively right now that no problems are induced by
> >>removing disable_IO_APIC(). However, my patch should be work well (and
> >>has already been merged to -tip tree). So how about taking my patch at
> >>first, and then discussing the removal of disabled_IO_APIC()?
> >
> >It doesn't matter to me.  My orignal patch last year was similar to yours
> >until it was suggested that we were working around a problem which was we
> >shouldn't touch the IO_APIC code on panic.  Then I wrote the removal of
> >disable_IO_APIC patch and did lots of testing on it.  I don't think I have
> >seen any issues with it (just the removal of disabling the lapic stuff).
> 
> Yes, you really did a lot of testing about this problem according to
> your patch(https://lkml.org/lkml/2012/1/31/391). Although you
> said jiffies calibration code does not need the PIT in
> http://lists.infradead.org/pipermail/kexec/2012-February/006017.html,
> I don't understand yet why we can remove disable_IO_APIC.
> Would you please explain about the calibration codes?

I forgot a lot of this, Eric B. might remember more (as he was the one that
pointed this out initially).  I believe initially the io_apic had to be in
a pre-configured state in order to do some early calibration of the timing
code.  Later on, it was my understanding, that the calibration of various
time keeping stuff did not need the io_apic in a correct state.  The code
might have switched to tsc instead of PIT, I forget.

Then again looking at the output of the latest dmesg, it seems the IO APIC
is initialized way before the tsc is calibrated.  So I am not sure what
needed to get done or what interrupts are needed before the IO APIC gets
initialized.


> 
> By the way, can we remove disable_IO_APIC even if an old dump capture
> kernel is used?

Good question.  I did a bunch of testing with RHEL-6 too, which is 2.6.32
based.  But I think we added some IRR fixes (commit 1e75b31d638), which
may or may not have helped in this case.  So I don't know when a kernel
started worked correctly during init (with the right changes).  I believe
2.6.32 had everything.

However, at the same time, the memory layout of current kernels has
changed and I am not sure if older kernels can read them correctly (or if
you just need the latest makedumpfile tool).  In other words, an old
kernel like 2.6.32 might not work as a kdump kernel for a 3.10 kernel.  I
don't know.

How old is the kernel you are working with?

Cheers,
Don
