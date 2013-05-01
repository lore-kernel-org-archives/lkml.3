Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab3EAEOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 00:14:16 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36683 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3EAEOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 00:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <87ppxd4ddm.fsf@devron.myhome.or.jp>
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
Date: Wed, 1 May 2013 13:14:10 +0900
Message-ID: <CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
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

2013/4/29, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
Hi OGAWA.
> I couldn't review fully though.
>
>> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
>> +	    filp->f_dentry->d_count == 1)
>> +		fat_truncate_blocks(inode, inode->i_size);
>
> Hm, why d_count == 1 check is needed? Feel strange and racy.
Since, fat_file_release() is called on every close for the file.
But we want to free up the reserved blocks only at the last reference
for the file exits.
So, we have used “d_count ==1” i.e., when there is only one reference
left for the file and it is being closed.
Then call the truncate blocks to free up the space.

>
>> +		/* Start the allocation.We are not zeroing out the clusters */
>> +		while (nr_cluster-- > 0) {
>> +			err = fat_alloc_clusters(inode, &cluster, 1);
>
> Why doesn't allocate clusters at once by fat_alloc_clusters()?
It is because of default design, where we cannot allocate all the
clusters at once. For reference if we try to allocate all clusters at
once, it will trigger a BUG_ON in
fat_alloc_clusters()->
BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2)); /* fixed limit */
And we needed to update the fat chain after each allocation and take
care of the failure cases as well. So, we have done that sequential.
That optimization of allocating all clusters at once can be considered
as a separate changeline.
>
>> +	size = i_size_read(inode);
>> +	mmu_private_actual = MSDOS_I(inode)->mmu_private;
>> +	mmu_private_ideal = round_up(size, sb->s_blocksize);
>> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
>> +		err = fat_zero_falloc_area(file, mapping, pos);
>> +		if (err) {
>> +			fat_msg(sb, KERN_ERR,
>> +				"Error (%d) zeroing fallocated area", err);
>> +			return err;
>> +		}
>> +	}
>
> This way probably inefficient. This would write data twice times (one is
> zeroed, one is actual data). So, cpu time would be twice higher if
> user uses fallocated, right?
We introduced the “zeroing out” after there was a comment regarding
the security loophole of accessing invalid data.
So, while doing fallocate we reserved the space. But, if there is a
request to access the pre-allocated space we zeroout the complete area
to avoid any security issue.

Let me know your opinion :)

Thanks.
>
> Difference of fallocated area would be whether get_block() set
> buffer_new() or not? If true, we should change get_block(), not
> write_begin()?
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
