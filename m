Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaBHTnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:43:24 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45210 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaBHTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:43:23 -0500
MIME-Version: 1.0
Reply-To: for.poige+linux@gmail.com
From: Igor Podlesny <for.poige+linux@gmail.com>
Date: Sun, 9 Feb 2014 03:42:52 +0800
X-Google-Sender-Auth: KXijwkHZnXitsEl1ZTHggWayQfk
Message-ID: <CA+sTkh7LzDSvhDyYX2Ybi=Z32OuJoK_F1VVHEBsW5Ly-4wa8Bg@mail.gmail.com>
Subject: Re: That greedy Linux VM cache
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 February 2014 18:55, Michal Hocko <mhocko@suse.cz> wrote:
> [Adding linux-mm to the CC]

[...]

> This means that the page has to be written back in order to be dropped.
> How much dirty memory you have (comparing to the total size of the page
> cache)?

   Not too many. May be you missed that part, but I said, that disk is
being mostly READ, NOT written.
   I also said, that READing is going from system partition (it was Btrfs).

> What does your /proc/sys/vm/dirty_ratio say?

   10

> How fast is your storage?

   Was 5400 HDD, today I installed SSD.

> Also, is this 32b or 64b system?

   Kernel is x86_64 or sometimes 32, userspace is 32 -- full x86_64
setup is simply not usable on 2 GiB,
you can run just one program, like in MS-DOS era. :) (I'd give a try
to x32, but alas, it's not really ready yet.)

>>    * How to analyze it? slabtop doesn't mention even 100 MiB of slab
>
> snapshoting /proc/meminfo and /proc/vmstat every second or two while
> your load is bad might tell us more.
>
>>    * Why that's possible?
>
> That is hard to tell withou some numbers. But it might be possible that
> you are seeing the same issue as reported and fixed here:
> http://marc.info/?l=linux-kernel&m=139060103406327&w=2

   No, there's no such amount of dirty data.

> Especially when you are using tmpfs (e.g. as a backing storage for /tmp)

   I use it, yeah, but it has ridiculously low occupied space ~ 1--2 MiB.

   *** Okay, so I've said I decided to try SSD. The issue stays
absolutely the same and is seen even more clearer: when swappiness is
0, Btrfs-endio is heating up processor constantly taking almost all
CPU resources (storage is fast, CPU's saturated), but when I set it
higher, thus allowing to swap, it helps -- ~ 250 MiB got swapped out
(quickly -- SSD rules) and the system became responsive again. As
previously it didn't try to reduce cache at all. I never saw it to be
even 250 MiB, always higher (~ 25 % of RAM). So, actually it's better
using swappiness = 100 in these circumstances.

   I think the problem should be easily reproducible -- kernel allows
you to limit available RAM. ;)

   P. S. The only thing's left as a theory is "Intel Corporation
Mobile GM965/GL960 Integrated Graphics Controller" with i915 kernel
module. I don't know much about it, but it should have had bitten a
good part of system RAM, right? Since it's Ubuntu, there's compiz by
default and pmap -d `pgrep compiz` shows lots of similar lines:

...
e0344000      20 rw-s- 0000000102e33000 000:00005 card0
e0479000      56 rw-s- 0000000102bf4000 000:00005 card0
e0487000      48 rw-s- 0000000102be8000 000:00005 card0
e0493000      56 rw-s- 0000000102bda000 000:00005 card0
e04a1000      56 rw-s- 0000000102bcc000 000:00005 card0
e04af000      48 rw-s- 0000000102bc0000 000:00005 card0
e04bb000      56 rw-s- 0000000102bb2000 000:00005 card0
e04c9000      48 rw-s- 0000000102d64000 000:00005 card0
e04d5000     192 rw-s- 0000000102ce5000 000:00005 card0
e0505000      80 rw-s- 0000000102de7000 000:00005 card0
e0519000      20 rw-s- 0000000102ccc000 000:00005 card0
e051e000     160 rw-s- 0000000102ca4000 000:00005 card0
e0546000      20 rw-s- 0000000102c9f000 000:00005 card0
e054b000      48 rw-s- 0000000102c93000 000:00005 card0
e0557000      20 rw-s- 0000000102c8e000 000:00005 card0
e055c000      20 rw-s- 0000000102c89000 000:00005 card0
...

   I have a suspicion... (I also dislike the sizes of those mappings)
... that a valuable amount of that "cached memory" can be related to
this i915. How can I check it?...

-- 
End of message. Next message?
