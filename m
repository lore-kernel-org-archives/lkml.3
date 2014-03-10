Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaCJKPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:15:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaCJKPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:15:43 -0400
Date: Mon, 10 Mar 2014 10:15:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: pgsql-hackers@postgresql.org, mysql@lists.mysql.com,
        maria-developers@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Database/kernel community topic at Collaboration Summit 2014
Message-ID: <20140310101537.GC10663@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arrangements have been made to hold a meeting between database and kernel
developers at Collaboration Summit 2014 http://sched.co/1hEBRuq on March
27th 2014. This was organised after discussions on pain points encountered
by the PostgreSQL community. Originally the plan had been to just have a
topic for LSF/MM there was much more interest in the topic than anticipated
so the Collaboration Summit meeting will be much more open.

If there are developers attending Collaboration Summit that work in
the database or kernel communities, it would be great if you could come
along. Previous discussions were on the PostgreSQL list and that should be
expanded in case we accidentally build postgres-only features. The intent
is to identify the problems encountered by databases and where relevant,
test cases that can be used to demonstrate them if they exist.  While the
kernel community may be aware of some of the problems, they are not always
widely known or understood. There is a belief that some interfaces are fine
when in reality applications cannot use them properly. The ideal outcome
of the meeting would be concrete proposals on kernel features that could
be developed over the course of time to address any identified problem.

For reference, this is a summary of the discussion that took place when
the topic was proposed for LSF/MM.

Thanks.

---8<---

On testing of modern kernels
----------------------------

Josh Berkus claims that most people are using Postgres with 2.6.19 and
consequently there may be poor awareness of recent kernel developments.
This is a disturbingly large window of opportunity for problems to have
been introduced.

Minimally, Postgres has concerns about IO-related stalls which may or may
not exist in current kernels. There were indications that large writes
starve reads. There have been variants of this style of bug in the past but
it's unclear what the exact shape of this problem is and if IO-less dirty
throttling affected it. It is possible that Postgres was burned in the past
by data being written back from reclaim context in low memory situations.
That would have looked like massive stalls with drops in IO throughput
but it was fixed in relatively recent kernels. Any data on historical
tests would be helpful. Alternatively, a pgbench-based reproduction test
could potentially be used by people in the kernel community that track
performance over time and have access to a suitable testing rig.

It was mentioned that Postgres has an tool called pg_test_fsync which
was mentioned in the context of testing different wal_sync_methods. Potentially
it could also be used for evaluating some kernel patches.

Gregory Smith highlighted the existence of a benchmark wrapper for pgbench
called pgbench-tools: https://github.com/gregs1104/pgbench-tools . It can
track statistics of interest to Postgres as well as report in interesting
metrics such as transaction latency. He had a lot of information on testing
requirements and some very interesting tuning information and it's worth
reading the whole mail

	http://www.postgresql.org/message-id/52D99161.60305@gmail.com

Postgres bug reports and LKML
-----------------------------

It is claimed that LKML does not welcome bug reports but it's less clear
what the basis of this claim is.  Is it because the reports are ignored? A
possible explanation is that they are simply getting lost in the LKML noise
and there would be better luck if the bug report was cc'd to a specific
subsystem list. A second possibility is the bug report is against an old
kernel and unless it is reproduced on a recent kernel the bug report will
be ignored. Finally it is possible that there is not enough data available
to debug the problem. The worst explanation is that to date the problem
has not been fixable but the details of this have been lost and are now
unknown. Is is possible that some of these bug reports can be refreshed
so at least there is a chance they get addressed?

Apparently there were changes to the reclaim algorithms that crippled
performance without any sysctls. The problem may be compounded by the
introduction of adaptive replacement cache in the shape of the thrash
detection patches currently being reviewed.  Postgres investigated the
use of ARC in the past and ultimately abandoned it. Details are in the
archives (http://www.Postgres.org/search/?m=1&q=arc&l=1&d=-1&s=r). I
have not read then, just noting they exist for future reference.

Sysctls to control VM behaviour are not popular as such tuning parameters
are often used as an excuse to not properly fix the problem. Would it be
possible to describe a test case that shows 2.6.19 performing well and a
modern kernel failing? That would give the VM people a concrete basis to
work from to either fix the problem or identify exactly what sysctls are
required to make this work.

I am confident that any bug related to VM reclaim in this area has been lost.
At least, I recall no instances of it being discussed on linux-mm and it
has not featured on LSF/MM during the last years.

IO Scheduling
-------------

Kevin Grittner has stated that it is known that the DEADLINE and NOOP
schedulers perform better than any alternatives for most database loads.
It would be desirable to quantify this for some test case and see can the
default scheduler cope in some way.

The deadline scheduler makes sense to a large extent though. Postgres
is sensitive to large latencies due to IO write spikes. It is at least
plausible that deadline would give more deterministic behaviour for
parallel reads in the presence of large writes assuming there were not
ordering problems between the reads/writes and the underlying filesystem.

For reference, these IO spikes can be massive. If the shared buffer is
completely dirtied in a short space of time then it could be 20-25% of
RAM being dirtied and writeback required in typical configurations. There
have been cases where it was worked around by limiting the size of the
shared buffer to a small enough size so that it can be written back
quickly. There are other tuning options available such as altering when
dirty background writing starts within the kernel but that will not help if
the dirtying happens in a very short space of time. Dave Chinner described
the considerations as follows

	There's no absolute rule here, but the threshold for background
	writeback needs to consider the amount of dirty data being generated,
	the rate at which it can be retired and the checkpoint period the
	application is configured with. i.e. it needs to be slow enough to
	not cause serious read IO perturbations, but still fast enough that
	it avoids peaks at synchronisation points. And most importantly, it
	needs to be fast enought that it can complete writeback of all the
	dirty data in a checkpoint before the next checkpoint is triggered.

	In general, I find that threshold to be somewhere around 2-5s
	worth of data writeback - enough to keep a good amount of write
	combining and the IO pipeline full as work is done, but no more.

	e.g. if your workload results in writeback rates of 500MB/s,
	then I'd be setting the dirty limit somewhere around 1-2GB as
	an initial guess. It's basically a simple trade off buffering
	space for writeback latency. Some applications perform well with
	increased buffering space (e.g. 10-20s of writeback) while others
	perform better with extremely low writeback latency (e.g. 0.5-1s).

Some of this may have been addressed in recent changes with IO-less dirty
throttling. When considering stalls related to excessive IO it will be
important to check if the kernel was later than 3.2 and what the underlying
filesystem was.

Again, it really should be possible to demonstrate this with a test case,
one driven by pgbench maybe? Workload would generate a bunch of test data,
dirty a large percentage of it and try to sync. Metrics would be measuring
average read-only query latency when reading in parallel to the write,
average latencies from the underlying storage, IO queue lengths etc and
comparing default IO scheduler with deadline or noop.

NUMA Optimisations
------------------

The primary one that showed up was zone_reclaim_mode. Enabling that parameter
is a disaster for many workloads and apparently Postgres is one. It might
be time to revisit leaving that thing disabled by default and explicitly
requiring that NUMA-aware workloads that are correctly partitioned enable it.
Otherwise NUMA considerations are not that much of a concern right now.
Bruce Momjian highlighted this block entry that covered zone_reclaim

http://frosty-postgres.blogspot.com/2012/08/postgresql-numa-and-zone-reclaim-mode.html

Direct IO, buffered IO, double buffering and wishlists
------------------------------------------------------

The general position of Postgres is that the kernel knows more about
storage geometries and IO scheduling that an application can or should
know. It would be preferred to have interfaces that allow Postgres to
give hints to the kernel about how and when data should be written back.
The alternative is exposing details of the underlying storage to userspace
so Postgres can implement a full IO scheduler using direct IO. It has
been asserted on the kernel side that the optimal IO size and alignment
is the most important detail should be all the details that are required
in the majority of cases. While some database vendors have this option,
the Postgres community do not have the resources to implement something
of this magnitude. They also have tried direct IO in the past in the areas
where it should have mattered and had mixed results.

I can understand Postgres preference for using the kernel to handle these
details for them. They are a cross-platform application and the kernel
should not be washing its hands of the problem and hiding behind direct
IO as a solution. Ted Ts'o summarises the issues as

	The high order bit is what's the right thing to do when database
	programmers come to kernel engineers saying, we want to do <FOO>
	and the performance sucks.  Do we say, "Use O_DIRECT, dummy", not
	withstanding Linus's past comments on the issue?  Or do we have
	some general design principles that we tell database engineers that
	they should do for better performance, and then all developers for
	all of the file systems can then try to optimize for a set of new
	API's, or recommended ways of using the existing API's?

In an effort to avoid depending on direct IO there were some proposals
and/or wishlist items. These are listed in order of likliehood to be
implemented and usefulness to Postgres.

   1. Hint to asynchronously queue writeback now in preparation for a
      fsync in the near future. Postgres dirties a large amount of data and
      asks the kernel to push it to disk over the next few minutes. Postgres
      still is required to fsync later but the fsync time should be
      minimised. vm.dirty_writeback_centisecs is unreliable for this.

      One possibility would be an fadvise call that queues the data for
      writeback by a flusher thread now and returns immediately

   2. Hint that a page is a prime candidate for reclaim but only if there
      is reclaim pressure. This avoids a problem where fadvise(DONTNEED)
      discards a page only to have a read/write or WILLNEED hint immediately
      read it back in again. The requirements are similar to the volatile
      range hinting but they do not use mmap() currently and would need a
      file-descriptor based interface. Robert Hass had some concerns with
      the general concept and described them thusly

	This is an interesting idea but it stinks of impracticality.
	Essentially when the last buffer pin on a page is dropped we'd
	have to mark it as discardable, and then the next person wanting
	to pin it would have to check whether it's still there.  But the
	system call overhead of calling vrange() every time the last pin
	on a page was dropped would probably hose us.

	Well, I guess it could be done lazily: make periodic sweeps through
	shared_buffers, looking for pages that haven't been touched in a
	while, and vrange() them.  That's quite a bit of new mechanism,
	but in theory it could work out to a win.  vrange() would have
	to scale well to millions of separate ranges, though.  Will it?
	And a lot depends on whether the kernel makes the right decision
	about whether to chunk data from our vrange() vs. any other page
	it could have reclaimed.

   3. Hint that a page should be dropped immediately when IO completes.
      There is already something like this buried in the kernel internals
      and sometimes called "immediate reclaim" which comes into play when
      pages are bgin invalidated. It should just be a case of investigating
      if that is visible to userspace, if not why not and do it in a
      semi-sensible fashion.

   4. 8kB atomic write with OS support to avoid writing full page images
      in the WAL. This is a feature that is likely to be delivered anyway
      and one that Postgres is interested in.

   5. Only writeback some pages if explicitly synced or dirty limits
      are violated. Jeff Janes states that he has problems with large
      temporary files that generate IO spikes when the data starts hitting
      the platter even though the data does not need to be preserved. Jim
      Nasby agreed and commented that he "also frequently see this, and it
      has an even larger impact if pgsql_tmp is on the same filesystem as
      WAL. Which *theoretically* shouldn't matter with a BBU controller,
      except that when the kernel suddenly +decides your *temporary*
      data needs to hit the media you're screwed."

      One proposal that may address this is

	Allow a process with an open fd to hint that pages managed by this
	inode will have dirty-sticky pages. Pages will be ignored by dirty
	background writing unless there is an fsync call or dirty page limits
	are hit. The hint is cleared when no process has the file open.

   6. Only writeback pages if explicitly synced. Postgres has strict write
      ordering requirements. In the words of Tom Lane -- "As things currently
      stand, we dirty the page in our internal buffers, and we don't write
      it to the kernel until we've written and fsync'd the WAL data that
      needs to get to disk first". mmap() would avoid double buffering but
      it has no control about the write ordering which is a show-stopper.
      As Andres Freund described;

	Postgres' durability works by guaranteeing that our journal
	entries (called WAL := Write Ahead Log) are written & synced to
	disk before the corresponding entries of tables and indexes reach
	the disk. That also allows to group together many random-writes
	into a few contiguous writes fdatasync()ed at once. Only during
	a checkpointing phase the big bulk of the data is then (slowly,
	in the background) synced to disk. I don't see how that's doable
	with holding all pages in mmap()ed buffers.

      There are also concerns there would be an absurd number of mappings.

      The problem with this sort of dirty pinning interface is that it
      can deadlock the kernel if all dirty pages in the system cannot be
      written back by the kernel. James Bottomley stated

	No, I'm sorry, that's never going to be possible.  No user space
	application has all the facts.	If we give you an interface to
	force unconditional holding of dirty pages in core you'll livelock
	the system eventually because you made a wrong decision to hold
	too many dirty pages.

      However, it was very clearly stated that the writing ordering is
      critical. If the kernel breaks the requirement then the database
      can get trashed in the event of a power failure.

      This led to a discussion on write barriers which the kernel uses
      internally but there are scaling concerns both with the number of
      constraints that would exist and the requirement that Postgres use
      mapped buffers.

      There were few solid conclusions on this. It would need major
      reworking on all sides and it would handing control of system safety
      to userspace which is going to cause layering violations. This
      whole idea may be a bust but it is still worth recording. Greg Stark
      outlined the motivation best as follows;

	Ted T'so was concerned this would all be a massive layering violation
	and I have to admit that's a huge risk. It would take some clever
	API engineering to come with a clean set of primitives to express
	the kind of ordering guarantees we need without being too tied to
	Postgres's specific implementation. The reason I think it's more
	interesting though is that Postgres's journalling and checkpointing
	architecture is pretty bog-standard CS stuff and there are hundreds
	or thousands of pieces of software out there that do pretty much
	the same work and trying to do it efficiently with fsync or O_DIRECT
	is like working with both hands tied to your feet.

   7. Allow userspace process to insert data into the kernel page cache
      without marking the page dirty. This would allow the application
      to request that the OS use the application copy of data as page
      cache if it does not have a copy already. The difficulty here
      is that the application has no way of knowing if something else
      has altered the underlying file in the meantime via something like
      direct IO. Granted, such activity has probably corrupted the database
      already but initial reactions are that this is not a safe interface
      and there are coherency concerns.

      Dave Chinner asked "why, exactly, do you even need the kernel page
      cache here?"  when Postgres already knows how and when data should
      be written back to disk. The answer boiled down to "To let kernel do
      the job that it is good at, namely managing the write-back of dirty
      buffers to disk and to manage (possible) read-ahead pages". Postgres
      has some ordering requirements but it does not want to be responsible
      for all cache replacement and IO scheduling. Hannu Krosing summarised
      it best as

	Again, as said above the linux file system is doing fine. What we
	want is a few ways to interact with it to let it do even better
	when working with Postgres by telling it some stuff it otherwise
	would have to second guess and by sometimes giving it back some
	cache pages which were copied away for potential modifying but
	ended up clean in the end.

	And let the linux kernel decide if and how long to keep these pages
	in its	cache using its superior knowledge of disk subsystem and
	about what else is going on in the system in general.

   8. Allow copy-on-write of page-cache pages to anonymous. This would limit
      the double ram usage to some extent. It's not as simple as having a
      MAP_PRIVATE mapping of a file-backed page because presumably they want
      this data in a shared buffer shared between Postgres processes. The
      implementation details of something like this are hairy because it's
      mmap()-like but not mmap() as it does not have the same writeback
      semantics due to the write ordering requirements Postgres has for
      database integrity.

      Completely nuts and this was not mentioned on the list, but arguably
      you could try implementing something like this as a character device
      that allows MAP_SHARED with ioctls with ioctls controlling that file
      and offset backs pages within the mapping.  A new mapping would be
      forced resident and read-only. A write would COW the page. It's a
      crazy way of doing something like this but avoids a lot of overhead.
      Even considering the stupid solution might make the general solution
      a bit more obvious.

      For reference, Tom Lane comprehensively
      described the problems with mmap at
      http://www.Postgres.org/message-id/17515.1389715715@sss.pgh.pa.us

      There were some variants of how something like this could be achieved
      but no finalised proposal at the time of writing.

   9. Hint that a page in an anonymous buffer is a copy of a page cache
       page and invalidate the page cache page on COW. This limits the
       amount of double buffering. It's in as a low priority item as it's
       unclear if it's really necessary and also I suspect the implementation
       would be very heavy because of the amount of information we'd have
       to track in the kernel.

It is important to note in general that Postgres has a problem with some
files being written back too aggressively and other files not written back
aggressively enough. Temp files for purposes such as sorting should have
writeback deferred as long as possible. Data file writes that must complete
before portions of the WAL can be discarded should begin writeback early
so the final fsync does not stall for too long.  As Dave Chinner says

	IOWs, there are two very different IO and caching requirements
	in play here and tuning the kernel for one actively degrades the
	performance of the other.

Robert Hass categorised the IO patterns as follows

	- WAL files are written (and sometimes read) sequentially and
	  fsync'd very frequently and it's always good to write the data
	  out to disk as soon as possible

	- Temp files are written and read sequentially and never fsync'd.
	  They should only be written to disk when memory pressure demands
	  it (but are a good candidate when that situation comes up)

	- Data files are read and written randomly.  They are fsync'd at
	  checkpoint time; between checkpoints, it's best not to write
	  them sooner than necessary, but when the checkpoint arrives,
	  they all need to get out to the disk without bringing the system
	  to a standstill

No matter it was pointed out that fsync should never be able to screw the
system. Robert Hass again summaried it as follows

	IMHO, the problem is simpler than that: no single process should
	be allowed to completely screw over every other process on the
	system.  When the checkpointer process starts calling fsync(), the
	system begins writing out the data that needs to be fsync()'d so
	aggressively that service times for I/O requests from other process
	go through the roof.  It's difficult for me to imagine that any
	application on any I/O scheduler is ever happy with that behavior.
	We shouldn't need to sprinkle of fsync() calls with special magic
	juju sauce that says "hey, when you do this, could you try to avoid
	causing the rest of the system to COMPLETELY GRIND TO A HALT?".
	That should be the *default* behavior, if not the *only* behavior.

It is important to keep this in mind although sometimes the ordering
requirements of the filesystem may make it impossible to achieve.


At LSF/MM last year there was a discussion on whether userspace should
hint that files are "hot" or "cold" so the underlying layers could decide
to relocate some data to faster storage. I tuned out a bit during the
discussion and did not track what happened with it since but I guess that
any developments of that sort would be of interest to the Postgres community.

Some of these wish lists still need polish but could potentially be
discussed further at LSF/MM with a wider audience as well as on the
lists. Then in a of unicorns and ponies it's a case of picking some of
these hinting wishlists, seeing what it takes to implement it in kernel
and testing it with a suitably patched version of postgres running a test
case driven by something (pgbench presumably).

-- 
Mel Gorman
SUSE Labs
