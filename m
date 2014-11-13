Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137AbaKMUki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:40:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaKMUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:40:37 -0500
Date: Thu, 13 Nov 2014 12:40:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave@sr71.net>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Alexander Nyberg <alexn@dsv.su.se>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm/page_ext: resurrect struct page extending
 code for debugging
Message-Id: <20141113124035.35bc5bb743affddf7f425825@linux-foundation.org>
In-Reply-To: <20141113064035.GB18369@js1304-P5Q-DELUXE>
References: <1415780835-24642-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1415780835-24642-2-git-send-email-iamjoonsoo.kim@lge.com>
	<54638BE4.3080509@sr71.net>
	<20141113064035.GB18369@js1304-P5Q-DELUXE>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 15:40:35 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> On Wed, Nov 12, 2014 at 08:33:40AM -0800, Dave Hansen wrote:
> > On 11/12/2014 12:27 AM, Joonsoo Kim wrote:
> > > @@ -1092,6 +1096,14 @@ struct mem_section {
> > >  
> > >  	/* See declaration of similar field in struct zone */
> > >  	unsigned long *pageblock_flags;
> > > +#ifdef CONFIG_PAGE_EXTENSION
> > > +	/*
> > > +	 * If !SPARSEMEM, pgdat doesn't have page_ext pointer. We use
> > > +	 * section. (see page_ext.h about this.)
> > > +	 */
> > > +	struct page_ext *page_ext;
> > > +	unsigned long pad;
> > > +#endif
> > 
> > Will the distributions be amenable to enabling this?  If so, I'm all for
> > it if it gets us things like page_owner at runtime.
> 
> Yes, I hope so.
> At least, I can make it default to our product. But, how distributions
> will do is beyond my power. :)
> 

>From my reading of the code, the overhead is very low if nobody is
using it.  In which case things should be OK and we can perhaps do away
with CONFIG_PAGE_EXTENSION altogether.

But my reading of the code may be wrong.  It is very poorly documented.
As far as I can tell, invoke_need_callbacks() works out whether there
are any clients of this feature and if not, we avoid allocating that
huge chunk of memory.

And the way we register clients is to enter a pointer into the global
page_ext_ops[].  So this requires a kernel rebuild anyway, so there's
no point in distros enabling CONFIG_PAGE_EXTENSION.  The way to do this
is for CONFIG_PAGE_OWNER (for example) to `select'
CONFIG_PAGE_EXTENSION.

It's unclear to me why invoke_need_callbacks() walks the page_ext_ops[]
entries, inspecting them.  Perhaps this is so that clients of
CONFIG_PAGE_EXTENSION can be enabled/disabled at boot time, dunno.

Please, can we get all this design and behaviour appropriately
documented in the code and changelogs?

