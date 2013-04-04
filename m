Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138Ab3DDNrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:47:23 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39687 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761095Ab3DDNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130404131003.GE1367@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
	<CAFTL4hx-k42Af1qhpf+0jra6HZ3LBxL=1A8J3xabzjWLAxH9GQ@mail.gmail.com>
	<20130404131003.GE1367@redhat.com>
Date: Thu, 4 Apr 2013 15:47:19 +0200
Message-ID: <CAFTL4hxZ8RJ0Wd-+sScfa90_c5j0bX3eufH+RC+u8i7=7hN+ig@mail.gmail.com>
Subject: Re: [PATCH -tip 0/4] do not make cputime scaling in kernel
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/4 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Thu, Apr 04, 2013 at 02:31:42PM +0200, Frederic Weisbecker wrote:
>> I don't know. I'm not convinced userland is the right place to perform
>> this kind of check. The kernel perhaps doesn't give guarantee about
>> utime/stime precision but now users may have got used to that scaled
>> behaviour. It's also a matter of security, a malicous app can hide
>> from the tick to make its activity less visible from tools like top.
>>
>> It's sortof an ABI breakage to remove such an implicit protection. And
>> fixing that from userspace with a lib or so won't change that fact.
>
> I think number of fields in /proc/PID/stat is not part of ABI. For
> example commit 5b172087f99189416d5f47fd7ab5e6fb762a9ba3 add various
> new fields at the end of the file. What is imported to keep unchanged
> ABI is not changing order or meaning of fields we already have.

Oh I wasn't considering the layout of the proc file but the semantic
change in its utime/stime fields.

> Regarding top, I added those additional fields to allow top to detect
> those malicious software. Patched top will work well with old and new
> (patched) kernel. Problem is old top with new kernel, but I believe
> users who care about security update they software regularly.

The usual rule is that but you can't remove a feature from the kernel
and tell userspace to fix it itself. That's basically an ABI breakage.
A semantic one. We do it sometimes for some cases. But the more we are
dealing with a central ABI component, the harder it is to change it.
And here it is quite a central component.

>
> Besides for most cases (not counting hostile software), those
> statistical stime/utime accounting give good approximation of CPU
> time utilizing by each process.

Yeah but still the users are expecting that result to be scaled now.

>
>> How about that 128bits based idea? I'm adding Paul Turner in Cc
>> because he seemed to agree with doing it using 128bits maths.
>
> For problem that I try to solve 128bits math is not necessary, assuming
> we can do multiplication in user space. Taking into account how easily
> things can be done in user space using floating point math, I prefer not
> to add complexity in kernel. This solution make kernel simpler and
> faster.

I'm always all for making the kernel simpler and faster, as long as we
don't break userspace.
