Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3FZQCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:02:46 -0400
Received: from longford.logfs.org ([213.229.74.203]:59666 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3FZQCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:02:44 -0400
Date: Wed, 26 Jun 2013 10:32:22 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130626143222.GA27481@logfs.org>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ehbpntuk.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 June 2013 17:45:23 +0900, OGAWA Hirofumi wrote:
>
> 
>  fs/fs-writeback.c  |    5 ++++-
>  include/linux/fs.h |    1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff -puN include/linux/fs.h~tux3-fix-wait_sb_inodes include/linux/fs.h
> --- tux3fs/include/linux/fs.h~tux3-fix-wait_sb_inodes	2013-06-24 19:03:10.000000000 +0900
> +++ tux3fs-hirofumi/include/linux/fs.h	2013-06-24 19:03:10.000000000 +0900
> @@ -1595,6 +1595,7 @@ struct super_operations {
>  	int (*write_inode) (struct inode *, struct writeback_control *wbc);
>  	int (*drop_inode) (struct inode *);
>  	void (*evict_inode) (struct inode *);
> +	void (*wait_inodes)(struct super_block *);
>  	void (*put_super) (struct super_block *);
>  	int (*sync_fs)(struct super_block *sb, int wait);
>  	int (*freeze_fs) (struct super_block *);
> diff -puN fs/fs-writeback.c~tux3-fix-wait_sb_inodes fs/fs-writeback.c
> --- tux3fs/fs/fs-writeback.c~tux3-fix-wait_sb_inodes	2013-06-24 19:03:10.000000000 +0900
> +++ tux3fs-hirofumi/fs/fs-writeback.c	2013-06-24 19:03:10.000000000 +0900
> @@ -1401,7 +1401,10 @@ void sync_inodes_sb(struct super_block *
>  	bdi_queue_work(sb->s_bdi, &work);
>  	wait_for_completion(&done);
>  
> -	wait_sb_inodes(sb);
> +	if (sb->s_op->wait_inodes)
> +		sb->s_op->wait_inodes(sb);
> +	else
> +		wait_sb_inodes(sb);
>  }
>  EXPORT_SYMBOL(sync_inodes_sb);

Two things.  Until there are actual implementations of
s_op->wait_inodes, this is pure obfuscation.  You already know this,
of course.

More interestingly, I personally hate methods with a default option if
they are not implemented.  Not too bad in this particular case, but
the same pattern has burned me a number of times and wasted weeks of
my life.  So I would prefer to unconditionally call
sb->s_op->wait_inodes(sb) and set it to wait_sb_inodes for all
filesystems that don't have a smarter way to do things.

Jörn

--
Linux is more the core point of a concept that surrounds "open source"
which, in turn, is based on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle
