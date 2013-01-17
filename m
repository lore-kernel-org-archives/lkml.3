Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3AQN05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:26:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3AQN0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:26:54 -0500
Date: Thu, 17 Jan 2013 13:26:21 +0000
From: thornber@redhat.com
To: Amit Kale <akale@stec-inc.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Message-ID: <20130117132620.GA2438@raspberrypi>
Mail-Followup-To: Amit Kale <akale@stec-inc.com>,
	device-mapper development <dm-devel@redhat.com>,
	"kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 05:52:00PM +0800, Amit Kale wrote:
> Hi Joe, Kent,
> 
> [Adding Kent as well since bcache is mentioned below as one of the contenders for being integrated into mainline kernel.]
> 
> My understanding is that these three caching solutions all have three principle blocks.

Let me try and explain how dm-cache works.

> 1. A cache block lookup - This refers to finding out whether a block was cached or not and the location on SSD, if it was.

Of course we have this, but it's part of the policy plug-in.  I've
done this because the policy nearly always needs to do some book
keeping (eg, update a hit count when accessed).

> 2. Block replacement policy - This refers to the algorithm for replacing a block when a new free block can't be found.

I think there's more than just this.  These are the tasks that I hand
over to the policy:

  a) _Which_ blocks should be promoted to the cache.  This seems to be
     the key decision in terms of performance.  Blindly trying to
     promote every io or even just every write will lead to some very
     bad performance in certain situations.

     The mq policy uses a multiqueue (effectively a partially sorted
     lru list) to keep track of candidate block hit counts.  When
     candidates get enough hits they're promoted.  The promotion
     threshold his periodically recalculated by looking at the hit
     counts for the blocks already in the cache.

     The hit counts should degrade over time (for some definition of
     time; eg. io volume).  I've experimented with this, but not yet
     come up with a satisfactory method.

     I read through EnhanceIO yesterday, and think this is where
     you're lacking.

  b) When should a block be promoted.  If you're swamped with io, then
     adding copy io is probably not a good idea.  Current dm-cache
     just has a configurable threshold for the promotion/demotion io
     volume.  If you or Kent have some ideas for how to approximate
     the bandwidth of the devices I'd really like to hear about it.

  c) Which blocks should be demoted?

     This is the bit that people commonly think of when they say
     'caching algorithm'.  Examples are lru, arc, etc.  Such
     descriptions are fine when describing a cache where elements
     _have_ to be promoted before they can be accessed, for example a
     cpu memory cache.  But we should be aware that 'lru' for example
     really doesn't tell us much in the context of our policies.

     The mq policy uses a blend of lru and lfu for eviction, it seems
     to work well.

A couple of other things I should mention; dm-cache uses a large block
size compared to eio.  eg, 64k - 1m.  This is a mixed blessing;

 - our copy io is more efficient (we don't have to worry about
   batching migrations together so much.  Something eio is careful to
   do).

 - we have fewer blocks to hold stats about, so can keep more info per
   block in the same amount of memory.

 - We trigger more copying.  For example if an incoming write triggers
   a promotion from the origin to the cache, and the io covers a block
   we can avoid any copy from the origin to cache.  With a bigger
   block size this optmisation happens less frequently.

 - We waste SSD space.  eg, a 4k hotspot could trigger a whole block
   to be moved to the cache.


We do not keep the dirty state of cache blocks up to date on the
metadata device.  Instead we have a 'mounted' flag that's set in the
metadata when opened.  When a clean shutdown occurs (eg, dmsetup
suspend my-cache) the dirty bits are written out and the mounted flag
cleared.  On a crash the mounted flag will still be set on reopen and
all dirty flags degrade to 'dirty'.  Correct me if I'm wrong, but I
think eio is holding io completion until the dirty bits have been
committed to disk?

I really view dm-cache as a slow moving hotspot optimiser.  Whereas I
think eio and bcache are much more of a heirarchical storage approach,
where writes go through the cache if possible?

> 3. IO handling - This is about issuing IO requests to SSD and HDD.

  I get most of this for free via dm and kcopyd.  I'm really keen to
  see how bcache does; it's more invasive of the block layer, so I'm
  expecting it to show far better performance than dm-cache.

> 4. Dirty data clean-up algorithm (for write-back only) - The dirty
  data clean-up algorithm decides when to write a dirty block in an
  SSD to its original location on HDD and executes the copy.

  Yep.

> When comparing the three solutions we need to consider these aspects.

> 1. User interface - This consists of commands used by users for
  creating, deleting, editing properties and recovering from error
  conditions.

  I was impressed how easy eio was to use yesterday when I was playing
  with it.  Well done.

  Driving dm-cache through dm-setup isn't much more of a hassle
  though.  Though we've decided to pass policy specific params on the
  target line, and tweak via a dm message (again simple via dmsetup).
  I don't think this is as simple as exposing them through something
  like sysfs, but it is more in keeping with the device-mapper way.

> 2. Software interface - Where it interfaces to Linux kernel and applications.

  See above.

> 3. Availability - What's the downtime when adding, deleting caches,
  making changes to cache configuration, conversion between cache
  modes, recovering after a crash, recovering from an error condition.

  Normal dm suspend, alter table, resume cycle.  The LVM tools do this
  all the time.

> 4. Security - Security holes, if any.

  Well I saw the comment in your code describing the security flaw you
  think you've got.  I hope we don't have any, I'd like to understand
  your case more.

> 5. Portability - Which HDDs, SSDs, partitions, other block devices it works with.

  I think we all work with any block device.  But eio and bcache can
  overlay any device node, not just a dm one.  As mentioned in earlier
  email I really think this is a dm issue, not specific to dm-cache.

> 6. Persistence of cache configuration - Once created does the cache
  configuration stay persistent across reboots. How are changes in
  device sequence or numbering handled.

  We've gone for no persistence of policy parameters.  Instead
  everything is handed into the kernel when the target is setup.  This
  decision was made by the LVM team who wanted to store this
  information themselves (we certainly shouldn't store it in two
  places at once).  I don't feel strongly either way, and could
  persist the policy params v. easily (eg, 1 days work).

  One thing I do provide is a 'hint' array for the policy to use and
  persist.  The policy specifies how much data it would like to store
  per cache block, and then writes it on clean shutdown (hence 'hint',
  it has to cope without this, possibly with temporarily degraded
  performance).  The mq policy uses the hints to store hit counts.

> 7. Persistence of cached data - Does cached data remain across
  reboots/crashes/intermittent failures. Is the "sticky"ness of data
  configurable.

  Surely this is a given?  A cache would be trivial to write if it
  didn't need to be crash proof.

> 8. SSD life - Projected SSD life. Does the caching solution cause
  too much of write amplification leading to an early SSD failure.

  No, I decided years ago that life was too short to start optimising
  for specific block devices.  By the time you get it right the
  hardware characteristics will have moved on.  Doesn't the firmware
  on SSDs try and even out io wear these days?

  That said I think we evenly use the SSD.  Except for the superblock
  on the metadata device.

> 9. Performance - Throughput is generally most important. Latency is
  also one more performance comparison point. Performance under
  different load classes can be measured.

  I think latency is more important than throughput.  Spindles are
  pretty good at throughput.  In fact the mq policy tries to spot when
  we're doing large linear ios and stops hit counting; best leave this
  stuff on the spindle.

> 10. ACID properties - Atomicity, Concurrency, Idempotent,
  Durability. Does the caching solution have these typical
  transactional database or filesystem properties. This includes
  avoiding torn-page problem amongst crash and failure scenarios.

  Could you expand on the torn-page issue please?

> 11. Error conditions - Handling power failures, intermittent and permanent device failures.

  I think the area where dm-cache is currently lacking is intermittent
  failures.  For example if a cache read fails we just pass that error
  up, whereas eio sees if the block is clean and if so tries to read
  off the origin.  I'm not sure which behaviour is correct; I like to
  know about disk failure early.

> 12. Configuration parameters for tuning according to applications.

  Discussed above.

> We'll soon document EnhanceIO behavior in context of these
  aspects. We'll appreciate if dm-cache and bcache is also documented.

  I hope the above helps.  Please ask away if you're unsure about
  something.

> When comparing performance there are three levels at which it can be measured

Developing these caches is tedious.  Test runs take time, and really
slow the dev cycle down.  So I suspect we've all been using
microbenchmarks that run in a few minutes.

Let's get our pool of microbenchmarks together, then work on some
application level ones (we're happy to put some time into developing
these).

- Joe
