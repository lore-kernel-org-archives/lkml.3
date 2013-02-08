Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946183Ab3BHJIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:08:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946132Ab3BHJIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:08:13 -0500
Date: Fri, 8 Feb 2013 10:08:05 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Andrew Morton <akpm@linux-foundation.org>
cc: Lukas Czerner <lczerner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 10/18] mm: teach truncate_inode_pages_range() to handle
 non page aligned ranges
In-Reply-To: <20130207154042.92430aed.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1302080948110.3225@localhost>
References: <1360055531-26309-1-git-send-email-lczerner@redhat.com> <1360055531-26309-11-git-send-email-lczerner@redhat.com> <20130207154042.92430aed.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013, Andrew Morton wrote:

> Date: Thu, 7 Feb 2013 15:40:42 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>     Hugh Dickins <hughd@google.com>
> Subject: Re: [PATCH v2 10/18] mm: teach truncate_inode_pages_range() to handle
>      non page aligned ranges
> 
> On Tue,  5 Feb 2013 10:12:03 +0100
> Lukas Czerner <lczerner@redhat.com> wrote:
> 
> > This commit changes truncate_inode_pages_range() so it can handle non
> > page aligned regions of the truncate. Currently we can hit BUG_ON when
> > the end of the range is not page aligned, but we can handle unaligned
> > start of the range.
> > 
> > Being able to handle non page aligned regions of the page can help file
> > system punch_hole implementations and save some work, because once we're
> > holding the page we might as well deal with it right away.
> > 
> > In previous commits we've changed ->invalidatepage() prototype to accept
> > 'length' argument to be able to specify range to invalidate. No we can
> > use that new ability in truncate_inode_pages_range().
> > 
> > ...
> >
> > +	/*
> > +	 * 'start' and 'end' always covers the range of pages to be fully
> > +	 * truncated. Partial pages are covered with 'partial_start' at the
> > +	 * start of the range and 'partial_end' at the end of the range.
> > +	 * Note that 'end' is exclusive while 'lend' is inclusive.
> > +	 */
> 
> That helped ;)  So the bytes to be truncated are
> 
> (start*PAGE_SIZE + partial_start) -> (end*PAGE_SIZE + partial_end) - 1
> 
> yes?

The start of the range is not right, because 'start' and 'end'
covers pages to be _fully_ truncated. See the while cycle and 
then 'if (partial_start)' condition where we search for the
page (start - 1) and do_invalidate within that page.

So it should be like this:


(start*PAGE_SIZE - partial_start*(PAGE_SIZE - partial_start) ->
(end*PAGE_END + partial_end) - 1


assuming that you want the range to be inclusive on both sides.

-Lukas
