Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab3EGMeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:34:50 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44264 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab3EGMet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:34:49 -0400
From: "Zhang Yi" <wetpzy@gmail.com>
To: "'Zhang Yi'" <wetpzy@gmail.com>, "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Dave Hansen'" <dave.hansen@linux.intel.com>, <zhang.yi20@zte.com.cn>,
        <wetpzy@163.com>
References: <000101ce4277$69df5af0$3d9e10d0$@com> <alpine.LFD.2.02.1304261951300.21884@ionos> 
In-Reply-To: 
Subject: RE: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
Date: Tue, 7 May 2013 20:34:39 +0800
Message-ID: <000201ce4b1f$42446110$c6cd2330$@com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac5Cq4gRtTB0hJTSRgGG2l6O4kBh6wIcY47QAABkM5A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is OK that I send the mail to myself , but there are some wrong while sending to you.
Ignore this mail ,please, I will check and send it again.

> -----Original Message-----
> From: Zhang Yi [mailto:wetpzy@gmail.com]
> Sent: Tuesday, May 07, 2013 8:24 PM
> To: 'Thomas Gleixner'
> Cc: 'linux-kernel@vger.kernel.org'; 'Peter Zijlstra'; 'Darren Hart'; 'Ingo Molnar'; 'Dave Hansen';
'zhang.yi20@zte.com.cn';
> 'wetpzy@163.com'
> Subject: RE: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
>
> > -----Original Message-----
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Sent: Saturday, April 27, 2013 2:26 AM
> > To: Zhang Yi
> > Cc: linux-kernel@vger.kernel.org; 'Peter Zijlstra'; 'Darren Hart'; 'Ingo Molnar'; 'Dave Hansen';
zhang.yi20@zte.com.cn;
> > wetpzy@163.com
> > Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
> >
> > Zhang,
> >
> > On Fri, 26 Apr 2013, Zhang Yi wrote:
> > > At 2013-04-26 04:52:31,"Thomas Gleixner" <tglx@linutronix.de> wrote:
> > > >
> > > >Unfortunately this did not work out very well.
> > > >
> > > >1. Your patch now lacks a proper changelog which explains the change
> > > >
> > > >2. Your patch lacks any newline characters as you can see below
> > > >
> > >
> > > I am so sorry for my mistakes. : )
> >
> > Nothing to worry about. We all make mistakes! :)
> >
> > > The futex-keys of processes share futex determined by page-offset, mapping-host, and
> > > mapping-index of the user space address.
> > > User appications using hugepage for futex may lead to futex-key conflict.
> > > Assume there are two or more futexes in diffrent normal pages of the hugepage,
> > > and each futex has the same offset in its normal page, causing all the futexes have the same futex-key.
> >
> > Nit-pick: Please format changelog text with a linebreak around 78
> > characters. So it looks like this:
> >
> > The futex-keys of processes share futex determined by page-offset,
> > mapping-host, and mapping-index of the user space address. User
> > appications using hugepage for futex may lead to futex-key conflict.
> >
> > Assume there are two or more futexes in diffrent normal pages of the
> > hugepage, and each futex has the same offset in its normal page,
> > causing all the futexes have the same futex-key.
> >
> > > In that case, futex may not work well.
> >
> > Very nice detective work!
> >
> > > diff -uprN orig/linux3.9-rc7/include/linux/futex.h new/linux3.9-rc7/include/linux/futex.h
> > > --- orig/linux3.9-rc7/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000
> > > +++ new/linux3.9-rc7/include/linux/futex.h	2013-04-19 16:33:58.725880000 +0000
> >
> > The canonical diff for patch submission is
> >
> >   diff -uprN linux3.9-rc7/ linux3.9-rc7.orig/
> >
> > That results in a patch which can be applied with "patch -p1" from the
> > kernel base directory and that's how all our scripts work.
> >
> > Your's needs to be applied with -p2, so it requires manual
> > interaction.
> >
> > You can verify that by cd'ing into the kernel tree base directory and
> > run "patch -p1 < your.patch".
> >
> > You might have a look at quilt or simply use git, which will do the
> > right thing for you and in both cases you do not need a separate
> > kernel tree to diff against.
> >
> > >  #define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
> > > @@ -36,17 +39,17 @@ union futex_key {
> > >  	struct {
> > >  		unsigned long pgoff;
> > >  		struct inode *inode;
> > > -		int offset;
> > > +		long offset;
> >
> > unsigned long please, offset can't be negative. The "int" type of
> > offset was silly already.
> >
> > > +/*
> > > +* Get subpage index in compound page, for futex_key.
> > > +*/
> > > +static inline int get_page_compound_index(struct page *page)
> > > +{
> > > +	struct page *head_page;
> > > +	if (PageHead(page))
> > > +		return 0;
> >
> > If you look at the callsite, then you'll see that this is only called
> > when page != page_head. And page_head = compound_head(page). So you
> > don't need to double check that.
> >
> > > +
> > > +	head_page = compound_head(page);
> >
> > Again. The head page is already known, so you can hand it into the
> > function.
> >
> > > +	if (compound_order(head_page) >= MAX_ORDER)
> > > +		return page_to_pfn(page) - page_to_pfn(head_page);
> > > +	else
> > > +		return page - compound_head(page);
> > > +}
> > > +
> >
> > Now instead of returning that value, I'd rather hand the futex key
> > pointer to the function and let the function add the index
> > value. Something like:
> >
> > static void key_add_compound_idx(key, page, page_head)
> > {
> > 	...
> > }
> >
> > That makes the code simpler and easier to read.
> >
> > Thanks,
> >
> > 	tglx
>
>
> The futex-keys of processes share futex determined by page-offset,
> mapping-host, and mapping-index of the user space address. User
> appications using hugepage for futex may lead to futex-key conflict.
>
> Assume there are two or more futexes in diffrent normal pages of the
> hugepage, and each futex has the same offset in its normal page,
> causing all the futexes have the same futex-key.
>
>
> Steps to reproduce the bug:
> 1. The 1st thread map a file of hugetlbfs, and use the return address
> as the 1st mutex's
> address, and use the return address with PAGE_SIZ
>  added as the 2nd mutex's addres.;
> 2. The 1st thread initialize the two mutexes with pshared attribute
>  and lock the two mutexes.
> 3. The 1st thread create the 2nd thread, and the 2nd thread block o
>  the 1st mutex.
> 4. The 1st thread create the 3rd thread, and the 3rd thread block o
>  the 2nd mutex.
> 5. The 1st thread unlock the 2nd mutex, the 3rd thread can not tak
>  the 2nd mutex, an
> may block forever.
>
>
> Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> Tested-by: Ma Chenggong <ma.chenggong@zte.com.c
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>n>
> Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
> Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
> Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
>
>
> diff -uprN linux3.9-orig/include/linux/futex.h linux3.9/include/linux/futex.h
> --- linux3.9-orig/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000
> +++ linux3.9/include/linux/futex.h	2013-04-27 08:59:58.932078000 +0000
> @@ -19,7 +19,7 @@ handle_futex_death(u32 __user *uaddr, st
>   * The key type depends on whether it's a shared or private mapping.
>   * Don't rearrange members without looking at hash_futex().
>   *
> - * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
> + * There are three cmponents in offset:
>   * We use the two low order bits of offset to tell what is the kind of key :
>   *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)
>   *       (no reference on an inode or mm)
> @@ -27,6 +27,9 @@ handle_futex_death(u32 __user *uaddr, st
>   *	mapped on a file (reference on the underlying inode)
>   *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
>   *       (but private mapping on an mm, and reference taken on it)
> + * Bits 2 to (PAGE_SHIFT-1) indicates the offset of futex in its page.
> + * The rest hign order bits indicates the index if the page is a
> + * subpage of a compound page.
>  */
>
>  #define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
> @@ -36,17 +39,17 @@ union futex_key {
>  	struct {
>  		unsigned long pgoff;
>  		struct inode *inode;
> -		int offset;
> +		unsigned long offset;
>  	} shared;
>  	struct {
>  		unsigned long address;
>  		struct mm_struct *mm;
> -		int offset;
> +		unsigned long offset;
>  	} private;
>  	struct {
>  		unsigned long word;
>  		void *ptr;
> -		int offset;
> +		unsigned long offset;
>  	} both;
>  };
>
> diff -uprN linux3.9-orig/kernel/futex.c linux3.9/kernel/futex.c
> --- linux3.9-orig/kernel/futex.c	2013-04-15 00:45:16.000000000 +0000
> +++ linux3.9/kernel/futex.c	2013-05-06 16:24:40.403525000 +0000
> @@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
>  	}
>  }
>
> +/*
> +* Get subpage index in compound page, and add it into futex_key.
> +*/
> +static void key_add_compound_idx(union futex_key *key,
> +				 struct page *head_page, struct page *page)
> +{
> +	int compound_idx;
> +
> +	if (compound_order(head_page) >= MAX_ORDER)
> +		compound_idx = page_to_pfn(page) - page_to_pfn(head_page);
> +	else
> +		compound_idx = page - head_page;
> +
> +	key->both.offset |= compound_idx << PAGE_SHIFT;
> +}
> +
>  /**
>   * get_futex_key() - Get parameters which are the keys for a futex
>   * @uaddr:	virtual address of the futex
> @@ -228,7 +244,8 @@ static void drop_futex_key_refs(union fu
>   * The key words are stored in *key on success.
>   *
>   * For shared mappings, it's (page->index, file_inode(vma->vm_file),
> - * offset_within_page).  For private mappings, it's (uaddr, current->mm).
> + * page_compound_index and offset_within_page).
> + * For private mappings, it's (uaddr, current->mm).
>   * We can usually work out the index without swapping in the page.
>   *
>   * lock_page() might sleep, the caller should not hold a spinlock.
> @@ -366,6 +383,8 @@ again:
>  		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
>  		key->shared.inode = page_head->mapping->host;
>  		key->shared.pgoff = page_head->index;
> +		if (page != page_head)
> +			key_add_compound_idx(key, page_head, page);
>  	}
>
>  	get_futex_key_refs(key);



