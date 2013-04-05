Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161617Ab3DEMzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161305Ab3DEMzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:55:20 -0400
Date: Fri, 5 Apr 2013 14:56:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH -tip 0/4] do not make cputime scaling in kernel
Message-ID: <20130405125604.GA1571@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
 <CAFTL4hx-k42Af1qhpf+0jra6HZ3LBxL=1A8J3xabzjWLAxH9GQ@mail.gmail.com>
 <20130404131003.GE1367@redhat.com>
 <CAFTL4hxZ8RJ0Wd-+sScfa90_c5j0bX3eufH+RC+u8i7=7hN+ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxZ8RJ0Wd-+sScfa90_c5j0bX3eufH+RC+u8i7=7hN+ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 03:47:19PM +0200, Frederic Weisbecker wrote:
> 2013/4/4 Stanislaw Gruszka <sgruszka@redhat.com>:
> > On Thu, Apr 04, 2013 at 02:31:42PM +0200, Frederic Weisbecker wrote:
> >> I don't know. I'm not convinced userland is the right place to perform
> >> this kind of check. The kernel perhaps doesn't give guarantee about
> >> utime/stime precision but now users may have got used to that scaled
> >> behaviour. It's also a matter of security, a malicous app can hide
> >> from the tick to make its activity less visible from tools like top.
> >>
> >> It's sortof an ABI breakage to remove such an implicit protection. And
> >> fixing that from userspace with a lib or so won't change that fact.
> >
> > I think number of fields in /proc/PID/stat is not part of ABI. For
> > example commit 5b172087f99189416d5f47fd7ab5e6fb762a9ba3 add various
> > new fields at the end of the file. What is imported to keep unchanged
> > ABI is not changing order or meaning of fields we already have.
> 
> Oh I wasn't considering the layout of the proc file but the semantic
> change in its utime/stime fields.

Please see below.

> > Regarding top, I added those additional fields to allow top to detect
> > those malicious software. Patched top will work well with old and new
> > (patched) kernel. Problem is old top with new kernel, but I believe
> > users who care about security update they software regularly.
> 
> The usual rule is that but you can't remove a feature from the kernel
> and tell userspace to fix it itself. That's basically an ABI breakage.
> A semantic one. We do it sometimes for some cases. But the more we are
> dealing with a central ABI component, the harder it is to change it.
> And here it is quite a central component.

I don't think patches change ABI. Semantic (meaning) of utime/stime is
the same with and without those patches. They are user mode and kernel
mode jiffies of the process, this does not change. What changes is
kernel calculation of those values, i.e. implementation.

Of course there is this top hiding malware, and that is "tell userspace
to fix it itself" thing. But I'm considering this as special case.
I comment more about that at the end of the email.
 
> > Besides for most cases (not counting hostile software), those
> > statistical stime/utime accounting give good approximation of CPU
> > time utilizing by each process.
> 
> Yeah but still the users are expecting that result to be scaled now.

I'm not sure about that, though I'm sure users expect other things. For
example that the values will increase when process utilize CPU, what is
now broken for long running CPU bound processes. Also they expect values
will not decrease, what was broken by adding cputime scaling, but is now
fixed. Or that the values will not increase if process do not utilize
CPU, what was another kernel bug, which is also now fixed.

My point here is that, in the past and now, cputime scaling cause lot of
troubles and get rid of it would be good thing to do.

> >> How about that 128bits based idea? I'm adding Paul Turner in Cc
> >> because he seemed to agree with doing it using 128bits maths.
> >
> > For problem that I try to solve 128bits math is not necessary, assuming
> > we can do multiplication in user space. Taking into account how easily
> > things can be done in user space using floating point math, I prefer not
> > to add complexity in kernel. This solution make kernel simpler and
> > faster.
> 
> I'm always all for making the kernel simpler and faster, as long as we
> don't break userspace.

I don't think in general the change does break user space, except special
case, which is this top hiding malware. But since this is _top_ hiding
malware it can be fixed in _top_. Consider this that way, kernel changed
way of calculating utime/stime to help top against hiding malware. But
since it is complicated and affect kernel performance, we will provide
other mechanism that top can use to protect itself against malware. Then
we can remove complicated utime/stime calculation.
 
Note times(2) and getrsuage(2) also use scaled cputime values, but do
this only for self process (getrusage(2) also for terminated children),
so there is no top hiding like issue for those.

Also note that cpu-timers (setitimer(2) and timer_create(2)) use raw
{signal,task}->{u,s}time values not scaled ones.

In general I agree with Frederic, that we should not remove feature that
was added to the kernel. But this case I'm not sure if it worth to keep
it and make kernel more complex, since the main and the only problem
that feature solves can be easily handled by top.

Would help if I would write that top hiding exploit (for patched kernel)
and ask for assign CVE number (not sure if that will be accepted), then
make sure that this CVE will be fixed and released in top, then patch
and release kernel with this patch set? Does it sound reasonable?

If not, I can continue try to solve problem by creating patch with 128bit
math (or some other solution, but we already tried different solutions
with no luck).

Stanislaw
