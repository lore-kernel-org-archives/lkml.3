Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3DZS0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:26:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:50011 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3DZS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:26:13 -0400
Date: Fri, 26 Apr 2013 20:26:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Zhang Yi <wetpzy@gmail.com>
cc: linux-kernel@vger.kernel.org, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Dave Hansen'" <dave.hansen@linux.intel.com>, zhang.yi20@zte.com.cn,
        wetpzy@163.com
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
In-Reply-To: <000101ce4277$69df5af0$3d9e10d0$@com>
Message-ID: <alpine.LFD.2.02.1304261951300.21884@ionos>
References: <000101ce4277$69df5af0$3d9e10d0$@com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang,

On Fri, 26 Apr 2013, Zhang Yi wrote:
> At 2013-04-26 04:52:31,"Thomas Gleixner" <tglx@linutronix.de> wrote:
> >
> >Unfortunately this did not work out very well.
> >
> >1. Your patch now lacks a proper changelog which explains the change
> >
> >2. Your patch lacks any newline characters as you can see below
> >
> 
> I am so sorry for my mistakes. : )

Nothing to worry about. We all make mistakes! :)

> The futex-keys of processes share futex determined by page-offset, mapping-host, and
> mapping-index of the user space address.
> User appications using hugepage for futex may lead to futex-key conflict.
> Assume there are two or more futexes in diffrent normal pages of the hugepage,
> and each futex has the same offset in its normal page, causing all the futexes have the same futex-key.

Nit-pick: Please format changelog text with a linebreak around 78
characters. So it looks like this:

The futex-keys of processes share futex determined by page-offset,
mapping-host, and mapping-index of the user space address. User
appications using hugepage for futex may lead to futex-key conflict.

Assume there are two or more futexes in diffrent normal pages of the
hugepage, and each futex has the same offset in its normal page,
causing all the futexes have the same futex-key.

> In that case, futex may not work well.

Very nice detective work!
 
> diff -uprN orig/linux3.9-rc7/include/linux/futex.h new/linux3.9-rc7/include/linux/futex.h
> --- orig/linux3.9-rc7/include/linux/futex.h	2013-04-15 00:45:16.000000000 +0000
> +++ new/linux3.9-rc7/include/linux/futex.h	2013-04-19 16:33:58.725880000 +0000

The canonical diff for patch submission is

  diff -uprN linux3.9-rc7/ linux3.9-rc7.orig/

That results in a patch which can be applied with "patch -p1" from the
kernel base directory and that's how all our scripts work.

Your's needs to be applied with -p2, so it requires manual
interaction.

You can verify that by cd'ing into the kernel tree base directory and
run "patch -p1 < your.patch".

You might have a look at quilt or simply use git, which will do the
right thing for you and in both cases you do not need a separate
kernel tree to diff against.

>  #define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
> @@ -36,17 +39,17 @@ union futex_key {
>  	struct {
>  		unsigned long pgoff;
>  		struct inode *inode;
> -		int offset;
> +		long offset;

unsigned long please, offset can't be negative. The "int" type of
offset was silly already.

> +/*
> +* Get subpage index in compound page, for futex_key.
> +*/
> +static inline int get_page_compound_index(struct page *page)
> +{
> +	struct page *head_page;
> +	if (PageHead(page))
> +		return 0;

If you look at the callsite, then you'll see that this is only called
when page != page_head. And page_head = compound_head(page). So you
don't need to double check that.

> +
> +	head_page = compound_head(page);

Again. The head page is already known, so you can hand it into the
function.

> +	if (compound_order(head_page) >= MAX_ORDER)
> +		return page_to_pfn(page) - page_to_pfn(head_page);
> +	else
> +		return page - compound_head(page);
> +}
> +

Now instead of returning that value, I'd rather hand the futex key
pointer to the function and let the function add the index
value. Something like:

static void key_add_compound_idx(key, page, page_head)
{
	...
}

That makes the code simpler and easier to read.

Thanks,

	tglx
