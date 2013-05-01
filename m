Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3EAGmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:42:17 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:46243 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3EAGmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:42:10 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
Date: Wed, 01 May 2013 15:42:06 +0900
In-Reply-To: <CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 1 May 2013 13:14:10 +0900")
Message-ID: <87bo8v42wx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Hi OGAWA.

Hi,

>> I couldn't review fully though.
>>
>>> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
>>> +	    filp->f_dentry->d_count == 1)
>>> +		fat_truncate_blocks(inode, inode->i_size);
>>
>> Hm, why d_count == 1 check is needed? Feel strange and racy.
> Since, fat_file_release() is called on every close for the file.

What is wrong? IIRC, it is what you choose (i.e. for each last close for
the file descriptor).

> But we want to free up the reserved blocks only at the last reference
> for the file exits.
> So, we have used “d_count ==1” i.e., when there is only one reference
> left for the file and it is being closed.
> Then call the truncate blocks to free up the space.

It probably doesn't work. E.g. if unlink(2) is grabbing refcount, then
close(2) may not be last referencer, right?

So, then, nobody truncates anymore.

>>> +		/* Start the allocation.We are not zeroing out the clusters */
>>> +		while (nr_cluster-- > 0) {
>>> +			err = fat_alloc_clusters(inode, &cluster, 1);
>>
>> Why doesn't allocate clusters at once by fat_alloc_clusters()?
> It is because of default design, where we cannot allocate all the
> clusters at once. For reference if we try to allocate all clusters at
> once, it will trigger a BUG_ON in
> fat_alloc_clusters()->
> BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2)); /* fixed limit */
> And we needed to update the fat chain after each allocation and take
> care of the failure cases as well. So, we have done that sequential.
> That optimization of allocating all clusters at once can be considered
> as a separate changeline.

OK.

>>> +	size = i_size_read(inode);
>>> +	mmu_private_actual = MSDOS_I(inode)->mmu_private;
>>> +	mmu_private_ideal = round_up(size, sb->s_blocksize);
>>> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
>>> +		err = fat_zero_falloc_area(file, mapping, pos);
>>> +		if (err) {
>>> +			fat_msg(sb, KERN_ERR,
>>> +				"Error (%d) zeroing fallocated area", err);
>>> +			return err;
>>> +		}
>>> +	}
>>
>> This way probably inefficient. This would write data twice times (one is
>> zeroed, one is actual data). So, cpu time would be twice higher if
>> user uses fallocated, right?
> We introduced the “zeroing out” after there was a comment regarding
> the security loophole of accessing invalid data.
> So, while doing fallocate we reserved the space. But, if there is a
> request to access the pre-allocated space we zeroout the complete area
> to avoid any security issue.

I know. Question is, why do we need to initialize twice.

1) zeroed for uninitialized area, 2) then copy user data area. We need
only either, right? This seems to be doing both for all fallocated area.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
