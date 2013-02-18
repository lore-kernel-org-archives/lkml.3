Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3BRLGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:06:40 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37703 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3BRLGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:06:38 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6 4/7] fat: restructure export_operations
References: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 18 Feb 2013 20:06:31 +0900
In-Reply-To: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 10 Feb 2013 00:02:25 +0900")
Message-ID: <87fw0t3mq0.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +	if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
> +		if (inode->i_ino == MSDOS_ROOT_INO)
> +			stat->ino = MSDOS_ROOT_INO;

Can we simply set i_pos = MSDOS_ROOT_INO in fat_read_root()? If so, I
think we can avoid this check.

> +		else
> +			/* Use i_pos for ino. This is used as fileid of nfs. */
> +			stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb),
> +						   inode);
> +	}
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(fat_getattr);


> +struct fat_fid {
> +	u32 i_gen;
> +	u32 i_pos_low;
> +	u16 i_pos_hi;
> +	u16 parent_i_pos_hi;
> +	u32 parent_i_pos_low;
> +	u32 parent_i_gen;
> +} __packed;

Do we need to use __packed? Unnecessary __packed can generate slower
code for alignment check on arch has unaligned fault.

> +	if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
> +		*lenp = FAT_FID_SIZE_WITH_PARENT;
> +		return 255;
> +	} else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
> +		*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
> +		return 255;
> +	}

This check strange. "parent && len == FAT_FID_SIZE_WITHOUT_PARENT" will
overwrite over limit of fh size?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
