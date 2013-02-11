Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3BKOAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:00:00 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54588 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab3BKN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:59:58 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <1660768.prnx6s70rD@vostro.rjw.lan>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<2964781.rPUOipNRNb@vostro.rjw.lan>
	<CAJfpegtNUr+AJXZcKmLEGBYqu20DVFwzg-OvOk_nS3fBS3wd=Q@mail.gmail.com>
	<1660768.prnx6s70rD@vostro.rjw.lan>
Date: Mon, 11 Feb 2013 14:59:56 +0100
Message-ID: <CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        Li Fei <fei.li@intel.com>, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 1:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 11, 2013 11:11:40 AM Miklos Szeredi wrote:
>> On Mon, Feb 11, 2013 at 12:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Sunday, February 10, 2013 07:55:05 PM Pavel Machek wrote:
>>
>> >> Well, from freezer you need:
>> >>
>> >> 1) user process frozen.
>> >>
>> >> 2) essential locks _not_ held so that block devices are still functional.
>> >>
>> >> > > > mmap... what is problem with mmap? For suspend, memory is powered, so
>> >> > > > you can permit people changing it.
>> >> > >
>> >> > > Suppose mmap is used to make the registers of some device available to user
>> >> > > space.  Yes, that can happen.
>> >>
>> >> "Don't do it, then". Yes, can happen, but hopefully is not too common
>> >> these days. [And... freezer doing 1) but not 2) would be enough to
>> >> handle that. Freezer doing 1) but not 2) would also be simpler...]
>> >
>> > Again, I'm not sure what you mean.
>> >
>> > Are you trying to say that it would be OK to freeze user space tasks in
>> > the D state?
>>
>> I think that's what Pavel is saying.   Processes in D state sleeping
>> on non-device mutexes _are_ actually OK to freeze.  And that would
>> nicely solve the fuse freeze problem.
>
> That's potentially deeadlock-prone, because a task waiting for mutex X may
> very well be holding mutex Y, so if there's another task waiting for mutex Y,
> it needs to be frozen at the same time.
>
>> The only little detail is how do we implement that...
>
> This means the only way I can see would be to hack the mutex code so that the
> try_to_freeze() was called for user space tasks after the
> sched_preempt_enable_no_resched() before schedule().
>
> That shouldn't be a big deal performance-wise, because we are in the slow
> path anyway then.  I'm not sure if Peter Z will like it, though.
>
> Moreover, a task waiting for a mutex may be holding a semaphore or be
> participating in some other mutual-exclusion mechanism, so we'd need to
> address them all.  Plus, as noted by Pavel, freezing those things would make
> it difficult to save hibernation images to us.

Well, as a first step I could cook up a patch that adds a flag to the
mutex indicating that it's freezable.  Fuse would mark its mutexes
(and the mutexes that VFS uses on its behalf) as freezable.  That way
we don't interfere with hibernation, except if hibernation uses fuse
but that's a very special case.

>
> What about having a "freeze me after all of my children" flag that will be
> inherited from parents?  Would that help the fuse case?


With kernel filesystems there's a clear distinction between tasks that
may originate filesystem requests (userspace processes) and those that
serve these requests (kernel threads).  So its possible to freeze the
originators first and the servers afterwards.

With fuse there's no such difference.  Even if it were known which
processes are servers and which are originators (it is not known in
the general case) then there would be a problem that some processes
are servers AND originators at the same time.

Thanks,
Miklos
