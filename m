Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaBCXEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:04:53 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:57266 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:04:52 -0500
MIME-Version: 1.0
In-Reply-To: <87mwi8x27b.fsf@devron.myhome.or.jp>
References: <1387953065-2726-1-git-send-email-linkinjeon@gmail.com>
	<87mwi8x27b.fsf@devron.myhome.or.jp>
Date: Tue, 4 Feb 2014 08:04:50 +0900
Message-ID: <CAKYAXd_EYrfF0iQVw5FJRHkGCeMTUoQdx+BogV+-g9vqXeGZdw@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] fat: add fat_fallocate operation
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-03, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>
> Sorry for long delay.
>
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +	if (mode & FALLOC_FL_KEEP_SIZE) {
>> +		/* First compute the number of clusters to be allocated */
>> +		mm_bytes = offset + len - round_up(MSDOS_I(inode)->mmu_private,
>> +			sbi->cluster_size);
>
Hi OGAWA.
> This should use ->i_disksize?
Right, I will fix it.
>
> [...]
>
>> +		/* Release unwritten fallocated blocks on inode eviction. */
>> +		if (MSDOS_I(inode)->mmu_private < MSDOS_I(inode)->i_disksize) {
>> +			int err;
>> +			fat_truncate_blocks(inode, MSDOS_I(inode)->mmu_private);
>> +			/* Fallocate results in updating the i_start/iogstart
>> +			 * for the zero byte file. So, make it return to
>> +			 * original state during evict and commit it
>> +			 * synchrnously to avoid any corruption on the next
>> +			 * access to the cluster chain for the file.
>> +			 */
>> +			err = fat_sync_inode(inode);
>
> Ah, good catch. We have to update i_size. I was forgetting about this.
> Well, sync inode unconditionally would not be good. Maybe, we better to
> use __fat_write_inode() with inode_needs_sync() or such.
Okay, I will change it.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
