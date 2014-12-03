Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaLCEOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:14:55 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50706 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaLCEOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141203034020.GI29748@ZenIV.linux.org.uk>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<20141202170037.GG29748@ZenIV.linux.org.uk>
	<CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
	<20141203034020.GI29748@ZenIV.linux.org.uk>
Date: Wed, 3 Dec 2014 15:14:51 +1100
Message-ID: <CAPs88r_K85w0uPni_TuSr1FZqS33dhew0mP42qSPwUp4STj0sg@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Alex Dubov <alex.dubov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 2:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Dec 03, 2014 at 01:22:33PM +1100, Alex Dubov wrote:
>
>> On a less related note, I hope you will agree that the simpler
>> mechanism for this very in-demand feature is long overdue on Linux
>> (every man and his dog are passing fds around these days).
>
> ... and I'm less than sure that it's a good thing.  If nothing else,
> once the pieces of your program are passing descriptors around freely,
> you have created a barfball that will be impossible to split between
> several boxen if you run into scalability issues.  Descriptor-passing
> is limited to a single system; you *can't* do that between e.g. components
> of a cluster.  So it's not an unmixed blessing, just as overuse of
> shared memory segments, etc.  They do have their uses, but that needs
> to be carefully considered every time, or you'll create a major headache
> a few years down the road.

Well, if you try hard enough, you can pass fds around the components
of the cluster - Mosix was doing just that some 10 years ago.
Conceptually, it's even easier than doing distributed shared memory,
as long as mmap is not concerned. :-)

I was, however, looking at it from a different standpoint. Abundance
of cores in the contemporary CPUs calls for locally parallel
applications (and those are still the majority - clearly 90% of the
applications and their workloads fit just fine on a single node).

Thus, any modern application developer faces the usual dilemma:

1. Go multi-threaded - easy inter-thread IPC, lousy reliability with
minor errors in secondary tasks crashing the whole application.

2. Go multi-process - circus hoop jumping when IPC is concerned, great
reliability through OS provided fault isolation (so even really broken
stuff, like PHP plugin for apache manages to perform most of the time
:-)

Memfd (on its own) and eventfd are great steps in the right direction,
as managing persistent shmem and sem objects was always pain in the
arse. If there was an alternative to AF_UNIX fd passing, with its
arcane API, fs persistence and mind boggling fd recursion bugs, then
option 2 would became much more attractive for developers leading to
over-all increase in application reliability and security.
