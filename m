Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaCROzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:55:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58214 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaCROzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:55:42 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v4 2/6] fat: add fat_fallocate operation
References: <1393769338-3506-1-git-send-email-linkinjeon@gmail.com>
Date: Tue, 18 Mar 2014 23:55:39 +0900
In-Reply-To: <1393769338-3506-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 2 Mar 2014 23:08:57 +0900")
Message-ID: <87eh1z4kus.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +	if (mode & FALLOC_FL_KEEP_SIZE) {
> +		/* First compute the number of clusters to be allocated */
> +		mm_bytes = offset + len - round_up(MSDOS_I(inode)->i_disksize,
> +			sbi->cluster_size);
> +		nr_cluster = (mm_bytes + (sbi->cluster_size - 1)) >>
> +			sbi->cluster_bits;
> +
> +		/* Start the allocation.We are not zeroing out the clusters */
> +		while (nr_cluster-- > 0) {
> +			err = fat_alloc_clusters(inode, &cluster, 1);
> +			if (err) {
> +				fat_msg(sb, KERN_ERR,
> +					"fat_fallocate(): fat_alloc_clusters() error");
> +				goto error;
> +			}
> +			err = fat_chain_add(inode, cluster, 1);
> +			if (err) {
> +				fat_free_clusters(inode, cluster);
> +				goto error;
> +			}
> +			MSDOS_I(inode)->i_disksize += sbi->cluster_size;
> +		}

Hm. This ->i_disksize calculation is right? Why do we use cluster align
here? My concern is, say blocksize == 512 and clustersize == 4096,

        0      512               5120
        |       |                  |
        +-------+-----------+------+
                           4096

Before fallocate(), ->i_disksize == 512. Then user called fallocate()
with offset == 512 and len == 4608.

After that, this sets ->i_disksize += 4096, == 4608?  I think, we should
set ->i_disksize == 5120, finally. I can be missing something though.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
