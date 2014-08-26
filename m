Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbaHZWAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:00:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60584 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaHZWAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:00:36 -0400
MIME-Version: 1.0
X-Originating-IP: [12.227.248.5]
In-Reply-To: <53FC7EC1.9070401@gmail.com>
References: <20140826054837.GA2766@nixos.hsd1.nh.comcast.net>
	<53FC7EC1.9070401@gmail.com>
Date: Tue, 26 Aug 2014 17:00:35 -0500
Message-ID: <CAOS_Y6R6uZtW1QZ9KKtwYk=thYmPU6NVTt8i5ACMmJLYLK=dhw@mail.gmail.com>
Subject: Re: Documentation for init
From: Rob Landley <rob@landley.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Shea Levy <shea@shealevy.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 7:34 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-08-26 01:48, Shea Levy wrote:
>> Hi all,
>>
>> Is there any official documentation of the init process? I'm
>> specifically interested in the process state at kernel handoff (argv,
>> envp, open fds, etc.) as well as any special properties pid 1 has
>> (parent of all orphans, anything else?).
>>
>> Thanks,
>> Shea Levy
>>
>> P.S. I am not subscribed to LKML, please CC me in responses
> This is following is just my understanding based on what I have seen and
> read, and I may well be totally wrong on some points (if that is the
> case, I would love to know about it, I'm always trying to learn more).

I used to maintain busybox init, and am researching to do a "lunchd"
on toybox (mdev is to udev as lunchd is to systemd, think "OSX launchd
without the insane xml file formats", only with at least one less
letter's worth of functionality), so I have to know far more about
this than is strictly recommended. :)

> As far as I can tell, the argv that gets passed to the init process is
> the concatenation of all arguments on the kernel command-line that the
> kernel doesn't recognize or parse.

For a definition of "recognize" where each KEYWORD=VALUE gets set as
an environment variable, and for the longest time there was this
horrible check where any argument with a period in it was jettisoned
with "you didn't _really_ mean to say init=/sbin/init.sh" obviously
you had some sort of attack, we'll call an ambulance immediately.

http://linux-kernel.2935.n7.nabble.com/patch-zap-broken-heuristic-in-init-main-c-td49698.html

Presumably fixed long since, but I bring it up to show that the
parsing done here is pretty crappy and assumption-filled. (Is there a
way to escape spaces in an environment variable you set? Who knows? I
couldn't find one when I looked...)

>  A lot of LiveCD's make use of this
> to control hardware detection and module loading.  The only open file
> descriptors (i believe, I may be wrong) are 0, 1, and 2, all pointing at
> /dev/console.

Specifically to the /dev/console out of initramfs. If you don't supply
an initramfs, it'll fake one for you, but if you _do_ you need a
/dev/console in there. (I have a todo item to fix the devtmpfs
auto-mount so it actually applies to initramfs/initmpfs instead of
only applying to the root= filesystem.)

Note that /dev/console is broken, and does not provide a controlling
tty. I have no idea why this is the case, but it's been that way
forever. The dance you have to do to get a shell prompt that actually
responds to ctrl-c and ctrl-z is:

http://landley.net/hg/toybox/file/tip/toys/other/oneit.c

> As for special properties:
>  * Parent of all orphans

Because I complained about this in early 2.4 and Andrew Morton added
reparent_to_init. :)

Now that we have containers, the container init process

>  * Doesn't have a session ID until it calls setsid() (not certain about
> this one)

News to me.

>  * Calling exit() will cause either a reboot or possibly a panic (I
> think that this is dependent on the argument passed to exit())

No, it's a panic. You can set "panic=1" on the kernel command line to
convert all panics into a reboot after a 1 second delay.

There's a mostly complete list of kernel command line options at:

https://www.kernel.org/doc/Documentation/kernel-parameters.txt

(And there's some syntax for passing arguments to statically linked
modules that I never remember. Might be involved with that dot
nonsense mentioned above.)

>  * Not catching a fatal signal will cause a panic (this means that
> sending SIGKILL and SIGABRT to PID 1 will always cause a panic).

No, the kernel starts with SIG_IGNORE on all signals. If you supply a
handler, your handler gets called. If you don't supply a handler, the
signal is ignored.

>  * Has a PPID of 0, only other process like this is kthreadd

Or the init task within any container (I.E. the first process in any
new PID context. "man 2 clone" and then look for CLONE_NEWNS.)

>  * Becomes the parent of most X programs (almost all of them dissociate
> very quickly from whatever started them.

That's another variant of "reparent to init", above.

Note that if the SIGCHLD handler is set to SIG_IGNORE then the zombie
trying to deliver a signal is allowed to finish exiting with its
status discarded. So reparenting to init is just one way to prevent
zombies from accumulating.

Rob
