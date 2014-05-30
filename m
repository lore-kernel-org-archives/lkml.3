Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaE3KzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaE3KzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:55:00 -0400
Date: Fri, 30 May 2014 12:54:48 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Namjae Jeon <namjae.jeon@samsung.com>
cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for
 fallocate
In-Reply-To: <003601cf6aa7$883103b0$98930b10$@samsung.com>
Message-ID: <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Namjae Jeon wrote:

> Date: Thu, 08 May 2014 19:23:19 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
>     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
> 
> In continuation of the work of making the process of non linear editing of
> media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> for fallocate.
> 
> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> in between the file within the range specified by offset and len. User can
> write new data in this space. e.g. ads.
> Like collapse range, currently we have the limitation that offset and len should
> be block size aligned for both XFS and Ext4.
> 
> The semantics of the flag are :
> 1) It allocates new zeroed out on disk space of len bytes starting
>    at offset byte without overwriting any existing data. All the data blocks
>    from offset to EOF are shifted towards right to make space for inserting
>    new blocks

Hi,

this sounds a little bit weird to me. I understand the reason for
this, but this is effectively two operations masking as one. We
shift the existing data and then we allocate unwritten extents for
the hole we've created.

What would make more sense to me is to implement only the first
operation - the shift. And then let the user to allocate unwritten
extents for the hole using simple fallocate.

The reason is that if you succeed the first part and then fail the
second due to ENOSPC or any other reason the file will end up in
undefined state unnecessarily. Yes in your current implementation
it seems that you'll always end up with the hole in the file and the
rest is properly shifted, but that may vary from file system to file
system. Some might choose to roll back the shift, some might not.

If FALLOC_FL_INSERT_RANGE (or any name you wish to choose) would
just simply shift the extents then you'll get rid of this and the
only thing that user needs to do (if he chooses to) is to use
fallocate for the hole created by the shift. If it fails, then
well, he can try again without any consequences. As a bonus you get
the possibility to leave the hole in the file which might be useful
as well.

With current behaviour this might get very confusing very quickly.

What do you and others think ?

Thanks!
-LUkas


> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Insert range does not work for the case when offset is overlapping/beyond
>    i_size. If the user wants to allocate space at the end of file they are
>    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> 5) It increses the size of file by len bytes.
> 
> 
> Namjae Jeon (10):
>  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  xfsprogs: xfs_io: add finsert command for insert range via fallocate
>  xfstests: generic/027: Standard insert range tests
>  xfstests: generic/028: Delayed allocation insert range
>  xfstests: generic/029: Multi insert range tests
>  xfstests: generic/030: Delayed allocation multi insert
>  xfstests: fsstress: Add fallocate insert range operation
>  xfstests: fsx: Add fallocate insert range operation
> 
> 
