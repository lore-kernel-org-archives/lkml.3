Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3C1Sxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:53:37 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:54476 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3C1Sxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:53:36 -0400
Date: Thu, 28 Mar 2013 11:53:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-crypt performance
Message-ID: <20130328185327.GF14088@htj.dyndns.org>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326202837.GA5599@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Vivek and Jens for the iosched related bits)

On Tue, Mar 26, 2013 at 04:28:38PM -0400, Mike Snitzer wrote:
> On Tue, Mar 26 2013 at  4:05pm -0400,
> Milan Broz <gmazyland@gmail.com> wrote:
> 
> > >On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
> > >
> > >>For best performance we could use the unbound workqueue implementation
> > >>with request sorting, if people don't object to the request sorting being
> > >>done in dm-crypt.
> > 
> > So again:
> > 
> > - why IO scheduler is not working properly here? Do it need some extensions?
> > If fixed, it can help even is some other non-dmcrypt IO patterns.
> > (I mean dmcrypt can set some special parameter for underlying device queue
> > automagically to fine-tune sorting parameters.)
> 
> Not sure, but IO scheduler changes are fairly slow to materialize given
> the potential for adverse side-effects.  Are you so surprised that a
> shotgun blast of IOs might make the IO schduler less optimal than if
> some basic sorting were done at the layer above?

My memory is already pretty hazy but Vivek should be able to correct
me if I say something nonsense.  The thing is, the order and timings
of IOs coming down from upper layers has certain meanings to ioscheds
and they exploit those patterns to do better scheduling.

Reordering IOs randomly actually makes certain information about the
IO stream lost and makes ioscheds mis-classify the IO stream -
e.g. what could have been classfied as "mostly consecutive streaming
IO" could after such reordering fail to be detected as such.  Sure,
ioscheds can probably be improved to compensate for such temporary
localized reorderings but nothing is free and given that most of the
upper stacks already do pretty good job of issuing IOs orderly when
possible, it would be a bit silly to do more than usually necessary in
ioscheds.

So, no, I don't think maintaining IO order in stacking drivers is a
bad idea.  I actually think all stacking drivers should do that;
otherwise, they really are destroying actual useful side-band
information.

> > - can we have some cpu-bound workqueue which automatically switch to unbound
> > (relocates work to another cpu) if it detects some saturation watermark etc?
> > (Again, this can be used in other code.
> > http://www.redhat.com/archives/dm-devel/2012-August/msg00288.html
> > (Yes, I see skepticism there :-)
> 
> Question for Tejun? (now cc'd).

Unbound workqueues went through quite a bit of improvements lately and
are currently growing NUMA affinity support.  Once merged, all unbound
work items issued on a NUMA node will be processed in the same NUMA
node, which should mitigate some, unfortunately not all, of the
disadvantages compared to per-cpu ones.  Mikulas, can you share more
about your test setup?  Was it a NUMA machine?  Which wq branch did
you use?

The NUMA affinity support would have less severe but similar issue as
per-cpu.  If all IOs are being issued from one node while other nodes
are idle, that specific node can get saturated.  NUMA affinity support
is adjusted both from inside kernel and userland via sysfs, so there
are control knobs for corner cases.

As for maintaining CPU or NUMA affinity until the CPU / node is
saturated and spilling to other CPUs/nodes beyond that, yeah, an
interesting idea.  It's non-trivial and would have to incorporate a
lot of notions on "load" similar to the scheduler.  It really becomes
a generic load balancing problem as it'd be pointless and actually
harmful to, say, spill work items to each other between two saturated
NUMA nodes.

So, if the brunt of scattering workload across random CPUs can be
avoided by NUMA affinity, that could be a reasonable tradeoff, I
think.

Thanks.

-- 
tejun
