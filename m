Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaH1SZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:25:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62938 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaH1SZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:25:44 -0400
MIME-Version: 1.0
X-Originating-IP: [12.227.248.5]
In-Reply-To: <53FF1472.3020404@gmail.com>
References: <20140826054837.GA2766@nixos.hsd1.nh.comcast.net>
	<53FC7EC1.9070401@gmail.com>
	<CAOS_Y6R6uZtW1QZ9KKtwYk=thYmPU6NVTt8i5ACMmJLYLK=dhw@mail.gmail.com>
	<53FF1472.3020404@gmail.com>
Date: Thu, 28 Aug 2014 13:25:40 -0500
Message-ID: <CAOS_Y6TpZNNKvS=Lxnii-dsb5E4G-Ubd6xD=AaK=eH7Axe6qYA@mail.gmail.com>
Subject: Re: Documentation for init
From: Rob Landley <rob@landley.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Shea Levy <shea@shealevy.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 6:37 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-08-26 18:00, Rob Landley wrote:
>>>  * Doesn't have a session ID until it calls setsid() (not certain about
>>> this one)
>>
>> News to me.
>>
> I think now (after reading the rest of your e-mail) that I am wrong
> about this.  I assumed that this was the case because I had heard
> something about needing to call setsid() to get a shell to behave
> properly when started as init.

I haven't _tested_ it, just saying I was unaware of this being unique. :)

(Don't mistake me for an expert, just somebody who's been through the
code a few times with machette and flaming torch, to make things like
oneit and busybox init and initmpfs work. I'm just very experienced at
being ignorant.)

>>>  * Calling exit() will cause either a reboot or possibly a panic (I
>>> think that this is dependent on the argument passed to exit())
>>
>> No, it's a panic. You can set "panic=1" on the kernel command line to
>> convert all panics into a reboot after a 1 second delay.
>>
> Yeah, I usually use panic=-1 when I'm not doing debugging, so I can't
> always tell the difference.
>> There's a mostly complete list of kernel command line options at:
>>
>> https://www.kernel.org/doc/Documentation/kernel-parameters.txt
>>
>> (And there's some syntax for passing arguments to statically linked
>> modules that I never remember. Might be involved with that dot
>> nonsense mentioned above.)
>>
> Yeah, the dot thing is a result of using that for statically linked
> modules (ie, to pass the argument bar to statically linked module foo,
> you specify foo.bar on the kernel commandline).  There are still some
> edge-cases here where things that should work don't, I keep meaning to
> look into this code further, but never have had the time.

I looked into it years ago, figured out how to fix it, submitted a
patch upstream, the patch got ignored, I maintained the patch locally
and moved on with my life. (That happens a lot.)

>>>  * Not catching a fatal signal will cause a panic (this means that
>>> sending SIGKILL and SIGABRT to PID 1 will always cause a panic).
>>
>> No, the kernel starts with SIG_IGNORE on all signals. If you supply a
>> handler, your handler gets called. If you don't supply a handler, the
>> signal is ignored.
> I actually hadn't realized this, are you sure that it does that for all
> signals?  If that is the case, then there must be some special handling
> in the kernel for if init does something to get a SIGSEGV or SIGFPE that
> it doesn't set a handler for.

Hmmm, I wandered across kernel code that implemented this a year or
two back, where was that...

Ah: kernel/signal.c function unhandled_signal(). First thing it does
is check is_global_init(tsk) and if so returns 1. Except... this only
seems to be used to print debug messages from architecture code? Odd.
Let's see...

Back in kernel/signal.c there's get_signal() with a comment "Global
init gets no signals it doesn't want." (Which oddly seems to have
become detached from any code that would actually _implement_ such a
thing...?) But the comment goes on to say that a nonblockable signal
that could only have been generated inside the kernel (illegal memory
access and such) gets passed through. And that _is_ the next test
after the comment. How the rest of them got ignored isn't specified
here, and I've learned not to trust comments in this codebase....

(Sigh... Not seeing it in init_task.h... init/main.c function
rest_init() creates PID 1 and starts it running kernel_init() and
_that_ calls kernel_init_freeable() to do the dirty work, and _that_
calls do_basic_setup() which calls a bunch of functions, none of which
are obviously this part of process state setup but it could be a side
effect of any of them....)

And that's about all the time I have for this right now. How the rest
of them are ignored is not obvious from the code (this is the 3.x
linux kernel, _nothing_ is obvious from the code), but easy to
experimentally determine from userspace. QEMU makes this sort of thing
a lot easier...

If you want to track it down in the kernel code yourself, I'd
recommend checking out something like the 2.2 kernel back before the
codebase went from merely crazy to the modern levels of outright
psychotic, track it down in there, and then bisect your way forward to
find each commit that screwed it up.

(I have a git repository that goes from 0.0.1 to 3.0 at
http://landley.net/kdocs/local/linux-fullhist.tar.bz2 , if you extract
that, "git checkout -f" to get the files (the tarball is just the .git
directory), and then "git pull", then you have a repo you can actually
do proper historical research in. I really need to go back and label
the early releases, but you can "git log | tail -n 1000 | less" to
find the 0.01 commit, and then bisect and look at the date...)

Rob
