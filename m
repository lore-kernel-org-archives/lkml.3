Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3GAPZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab3GAPZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:25:22 -0400
Date: Mon, 01 Jul 2013 11:25:03 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: gong.chen@linux.intel.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <1372692303-56f0gltk-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130701091355.GA14444@gchen.bj.intel.com>
References: <1368807482-11153-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130701091355.GA14444@gchen.bj.intel.com>
Subject: Re: [PATCH] mm/memory-failure.c: fix memory leak in successful soft
 offlining
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130701091355.GA14444@gchen.bj.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 05:13:55AM -0400, Chen Gong wrote:
> On Fri, May 17, 2013 at 12:18:02PM -0400, Naoya Horiguchi wrote:
> > Date: Fri, 17 May 2013 12:18:02 -0400
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > To: linux-mm@kvack.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen
> >  <andi@firstfloor.org>, linux-kernel@vger.kernel.org, Naoya Horiguchi
> >  <n-horiguchi@ah.jp.nec.com>
> > Subject: [PATCH] mm/memory-failure.c: fix memory leak in successful soft
> >  offlining
> > 
> > After a successful page migration by soft offlining, the source page is
> > not properly freed and it's never reusable even if we unpoison it afterward.
> > 
> > This is caused by the race between freeing page and setting PG_hwpoison.
> > In successful soft offlining, the source page is put (and the refcount
> > becomes 0) by putback_lru_page() in unmap_and_move(), where it's linked to
> > pagevec and actual freeing back to buddy is delayed. So if PG_hwpoison is
> > set for the page before freeing, the freeing does not functions as expected
> > (in such case freeing aborts in free_pages_prepare() check.)
> > 
> > This patch tries to make sure to free the source page before setting
> > PG_hwpoison on it. To avoid reallocating, the page keeps MIGRATE_ISOLATE
> > until after setting PG_hwpoison.
> > 
> > This patch also removes obsolete comments about "keeping elevated refcount"
> > because what they say is not true. Unlike memory_failure(), soft_offline_page()
> > uses no special page isolation code, and the soft-offlined pages have no
> > difference from buddy pages except PG_hwpoison. So no need to keep refcount
> > elevated.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
...
> Hi, Naoya
> 
> What happens about this patch? It looks find to me but not merged yet.
> If something I missed, would you please tell me again?

Hello Gong,

It's already on mmotm, so I hope Andrew will push it in this merge window
(just opened yesterday.)

Thanks,
Naoya Horiguchi
