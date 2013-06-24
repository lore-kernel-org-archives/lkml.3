Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3FXGsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 02:48:16 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40962 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3FXGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 02:48:15 -0400
MIME-Version: 1.0
In-Reply-To: <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
	<03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
Date: Mon, 24 Jun 2013 15:48:14 +0900
Message-ID: <CAKYAXd-QqhuDKAm8zFTtmiovWEax-OoyEixuQKSWxF2zQVXFSQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
From: Namjae Jeon <linkinjeon@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "a.sangwan@samsung.com" <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/24, Andreas Dilger <adilger@dilger.ca>:
> On 2013-06-23, at 0:07, Namjae Jeon <linkinjeon@gmail.com> wrote:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch series introduces 2 new ioctls for ext4.
>>
>> Truncate_block_range ioctl truncates blocks from source file.
>
Hi. Andreas.
> How is this different from fallocate(FALLOC_FL_PUNCH_HOLE)?  That is already
> in existing kernels, and portable across multiple filesystems.
Dave chinner already answered it.

>
>> Transfer_block_range ioctl transfers data blocks from source file
>> and append them at the end of destination file.
>
> There is already a similar ioctl for defragmenting files. Is it possible to
> use that, or does it have different semantics?

For defrag ioctl:
struct move_extent {
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};

For this ioctl to work, there are some pre conditions:
1) Contiguous blocks for donor_fd are allocated in user space using fallocate.
2) orig_start and donor_start should be same.

The fundamental difference between these 2 ioctls is that in defrag
ioctl data is copied, (page by page?) from the extents of source file
to the newly allocated extents of donor file. However, in transfer
block range ioctl the extents are transfered from the source file and
appended at the end of donor file. There is only metadata movement.

Thanks.
>
>> Ioctl1:        EXT4_IOC_TRUNCATE_BLOCK_RANGE:
>> This ioctl truncates a range of data blocks from file.
>> It is useful to remove easily and quickly the garbage data
>> at the middle of file.
>>
>> e.g. we have a movie file and there is long advertisement in movie file.
>> user want to remove only advertisement range.
>
> While this works in theory, there is very little chance that the movie data
> will align exactly to filesystem block boundaries.
>
> Cheers, Andreas
>
>> 1) Movie file (8GB), There is the adverisement of 500MB size.
>> ____________________________________________________________________
