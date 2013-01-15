Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3AOHcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:32:12 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38215 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3AOHcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <1358217615.8234.35.camel@kjgkr>
References: <1357969323-9396-1-git-send-email-linkinjeon@gmail.com>
	<1358128249.23942.6.camel@kjgkr>
	<CAKYAXd-f_rLJ5YdtsOX40XiGcNFivPTiXJ5kt03E-AOpuinMMQ@mail.gmail.com>
	<1358217615.8234.35.camel@kjgkr>
Date: Tue, 15 Jan 2013 16:32:06 +0900
Message-ID: <CAKYAXd_tnM1arONxpx0pvnftGHvdxwLWJSFXVfdzrAUJe5taWQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] f2fs: add blk plugging support in f2fs
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/15, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-01-14 (월), 20:10 +0900, Namjae Jeon:
>> 2013/1/14, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > 2013-01-12 (토), 14:42 +0900, Namjae Jeon:
>> >> From: Namjae Jeon <namjae.jeon@samsung.com>
>> >>
>> >> With f2fs having different writepages support for data, node and
>> >> metapages.
>> >> It will not be covered under the generic blk plug support.
>> >
>> > Could you show any improvement points with this patch?
>> >
>> > Currently, there is no reason to use blk plugging, since f2fs itself
>> > gathers bios and then submit one big bio.
>> >
>> > Thanks,
>> Hi Jaegeuk,
>>
>> There is no performance difference after introducing the block
>> plugging in F2FS.
>
> Well, this patch is not a bug fix, but an enhancement patch.
> Therefore we need to come up with how exactly the blk plugging support
> makes an effect on the performance.
>
>> We introduced this to reduced block lock contention for f2fs also.
>
>> For every BIO request queuing part to the request queue: it needs to
>> acquire lock->
>> spin_lock_irq(q->queue_lock);
>>
>> Even though the F2FS - already is handling the requests part very
>> well. But still we can make use of blk_plug to reduce the block lock
>> contention.
>>
>> When we introduce block plugging to F2FS part - all the requests will
>> first be maintained on TASK basis and then pushed to the request
>> queue. So, we do not have contention for the “queue lock”.
>>
>
> What I concern is how much block lock contention would be serious.
> Let's see the following operational differences.
>
> 1. Merging bios prior to grabing "queue lock"
>  The f2fs merges consecutive IOs in the file system level before
> submitting any bios, which is similar with the back merge by the
> plugging mechanism in attempt_plug_merge(). Both of them need to acquire
> no queue lock.
>
> 2. Merging policy with respect to tasks
>  The f2fs merges IOs as much as possible regardless of tasks, while
> blk-plugging is conducted on a basis of tasks. As we can understand
> there are trade-offs, f2fs tries to maximize the write performance with
> well-merged bios.
>
> As a result, if f2fs produces many consecutive but separated bios in
> writepages(), it would be good to use blk-plugging. Since as you said,
> f2fs would be able to avoid queue lock contention in the block layer by
> merging them.
> But, f2fs merges IOs and submit one bio, which means that there are not
> much chances to merge bios by attempt_plug_merge().
>
> How do you think?
Hi Jaegeuk.

Yes, You're right. I agree block plug is not needed in f2fs. So plz
ignore this patch.
note => Regardless of the intent in the patch, it has already been
used in writepages (f2fs uses generic_writepages).
So to make the overall code consistent, either we should remove blk
plug from entire F2FS write part or change f2fs_write_data_pages to
include blk plug properly - like the code change for this part we
share in the patch.

Let me know your opinion.

Thanks.

>
> Thanks,
>
> --
> Jaegeuk Kim
> Samsung
>
