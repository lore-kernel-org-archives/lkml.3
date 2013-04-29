Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3D2Obk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:31:40 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:45588 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3D2Obj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:31:39 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 29 Apr 2013 23:31:33 +0900
In-Reply-To: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 28 Apr 2013 09:08:23 +0900")
Message-ID: <87ppxd4ddm.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

I couldn't review fully though.

> +	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
> +	    filp->f_dentry->d_count == 1)
> +		fat_truncate_blocks(inode, inode->i_size);

Hm, why d_count == 1 check is needed? Feel strange and racy.

> +		/* Start the allocation.We are not zeroing out the clusters */
> +		while (nr_cluster-- > 0) {
> +			err = fat_alloc_clusters(inode, &cluster, 1);

Why doesn't allocate clusters at once by fat_alloc_clusters()?

> +	size = i_size_read(inode);
> +	mmu_private_actual = MSDOS_I(inode)->mmu_private;
> +	mmu_private_ideal = round_up(size, sb->s_blocksize);
> +	if ((mmu_private_actual > mmu_private_ideal) && (pos > size)) {
> +		err = fat_zero_falloc_area(file, mapping, pos);
> +		if (err) {
> +			fat_msg(sb, KERN_ERR,
> +				"Error (%d) zeroing fallocated area", err);
> +			return err;
> +		}
> +	}

This way probably inefficient. This would write data twice times (one is
zeroed, one is actual data). So, cpu time would be twice higher if
user uses fallocated, right?

Difference of fallocated area would be whether get_block() set
buffer_new() or not? If true, we should change get_block(), not
write_begin()?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
