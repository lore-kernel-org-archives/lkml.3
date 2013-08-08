Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966298Ab3HHT4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:56:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab3HHT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:56:30 -0400
Date: Thu, 8 Aug 2013 12:56:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
Message-Id: <20130808125629.a5d6a55638743e2deee43065@linux-foundation.org>
In-Reply-To: <6E6337F8-28E9-4361-A7E5-063C6AFFE5BD@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com>
	<0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
	<20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org>
	<EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com>
	<20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org>
	<782613DB-4C38-450C-BBC2-E14FA64D44AC@coraid.com>
	<20130807163507.954590c479a07886a8ae6cb1@linux-foundation.org>
	<FA421A63-C90D-42A2-B5A3-0B55AB22673F@coraid.com>
	<20130807170548.b4bb3355d3aec8f280c7feff@linux-foundation.org>
	<6E6337F8-28E9-4361-A7E5-063C6AFFE5BD@coraid.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 20:50:09 -0400 Ed Cashin <ecashin@coraid.com> wrote:

> > But we shouldn't get that far:
> > 
> > static inline void get_page(struct page *page)
> > {
> > 	if (unlikely(PageTail(page)))
> > 		if (likely(__get_page_tail(page)))
> > 			return;
> > 	/*
> > 	 * Getting a normal page or the head of a compound page
> > 	 * requires to already have an elevated page->_count.
> > 	 */
> > 	VM_BUG_ON(atomic_read(&page->_count) <= 0);
> > 	atomic_inc(&page->_count);
> > }
> > 
> > This is a tail page, so we should be using __get_page_tail().
> 
> 
> When the workaround was created, it was with the assumption that the zero-count pages are not always tail pages, and that seemed to be the case in 2007, but as I said, I don't have a mechanism for detecting that now, so I cannot say whether it really happens with today's kernel.

It sounds we should pull out all that code and retest.  It shouldn't be
needed - if this results in some failure then I suspect core MM will
need changes.

Why don't you have a "mechanism for detecting that"?  It's a matter of
pointing AOE at some hugetlb pages?

> If it is never correct for normal pages or compound page heads to have a zero count while they are associated with a bio, then yes, I think get_page is a great solution.  The VM_BUG_ON in get_page would identify any parts of the kernel that are supplying bios that have pages without references.
> 
> Just a note in response to "we shouldn't get that far":  I believe the VM_BUG_ON line in get_page does get executed for tail pages when the __get_page_tail returns false because the compound page head has a zero count:
> 
>   get_page -> __get_page_tail -> get_page_unless_zero returns false, so
>     __get_page_tail returns "got", which is still false, so
>       get_page executes the VM_BUG_ON, where the _count will be zero for the tail page.

Yup.  If we hit a zero-ref huge page here then we want that BUG_ON to trigger.

