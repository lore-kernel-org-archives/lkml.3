Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaDOBeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:34:21 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39379 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDOBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:34:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Conrad Meyer <cse.cem@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] fs: FAT: Add support for DOS 1.x formatted volumes
References: <1397435124-31482-1-git-send-email-cse.cem@gmail.com>
Date: Tue, 15 Apr 2014 10:34:08 +0900
In-Reply-To: <1397435124-31482-1-git-send-email-cse.cem@gmail.com> (Conrad
	Meyer's message of "Sun, 13 Apr 2014 17:25:24 -0700")
Message-ID: <87r44zv0j3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conrad Meyer <cse.cem@gmail.com> writes:

> Add structure for parsed BPB information, struct fat_bios_param_block,
> and move all of the deserialization and validation logic from
> fat_fill_super() into fat_read_bpb().
>
> Add a 'dos1xfloppy' mount option to infer DOS 2.x BIOS Parameter Block
> defaults from block device geometry for ancient floppies and floppy
> images, as a fall-back from the default BPB parsing logic.
>
> When fat_read_bpb() finds an invalid FAT filesystem and dos1xfloppy is
> set, fall back to fat_read_static_bpb(). fat_read_static_bpb() validates
> that the entire BPB is zero, and that the floppy has a DOS-style 8086
> code bootstrapping header. Then it fills in default BPB values from
> media size and a table.[0]
>
> Media size is assumed to be static for archaic FAT volumes. See also:
> [1].
>
> Fixes kernel.org bug #42617.
>
> [0]: https://en.wikipedia.org/wiki/File_Allocation_Table#Exceptions
> [1]: http://www.win.tue.nl/~aeb/linux/fs/fat/fat-1.html
>
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
> ---
> Changes since v5:
>   * Leave the bulk of sbi-> filling logic to the aptly named fat_fill_super()
>   * Create separate structure for deserialized BPB values
>   * fat_read_bpb() deserializes BPB from raw fat_boot_sector and performs
>     validations
>   * fat_read_static_bpb() validates raw fat_boot_sector as dos1x and fills in
>     BPB values from table
>
> Thanks,
> Conrad
> ---
>  fs/fat/fat.h   |  28 ++++-
>  fs/fat/inode.c | 316 +++++++++++++++++++++++++++++++++++++++++++--------------
>  2 files changed, 267 insertions(+), 77 deletions(-)
>
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 7270bdb..bcb0d67 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -52,7 +52,8 @@ struct fat_mount_options {
>  		 usefree:1,	   /* Use free_clusters for FAT32 */
>  		 tz_set:1,	   /* Filesystem timestamps' offset set */
>  		 rodir:1,	   /* allow ATTR_RO for directory */
> -		 discard:1;	   /* Issue discard requests on deletions */
> +		 discard:1,	   /* Issue discard requests on deletions */
> +		 dos1xfloppy:1;	   /* Assume default BPB for DOS 1.x floppies */
>  };

OK. Looks good basically.

Another one I am also forgetting. Need to update show_options() and
Documents/fs/vfat.txt for new option.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
