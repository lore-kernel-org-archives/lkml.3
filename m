Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaB1TqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:46:17 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55069 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaB1TqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:46:15 -0500
Date: Fri, 28 Feb 2014 14:46:08 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dm-writeboost: Persistent memory support
Message-ID: <20140228194603.GA16021@gmail.com>
References: <524EC491.30701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <524EC491.30701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:37:21PM +0900, Akira Hayakawa wrote:
> Hi, all
> 
> Let me introduce my future plan
> of applying persistent memory to dm-writeboost.
> dm-writeboost can potentially
> gain many benefits by the persistent memory.
> 
> (1) Problem
> The basic mechanism of dm-writeboost is
> (i) first stores the write data to RAM buffer
>     whose size is 1MB at maximum and
>     can include 255 * 4KB data.
> (ii) when the RAM buffer is fulfilled
>      it packs the data and its metadata 
>      which indicates where to write back,
>      into a structure called "log" and
>      queues it.
> (iii) the log is flushed to the cache device
>       in background.
> (iv) and later migrated or written back
>      to the backing store in background.
> 
> The problem is in handling barrier writes
> flagged with REA_FUA or REQ_FLUSH.
> Upper layer waits for these kind of bios complete
> so waiting for log to be fulfilled and then queued
> may stall the upper layer.
> One of the methods in receiving these bios is that
> dm-writeboost makes a "partial" log and queues it
> which causes potentially random writes to the 
> cache device(SSD) which not only loses its performance
> but also fails to maximize the lifetime of the SSD device.
> Moreover, it consumes CPU cycles to make a partial log
> again and again. It is not free.
> 
> So, dm-writeboost provides a tunable parameter called
> barrier_deadline_ms that indicates the
> worst time guaranteed that these unusually flagged bios queued.
> Making a partial log is deferred and
> it means that the log can be fulfilled before the deadline
> if there are many processes submitting writes.
> 
> In summary,
> due to the REQ_FUA and REQ_FLUSH flag
> dm-writeboost can not guarantee the log always fulfilled.
> Imagine there is only one process above the dm-writeboost device
> and rediculously submits REQ_FUAed bio and waits for the completion repeatly.
> This is the worst case for dm-writeboost
> the log is always partial and the process always waits for 
> the deadline.
> 
> If the RAM buffer is smaller than 1MB
> the log is likely to be fulfilled.
> The size of the RAM buffer is tunable in constructor.
> However, this is not the ultimate solution.
> 
> So, let's find the ultimate solution next.
> 
> (2) What if RAM buffer is non-volatile
> If we use persistent memory for the RAM buffer instead of
> DRAM which is volatile
> we don't need to partially flush the log
> to complete these flagged bios quickly
> but can do away with only writing the data
> to the persistent RAM buffer and then returning ACK.
> 
> This means
> the 1MB log will be always fulfilled
> and the upper layer will never be annoyed with
> how to handle the REQ_FUA or REQ_FLUSH flagged bios.
> This will always maximize the write thoughput to the SSD device
> and maximize its lifetime.
> 
> Futhermore,
> upper layer can eliminate the
> optimization for these bios.
> For example, XFS also does the same technique
> of gathering the barriers as explained by Dave Chinner in
> https://lkml.org/lkml/2013/10/3/804
> 
> Using dm-writeboost with persistent memory
> the upper layer will be alliviated
> from doing difficult things.
> Applying persistent memory to dm-writeboost is promising.
> 
> Any comment?
> 
> (3) Design Change
> I have read this thread in LKML
> "RFC Block Layer Extensions to Support NV-DIMMs"
> https://lkml.org/lkml/2013/9/4/555
>  
> The interface design is still in discussion but
> I hope to see an interface design that deals with
> persistent memory as the new type of memory
> not the block device.
> 
> Even if the RAM buffer is switch to 
> volatile to non-volatile
> the basic I/O path of dm-writeboost will not change.
> I think most of the code can be shared between
> volatile mode and non-volatile mode of dm-writeboost.
> So, switching the mode in constructor parameter
> will be my design choice.
> 
> Maybe the constructor will be like this
> writeboost <mode> ...
> writeboost 0 <backing store> <cache device> ....
> writeboost 1 <backing store> <cache device> <persistent memory> ...
> 
> If the mode is 0 it builds a writeboost device with volatile RAM buffer
> and the mode is 1 it builds with non-volatile RAM buffer.
> 
> The current design doesn't have mode parameter
> so adding the parameter right now could be our design choice
> but even if we don't add it right now
> the backward-compatibility can be guaranteed
> by implicitly setting the mode to 0 if the first parameter is not a number.
> I prefer adding it right now for future design consistency.
> 
> Should or Shouldn't I add the paramter before
> making a patch to device-mapper tree?
> 
> (4) Prototype
> I think I can start prototyping
> by defining a pseudo persistent memory backed by a block device.
> 
> The temporary interface will be defined like:
> struct pmem *pmem_alloc(struct block_device *, size_t start, size_t len);
> void pmem_write(struct pmem *, size_t start, size_t len, void *data);
> void pmem_read(struct pmem *, size_t start, size_t len, void *dest);
> void pmem_free(struct pmem *);
> 
> Byte-addressableness is implemented by Read-Modify-Write.
> 
> The difficulty in using the persistent memory instead
> is in recovering the data both on the RAM buffer and the cache device
> in rebooting.
> The implementation will be complicated but
> can mostly be limited under recover_cache() routine
> and the outside of it will not be badly tainted.
> 
> Should I prototype before making patch to device-mapper tree?
> 
> Akira

Just jumping in. I am working on new API to allow mirroring process address
on a device. The devices we are targeting sit behind IOMMU and i fear that
in some case the persistent memory will not be accessible from behind the
IOMMU.

In such case it is important to be able to enforce for some range of memory
to go through the normal page cache volatile memory.

Even when the persistent memory is accessible from behind the IOMMU we will
want to mirror memory in local device memory for more or long period of time
and thus will need way again to make range of persistent to behave like if
things were going through volatile memory.

I hope to send a patchset for comment in April and at that time it will be
easier for everyone to see the internal of how things are done but in a
nutshell device memory is consired swap and page cache entry can be swap
to the device memory.

Cheers,
Jérôme

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
