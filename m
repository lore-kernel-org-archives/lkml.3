Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3KDM0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:26:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48566 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3KDM0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:26:15 -0500
Date: Mon, 4 Nov 2013 13:26:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Maxim Patlasov <mpatlasov@parallels.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131104122613.GB24407@amd.pavel.ucw.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
 <20131029205756.GH9568@quack.suse.cz>
 <CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
 <20131029221324.GC12814@quack.suse.cz>
 <CA+55aFw_jjB687nJKuVdjPM6BicF-+0da-wSYHLBqdx0ZfVrGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_jjB687nJKuVdjPM6BicF-+0da-wSYHLBqdx0ZfVrGw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>  - temp-files may not be written out at all.
> >>
> >>    Quite frankly, if you have multi-hundred-megabyte temptiles, you've
> >> got issues
> >   Actually people do stuff like this e.g. when generating ISO images before
> > burning them.
> 
> Yes, but then the temp-file is long-lived enough that it *will* hit
> the disk anyway. So it's only the "create temporary file and pretty
> much immediately delete it" case that changes behavior (ie compiler
> assembly files etc).
> 
> If the temp-file is for something like burning an ISO image, the
> burning part is slow enough that the temp-file will hit the disk
> regardless of when we start writing it.

It will hit the disk, but with proposed change, burning still will be
slower.

Before:

create 700MB iso
burn the CD, at the same time writing the iso to disk

After:

create 700MB iso and write most of it to disk
burn the CD, writing the rest.

But yes, limiting dirty ammounts is good idea.

> That said, I'd certainly like it even *more* if the limits really were
> per-BDI, and the global limit was in addition to the per-bdi ones.
> Because when you have a USB device that gets maybe 10MB/s on
> contiguous writes, and 100kB/s on random 4k writes, I think it would
> make more sense to make the "start writeout" limits be 1MB/2MB, not

Actually I believe I seen 10kB/sec on an SD card... would expect that
from USB sticks, too.

And yes, there are actually real problems with this at least on N900.

You do apt-get install <big package>. apt internally does fsyncs. It
results in big enough latencies that watchdogs kick in and kill the
machine.

http://pavelmachek.livejournal.com/117089.html

People are doing 

 echo 3 > /proc/sys/vm/dirty_ratio
    echo 3 > /proc/sys/vm/dirty_background_ratio
    echo 100 > /proc/sys/vm/dirty_writeback_centisecs 
    echo 100 > /proc/sys/vm/dirty_expire_centisecs 
    echo 4096 > /proc/sys/vm/min_free_kbytes 
    echo 50 > /proc/sys/vm/swappiness 
    echo 200 > /proc/sys/vm/vfs_cache_pressure 
    echo 8 > /proc/sys/vm/page-cluster
    echo 4 > /sys/block/mmcblk0/queue/nr_requests
    echo 4 > /sys/block/mmcblk1/queue/nr_requests

.. to avoid it, but IIRC it only makes the watchdog reset less likely
:-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
