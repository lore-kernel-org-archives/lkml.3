Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab3DDNJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab3DDNJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:09:28 -0400
Date: Thu, 4 Apr 2013 15:10:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH -tip 0/4] do not make cputime scaling in kernel
Message-ID: <20130404131003.GE1367@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
 <CAFTL4hx-k42Af1qhpf+0jra6HZ3LBxL=1A8J3xabzjWLAxH9GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hx-k42Af1qhpf+0jra6HZ3LBxL=1A8J3xabzjWLAxH9GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:31:42PM +0200, Frederic Weisbecker wrote:
> 2013/4/4 Stanislaw Gruszka <sgruszka@redhat.com>:
> > This patch series removes cputime scaling from kernel. It can be easily
> > done in user space using floating point if we provide sum_exec_runtime,
> > what patches 2/4 and 3/4 do. I have procps patch which utilize that:
> >
> > http://people.redhat.com/sgruszka/procps-use-sum_exec_runtime.patch
> >
> > I will post it, if this patch set will be queued.
> >
> > Change affect also getrusage() and times() syscals, but I don't think
> > kernel give guarantees about utime/stime precision, in a matter of fact
> > before commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa, we do not
> > perform any scaling and we provided raw cputime values to user space.
> >
> > Providing sum_exec_runtime via proc is done against malware that utilize
> > lot of cpu time but hide itself from top program.
> >
> > This affect kernels not compiled with CONFIG_VIRT_CPU_ACCOUNTING_{GEN,NATIVE},
> > if user choose to compile kernel with some of those options, he/she will
> > have more precise cputime accounting, what is documented in Kconfig.
> >
> 
> I don't know. I'm not convinced userland is the right place to perform
> this kind of check. The kernel perhaps doesn't give guarantee about
> utime/stime precision but now users may have got used to that scaled
> behaviour. It's also a matter of security, a malicous app can hide
> from the tick to make its activity less visible from tools like top.
> 
> It's sortof an ABI breakage to remove such an implicit protection. And
> fixing that from userspace with a lib or so won't change that fact.

I think number of fields in /proc/PID/stat is not part of ABI. For
example commit 5b172087f99189416d5f47fd7ab5e6fb762a9ba3 add various
new fields at the end of the file. What is imported to keep unchanged
ABI is not changing order or meaning of fields we already have.

Regarding top, I added those additional fields to allow top to detect
those malicious software. Patched top will work well with old and new
(patched) kernel. Problem is old top with new kernel, but I believe
users who care about security update they software regularly.

Besides for most cases (not counting hostile software), those
statistical stime/utime accounting give good approximation of CPU
time utilizing by each process.
 
> How about that 128bits based idea? I'm adding Paul Turner in Cc
> because he seemed to agree with doing it using 128bits maths.

For problem that I try to solve 128bits math is not necessary, assuming
we can do multiplication in user space. Taking into account how easily
things can be done in user space using floating point math, I prefer not
to add complexity in kernel. This solution make kernel simpler and
faster.

Stanislaw
