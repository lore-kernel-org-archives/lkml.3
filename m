Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3J3MB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:01:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3J3MB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:01:57 -0400
Date: Wed, 30 Oct 2013 12:01:52 +0000
From: Mel Gorman <mgorman@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131030120152.GM2400@suse.de>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
 <20131029205756.GH9568@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131029205756.GH9568@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:57:56PM +0100, Jan Kara wrote:
> On Fri 25-10-13 10:32:16, Linus Torvalds wrote:
> > On Fri, Oct 25, 2013 at 10:29 AM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > Apparently all this stuff isn't working as desired (and perhaps as designed)
> > > in this case.  Will take a look after a return to normalcy ;)
> > 
> > It definitely doesn't work. I can trivially reproduce problems by just
> > having a cheap (==slow) USB key with an ext3 filesystem, and going a
> > git clone to it. The end result is not pretty, and that's actually not
> > even a huge amount of data.
>
>   I'll try to reproduce this tomorrow so that I can have a look where
> exactly are we stuck. But in last few releases problems like this were
> caused by problems in reclaim which got fed up by seeing lots of dirty
> / under writeback pages and ended up stuck waiting for IO to finish. Mel
> has been tweaking the logic here and there but maybe it haven't got fixed
> completely. Mel, do you know about any outstanding issues?
> 

Yeah, there are still a few. The work in that general area dealt with
such problems as dirty pages reaching the end of the LRU (excessive CPU
usage), calling wait_on_page_writeback from reclaim context (random
processes stalling even though there was not much memory pressure),
desktop applications stalling randomly (second quick write stalling on
stable writeback). The systemtap script caught those type of areas and I
believe they are fixed up.

There are still problems though. If all dirty pages were backed by a slow
device then dirty limiting is still eventually going to cause stalls in
dirty page balancing. If there is a global sync then the shit can really
hit the fan if it all gets stuck waiting on something like journal space.
Applications that are very fsync happy can still get stalled for long
periods of time behind slower writers as they wait for the IO to flush.
When all this happens there still make be spikes in CPU usage if it scans
the dirty pages excessively without sleeping.

Consciously or unconsciously my desktop applications generally do not fall
foul of these problems. At least one of the desktop environments can stall
because it calls fsync on history and preference files constantly but I
cannot remember which one of if it has been fixed since. I did have a problem
with gnome-terminal as it depended on a library that implemented scrollback
buffering by writing single-line files to /tmp and then truncating them
which would "freeze" the terminal under IO. I now use tmpfs for /tmp to
get around this. When I'm writing to USB sticks I think it tends to stay
between the point where background writing starts and dirty throttling
occurs so I rarely notice any major problems. I'm probably unconsciously
avoiding doing any write-heavy work while a USB stick is plugged in.

Addressing this goes back to tuning dirty ratio or replacing it. Tuning
it always falls foul of "works for one person and not another" and fails
utterly when there is storage with differet speeds. We talked about this a
few months ago but I still suspect that we will have to bite the bullet and
tune based on "do not dirty more data than it takes N seconds to writeback"
using per-bdi writeback estimations. It's just not that trivial to implement
as the writeback speeds can change for a variety of reasons (multiple IO
sources, random vs sequential etc). Hence at one point we think we are
within our target window and then get it completely wrong. Dirty ratio
is a hard guarantee, dirty writeback estimation is best-effort that will
go wrong in some cases.

-- 
Mel Gorman
SUSE Labs
