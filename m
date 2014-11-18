Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaKRMK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:10:57 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50698 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaKRMKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:10:54 -0500
Message-ID: <546B374A.1010902@electrozaur.com>
Date: Tue, 18 Nov 2014 14:10:50 +0200
From: Boaz Harrosh <ooo@electrozaur.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
References: <20141113220927.GF2598@htj.dyndns.org> <20141113221139.GG2598@htj.dyndns.org>
In-Reply-To: <20141113221139.GG2598@htj.dyndns.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 12:11 AM, Tejun Heo wrote:
<>
> @@ -426,7 +427,7 @@ struct block_device {
>  	struct inode *		bd_inode;	/* will die */
>  	struct super_block *	bd_super;
>  	struct mutex		bd_mutex;	/* open/close mutex */
> -	struct list_head	bd_inodes;
> +	struct ptrset		bd_inodes;
>  	void *			bd_claiming;
>  	void *			bd_holder;
>  	int			bd_holders;
> @@ -609,7 +610,6 @@ struct inode {
>  #ifdef CONFIG_QUOTA
>  	struct dquot		*i_dquot[MAXQUOTAS];
>  #endif
> -	struct list_head	i_devices;
>  	union {
>  		struct pipe_inode_info	*i_pipe;
>  		struct block_device	*i_bdev;

You do know that you can completely dodge the bullet
by making i_devices a union with some other members.

If I understand correctly these are the init_special_inode()
	if (S_ISCHR(mode)) {
		inode->i_fop = &def_chr_fops;
		inode->i_rdev = rdev;
	} else if (S_ISBLK(mode)) {
		inode->i_fop = &def_blk_fops;
		inode->i_rdev = rdev;

Right? well if so than those special inodes do
not hold any data and never do IO of any kind
so all the inode members that are needed for IO
are candidates.
example: i_wb_list; i_lru; i_dio_count i_writecount
i_dquot (when QUOTA is on) i_private and more

Even union with the "cgroup writback support" you
want to add.

Hey interesting per-cpu code though I learned something ...
Thanks
Boaz
