Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaBCEqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 23:46:35 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:50038 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaBCEqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 23:46:34 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/6] fat: add fat_fallocate operation
References: <1387953065-2726-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 03 Feb 2014 13:14:16 +0900
In-Reply-To: <1387953065-2726-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 25 Dec 2013 15:31:05 +0900")
Message-ID: <87mwi8x27b.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for long delay.

Namjae Jeon <linkinjeon@gmail.com> writes:

> +	if (mode & FALLOC_FL_KEEP_SIZE) {
> +		/* First compute the number of clusters to be allocated */
> +		mm_bytes = offset + len - round_up(MSDOS_I(inode)->mmu_private,
> +			sbi->cluster_size);

This should use ->i_disksize?

[...]

> +		/* Release unwritten fallocated blocks on inode eviction. */
> +		if (MSDOS_I(inode)->mmu_private < MSDOS_I(inode)->i_disksize) {
> +			int err;
> +			fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
> +			/* Fallocate results in updating the i_start/iogstart
> +			 * for the zero byte file. So, make it return to
> +			 * original state during evict and commit it
> +			 * synchrnously to avoid any corruption on the next
> +			 * access to the cluster chain for the file.
> +			 */
> +			err = fat_sync_inode(inode);

Ah, good catch. We have to update i_size. I was forgetting about this.
Well, sync inode unconditionally would not be good. Maybe, we better to
use __fat_write_inode() with inode_needs_sync() or such.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
