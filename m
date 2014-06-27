Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaF0IVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:21:10 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:55971 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaF0IVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:21:08 -0400
Date: Fri, 27 Jun 2014 10:20:58 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH PING] VFS: mount must return EACCES, not EROFS
Message-ID: <20140627082058.GA24986@frolo.macqel>
References: <20140619230924.GO4453@dastard> <1403253562-29248-1-git-send-email-phdm@macqel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403253562-29248-1-git-send-email-phdm@macqel.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING

Currently, the initial mount of the root file system by the linux
kernel fails with a cryptic message instead of being retried with
the MS_RDONLY flag set,  when the device is read-only and the
combination of block driver and filesystem driver yields EROFS.

I do not know if POSIX mandates that mount(2) must fail with EACCES, nor
if linux aims to strict compliance with POSIX on that point.  Consensus
amongst the messages that I have read so far seems to show that linux
kernel hackers feel that EROFS is a more appropriate error code than
EACCES in that case.

So, do you choose for my first pragmatic and non-intrusive patch, that
lets mount_block_root() retry with MS_RDONLY if the file system
returns EROFS (https://lkml.org/lkml/2014/6/18/468) or for the second
one that forces all file-systems to return EACCES instead of EROFS.
(https://lkml.org/lkml/2014/6/20/98).

Best regards

Philippe

On Fri, Jun 20, 2014 at 10:39:22AM +0200, Philippe De Muyter wrote:
> mount must return EACCES, not EROFS, when one attempts to mount a
> read-only filesystem in read-write mode, but the file-system layer
> only transmits the error given by the block layer, and many block
> drivers return EROFS in that case, so let's fix it in do_mount.
> 
> Actually it is only a small problem for a user using the mount(1)
> command, because EROFS is actually a more explicit answer than
> EACCES, but init/do_mounts.c checks only for EACCES, not EROFS,
> to decide to retry to mount the root file-system in read-only mode,
> and so we are left with an unbootable kernel, and with a cryptic
> error message (*) if the root partition happens to be read-only
> 
> (*): VFS: Cannot open root device "mmcblk0p2" or unknown-block(179,2):
> error -30
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/namespace.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 182bc41..6291a3f 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2411,6 +2411,8 @@ long do_mount(const char *dev_name, const char *dir_name,
>  
>  	retval = security_sb_mount(dev_name, &path,
>  				   type_page, flags, data_page);
> +	if (retval == -EROFS)
> +		retval = -EACCES;
>  	if (!retval && !may_mount())
>  		retval = -EPERM;
>  	if (retval)
> -- 
> 1.7.5.3

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
