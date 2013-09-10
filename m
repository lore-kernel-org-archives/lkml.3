Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3IJVrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:47:05 -0400
Received: from zill.ext.symas.net ([69.43.206.106]:38593 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3IJVqy (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 10 Sep 2013 17:46:54 -0400
Message-ID: <522F934C.7080001@symas.com>
Date: Tue, 10 Sep 2013 14:46:52 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Firefox/25.0 SeaMonkey/2.22a1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: dirty_expire_centisecs, msync behavior
References: <522BBE46.9060809@symas.com> <20130910204544.GB3046@quack.suse.cz>
In-Reply-To: <20130910204544.GB3046@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>    Hello,

Hi Jan, thanks for your answers.

> On Sat 07-09-13 17:01:10, Howard Chu wrote:
>> The documentation for dirty_expire_centisecs states: "Data which has
>> been dirty in-memory for longer than this interval will be written
>> out next time a flusher thread wakes up."
>>
>> In practice, it appears that once the expire time has passed, all
>> dirty pages get flushed, regardless of their age. This behavior
>> makes this setting fairly useless. This appears to have been the
>> behavior for most of 2.6 and 3.x. Can anyone explain, is the current
>> behavior really as intended, and is the doc just out of date?
>    What really happens is that all inodes which have been dirtied before
> 'expire time' are completely flushed.

Still it appears to be more than that. If I suspend the writer, I can see 
(using atop) that the flusher always keeps writing until the number of dirty 
pages is zero, and that happens in much shorter than the expire time. This is 
on an Ubuntu build 3.5.0-23-generic. Perhaps this behavior has also changed in 
more recent kernels? Another person has reported the same thing using 3.0

http://stackoverflow.com/questions/18353467/implementation-of-dirty-expire-centisecs

>> On a slightly related note, what was the key problem with this patch
>> "msync: support syncing a small part of the file"?
>> http://thread.gmane.org/gmane.linux.kernel/1313767/focus=1317498
>>
>> Andrew Morton's message states that Paolo's patch would break
>> nonlinear mappings, and the matter was dropped. Why wasn't it
>> possible to write a patch that would also work with nonlinear
>> mappings? I couldn't find any earlier context for that subject,
>> pointers welcome.
>    It is certainly possible. But actually I'm not 100% sure it is worth it.
> Because each fsync() call has a certain overhead in the filesystem and that
> is rather considerable - forcing a journal transaction to disk, flushing
> disk caches, ... So splitting one large fsync() into several smaller ones
> (even if they together write significantly less pages) is often slower.

OK... But does msync() have to do that? Is msync() closer to fsync() in 
behavior, or just fdatasync()? And also, if you're using something without 
journaling, like ext2, I would think it's a pure win.

>> My interest in both of these questions stems from what I've observed
>> while testing the LMDB memory-mapped database. On a machine with
>> 32GB RAM, using a database that occupies about 18GB of memory, doing
>> continuous writes to the DB without ever calling msync, and default
>> writeback settings, I see DB throughput spike downward every time
>> the flusher wakes up. The DB is a mmap'd file on an XFS partition,
>> and a DB write operation simply dirties a random set of pages. After
>> the program has been running for more than dirty_expire_centisecs,
>> every dirty_writeback_centisecs the DB app basically stops while the
>> flusher writes out all the dirty pages.
>    What kernel version are you using? What you describe sounds like the
> problems that happened due to 'stable pages under writeback' work. We
> didn't allow page to be redirtied while it was under writeback. In 3.10
> we fixed that so workloads that are redirtying pages should be improved.

Currently using 3.5 (as noted earlier in this reply). Out of curiosity, do you 
happen to know how long the pre-3.10 behavior has existed? Is it a 3.x change 
that wasn't present in 2.6?

>> I'm curious about a couple things - since the DB knows which pages
>> it is dirtying in a given transaction, would it help overall
>> throughput if the DB told the OS (via msync) exactly which ranges to
>> flush? Obviously not, in the current implementation of msync, but
>> can a patch like Paolo's make this better? And can the
>> dirty_expire_centisecs behavior be fixed, so that it's only writing
>> out a smaller set of pages on each wakeup? What else can we do to
>> minimize the impact of the flusher? If I turn it off completely the
>> throughput nearly doubles, from 5100 DB writes/sec to 9000/sec. If I
>> turn off the timed flush and just use dirty_background_bytes the
>> throughput just slows to around 7000/sec.
>    After 3.10 running flusher should have rather minimal impact on the
> parallel mmap workload. It still locks the page when submitting it for IO
> but when the underlying blocks are allocated (which is your case I believe)
> this interval when the page is locked is very short.

Sounds promising, will have to look into retesting with a 3.10 kernel.

>> It seems to me the main slowdown is because the OS is locking dirty
>> pages indiscriminately. The DB does copy-on-write, so pages that it
>> dirties in one transaction will not be written again in the next
>> transaction. I would have expected read-only accesses to these pages
>> to be able to progress without any delay but that doesn't seem to be
>> the case.
>    So I would be really surprised if read-only access to the pages blocked
> because you shouldn't really enter the kernel at all if those pages are
> already mapped and faulted in.

OK. Quite sure that all the pages are mapped and present. Perhaps it was all 
due to the writes. I'll know more when I've had a chance to test 3.10.

Thanks again for the info.
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
