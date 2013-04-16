Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935371Ab3DPB14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:27:56 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37265 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934897Ab3DPB1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:27:55 -0400
Date: Mon, 15 Apr 2013 18:27:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michel Lespinasse <walken@google.com>
cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on
 CPU due to 09a9f1d27
In-Reply-To: <20130416002123.GA29465@google.com>
Message-ID: <alpine.LNX.2.00.1304151825270.1376@eggly.anvils>
References: <20130412181348.GA2253@redhat.com> <CANN689GKfxM3R96wgY8-+FftpVT76zMFcHdgKccNKnjHGfYq1Q@mail.gmail.com> <20130415163552.GA31868@redhat.com> <20130415173424.GB31868@redhat.com> <20130415175929.GB30583@redhat.com> <20130415191304.GC30583@redhat.com>
 <alpine.LNX.2.00.1304151425540.1030@eggly.anvils> <20130416002123.GA29465@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Michel Lespinasse wrote:
> On Mon, Apr 15, 2013 at 2:47 PM, Hugh Dickins <hughd@google.com> wrote:
> > --- 3.9-rc7/mm/mlock.c  2013-04-01 09:08:05.736012852 -0700
> > +++ linux/mm/mlock.c    2013-04-15 14:20:24.454773245 -0700
> > @@ -397,8 +397,7 @@ int __mm_populate(unsigned long start, u
> >         long ret = 0;
> >
> >         VM_BUG_ON(start & ~PAGE_MASK);
> > -       VM_BUG_ON(len != PAGE_ALIGN(len));
> > -       end = start + len;
> > +       end = start + PAGE_ALIGN(len);
> >
> >         for (nstart = start; nstart < end; nstart = nend) {
> >                 /*
> 
> Yes, there was originally an issue with page alignment in mmap as well, which was fixed by making sure mmap now passes the page aligned length to mm_populate().
> 
> sys_brk() passes the length as the difference of two page aligned addresses, so it's fine. But vm_brk() doesn't - it calls do_brk() which page aligns the length, but then vm_brk passes the unaligned length to mm_populate().
> 
> What do you think of the following ? len is already a PAGE_SIZE multiple when called from sys_brk()...

Yes, that's good.

> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0db0de1c2fbe..6af8b0d1c7db 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2557,10 +2557,6 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
>  	pgoff_t pgoff = addr >> PAGE_SHIFT;
>  	int error;
>  
> -	len = PAGE_ALIGN(len);
> -	if (!len)
> -		return addr;
> -
>  	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
>  
>  	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
> @@ -2643,6 +2639,10 @@ unsigned long vm_brk(unsigned long addr, unsigned long len)
>  	unsigned long ret;
>  	bool populate;
>  
> +	len = PAGE_ALIGN(len);
> +	if (!len)
> +		return addr;
> +
>  	down_write(&mm->mmap_sem);
>  	ret = do_brk(addr, len);
>  	populate = ((mm->def_flags & VM_LOCKED) != 0);
> 
> -- 
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.
