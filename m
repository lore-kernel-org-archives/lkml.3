Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3ELXhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 19:37:09 -0400
Received: from canardo.mork.no ([148.122.252.1]:45990 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3ELXhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 19:37:07 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: paulmck@linux.vnet.ibm.com
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Organization: m
References: <87ip2opntp.fsf@nemi.mork.no>
	<20130512113905.GH3648@linux.vnet.ibm.com>
	<87li7kp50r.fsf@nemi.mork.no>
	<20130512172135.GJ3648@linux.vnet.ibm.com>
	<87a9o0ukll.fsf@nemi.mork.no>
Date: Mon, 13 May 2013 01:35:22 +0200
In-Reply-To: <87a9o0ukll.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Sun, 12
	May 2013 20:19:34 +0200")
Message-ID: <87sj1rydol.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjørn Mork <bjorn@mork.no> writes:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>
>> Other than wondering whether powertop has issues similar to the bug
>> Steven Rostedt located, I must confess myself clueless.  Here are some
>> diagnostics I can suggest:
>>
>> 1.	Run in 32-bit mode.  This disables some of the new adaptive-ticks
>> 	functionality, so might give a probabilistic indication of where
>> 	the bug lies.
>>
>> 2.	The standard fallback of bisection.
>>
>> Would you be willing to do either of these?
>
> Willing, yes. But it will take some time before I am able to do either
> unless I can recreate the problem in a virtual machine.  I assume that
> you by " 32-bit mode" mean a 32bit kernel?  I'm not exactly set up to
> run that on my laptop.  Bisection will be less work.
>
> To be honest, I don't even know how old this thing is.  It could be
> totally unrelated to your recent changes for all I know. Running
> powertop is something I do once every 6 kernel releases or something
> like that...
>
> I'll see what I can come up with.  Thanks for your attention.

I was unable to recreate the problem in a virtual machine, which is
slightly suspicious.  And bisecting it ended up pointing to a merge
commit: 

 commit ab86e974f04b1cd827a9c7c35273834ebcd9ab38
 Merge: 8700c95 6f7a05d
 Author: Linus Torvalds <torvalds@linux-foundation.org>
 Date:   Tue Apr 30 08:15:40 2013 -0700

     Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
 ..


which I don't think makes much sense at all.  The bisect log leading to
this was:

bjorn@canardo:/usr/local/src/build-tmp/linux$ git bisect log
# bad: [f722406faae2d073cc1d01063d1123c35425939e] Linux 3.10-rc1
# good: [c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1] Linux 3.9
git bisect start 'v3.10-rc1' 'v3.9'
# bad: [73287a43cc79ca06629a88d1a199cd283f42456a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect bad 73287a43cc79ca06629a88d1a199cd283f42456a
# bad: [5d434fcb255dec99189f1c58a06e4f56e12bf77d] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect bad 5d434fcb255dec99189f1c58a06e4f56e12bf77d
# good: [507ffe4f3840ac24890a8123c702cf1b7fe4d33c] Merge tag 'tty-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 507ffe4f3840ac24890a8123c702cf1b7fe4d33c
# good: [4a7b4d2360175f67ab2c58effeeb8362a3057c25] x86: pageattr-test: remove srandom32 call
git bisect good 4a7b4d2360175f67ab2c58effeeb8362a3057c25
# good: [46d9be3e5eb01f71fc02653755d970247174b400] Merge branch 'for-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect good 46d9be3e5eb01f71fc02653755d970247174b400
# good: [e0972916e8fe943f342b0dd1c9d43dbf5bc261c2] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good e0972916e8fe943f342b0dd1c9d43dbf5bc261c2
# bad: [ab86e974f04b1cd827a9c7c35273834ebcd9ab38] Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad ab86e974f04b1cd827a9c7c35273834ebcd9ab38
# good: [8700c95adb033843fc163d112b9d21d4fda78018] Merge branch 'smp-hotplug-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 8700c95adb033843fc163d112b9d21d4fda78018
# good: [0ed2aef9b3bffe598045b62a31a50d912eee92d8] Merge branch 'fortglx/3.10/time' of git://git.linaro.org/people/jstultz/linux into timers/core
git bisect good 0ed2aef9b3bffe598045b62a31a50d912eee92d8
# good: [8f294b5a139ee4b75e890ad5b443c93d1e558a8b] hrtimer: Add expiry time overflow check in hrtimer_interrupt
git bisect good 8f294b5a139ee4b75e890ad5b443c93d1e558a8b
# good: [60cf7ea849e77c8782dee147cfb8c38d1984236e] timer_list: Split timer_list_show_tickdevices
git bisect good 60cf7ea849e77c8782dee147cfb8c38d1984236e
# good: [d2054b2c11682495fca41e9d4092e654df63b517] posix-timers: Remove unused variable
git bisect good d2054b2c11682495fca41e9d4092e654df63b517
# good: [6402c7dc2a19c19bd8cdc7d80878b850da418942] Merge branch 'linus' into timers/core Reason: Get upstream fixes before adding conflicting code.
git bisect good 6402c7dc2a19c19bd8cdc7d80878b850da418942
# good: [6f7a05d7018de222e40ca003721037a530979974] clockevents: Set dummy handler on CPU_DEAD shutdown
git bisect good 6f7a05d7018de222e40ca003721037a530979974


So there it stands.  I have no clue and I don't think I'm able to
provide any clue for anyone else either.  Given that the problem seems
to be very consistently reproducible on my laptop, I am a bit puzzled as
to how the bisect would fail like that.



Bjørn
