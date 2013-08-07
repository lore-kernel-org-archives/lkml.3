Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab3HGVSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:18:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3HGVSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:18:36 -0400
Date: Wed, 7 Aug 2013 14:18:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
Message-Id: <20130807141835.533816143f8b37175c50d58d@linux-foundation.org>
In-Reply-To: <8DFEA276-4EE1-44B4-9669-5634631D7BBC@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com>
	<0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com>
	<20130807135804.e62b75f6986e9568ab787562@linux-foundation.org>
	<8DFEA276-4EE1-44B4-9669-5634631D7BBC@coraid.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 17:12:36 -0400 Ed Cashin <ecashin@coraid.com> wrote:

> 
> On Aug 7, 2013, at 4:58 PM, Andrew Morton wrote:
> 
> > On Thu, 1 Aug 2013 21:29:59 -0400 Ed Cashin <ecashin@coraid.com> wrote:
> > 
> >> As discussed previously,
> > 
> > I think I missed that.
> > 
> >> the fact that some users of the block
> >> layer provide bios that point to pages with a zero _count means
> >> that it is not OK for the network layer to do a put_page on the
> >> skb frags during an skb_linearize, so the aoe driver gets a
> >> reference to pages in bios and puts the reference before ending
> >> the bio.  And because it cannot use get_page on a page with a
> >> zero _count, it manipulates the value directly.
> > 
> > Eh?  What code is putting count==0 pages into bios?  That sounds very
> > weird and broken.
> 
> I thought so in 2007 but couldn't solicit a clear "this is wrong" consensus from the discussion.
> 
>   http://article.gmane.org/gmane.linux.kernel/499197
>   https://lkml.org/lkml/2007/1/19/56
>   https://lkml.org/lkml/2006/12/18/230
> 
> We were seeing zero-count pages in bios from XFS, but Christoph Hellwig pointed out that kmalloced pages can also come from ext3 when it's doing log recovery, and they'll have zero page counts.

aiiee!

It is (I suppose) reasonable to put kmalloced memory into a BIO's page
array.  And it is perfectly reasonable for a user of that bio to do a
get_page/put_page against that page.  It is utterly unreasonable for
the damn page to get freed as a result!

I'd claim that slab is broken.  The page is in use, so it should have an
elevated refcount, full stop.

