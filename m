Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3JDNh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:37:28 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56934 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3JDNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:37:26 -0400
Message-ID: <524EC491.30701@gmail.com>
Date: Fri, 04 Oct 2013 22:37:21 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: [RFC] dm-writeboost: Persistent memory support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Let me introduce my future plan
of applying persistent memory to dm-writeboost.
dm-writeboost can potentially
gain many benefits by the persistent memory.

(1) Problem
The basic mechanism of dm-writeboost is
(i) first stores the write data to RAM buffer
    whose size is 1MB at maximum and
    can include 255 * 4KB data.
(ii) when the RAM buffer is fulfilled
     it packs the data and its metadata 
     which indicates where to write back,
     into a structure called "log" and
     queues it.
(iii) the log is flushed to the cache device
      in background.
(iv) and later migrated or written back
     to the backing store in background.

The problem is in handling barrier writes
flagged with REA_FUA or REQ_FLUSH.
Upper layer waits for these kind of bios complete
so waiting for log to be fulfilled and then queued
may stall the upper layer.
One of the methods in receiving these bios is that
dm-writeboost makes a "partial" log and queues it
which causes potentially random writes to the 
cache device(SSD) which not only loses its performance
but also fails to maximize the lifetime of the SSD device.
Moreover, it consumes CPU cycles to make a partial log
again and again. It is not free.

So, dm-writeboost provides a tunable parameter called
barrier_deadline_ms that indicates the
worst time guaranteed that these unusually flagged bios queued.
Making a partial log is deferred and
it means that the log can be fulfilled before the deadline
if there are many processes submitting writes.

In summary,
due to the REQ_FUA and REQ_FLUSH flag
dm-writeboost can not guarantee the log always fulfilled.
Imagine there is only one process above the dm-writeboost device
and rediculously submits REQ_FUAed bio and waits for the completion repeatly.
This is the worst case for dm-writeboost
the log is always partial and the process always waits for 
the deadline.

If the RAM buffer is smaller than 1MB
the log is likely to be fulfilled.
The size of the RAM buffer is tunable in constructor.
However, this is not the ultimate solution.

So, let's find the ultimate solution next.

(2) What if RAM buffer is non-volatile
If we use persistent memory for the RAM buffer instead of
DRAM which is volatile
we don't need to partially flush the log
to complete these flagged bios quickly
but can do away with only writing the data
to the persistent RAM buffer and then returning ACK.

This means
the 1MB log will be always fulfilled
and the upper layer will never be annoyed with
how to handle the REQ_FUA or REQ_FLUSH flagged bios.
This will always maximize the write thoughput to the SSD device
and maximize its lifetime.

Futhermore,
upper layer can eliminate the
optimization for these bios.
For example, XFS also does the same technique
of gathering the barriers as explained by Dave Chinner in
https://lkml.org/lkml/2013/10/3/804

Using dm-writeboost with persistent memory
the upper layer will be alliviated
from doing difficult things.
Applying persistent memory to dm-writeboost is promising.

Any comment?

(3) Design Change
I have read this thread in LKML
"RFC Block Layer Extensions to Support NV-DIMMs"
https://lkml.org/lkml/2013/9/4/555
 
The interface design is still in discussion but
I hope to see an interface design that deals with
persistent memory as the new type of memory
not the block device.

Even if the RAM buffer is switch to 
volatile to non-volatile
the basic I/O path of dm-writeboost will not change.
I think most of the code can be shared between
volatile mode and non-volatile mode of dm-writeboost.
So, switching the mode in constructor parameter
will be my design choice.

Maybe the constructor will be like this
writeboost <mode> ...
writeboost 0 <backing store> <cache device> ....
writeboost 1 <backing store> <cache device> <persistent memory> ...

If the mode is 0 it builds a writeboost device with volatile RAM buffer
and the mode is 1 it builds with non-volatile RAM buffer.

The current design doesn't have mode parameter
so adding the parameter right now could be our design choice
but even if we don't add it right now
the backward-compatibility can be guaranteed
by implicitly setting the mode to 0 if the first parameter is not a number.
I prefer adding it right now for future design consistency.

Should or Shouldn't I add the paramter before
making a patch to device-mapper tree?

(4) Prototype
I think I can start prototyping
by defining a pseudo persistent memory backed by a block device.

The temporary interface will be defined like:
struct pmem *pmem_alloc(struct block_device *, size_t start, size_t len);
void pmem_write(struct pmem *, size_t start, size_t len, void *data);
void pmem_read(struct pmem *, size_t start, size_t len, void *dest);
void pmem_free(struct pmem *);

Byte-addressableness is implemented by Read-Modify-Write.

The difficulty in using the persistent memory instead
is in recovering the data both on the RAM buffer and the cache device
in rebooting.
The implementation will be complicated but
can mostly be limited under recover_cache() routine
and the outside of it will not be badly tainted.

Should I prototype before making patch to device-mapper tree?

Akira
