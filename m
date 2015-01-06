Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbbAFNSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:18:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbAFNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:18:47 -0500
MIME-Version: 1.0
In-Reply-To: <54AAE4FD.1070609@parallels.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<CA+icZUV17qR-kBRnYa+r0DfchQ0QtaBy-6c3f3QuXn0EGwuJzQ@mail.gmail.com>
	<54A4703B.2000006@oracle.com>
	<CA+icZUXarbLJt5yL_JJHntDFRkBZyvNMHxUGcOLNjULUQ8FhHw@mail.gmail.com>
	<CACVXFVP+30g1k8nf3FR1ZFg=CBay_yg=guZfoM+DFdco64AhyQ@mail.gmail.com>
	<54AAE4FD.1070609@parallels.com>
Date: Tue, 6 Jan 2015 21:18:44 +0800
Message-ID: <CACVXFVODrkCVqLd4hLyY7YP6FwgbYF+6vO9fPytJ=3xOHB=39A@mail.gmail.com>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
From: Ming Lei <ming.lei@canonical.com>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: sedat.dilek@gmail.com, Dave Kleikamp <dave.kleikamp@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@zabbo.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/15, Maxim Patlasov <mpatlasov@parallels.com> wrote:
> On 12/31/2014 04:52 PM, Ming Lei wrote:
>> On Thu, Jan 1, 2015 at 6:35 AM, Sedat Dilek <sedat.dilek@gmail.com>
>> wrote:
>>> On Wed, Dec 31, 2014 at 10:52 PM, Dave Kleikamp
>>> <dave.kleikamp@oracle.com> wrote:
>>>> On 12/31/2014 02:38 PM, Sedat Dilek wrote:
>>>>> What has happened to that aio_loop patchset?
>>>>> Is it in Linux-next?
>>>>> ( /me started to play with "block: loop: convert to blk-mq (v3)", so I
>>>>> recalled this other improvement. )
>>>> It met with some harsh resistance, so I backed off on it. Then Al Viro
>>>> got busy re-writing the iov_iter infrastructure and I put my patchset
>>>> on
>>>> the shelf to look at later. Then Ming Lei submitted more up-to-date
>>>> patchset: https://lkml.org/lkml/2014/8/6/175
>>>>
>>>> It looks like Ming is currently only pushing the first half of that
>>>> patchset. I don't know what his plans are for the last three patches:
>>>>
>>>> aio: add aio_kernel_() interface
>>>> fd/direct-io: introduce should_dirty for kernel aio
>>>> block: loop: support to submit I/O via kernel aio based
>>>>
>>> I tested with block-mq-v3 (for next-20141231) [1] and this looks
>>> promising [2].
>>>
>>> Maybe Ming can say what the plan is with the missing parts.
>> I have compared kernel aio based loop-mq(the other 3 aio patches
>> against loop-mq v2, [1]) with loop-mq v3, looks the data isn't
>> better than loop-mq v3.
>>
>> kernel aio based approach requires direct I/O, at least direct write
>> shouldn't be good as page cache write, IMO.
>>
>> So I think we need to investigate kernel aio based approach further
>> wrt. loop improvement.
>
> A great advantage of kernel aio for loop device is the avoidance of
> double caching: the data from page cache of inner filesystem (mounted on
> the loop device) won't be cached again in the page cache of the outer
> filesystem (one that keeps image file of the loop device).

Yes, I agree avoidance of double cache is very good, at least
page consumption can be decreased, avoid one copy and make the backed
file more like a 'block' device.

>
> So I don't think it's correct to compare the performance of aio based
> loop-mq with loop-mq v3. Aio based approach is OK as long as it doesn't
> introduce significant overhead as compared with submitting bio-s
> straightforwardly from loop device (or any other in-kernel user of
> kernel aio) to host block device.

One problem is that aio based approach requires O_DIRECT, and direct
write looks much slower compared with page cache write in my fio
test over loop block directly.

But it might not be so bad when write I/O is considered from
filesystem over loop block since there is still page cache and the
write I/O is often big chunk from file system. I will run tests inside
filesystem to compare the two approaches further.


Thanks,
Ming Lei
