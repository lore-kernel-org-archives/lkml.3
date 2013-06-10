Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3FJJMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:12:51 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:57306 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3FJJMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:12:47 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 05:12:47 EDT
X-AuditID: cbfec37c-b7f166d000004b4e-54-51b59634855e
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Tux3 Report: Fsync Redux
Thread-topic: Tux3 Report: Fsync Redux
Thread-index: Ac5luUPpvW8TOKQESW2XqEHSa41zEg==
Date: Mon, 10 Jun 2013 09:02:42 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE884507B6@sisaex02sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.34.5]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9hX12TaVsDDQ49FrfYs/cki8XlXXPY
	LD4c+MzowOzx7ekrNo/Pm+QCmKK4bFJSczLLUov07RK4Mi4c+8tW0ONT0fT2HmMD433bLkZO
	DgkBE4l3m1vYIWwxiQv31rN1MXJxCAksY5SY92oeWEJIoJdJ4v4JUwh7PqPEwTUBIDabgJnE
	0uNnmEAaRASWM0q8eHqLBSQhLKAosehlE5gtIqAmsWbuaiYIW0/i0YLFrCA2i4CqxKJjP8Bs
	XgF7ievf3rGB2IxAV3w/tQasnllAXKK59SYLxHUCEkv2nGeGsEUlXj7+xwphK0jcWLiMFaJe
	S2L9zuNQvdoST95dgJovKPFj8j2WCYwis5CMnYWkZRaSlllIWhYwsqxiFCstTi4oTkpPrTDW
	K07MLS7NS9dLzs/dxAiJjZodjPe+2hxiFOBgVOLhffhrS6AQa2JZcWXuIUYJDmYlEd60yVsD
	hXhTEiurUovy44tKc1KLDzEycXBKNTBa23Nt0e2Xsojczcfy7cuKe5GftZ+vlZPVCOTZuMHZ
	fhV7zan0TQ/tzrvnpp4WsW82S3kj/4jhvZEHS3CM3zP1zZPUUwxWqArXdjD/fco0pbEja4Ht
	31O8ayW/Sq0WlE58cWd2+wSuI7MXOd2e2uAysYv1lZ/aD4kSc4n0B97LTyuviPermKHEUpyR
	aKjFXFScCADjcHTUawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One month ago we reported that Tux3 is now able to beat tmpfs in at 
least one benchmark load, a claim that generated considerable lively 
commentary, some of it collegial:

     https://lkml.org/lkml/2013/5/7/742

Ted raised an interesting question about whether Tux3 is forever 
destined to suffer from slow fsync as an inherent design tradeoff. To be 
clear about it: that was never part of our plan.

 From early on, we intended to rely on full filesystem sync in place of 
fsync in the interest of correctness, then implement a properly 
optimized fsync later, probably after mainline merge. Elaborating our 
simple, rugged full-filesystem atomic commit strategy to accomodate 
efficient fsync always seemed to be a relatively easy design problem 
compared to the daunting task of adding strong consistency properties to 
a filesystem primarily oriented towards writing out single inodes. In 
the event, our intuition proved correct.

First, let me characterize the case where sync performs measurably worse 
than a purpose-built fsync. If Tux3 has just one dirty file and does a 
full filesystem sync, it performs well because only a few blocks need to 
be written. However, if there are dirty inodes in cache that fsync could 
bypass, sync may exhibit much higher latency than a well targetted fsync.

The arguably artificial dbench benchmark load rewards such dirty inode 
bypass richly by deleting most files while they are still retained in 
cache, thus avoiding a large amount of disk traffic. The question of 
whether this models any real world situation accurately is beside the 
point: if Tux3 wants to win at pure, unadulterated dbench, it better not 
let fsync push other dirty inodes to disk.

We set the following goals for our new, improved fsync design:

   * Meet or beat Ext4 performance
   * Keep our strong consistency semantics (similar to Ext3 data=journal)
   * No performance regression for non-fsync updates
   * Simple and provably correct

As always, the "simple" requirement is the biggest challenge. Various 
complex and finicky solutions suggest themselves. For example, we could 
analyze block level dependencies and write out just those blocks 
involved with a given dirty file. I can imagine such an approach 
succeeding, but cannot imagine it being simple.

After a few days of worrying away at the issues, I hit on a simple, 
effective idea. This was really just a matter of understanding our 
existing design more deeply rather than any fundamental breakthrough. 
(Note: we still do not intend to implement this right now, only design 
it with a view to putting to rest doubts that were expressed about the 
innate ability of Tux3 to handle fsync efficiently.)

Background

Tux3 normally divides episodes of filesystem update activity into chunks 
called "deltas". Each delta includes all data, namespace and attribute 
changes caused by some arbitrary set of syscalls. Each delta cleans all 
dirty cache. This is perfectly efficient for many common filesystem 
loads, but not all. Fsync is a good example of a case where we would 
like to leave most dirty data sitting in cache while committing just the 
dirty blocks of a single file. In other words, dirty data for an fsynced 
file needs to "jump the queue" of delta commits in the interest of 
efficiency.

Ext4 gets this kind of behavior more or less for free, because it is 
designed to write out whichever inode that core kernel tells it to, 
whenever it is told to. In contrast, Tux3 ignores core kernel's plan for 
which inodes should be written (taking the view that core kernel just 
does not understand the problem very well) and always writes out all of 
them. Our immediate project is to relax that behavior to support writing 
out just one of them.

The first big step forward came from noticing that it is easy to move 
dirty file data forward from the "current" delta (in process of being 
modified by syscalls) to the pervious delta (scheduled for commit to 
disk). For each dirty page, Tux3 conceptually maintains two dirty bits, 
one for the current and one for the previous delta. The "forking" 
mechanism protects any cache page that is dirty in the previous delta 
from being modified by subsequent syscalls. It is easy to walk the list 
of dirty pages of a given inode and change the state of all pages dirty 
in the current delta to be dirty in the previous delta instead. I call 
this the "promote" operation, which effectively takes a point in time 
snapshot of inode data. In our parlance, fsync promotes dirty data from 
the current to the previous delta. The remainder of the effort to turn 
this promote tool into an efficient fsync concerns feeding such promoted 
pages out to disk efficiently.

Subdelta concept rejected

My first stab at the fsync writeout problem revolved around a "subdelta"
concept. A subdelta would be an intermediate commit including just some 
of the dirty inodes belonging to a given delta. With this, fsync could 
interrupt the backend as it marshals some big delta for writeout, commit 
the fsynced inode, then resume committing the remainder of the delta.

This idea was vetoed by Hirofumi because it breaks our strong ordering
guarantee that we have grown rather fond of:

     If transaction A completes before transaction B begins, then
     transaction B will never be durably recorded unless transaction
     A is too.

I agree: stronger consistency semantics are user-friendly; we have 
become accustomed to them; we will hold that sacred as far as we can. So 
back to the drawing board.

Parallel log streams

The winning idea occurred practically simultaneously to both of us. We 
will elaborate our log design slightly to support parallel log streams. 
When the backend is in the middle of committing a big delta to disk, it 
may interrupt its work to start a new log chain that includes only a 
single inode with its modified attributes. When this completes, the 
backend resumes committing the remainder of the big delta.

For this to work properly there must not be any dependencies between the 
two log streams. In the case of regular files the log only needs to 
track block allocations and record new positions of any redirected 
blocks. To avoid colliding with changes belonging to the in-flight delta 
we will not modify the inode table immediately but rely on the fsync log 
to hold the updates until the in-flight delta completes. Then the 
backend will update the inode table to reflect the synced state in the 
following delta.

Various details need to be addressed to make this work. If an fsynced 
inode has already been marshalled and is on its way to disk in a 
previous delta then we need to wait for that delta to complete before 
committing the fsync. Doing otherwise would require significant design 
elaboration, and such a situation should be rare compared to the case 
where an fsynced inode is dirty in the previous delta but not yet 
marshalled (e.g., updated just before a delta transition and fsynced 
just after the transition). We must take care that an fsynced inode is 
not evicted before the inode table is updated to point to the new file 
data. Log replay becomes slightly more complex. Specifically, updated 
data attributes from fsync logs need to be entered into the inode table. 
This is a small amount of additional work to be done only on unexpected 
restart and has no efficiency impact. If an inode is newly created we 
must ensure that it is linked from some directory so that it will not 
leak on unexpected restart. For now we will fall back to sync for that 
situation, which guarantees that directories are consistent with the 
inode table.

That seems to be about it. No doubt we will discover a few unanticipated
details during implementation, however there is nothing more complex 
than or dissimilar from work we have already completed successfully. 
When we do get around to it, we should end up performing just fine in 
pure, unadulterated dbench, for what that is worth.

Directory fsync

We will not attempt to optimize directory fsync for the time being, not 
because of any inherent design limitation, but because we need to get 
back to work on the remaining issues that actually impact base 
functionality and currently stand in the way of Tux3 being practically 
usable. I will just mention that directory fsync involves consistency 
between directory data and the inode table, a topologically more complex 
problem than consistency between the inode table and regular file data. 
We are content to let this interesting problem simmer quietly on the 
back burner for the time being.

Shoutout to Samsung

I would like to thank Samsung warmly for providing me with a working 
situation where I can concentrate fully on Tux3 development as a member 
of the new Samsung Open Source Group.

Regards,

Daniel

