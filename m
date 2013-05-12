Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3ELNkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 09:40:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48958 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3ELNkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 09:40:36 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: eunb.song@samsung.com, "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs\@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: Re: Re: EXT4 regression caused 4eec7
In-Reply-To: <31302271.2821368363898561.JavaMail.weblogic@epml17>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Sun, 12 May 2013 17:40:31 +0400
Message-ID: <87li7kxqnk.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 May 2013 13:05:00 +0000 (GMT), EUNBONG SONG <eunb.song@samsung.com> wrote:
> 
> 
> >> Since at this point it's safer to rollback the change and we can
> >> investigate more deeply how to fix it correctly for the next
> >> development cycle, this is the patch which I'm testing.
> 
> >>                     - Ted
> 
> > Hello, I've tested with your patch. But the same problem was reproduced.
> > Currently, I'm trying to git bisect. If i done git bisect, i will let you know.
> 
> Hi, I've done git bisect. and panic at jbd2_journal_put_journal_head() is caused by 
> ae4647fb7654676fc44a97e86eb35f9f06b99f66: "jbd2: reduce journal_head size."
OK that explains both regressions ext4/jbd2 and ext3/jbd(https://lkml.org/lkml/2013/5/10/434)
Probably some race because b_jlist accessed w/o lock some places. 
BUT i still can not reproduce original issue :(
I've tried all types of disks near me (ssd,hdd,usb-dongle),
What disk type you use? Is it reproducible on x86?
Please post following info:
#fdisk -l  $HDD
#hdparm -t $HDD
#df -h 
#cat /proc/mounts

> I write just code patch which revert ae4647fb7654676fc44a97e86eb35f9f06b99f66 because
> I don't know the root cause. 
> 
> 
> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> ---
>  include/linux/journal-head.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index 13a3da2..c18b46f 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -31,14 +31,21 @@ struct journal_head {
>  	/*
>  	 * Journalling list for this buffer [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_jlist:4;
> +	unsigned b_jlist;
>  
>  	/*
>  	 * This flag signals the buffer has been modified by
>  	 * the currently running transaction
>  	 * [jbd_lock_bh_state()]
>  	 */
> -	unsigned b_modified:1;
> +	unsigned b_modified;
> +
> +	/*
> +	 * This feild tracks the last transaction id in which this buffer
> +	 * has been cowed
> +	 * [jbd_lock_bh_state()]
> +	 */
> +	tid_t b_cow_tid;
>  
>  	/*
>  	 * Copy of the buffer data frozen for writing to the log.
> -- 
> 1.7.0.4
> 
> 
> Thanks. N㎠咽ry鉉bXФ푤v^)頻{.n+램{喩zX㎍●}꼿z&j:+v㉭喩zZ++zf＂h~i鎬zwⅱ?②&)刪f^j푹ym@Aa뛴0띠hi
