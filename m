Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3FQKS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:18:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab3FQKSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:18:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        "Alexander Beregalov" <a.beregalov@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, "Zheng Liu" <wenqing.lz@taobao.com>
Subject: Re: [28/83] ext4: lock i_mutex when truncating orphan inodes
References: <lsq.1371420097.220610690@decadent.org.uk>
Date: Mon, 17 Jun 2013 11:18:20 +0100
In-Reply-To: <lsq.1371420097.220610690@decadent.org.uk> (Ben Hutchings's
	message of "Sun, 16 Jun 2013 23:01:37 +0100")
Message-ID: <87a9mprqfn.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> 3.2.47-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Theodore Ts'o <tytso@mit.edu>
>
> commit 721e3eba21e43532e438652dd8f1fcdfce3187e7 upstream.

I'm also queuing this commit as it looks like 3.5 is also missing it.

Cheers,
-- 
Luis

>
> Commit c278531d39 added a warning when ext4_flush_unwritten_io() is
> called without i_mutex being taken.  It had previously not been taken
> during orphan cleanup since races weren't possible at that point in
> the mount process, but as a result of this c278531d39, we will now see
> a kernel WARN_ON in this case.  Take the i_mutex in
> ext4_orphan_cleanup() to suppress this warning.
>
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  fs/ext4/super.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2260,7 +2260,9 @@ static void ext4_orphan_cleanup(struct s
>  				__func__, inode->i_ino, inode->i_size);
>  			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
>  				  inode->i_ino, inode->i_size);
> +			mutex_lock(&inode->i_mutex);
>  			ext4_truncate(inode);
> +			mutex_unlock(&inode->i_mutex);
>  			nr_truncates++;
>  		} else {
>  			ext4_msg(sb, KERN_DEBUG,
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
