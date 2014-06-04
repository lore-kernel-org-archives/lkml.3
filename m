Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaFDN4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:56:33 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:39795 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaFDN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:56:31 -0400
Date: Wed, 4 Jun 2014 09:56:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 11/12] block, bfq: boost the throughput
 on NCQ-capable flash-based devices
Message-ID: <20140604135627.GB5004@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-12-git-send-email-paolo.valente@unimore.it>
 <20140531115216.GB5057@htj.dyndns.org>
 <36BFDB73-AEC2-4B87-9FD6-205E9431E722@unimore.it>
 <20140603171124.GE26210@htj.dyndns.org>
 <03CDD106-DB18-4E8F-B3D6-2AAD45782A06@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03CDD106-DB18-4E8F-B3D6-2AAD45782A06@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

On Wed, Jun 04, 2014 at 09:29:20AM +0200, Paolo Valente wrote:
> > Shouldn't the comparison be against the benefit of "not idling
> > selectively" vs "always idling" when blkcg is in use?
> > 
> 
> Exactly. I’m sorry if I wrote things/sentences that did not let this
> point be clear. Maybe this lack of clarity is a further consequence
> of the annoying “not not” scheme adopted in the code and in the
> comments.

Ah, no, it was just me misreading the message.

> > I'm not really convinced about the approach.  With rotating disks, we
> > know that allowing queue depth > 1 generaly lowers both throughput and
> > responsiveness and brings benefits in quite restricted cases.  It
> > seems rather backwards to always allow QD > 1 and then try to optimize
> > in an attempt to recover what's lost.  Wouldn't it make far more sense
> > to actively maintain QD == 1 by default and allow QD > 1 in specific
> > cases where it can be determined to be more beneficial than harmful?
> 
> Although QD == 1 is not denoted explicitly as default, what you suggest is exactly what bfq does. 
I see.

> >> I do not know how widespread a mechanism like ulatencyd is
> >> precisely, but in the symmetric scenario it creates, the throughput
> >> on, e.g., an HDD would drop by half if the workload is mostly random
> >> and we removed the more complex mechanism we set up.  Wouldn't this
> >> be bad?
> > 
> > It looks like a lot of complexity for optimization for a very
> > specific, likely unreliable (in terms of its triggering condition),
> > use case.  The triggering condition is just too specific.
> 
> Actually we have been asked several times to improve random-I/O
> performance on HDDs over the last years, by people recording, for
> the typical tasks performed by their machines, much lower throughput
> than with the other schedulers. Major problems have been reported
> for server workloads (database, web), and for btrfs. According to
> the feedback received after introducing this optimization in bfq,
> those problems seem to be finally gone.

I see.  The equal priority part can probably work in enough cases to
be meaningful given that it just depends on the busy queues having the
same weight instead of everything in the system.  It'd nice to note
that in the comment tho.

I'm still quite skeptical about the cgroup part tho.  The triggering
condition is too specific and fragile.  If I'm reading the bfq blkcg
implementation correctly, it seems to be applying the scheduling
algorithm recursively walking down the tree one level at a time.  cfq
does it differently.  cfq flattens the hierarchy by calculating the
nested weight of each active leaf queue and schedule all of them from
the same service tree.  IOW, scheduling algorithm per-se doesn't care
about the hierarchy.  All it sees are differing weights competing
equally regardless of the hierarchical structure.

If the same strategy can be applied to bfq, possibly the same strategy
of checking whether all the active queues have the same weight can be
used regardless of blkcg?  That'd be simpler and a lot more robust.

Another thing I'm curious about is that the logic that you're using to
disable idling assumes that the disk will serve the queued commands
more or less in fair manner over time, right?  If so, why does queues
having the same weight matter?  Shouldn't the bandwidth scheduling
eventually make them converge to the specified weights over time?
Isn't wr_coeff > 1 test enough for maintaining reasonable
responsiveness?

> Besides, turning back to bfq, if its low-latency heuristics are
> disabled for non rotational devices, then, according to our results
> with slower devices, such as SD Cards and eMMCs, latency becomes
> easily unbearable, with no throughput gain.

Hmmm... looking at the nonrot optimizations again, so yeah assuming
the weight counting is necessary for NCQ hdds the part specific to
ssds isn't that big.  You probably wanna sequence it the other way
around tho.  This really should be primarily about disks at this
point.

The thing which still makes me cringe is how it scatters
blk_queue_nonrot() tests across multiple places without clear
explanation on what's going on.  A bfqq being constantly seeky or not
doesn't have much to do with whether the device is rotational or not.
Its effect does and I don't think avoiding the overhead of keeping the
counters is meaningful.  Things like this make the code a lot harder
to maintain in the long term as code is organized according to
seemingly arbitrary optimization rather than semantic structure.  So,
let's please keep the accounting and optimization separate.

Thanks.

-- 
tejun
