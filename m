Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3AJWiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:38:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3AJWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:38:14 -0500
Date: Thu, 10 Jan 2013 14:38:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fan Du <fan.du@windriver.com>
Cc: <matthew@wil.cx>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: Disable preempt when acquire i_size_seqcount write
 lock
Message-Id: <20130110143813.1ba2b4fd.akpm@linux-foundation.org>
In-Reply-To: <1357702459-2718-1-git-send-email-fan.du@windriver.com>
References: <1357702459-2718-1-git-send-email-fan.du@windriver.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2013 11:34:19 +0800
Fan Du <fan.du@windriver.com> wrote:

> Two rt tasks bind to one CPU core.
> 
> The higher priority rt task A preempts a lower priority rt task B which
> has already taken the write seq lock, and then the higher priority
> rt task A try to acquire read seq lock, it's doomed to lockup.
> 
> rt task A with lower priority: call write
> i_size_write                                        rt task B with higher priority: call sync, and preempt task A
>   write_seqcount_begin(&inode->i_size_seqcount);    i_size_read  
>   inode->i_size = i_size;                             read_seqcount_begin <-- lockup here... 
> 

Ouch.

And even if the preemping task is preemptible, it will spend an entire
timeslice pointlessly spinning, which isn't very good.

> So disable preempt when acquiring every i_size_seqcount *write* lock will
> cure the problem.
> 
> ...
>
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -758,9 +758,11 @@ static inline loff_t i_size_read(const struct inode *inode)
>  static inline void i_size_write(struct inode *inode, loff_t i_size)
>  {
>  #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
> +	preempt_disable();
>  	write_seqcount_begin(&inode->i_size_seqcount);
>  	inode->i_size = i_size;
>  	write_seqcount_end(&inode->i_size_seqcount);
> +	preempt_enable();
>  #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
>  	preempt_disable();
>  	inode->i_size = i_size;

afacit all write_seqcount_begin()/read_seqretry() sites are vulnerable
to this problem.  Would it not be better to do the preempt_disable() in
write_seqcount_begin()?


Possible problems:

- mm/filemap_xip.c does disk I/O under write_seqcount_begin().

- dev_change_name() does GFP_KERNEL allocations under write_seqcount_begin()

- I didn't review u64_stats_update_begin() callers.

But I think calling schedule() under preempt_disable() is OK anyway?
