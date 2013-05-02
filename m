Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3EBEqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 00:46:03 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46349 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3EBEqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 00:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <87bo8v42wx.fsf@devron.myhome.or.jp>
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
Date: Thu, 2 May 2013 13:46:00 +0900
Message-ID: <CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> Hi OGAWA.
>
> Hi,
>
>>> I couldn't review fully though.
>>>
>>>> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
>>>> +	    filp->f_dentry->d_count == 1)
>>>> +		fat_truncate_blocks(inode, inode->i_size);
>>>
>>> Hm, why d_count == 1 check is needed? Feel strange and racy.
>> Since, fat_file_release() is called on every close for the file.
>
> What is wrong? IIRC, it is what you choose (i.e. for each last close for
> the file descriptor).
Yes, this is what we had chosen after discussion. Freeing reserved
space point being the file release path.
But if there are multiple accessors for the file then file_release
will be called by each process.
Freeing the space in first call will result in wrong file attributes
for the other points. So, we needed a differentiation of last close
for the file.
Am I missing something ?

>
>> But we want to free up the reserved blocks only at the last reference
>> for the file exits.
>> So, we have used “d_count ==1” i.e., when there is only one reference
>> left for the file and it is being closed.
>> Then call the truncate blocks to free up the space.
>
> It probably doesn't work. E.g. if unlink(2) is grabbing refcount, then
> close(2) may not be last referencer, right?
Yes, Right. I will check :)

>
> So, then, nobody truncates anymore.
>
>>>> +		/* Start the allocation.We are not zeroing out the clusters */
>>>> +		while (nr_cluster-- > 0) {
>>>> +			err = fat_alloc_clusters(inode, &cluster, 1);
>>>
>>> Why doesn't allocate clusters at once by fat_alloc_clusters()?
>> It is because of default design, where we cannot allocate all the
>> clusters at once. For reference if we try to allocate all clusters at
>> once, it will trigger a BUG_ON in
>> fat_alloc_clusters()->
>> BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2)); /* fixed limit */
>> And we needed to update the fat chain after each allocation and take
>> care of the failure cases as well. So, we have done that sequential.
>> That optimization of allocating all clusters at once can be considered
>> as a separate changeline.
>
> OK.
>
>>>> +	size = i_size_read(inode);
>>>> +	mmu_private_actual = MSDOS_I(inode)->mmu_private;
>>>> +	mmu_private_ideal = round_up(size, sb->s_blocksize);
>>>> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
>>>> +		err = fat_zero_falloc_area(file, mapping, pos);
>>>> +		if (err) {
>>>> +			fat_msg(sb, KERN_ERR,
>>>> +				"Error (%d) zeroing fallocated area", err);
>>>> +			return err;
>>>> +		}
>>>> +	}
>>>
>>> This way probably inefficient. This would write data twice times (one is
>>> zeroed, one is actual data). So, cpu time would be twice higher if
>>> user uses fallocated, right?
>> We introduced the “zeroing out” after there was a comment regarding
>> the security loophole of accessing invalid data.
>> So, while doing fallocate we reserved the space. But, if there is a
>> request to access the pre-allocated space we zeroout the complete area
>> to avoid any security issue.
>
> I know. Question is, why do we need to initialize twice.
>
> 1) zeroed for uninitialized area, 2) then copy user data area. We need
> only either, right? This seems to be doing both for all fallocated area.
We did not initialize twice. We are using the ‘pos’ as the attribute
to define zeroing length in case of pre-allocation.
Zeroing out occurs till the ‘pos’ while actual write occur after ‘pos’.
If we file size is 100KB and we pre-allocated till 1MB. Next if we try
to write at 500KB,
Then zeroing out will occur only for 100KB->500KB, after that there
will be normal write. There is no duplication for the same space.

Let me know your opinion.

Thanks~
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
