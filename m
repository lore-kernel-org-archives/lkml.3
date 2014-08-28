Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965806AbaH1KHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:07:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934847AbaH1KHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:07:09 -0400
Date: Thu, 28 Aug 2014 12:07:06 +0200
From: Jan Kara <jack@suse.cz>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCHv3 3/3] jbd/jbd2: allocate buffer-cache for superblock
 inode in non-movable area
Message-ID: <20140828100706.GD5961@quack.suse.cz>
References: <53FE9357.6000505@lge.com>
 <53FE94F0.5070401@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FE94F0.5070401@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-08-14 11:33:20, Gioh Kim wrote:
> 
> A long-lasting buffer-cache can distrub page migration so that
> it must be allocated from non-movable area.
> 
> The journal_init_inode is creating a buffer-cache for superblock journaling.
> The superblock exists until system shutdown so that the buffer-cache
> for the superblock would also exist for a long time
> and it can distrub page migration.
> 
> This patch make the buffer-cache be allocated from non-movable area
> not to distrub page migration.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>  fs/jbd/journal.c  |    2 +-
>  fs/jbd2/journal.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 06fe11e..aab8549 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -886,7 +886,7 @@ journal_t * journal_init_inode (struct inode *inode)
>                 goto out_err;
>         }
> 
> -       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
> +       bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
>         if (!bh) {
>                 printk(KERN_ERR
>                        "%s: Cannot get buffer for journal superblock\n",
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 67b8e30..65bd3b1 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1237,7 +1237,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
>                 goto out_err;
>         }
> 
> -       bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
> +       bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
>         if (!bh) {
>                 printk(KERN_ERR
>                        "%s: Cannot get buffer for journal superblock\n",
> --
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
