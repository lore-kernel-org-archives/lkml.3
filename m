Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaESTsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:48:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaESTsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:48:52 -0400
Date: Mon, 19 May 2014 12:48:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the akpm tree
Message-Id: <20140519124850.7d4470e179c237552f363658@linux-foundation.org>
In-Reply-To: <1400512396.2560.9.camel@buesod1.americas.hpqcorp.net>
References: <20140519181314.1b92c548@canb.auug.org.au>
	<1400512396.2560.9.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 08:13:16 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > Presumably a result of commit fe2038c57c03 ("rwsem: Support optimistic
> > spinning").
> 
> If CONFIG_SMP, we add two new fields to the rwsem structure
> (include/linux/rwsem.h) and likewise we update the
> __RWSEM_INITIALIZER(name) macro. Afaict the only way to trigger
> something like that is to be using the spinlock variant
> (rwsem-spinlock.h).
> 
> The fix for that would be:
> 
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 3e108f1..091d993 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  # define __RWSEM_DEP_MAP_INIT(lockname)
>  #endif
>  
> -#ifdef CONFIG_SMP
> +#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
>  #define __RWSEM_INITIALIZER(name)                      \
>         { RWSEM_UNLOCKED_VALUE,                         \
>           __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),     \

that squishes the warnings for me.
