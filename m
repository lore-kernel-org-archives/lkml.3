Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab3D3AdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:33:12 -0400
Received: from peace.netnation.com ([204.174.223.2]:47309 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3D3Acy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:32:54 -0400
X-Greylist: delayed 1087 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 20:32:54 EDT
Date: Mon, 29 Apr 2013 17:14:45 -0700
From: Simon Kirby <sim@hostway.ca>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
Message-ID: <20130430001445.GA17260@hostway.ca>
References: <20130429184752.435249613@linuxfoundation.org>
 <20130429184752.700428715@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429184752.700428715@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 12:01:44PM -0700, Greg Kroah-Hartman wrote:

> 3.8-stable review patch.  If anyone has any objections, please let me know.

I object. This breaks functionality I use every day (seeing who else is
working on stuff with "w").

Furthermore, the patch does not actually fix the hole referenced (see
ptmx-keystroke-latency.c on http://vladz.devzero.fr/013_ptmx-timing.php).
I can still reproduce the timing capture even with this patch applied
(in 3.9-rc8).

The grsec patch instead introdues another test within the inotify code
(is_sidechannel_device()-related bits) -- untested by me, but probably
more relevant.

Even 37b7f3c76595e23257f61bd80b223de8658617ee, the "regression fix",
which Linus merged in for the 3.9 release, is still a regression for me.
60 seconds means somebody is asleep in my environment, and so is still
the kind of thing that just pisses me off. I'd rather revert this whole
thing.

I'd stand maybe 1 seconds as maximum granularity. You could do that with
less code and no test.

"watch -n.1 ls --full-time /dev/pts/1" shows that the exposed resolution
(without inotify) is to the nanosecond.

Simon-

> ------------------
> 
> From: Jiri Slaby <jslaby@suse.cz>
> 
> commit b0de59b5733d18b0d1974a060860a8b5c1b36a2e upstream.
> 
> On http://vladz.devzero.fr/013_ptmx-timing.php, we can see how to find
> out length of a password using timestamps of /dev/ptmx. It is
> documented in "Timing Analysis of Keystrokes and Timing Attacks on
> SSH". To avoid that problem, do not update time when reading
> from/writing to a TTY.
> 
> I am afraid of regressions as this is a behavior we have since 0.97
> and apps may expect the time to be current, e.g. for monitoring
> whether there was a change on the TTY. Now, there is no change. So
> this would better have a lot of testing before it goes upstream.
> 
> References: CVE-2013-0160
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/tty/tty_io.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -977,8 +977,7 @@ static ssize_t tty_read(struct file *fil
>  	else
>  		i = -EIO;
>  	tty_ldisc_deref(ld);
> -	if (i > 0)
> -		inode->i_atime = current_fs_time(inode->i_sb);
> +
>  	return i;
>  }
>  
> @@ -1079,11 +1078,8 @@ static inline ssize_t do_tty_write(
>  			break;
>  		cond_resched();
>  	}
> -	if (written) {
> -		struct inode *inode = file->f_path.dentry->d_inode;
> -		inode->i_mtime = current_fs_time(inode->i_sb);
> +	if (written)
>  		ret = written;
> -	}
>  out:
>  	tty_write_unlock(tty);
>  	return ret;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
