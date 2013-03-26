Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab3CZUGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:06:32 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54002 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907Ab3CZUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:06:30 -0400
Message-ID: <5151FF82.6090405@gmail.com>
Date: Tue, 26 Mar 2013 21:05:22 +0100
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        Milan Broz <gmazyland@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: [dm-devel] dm-crypt performance
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com> <20130326122713.GC27610@agk-dp.fab.redhat.com>
In-Reply-To: <20130326122713.GC27610@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.3.2013 13:27, Alasdair G Kergon wrote:
> [Adding dm-crypt + linux-kernel]

Thanks.

>
> On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
>> I performed some dm-crypt performance tests as Mike suggested.
>>
>> It turns out that unbound workqueue performance has improved somewhere
>> between kernel 3.2 (when I made the dm-crypt patches) and 3.8, so the
>> patches for hand-built dispatch are no longer needed.
>>
>> For RAID-0 composed of two disks with total throughput 260MB/s, the
>> unbound workqueue performs as well as the hand-built dispatch (both
>> sustain the 260MB/s transfer rate).
>>
>> For ramdisk, unbound workqueue performs better than hand-built dispatch
>> (620MB/s vs 400MB/s). Unbound workqueue with the patch that Mike suggested
>> (git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git) improves
>> performance slighlty on ramdisk compared to 3.8 (700MB/s vs. 620MB/s).

I found that ramdisk tests are usualy quite misleading for dmcrypt.
Better use some fast SSD, ideally in RAID0 (so you get >500MB or so).
Also be sure you compare recent machines which uses AES-NI.
For reference, null cipher (no crypt, data copy only) works as well,
but this is not real-world scenario.

After introducing Andi's patches, we created performance regression
for people which created "RAID over several dmcrypt devices".
(All IOs were processed by one core.) Rerely use case but several people
complained.
But most of people reported that current approach works much better
(even with stupid dd test - I think it is because page cache sumbits
requests from different CPUs so it in fact run in parallel).

But using dd with direct-io is trivial way how to simulate the "problem".
(I guess we all like using dd for performance testing... :-])

>> However, there is still the problem with request ordering. Milan found out
>> that under some circumstances parallel dm-crypt has worse performance than
>> the previous dm-crypt code. I found out that this is not caused by
>> deficiencies in the code that distributes work to individual processors.
>> Performance drop is caused by the fact that distributing write bios to
>> multiple processors causes the encryption to finish out of order and the
>> I/O scheduler is unable to merge these out-of-order bios.

If the IO scheduler is unable to merge these request because of out of order
bios, please try to FIX IO scheduler and do not invent workarounds in dmcrypt.
(With recent accelerated crypto this should not happen so often btw.)

I know it is not easy but I really do not like that in "little-walled
device-mapper garden" is something what should be done on different
layer (again).

>> The deadline and noop schedulers perform better (only 50% slowdown
>> compared to old dm-crypt), CFQ performs very badly (8 times slowdown).
>>
>>
>> If I sort the requests in dm-crypt to come out in the same order as they
>> were received, there is no longer any slowdown, the new crypt performs as
>> well as the old crypt, but the last time I submitted the patches, people
>> objected to sorting requests in dm-crypt, saying that the I/O scheduler
>> should sort them. But it doesn't. This problem still persists in the
>> current kernels.

I have probable no vote here anymore but for the record: I am strictly
against any sorting of requests in dmcrypt. My reasons are:

- dmcrypt should be simple transparent layer (doing one thing - encryption),
sorting of requests was always primarily IO scheduler domain
(which has well-known knobs to control it already)

- Are we sure we are not inroducing some another side channel in disc
encryption? (Unprivileged user can measure timing here).
(Perhaps stupid reason but please do not prefer performance to security
in encryption. Enough we have timing attacks for AES implementations...)

- In my testing (several months ago) output was very unstable - in some
situations it helps, in some it was worse. I have no longer hard
data but some test output was sent to Alasdair.

>> For best performance we could use the unbound workqueue implementation
>> with request sorting, if people don't object to the request sorting being
>> done in dm-crypt.

So again:

- why IO scheduler is not working properly here? Do it need some extensions?
If fixed, it can help even is some other non-dmcrypt IO patterns.
(I mean dmcrypt can set some special parameter for underlying device queue
automagically to fine-tune sorting parameters.)

- can we have some cpu-bound workqueue which automatically switch to unbound
(relocates work to another cpu) if it detects some saturation watermark etc?
(Again, this can be used in other code.
http://www.redhat.com/archives/dm-devel/2012-August/msg00288.html
(Yes, I see skepticism there :-)

> On Tue, Mar 26, 2013 at 02:52:29AM -0400, Christoph Hellwig wrote:
>> FYI, XFS also does it's own request ordering for the metadata buffers,
>> because it knows the needed ordering and has a bigger view than than
>> than especially CFQ.  You at least have precedence in a widely used
>> subsystem for this code.

Nice. But XFS is much more complex system.
Isn't it enough that multipath uses own IO queue (so we have one IO scheduler
on top of another, and now we have metadata io sorting in XFS on top of it
and planning one more in dmcrypt? Is it really good approach?)

Milan
