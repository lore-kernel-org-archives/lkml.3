Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaJ2WYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:24:14 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:44635 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbaJ2WYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141029220905.GL16186@dastard>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	<20141029201417.GK16186@dastard>
	<545157DB.70304@fb.com>
	<20141029220905.GL16186@dastard>
Date: Wed, 29 Oct 2014 15:24:11 -0700
Message-ID: <CAPcyv4iiqfeWQyZpzYwASFV+7Ztjcjrp0DEq3ThOmdwgWGGJUw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
From: Dan Williams <dan.j.williams@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>, "Jason B. Akers" <jason.b.akers@intel.com>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 29, 2014 at 03:10:51PM -0600, Jens Axboe wrote:
>> On 10/29/2014 02:14 PM, Dave Chinner wrote:
>> > On Wed, Oct 29, 2014 at 11:23:38AM -0700, Jason B. Akers wrote:
>> >> The following series enables the use of Solid State hybrid drives
>> >> ATA standard 3.2 defines the hybrid information feature, which provides a means for the host driver to provide hints to the SSHDs to guide what to place on the SSD/NAND portion and what to place on the magnetic media.
>> >>
>> >> This implementation allows user space applications to provide the cache hints to the kernel using the existing ionice syscall.
>> >>
>> >> An application can pass a priority number coding up bits 11, 12, and 15 of the ionice command to form a 3 bit field that encodes the following priorities:
>> >>    OPRIO_ADV_NONE,
>> >>    IOPRIO_ADV_EVICT, /* actively discard cached data */
>> >>    IOPRIO_ADV_DONTNEED, /* caching this data has little value */
>> >>    IOPRIO_ADV_NORMAL, /* best-effort cache priority (default) */
>> >>    IOPRIO_ADV_RESERVED1, /* reserved for future use */
>> >>    IOPRIO_ADV_RESERVED2,
>> >>    IOPRIO_ADV_RESERVED3,
>> >>    IOPRIO_ADV_WILLNEED, /* high temporal locality */
>> >>
>> >> For example the following commands from the user space will make dd IOs to be generated with a hint of IOPRIO_ADV_DONTNEED assuming the SSHD is /dev/sdc.
>> >>
>> >> ionice -c2 -n4096 dd if=/dev/zero of=/dev/sdc bs=1M count=1024
>> >> ionice -c2 -n4096 dd if=/dev/sdc of=/dev/null bs=1M count=1024
>> >
>> > This looks to be the wrong way to implement per-IO priority
>> > information.
>> >
>> > How does a filesystem make use of this to make sure it's
>> > metadata ends up with IOPRIO_ADV_WILLNEED to store frequently
>> > accessed metadata in flash. Conversely, journal writes need to
>> > be issued with IOPRIO_ADV_DONTNEED so they don't unneceessarily
>> > consume flash space as they are never-read IOs...
>>
>> Not disagreeing that loading more into the io priority fields is a
>> bit... icky. I see why it's done, though, it requires the least amount
>> of plumbing.
>
> Yeah, but we don't do things the easy way just because it's easy. We
> do things the right way. ;)

...heh, I also don't think we add complication when the simple way
gets us most of the benefit*.

* says the low-level device driver guy ;-).

>> As for the fs accessing this, the io nice fields are readily exposed
>> through the ->bi_rw setting. So while the above example uses ionice to
>> set a task io priority (that a bio will then inherit), nothing prevents
>> you from passing it in directly from the kernel.
>
> Right, but now the filesystem needs to provide that on a per-inode
> basis, not from the task structure as the task that is submitting
> the bio is not necesarily the task doing the read/write syscall.
>
> e.g. the write case above doesn't actually inherit the task priority
> at the bio level at all because the IO is being dispatched by a
> background flusher thread, not the ioniced task calling write(2).

When the ioniced task calling write(2) inserts the page into the page
cache then the current priority is recorded in the struct page.  The
background flusher likely runs at a lower / neutral caching priority
and the priority carried in the page will be the effective caching
priority applied to the bio.

> IMO using ionice is a nice hack, but utimately it looks mostly useless
> from a user and application perspective as cache residency is a
> property of the data being read/written, not the task doing the IO.
> e.g. a database will want it's indexes in flash and bulk
> data in non-cached storage.

Right, if those are doing direct-i/o then have a separate thread-id
for those write(2) calls.  Otherwise if they are dirtying page cache
the struct page carries the hint.

> IOWs, to make effective use of this the task will need different
> cache hints for each different type of data needs to do IO on, and
> so overloading IO priorities just seems the wrong direction to be
> starting from.

There's also the fadvise() enabling that could be bolted on top of
this capability.  But, before that step, is a thread-id per-caching
context too much to ask?
