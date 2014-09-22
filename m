Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaIVRNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbaIVRNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:13:19 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 4/5] O_NONBLOCK flag for readv2/preadv2
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<e190ba39a6244ec19344f7fe161d6e4e89962a3d.1410983999.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Sep 2014 13:12:35 -0400
In-Reply-To: <e190ba39a6244ec19344f7fe161d6e4e89962a3d.1410983999.git.milosz@adfin.com>
	(Milosz Tanski's message of "Wed, 17 Sep 2014 22:20:49 +0000")
Message-ID: <x49mw9ro9z0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 3db2e87..29b5823 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -864,8 +864,10 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
>  		return -EBADF;
>  	if (!(file->f_mode & FMODE_CAN_READ))
>  		return -EINVAL;
> -	if (flags & ~0)
> +	if (flags & ~RWF_NONBLOCK)
>  		return -EINVAL;
> +	if ((file->f_flags & O_DIRECT) && (flags & RWF_NONBLOCK))
> +		return -EAGAIN;

Just to close out our discussion on EINVAL for O_DIRECT with
RWF_NONBLOCK:

After discussing this with Zach, I agree that EAGAIN would be better.
There may be libraries that lack context and may benefit from the EAGAIN
return value.

> +/* These flags are used for the readv/writev syscalls with flags. */
> +#define RWF_NONBLOCK O_NONBLOCK

I'm not sure this make sense.  As I mentioned earlier, the epoll variant
made sense because the flag was shared (passed unmodified to other vfs
calls that understand it).  Here we can just define an entirely new flag
space.  Unless, of course, someone can come up with a reason why this
/would/ make sense?

> diff --git a/mm/filemap.c b/mm/filemap.c
> index e0919ba..6b7aba8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1483,7 +1483,10 @@ static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
>  		cond_resched();
>  find_page:
>  		page = find_get_page(mapping, index);
> +

Please resist the urge to add whitespace.

Cheers,
Jeff
