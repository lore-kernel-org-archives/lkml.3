Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3CLJio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:38:44 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:45012 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3CLJim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <87ip4xyoin.fsf@devron.myhome.or.jp>
References: <1362664617-3825-1-git-send-email-linkinjeon@gmail.com>
	<87sj44ac82.fsf@devron.myhome.or.jp>
	<CAKYAXd_E8ZzutRVX6bCpzuosVLqsCDk0VzPYeXtcG8K+4wwBvQ@mail.gmail.com>
	<87620y2d68.fsf@devron.myhome.or.jp>
	<CAKYAXd_rettrtbYJoF4feBYTCWYOYGg_x1XbnNLyAZJBo7xa-Q@mail.gmail.com>
	<87ip4xyoin.fsf@devron.myhome.or.jp>
Date: Tue, 12 Mar 2013 18:38:42 +0900
Message-ID: <CAKYAXd94uLjWT-BWM8c=qtQtOHpp+6BpLNFPAPvV3hqijvfqHQ@mail.gmail.com>
Subject: Re: [PATCH v3] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, abartlet@samba.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/12, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> If so, probably, I didn't clear my opinion/suggestion, or misled
>>> you. Sorry about it.
>>>
>>> My opinion/suggestion is, "it should be before umount()".
>>> I.e. fallocate() doesn't have any affect to FAT on clean state (clean
>>> umount).
>>>
>>> To clear my state, I don't have strong opinion about implementation yet.
>>> For example, about ->release() or ->evict_inode().
>>>
>>> So, if you had reason to use ->release() over "we discussed", it would
>>> be good. (Or, if you still didn't have reasons, we would be better to
>>> think about it)
>> We considered all the possible points where we can release the
>> pre-allocated blocks.
>> As the "pre-allocation" is file based, we think it need to have
>> release mechanism.
>>
>> In case of evict, Eviction will either happen when the file is removed
>> or the inode is evicted from the cache by memory pressure when no
>> references are present for that file.
>> It is good that evict will be triggered in umount. but there is a risk
>> that umount time can be increased.
>> And It show users inconsistent result. e.g sometime user can not get
>> file discarded fallocated blocks by memory pressure.
>>
>> Let me know your opinion.
>
> Yes. My personal opinion is almost same, but I see some trade-off, and
> it is why I can't decide easily.
>
> Although I don't care about inconsistency on umount time. Because
> inconsistency window is opening while user is holding reference to
> inode, the window can already be enough big, and inconsistent only
> happens with crash.  And if crashed, after all, both of ->release and
> ->evict requires fsck to recover FS.
>
> Possibly longer umount time (batch modify) and longer close time (on
> demand modify) are simply trade-off.
>
> Predictable behavior would matter. Yes, evict time doesn't guarantee to
> fallocate() is still available, however evict can be able to say it just
> guarantees to available fallocated blocks between open() and
> close(). Users have to call fallocate() again after close(), but
> fallocate() may skip actual allocation if blocks still available.
>
> I see optimization window with this evict behavior, because it can do
> batch discard of fallocated blocks on multiple files, and update FAT at
> once.
>
> However, ->release() would be simpler, and would more predictable.
Yes, agreed so let’s prepare the solution with freeing blocks part of ->release.
This will also make solution align with the concept of normal default
reserved block allocation like ext2/XFS in which it allocates extra
blocks at initial write request and extra blocks are freed in
->release.
Once I will share the patch with all the review comments.

Thanks OGAWA :)
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
