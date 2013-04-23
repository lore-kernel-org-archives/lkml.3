Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3DWFeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:34:02 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49600 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3DWFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:33:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130422150302.d01a3edb005a79bd68929d38@linux-foundation.org>
References: <1366293255-4649-1-git-send-email-linkinjeon@gmail.com>
	<20130422150302.d01a3edb005a79bd68929d38@linux-foundation.org>
Date: Tue, 23 Apr 2013 14:33:59 +0900
Message-ID: <CAKYAXd8PwvExNJ9VruuuTp15PLijzWfZAjC85L6_9GsdMB+TfA@mail.gmail.com>
Subject: Re: [PATCH v5] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hirofumi@mail.parknet.co.jp, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/23, Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 18 Apr 2013 22:54:15 +0900 Namjae Jeon <linkinjeon@gmail.com>
> wrote:
>
>> Change Log:
>> v5: change to avoid compilation warning:
>>   fs/fat/inode.c: In function 'fat_zero_falloc_area':
>> >> fs/fat/inode.c:169:11: warning: comparison of distinct pointer
>> types lacks a cast [enabled by default]
>
> The patch does more than that - here's the v4->v5 delta:
>
> --- a/fs/fat/file.c~fat-additions-to-support-fat_fallocate-v5
> +++ a/fs/fat/file.c
> @@ -153,7 +153,6 @@ static int fat_file_release(struct inode
>  	 */
>  	mutex_lock(&inode->i_mutex);
>  	mmu_private_ideal = round_up(inode->i_size, sb->s_blocksize);
> -
>  	if (mmu_private_ideal < MSDOS_I(inode)->mmu_private &&
>  	    filp->f_dentry->d_count == 1)
>  		fat_truncate_blocks(inode, inode->i_size);
> @@ -231,7 +230,6 @@ static int fat_cont_expand(struct inode
>  out:
>  	return err;
>  }
> -
>  /*
>   * Preallocate space for a file. This implements fat's fallocate file
>   * operation, which gets called from sys_fallocate system call. User
> @@ -281,10 +279,8 @@ static long fat_fallocate(struct file *f
>  						      sbi->cluster_bits;
>  		} else
>  			nr_bytes = offset + len - inode->i_size;
> -
>  		nr_cluster = (nr_bytes + (sbi->cluster_size - 1)) >>
>  			     sbi->cluster_bits;
> -
>  		/* Start the allocation.We are not zeroing out the clusters */
>  		while (nr_cluster-- > 0) {
>  			err = fat_alloc_clusters(inode, &cluster, 1);
> @@ -308,12 +304,10 @@ static long fat_fallocate(struct file *f
>  				"fat_fallocate(): fat_cont_expand() error");
>  		}
>  	}
> -
>  error:
>  	mutex_unlock(&inode->i_mutex);
>  	return err;
>  }
> -
>  /* Free all clusters after the skip'th cluster. */
>  static int fat_free(struct inode *inode, int skip)
>  {
> --- a/fs/fat/inode.c~fat-additions-to-support-fat_fallocate-v5
> +++ a/fs/fat/inode.c
> @@ -166,7 +166,7 @@ static int fat_zero_falloc_area(struct f
>
>  		offset = (curpos & (PAGE_CACHE_SIZE - 1));
>  		bytes = PAGE_CACHE_SIZE - offset;
> -		bytes = min(bytes, count);
> +		bytes = min_t(size_t, bytes, count);
>
>  		err = pagecache_write_begin(NULL, mapping, curpos, bytes,
>  					AOP_FLAG_UNINTERRUPTIBLE,
>
> The whitespace changes are mostly dubious and the ones which remove the
> newline after a function's final brace are simply wrong.  The min_t
> change is unneeded - it's better to make the type of `bytes' size_t.
> So I shall skip v5.
>
> BTW, I don't intend to send this patch into Linus until I have
> heard from hirofumi.  Please let me know if he has already reviewed
> and acked it?
Thanks Andrew for updating.
We do not have ACK mail from OGAWA yet, even though he reviewed but
final ACK is pending.
And we will send updated one v5 patch with your change soon.
>
