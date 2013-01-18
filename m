Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3ARHHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:07:30 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:35222 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751322Ab3ARHHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:07:21 -0500
X-ASG-Debug-ID: 1358492836-053ea90dcf1bea80001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: "thornber@redhat.com" <thornber@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Date: Fri, 18 Jan 2013 15:03:54 +0800
Subject: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Topic: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
X-ASG-Orig-Subj: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Index: Ac3043LdBdl+r6jkRzWytABMFtenEQAZVnLA
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72A9@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <20130117185016.GA2479@raspberrypi>
In-Reply-To: <20130117185016.GA2479@raspberrypi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358492836
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120179
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >      The mq policy uses a multiqueue (effectively a partially
> sorted
> > >      lru list) to keep track of candidate block hit counts.  When
> > >      candidates get enough hits they're promoted.  The promotion
> > >      threshold his periodically recalculated by looking at the hit
> > >      counts for the blocks already in the cache.
> >
> > Multi-queue algorithm typically results in a significant metadata
> > overhead. How much percentage overhead does that imply?
> 
> It is a drawback, at the moment we have a list head, hit count and some
> flags per block.  I can compress this, it's on my todo list.
> Looking at the code I see you have doubly linked list fields per block
> too, albeit 16 bit ones.  We use much bigger blocks than you, so I'm
> happy to get the benefit of the extra space.
> 
> > >      I read through EnhanceIO yesterday, and think this is where
> > >      you're lacking.
> >
> > We have an LRU policy at a cache set level. Effectiveness of the LRU
> > policy depends on the average duration of a block in a working
> > dataset. If the average duration is small enough so a block is most
> of
> > the times "hit" before it's chucked out, LRU works better than any
> > other policies.
> 
> Yes, in some situations lru is best, in others lfu is best.  That's why
> people try and blend in something like arc.  Now my real point was
> although you're using lru to choose what to evict, you're not using
> anything to choose what to put _in_ the cache, or have I got this
> totally wrong?

We simply put in any read or written blocks into the cache (subject to availability and controlled limits).

> 
> > > A couple of other things I should mention; dm-cache uses a large
> > > block size compared to eio.  eg, 64k - 1m.  This is a mixed
> > > blessing;
> >
> > Yes. We had a lot of debate internally on the block size. For now we
> > have restricted to 2k, 4k and 8k. We found that larger block sizes
> > result in too much of internal fragmentation, in-spite of a
> > significant reduction in metadata size. 8k is adequate for Oracle and
> > mysql.
> 
> Right, you need to describe these scenarios so you can show off eio in
> the best light.
> 
> > > We do not keep the dirty state of cache blocks up to date on the
> > > metadata device.  Instead we have a 'mounted' flag that's set in
> the
> > > metadata when opened.  When a clean shutdown occurs (eg, dmsetup
> > > suspend my-cache) the dirty bits are written out and the mounted
> > > flag cleared.  On a crash the mounted flag will still be set on
> > > reopen and all dirty flags degrade to 'dirty'.
> >
> 
> > Not sure I understand this. Is there a guarantee that once an IO is
> > reported as "done" to upstream layer
> > (filesystem/database/application), it is persistent. The persistence
> > should be guaranteed even if there is an OS crash immediately after
> > status is reported. Persistence should be guaranteed for the entire
> IO
> > range. The next time the application tries to read it, it should get
> > updated data, not stale data.
> 
> Yes, we're careful to persist all changes in the mapping before
> completing io.  However the dirty bits are just used to ascertain what
> blocks need writing back to the origin.  In the event of a crash it's
> safe to assume they all do.  dm-cache is a slow moving cache, change of
> dirty status occurs far, far more frequently than change of mapping.
> So avoiding these updates is a big win.

That's great.


> 
> > > Correct me if I'm wrong, but I
> > > think eio is holding io completion until the dirty bits have been
> > > committed to disk?
> >
> > That's correct. In addition to this, we try to batch metadata updates
> if multiple IOs occur in the same cache set.
> 
> y, I batch updates too.
> 
> > > > 3. Availability - What's the downtime when adding, deleting
> > > > caches,
> > >   making changes to cache configuration, conversion between cache
> > >   modes, recovering after a crash, recovering from an error
> condition.
> > >
> > >   Normal dm suspend, alter table, resume cycle.  The LVM tools do
> this
> > >   all the time.
> >
> > Cache creation and deletion will require stopping applications,
> > unmounting filesystems and then remounting and starting the
> > applications. A sysad in addition to this will require updating fstab
> > entries. Do fstab entries work automatically in case they use labels
> > instead of full device paths.
> 
> The common case will be someone using a volume manager like LVM, so the
> device nodes are already dm ones.  In this case there's no need for
> unmounting or stopping applications.  Changing the stack of dm targets
> around on a live system is a key feature.  For example this is how we
> implement the pvmove functionality.
> 
> > >   Well I saw the comment in your code describing the security flaw
> you
> > >   think you've got.  I hope we don't have any, I'd like to
> understand
> > >   your case more.
> >
> > Could you elaborate on which comment you are referring to?
> 
> Top of eio_main.c
> 
>  * 5) Fix a security hole : A malicious process with 'ro' access to a
>  * file can potentially corrupt file data. This can be fixed by
>  * copying the data on a cache read miss.

That's stale. Slipped out of our cleanup. Will remove that.

It's still possible for an ordinary user to "consume" a significant portion of a cache by perpetually reading all permissible data. Caches as of now don't have user based controls for caches.
-Amit

> 
> > > > 5. Portability - Which HDDs, SSDs, partitions, other block
> devices
> > > > it
> > > works with.
> > >
> > >   I think we all work with any block device.  But eio and bcache
> can
> > >   overlay any device node, not just a dm one.  As mentioned in
> earlier
> > >   email I really think this is a dm issue, not specific to dm-
> cache.
> >
> > DM was never meant to be cascaded. So it's ok for DM.
> 
> Not sure what you mean here?  I wrote dm specifically with stacking
> scenarios in mind.

DM can't use a device containing partitions, by design. It works on individual partitions, though.

> 
> > > > 7. Persistence of cached data - Does cached data remain across
> > >   reboots/crashes/intermittent failures. Is the "sticky"ness of
> data
> > >   configurable.
> > >
> > >   Surely this is a given?  A cache would be trivial to write if it
> > >   didn't need to be crash proof.
> >
> > There has to be a way to make it either persistent or volatile
> > depending on how users want it. Enterprise users are sometimes
> > paranoid about HDD and SSD going out of sync after a system shutdown
> > and before a bootup. This is typically for large complicated iSCSI
> > based shared HDD setups.
> 
> Well in those Enterprise users can just use dm-cache in writethrough
> mode and throw it away when they finish.  Writing our metadata is not
> the bottle neck (copy for migrations is), and it's definitely worth
> keeping so there are up to date hit counts for the policy to work off
> after reboot.

Agreed. However there are arguments both ways. The need to start afresh is valid, although not frequent.

> 
> > That's correct. We don't have to worry about wear leveling. All of
> the competent SSDs around do that.
> >
> 
> > What I wanted to bring up was how many SSD writes does a cache
> > read/write result. Write back cache mode is specifically taxing on
> > SSDs in this aspect.
> 
> No more than read/writes to a plain SSD.  Are you getting hit by extra
> io because you persist dirty flags?

It's a price users pay for metadata updates. Our three caching modes have different levels of SSD writes. Read-only < write-through < write-back. Users can look at the benefits versus SSD life and choose accordingly.
-Amit


PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
