Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab3BRPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:16:59 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59085 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3BRPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <1360838032.4045.126.camel@hornet>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	<1350408232.2336.42.camel@laptop>
	<1359728280.8360.15.camel@hornet>
	<CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	<51118797.9080800@linaro.org>
	<1360113595.2621.30.camel@gandalf.local.home>
	<1360174657.4045.33.camel@hornet>
	<CABPqkBR=R_xnM1j8J_+vXHniqfBzJQRr8oUZz05YVzhbSW777w@mail.gmail.com>
	<1360838032.4045.126.camel@hornet>
Date: Mon, 18 Feb 2013 16:16:55 +0100
Message-ID: <CABPqkBRaMUOz6MsJRzCu2wcvGoYasdnZCnneyzrUstYTWRJnqA@mail.gmail.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
From: Stephane Eranian <eranian@google.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I think the advantage of the ioctl() is that is reuses existing infrastructure.
The downside is that to get the timestamp you need at a minimum:

uint64_t get_perf_timestamp(void)
{
   struct perf_event_attr attr;
   uint64_t ts = 0;
   int fd;

   memset(&attr, 0, sizeof(attr));

   /* pick a dummy SW event (no PMU HW resource allocated), keep it disabled */
   attr.type = PERF_TYPE_SOFTWARE;
   attr.config =  PERF_COUNT_SW_CPU_CLOCK; /* dummy event */
   attr.disabled = 1;

   /* attach to self in per-thread mode */
   fd = perf_event_open(&attr, 0, -1, -1, 0);
   if (fd == -1)
       return 0;

  ioctl(fd, PERF_EVENT_IOC_GET_TIME, &ts);
  close(fd);

  return ts;
}

This function is likely to be called multiple times. So we could cache
the fd and reuse it.
There would be a bigger penalty only for the first call. Thereafter it
would cost probably
 just a bit more than the pfm_control() approach, because of the need
to go through VFS.
So I am fine with this.


On Thu, Feb 14, 2013 at 11:33 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Wed, 2013-02-13 at 20:00 +0000, Stephane Eranian wrote:
>> On Wed, Feb 6, 2013 at 7:17 PM, Pawel Moll <pawel.moll@arm.com> wrote:
>> > On Wed, 2013-02-06 at 01:19 +0000, Steven Rostedt wrote:
>> >> If people are worried about adding a bunch of new perf syscalls, maybe
>> >> add a sys_perf_control() system call that works like an ioctl but
>> >> without a file descriptor. Something for things that don't require an
>> >> event attached to it, like to retrieve a time stamp counter that perf
>> >> uses, but done in a way that it could be used for other things perf
>> >> related that does not require an event.
>> >
>> >  /**
>> > + * sys_perf_control - ioctl-like interface to control system-wide
>> > + *                   perf behaviour
>> > + *
>> > + * @cmd:       one of the PERF_CONTROL_* commands
>> > + * @arg:       command-specific argument
>> > + */
>> > +SYSCALL_DEFINE2(perf_control, unsigned int, cmd, unsigned long, arg)
>> > +{
>> > +       switch (cmd) {
>> > +       case PERF_CONTROL_GET_TIME:
>> > +       {
>> > +               u64 time = perf_clock();
>> > +               if (copy_to_user((void __user *)arg, &time, sizeof(time)))
>> > +                       return -EFAULT;
>> > +               return 0;
>> > +       }
>> > +
>> > +       default:
>> > +               return -ENOTTY;
>> > +       }
>> > +}
>>
>> So what would be the role of this new syscall besides GET_TIME?
>> What other controls without a fd could be done? We are already passing
>> a lot of control thru the perf_event_open() some in the attr struct others
>> as arguments.
>
> I think Steven was thinking about an "extensible" fd-less interface.
> Whether we'll need any other fd-less control in the future, I don't
> know...
>
>> The only advantage of this "disguised" ioctl() is that it does not require
>> a fd. But it is worth adding a syscall just to avoid creating a fd?
>
> Frankly speaking, I have some doubts here, but I do sys_perf_open()
> anyway, so it was mainly trying to address your situation.
>
> One way or another I'd like to get the timestamp, so how about picking
> one solution and trying to make it happen? Seems that my previous
> "standard ioctl()" patch would be the best compromise?
>
> Pawel
>
>
