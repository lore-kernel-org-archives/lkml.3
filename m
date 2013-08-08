Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab3HHAFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 20:05:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab3HHAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 20:05:50 -0400
Date: Wed, 7 Aug 2013 17:05:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
Message-Id: <20130807170548.b4bb3355d3aec8f280c7feff@linux-foundation.org>
In-Reply-To: <FA421A63-C90D-42A2-B5A3-0B55AB22673F@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com>
	<0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
	<20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org>
	<EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com>
	<20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org>
	<782613DB-4C38-450C-BBC2-E14FA64D44AC@coraid.com>
	<20130807163507.954590c479a07886a8ae6cb1@linux-foundation.org>
	<FA421A63-C90D-42A2-B5A3-0B55AB22673F@coraid.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 19:54:45 -0400 Ed Cashin <ecashin@coraid.com> wrote:

> > +bio_pageinc(struct bio *bio)
> > +{
> > +       struct bio_vec *bv;
> > +       struct page *page;
> > +       int i;
> > +
> > +       bio_for_each_segment(bv, bio, i) {
> > +               page = bv->bv_page;
> > +               /* Non-zero page count for non-head members of
> > +                * compound pages is no longer allowed by the kernel,
> > +                * but this has never been seen here.
> > +                */
> > +               if (unlikely(PageCompound(page)))
> > +                       if (compound_trans_head(page) != page) {
> > +                               pr_crit("page tail used for block I/O\n");
> > +                               BUG();
> > +                       }
> > 
> > But get_page/put_page against a tail page of a compound page should
> > Just Work.  The core MM will hunt down the head page and manipulate its
> > refcount.  
> > 
> > Perhaps the problem here is that AOE is diving under the covers and is
> > using low-level page refcount alterations:
> > 
> > +               atomic_inc(&page->_count);
> > 
> > Why does AOE do this?  It would be better if it were to use the
> > official published MM interfaces.  If those interfaces need
> > alteration/augmentation then we can do that.
> 
> The get_page cannot be used when the _count is 0 (which is exactly when we need to increment it), because it will VM_BUG_ON.
> 
> 	/*
> 	 * Getting a normal page or the head of a compound page
> 	 * requires to already have an elevated page->_count.
> 	 */
> 	VM_BUG_ON(atomic_read(&page->_count) <= 0);
> 

But we shouldn't get that far:

static inline void get_page(struct page *page)
{
	if (unlikely(PageTail(page)))
		if (likely(__get_page_tail(page)))
			return;
	/*
	 * Getting a normal page or the head of a compound page
	 * requires to already have an elevated page->_count.
	 */
	VM_BUG_ON(atomic_read(&page->_count) <= 0);
	atomic_inc(&page->_count);
}

This is a tail page, so we should be using __get_page_tail().
