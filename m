Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3KEAuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:50:19 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60881 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3KEAuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:50:17 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
Date: Mon, 4 Nov 2013 17:50:13 -0700
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-mm <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <89AE8FE8-5B15-41DB-B9CE-DFF73531D821@dilger.ca>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07> <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
X-Mailer: Apple Mail (2.1816)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2013, at 2:18 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, Oct 25, 2013 at 8:25 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>> 
>> On my x86-64 PC (Intel Core i5 2500, 16GB RAM), I have the same 3.11
>> kernel built for the i686 (with PAE) and x86-64 architectures. What’s
>> really troubling me is that the x86-64 kernel has the following problem:
>> 
>> When I copy large files to any storage device, be it my HDD with ext4
>> partitions or flash drive with FAT32 partitions, the kernel first
>> caches them in memory entirely then flushes them some time later
>> (quite unpredictably though) or immediately upon invoking "sync".
> 
> Yeah, I think we default to a 10% "dirty background memory" (and
> allows up to 20% dirty), so on your 16GB machine, we allow up to 1.6GB
> of dirty memory for writeout before we even start writing, and twice
> that before we start *waiting* for it.
> 
> On 32-bit x86, we only count the memory in the low 1GB (really
> actually up to about 890MB), so "10% dirty" really means just about
> 90MB of buffering (and a "hard limit" of ~180MB of dirty).
> 
> And that "up to 3.2GB of dirty memory" is just crazy. Our defaults
> come from the old days of less memory (and perhaps servers that don't
> much care), and the fact that x86-32 ends up having much lower limits
> even if you end up having more memory.

I think the “delay writes for a long time” is a holdover from the
days when e.g. /tmp was on a disk and compilers had lousy IO
patterns, then they deleted the file.  Today, /tmp is always in
RAM, and IMHO the “write and delete” workload tested by dbench
is not worthwhile optimizing for.

With Lustre, we’ve long taken the approach that if there is enough
dirty data on a file to make a decent write (which is around 8MB
today even for very fast storage) then there isn’t much point to
hold back for more data before starting the IO.

Any decent allocator will be able to grow allocated extents to
handle following data, or allocate a new extent.  At 4-8MB extents,
even very seek-impaired media could do 400-800MB/s (likely much
faster than the underlying storage anyway).

This also avoids wasting (tens of?) seconds of idle disk bandwidth.
If the disk is already busy, then the IO will be delayed anyway.
If it is not busy, then why aggregate GB of dirty data in memory
before flushing it?

Something simple like “start writing at 16MB dirty on a single file”
would probably avoid a lot of complexity at little real-world cost.
That shouldn’t throttle dirtying memory above 16MB, but just start
writeout much earlier than it does today.

Cheers, Andreas





