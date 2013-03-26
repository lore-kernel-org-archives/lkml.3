Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3CZVPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:15:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3CZVPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:15:22 -0400
Date: Tue, 26 Mar 2013 22:15:20 +0100
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] fsfreeze: moving from uniterruptible to killable
Message-ID: <20130326211520.GF2082@quack.suse.cz>
References: <514EC323.7050002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514EC323.7050002@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 24-03-13 10:10:59, Marco Stornelli wrote:
> When a fs is frozen, a process can hang because we wait in
> uniterruptible state. We give the user the possibility to kill the process.
  Yes, but it needs slightly more work as you probably know... (bailing out
properly when the signal arrives).

								Honza

> 
> Not-signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> --- fs/super.c.orig	2013-03-24 09:56:33.000000000 +0100
> +++ fs/super.c	2013-03-24 09:58:41.000000000 +0100
> @@ -1198,7 +1198,7 @@ retry:
>  	if (unlikely(sb->s_writers.frozen >= level)) {
>  		if (!wait)
>  			return 0;
> -		wait_event(sb->s_writers.wait_unfrozen,
> +		wait_event_killable(sb->s_writers.wait_unfrozen,
>  			   sb->s_writers.frozen < level);
>  	}
>  
> @@ -1248,7 +1248,7 @@ static void sb_wait_write(struct super_b
>  		 * of frozen and checking of the counter
>  		 */
>  		prepare_to_wait(&sb->s_writers.wait, &wait,
> -				TASK_UNINTERRUPTIBLE);
> +				 TASK_KILLABLE);
>  
>  		writers = percpu_counter_sum(&sb->s_writers.counter[level-1]);
>  		if (writers)
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
