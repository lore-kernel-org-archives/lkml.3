Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaBJNdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:33:50 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37977 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaBJNdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:44 -0500
Date: Mon, 10 Feb 2014 14:33:40 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Igor Podlesny <for.poige+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: That greedy Linux VM cache
Message-ID: <20140210133340.GE7117@dhcp22.suse.cz>
References: <CA+sTkh7LzDSvhDyYX2Ybi=Z32OuJoK_F1VVHEBsW5Ly-4wa8Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sTkh7LzDSvhDyYX2Ybi=Z32OuJoK_F1VVHEBsW5Ly-4wa8Bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 09-02-14 03:42:52, Igor Podlesny wrote:
> On 3 February 2014 18:55, Michal Hocko <mhocko@suse.cz> wrote:
> > [Adding linux-mm to the CC]
> 
> [...]
> 
> > This means that the page has to be written back in order to be dropped.
> > How much dirty memory you have (comparing to the total size of the page
> > cache)?
> 
>    Not too many. May be you missed that part, but I said, that disk is
> being mostly READ, NOT written.
>    I also said, that READing is going from system partition (it was Btrfs).
> 
> > What does your /proc/sys/vm/dirty_ratio say?
> 
>    10

With 2G of RAM this shouldn't be a lot. And definitely shouldn't make a
problem with SSD.

> > How fast is your storage?
> 
>    Was 5400 HDD, today I installed SSD.
> 
> > Also, is this 32b or 64b system?
> 
>    Kernel is x86_64 or sometimes 32, userspace is 32 -- full x86_64
> setup is simply not usable on 2 GiB,

Which is unexpected on its own. We have many systems with comparable
and much less memory as well running just fine. You haven't posted any
numbers yet so it is still not clear where is the bottleneck on your
system.

> you can run just one program, like in MS-DOS era. :) (I'd give a try
> to x32, but alas, it's not really ready yet.)
> 
> >>    * How to analyze it? slabtop doesn't mention even 100 MiB of slab
> >
> > snapshoting /proc/meminfo and /proc/vmstat every second or two while
> > your load is bad might tell us more.
> >
> >>    * Why that's possible?
> >
> > That is hard to tell withou some numbers. But it might be possible that
> > you are seeing the same issue as reported and fixed here:
> > http://marc.info/?l=linux-kernel&m=139060103406327&w=2
> 
>    No, there's no such amount of dirty data.

OK, then I would check whether this is fs related. You said that you've
tried xfs or something else with similar results?

> > Especially when you are using tmpfs (e.g. as a backing storage for /tmp)
> 
>    I use it, yeah, but it has ridiculously low occupied space ~ 1--2 MiB.
> 
>    *** Okay, so I've said I decided to try SSD. The issue stays
> absolutely the same and is seen even more clearer: when swappiness is
> 0, Btrfs-endio is heating up processor constantly taking almost all
> CPU resources (storage is fast, CPU's saturated), but when I set it
> higher, thus allowing to swap, it helps -- ~ 250 MiB got swapped out
> (quickly -- SSD rules) and the system became responsive again. As
> previously it didn't try to reduce cache at all. I never saw it to be
> even 250 MiB, always higher (~ 25 % of RAM). So, actually it's better
> using swappiness = 100 in these circumstances.

Hmm, so the swapping is fast enough while the page cache backed by the
storage is slow. I guess both the swap partition and fs are backed by
the same storage, right?
Do you have a sufficient free space on the filesystem?

>    I think the problem should be easily reproducible -- kernel allows
> you to limit available RAM. ;)
> 
>    P. S. The only thing's left as a theory is "Intel Corporation
> Mobile GM965/GL960 Integrated Graphics Controller" with i915 kernel
> module. I don't know much about it, but it should have had bitten a
> good part of system RAM, right?

How much memory? I vaguely remember that i915 had very aggressive
reclaiming logic which led to some stalls during reclaim. I cannot seem
to find any reference right now.

Btw. Are you using vanilla kernel?

> Since it's Ubuntu, there's compiz by
> default and pmap -d `pgrep compiz` shows lots of similar lines:

It would be good to reduce problem space by disabling compiz.
 
> ...
> e0344000      20 rw-s- 0000000102e33000 000:00005 card0
> e0479000      56 rw-s- 0000000102bf4000 000:00005 card0
> e0487000      48 rw-s- 0000000102be8000 000:00005 card0
> e0493000      56 rw-s- 0000000102bda000 000:00005 card0
> e04a1000      56 rw-s- 0000000102bcc000 000:00005 card0
> e04af000      48 rw-s- 0000000102bc0000 000:00005 card0
> e04bb000      56 rw-s- 0000000102bb2000 000:00005 card0
> e04c9000      48 rw-s- 0000000102d64000 000:00005 card0
> e04d5000     192 rw-s- 0000000102ce5000 000:00005 card0
> e0505000      80 rw-s- 0000000102de7000 000:00005 card0
> e0519000      20 rw-s- 0000000102ccc000 000:00005 card0
> e051e000     160 rw-s- 0000000102ca4000 000:00005 card0
> e0546000      20 rw-s- 0000000102c9f000 000:00005 card0
> e054b000      48 rw-s- 0000000102c93000 000:00005 card0
> e0557000      20 rw-s- 0000000102c8e000 000:00005 card0
> e055c000      20 rw-s- 0000000102c89000 000:00005 card0
> ...
> 
>    I have a suspicion... (I also dislike the sizes of those mappings)

The mappings do not seem to be too big (the biggest one has 160kB)...

> ... that a valuable amount of that "cached memory" can be related to
> this i915. How can I check it?...

I am not sure I understand what you are asking about.
-- 
Michal Hocko
SUSE Labs
