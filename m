Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbaLBWmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:42:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaLBWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:42:01 -0500
Date: Tue, 2 Dec 2014 14:42:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Message-Id: <20141202144200.a4ca81a46a43563a8874fd8e@linux-foundation.org>
In-Reply-To: <CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141125150101.9596a09e.akpm@linux-foundation.org>
	<CANP1eJEALZTwMv0Z1udmPWKhfGmpe+idtdRASp62Jm_V0N2HcQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 17:17:42 -0500 Milosz Tanski <milosz@adfin.com> wrote:

> > There have been several incomplete attempts to implement fincore().  If
> > we were to complete those attempts, preadv2() could be implemented
> > using fincore()+pread().  Plus we get fincore(), which is useful for
> > other (but probably similar) reasons.  Probably fincore()+pwrite() could
> > be used to implement pwritev2(), but I don't know what pwritev2() does
> > yet.
> >
> > Implementing fincore() is more flexible, requires less code and is less
> > likely to have bugs.  So why not go that way?  Yes, it's more CPU
> > intensive, but how much?  Is the difference sufficient to justify the
> > preadv2()/pwritev2() approach?
> 
> I would like to see a fincore() functionality (for other reasons) I
> don't think it does the job here. fincore() + preadv() is inherently
> racy as there's no guarantee that the data becomes uncached between
> the two calls.

There will always be holes.  For example find_get_page() could block on
lock_page() while some other process is doing IO. 
page_cache_async_readahead() does lots of memory allocation which can
get blocked for long periods in the page allocator. 
page_cache_async_readahead() can block on synchronous metadata reads,
etc.

The question is whether a simpler approach such as fincore() will be
sufficient.

> This may not matter in some cases, but in others (ones
> that I'm trying to solve) it will introduce unexpected latency.

Details?

> There's no overlap between prwritev2 and fincore() functionality.

Do we actually need pwritev2()?  What's the justification for that?


Please let's examine the alternative(s) seriously.  It would be mistake
to add preadv2/pwritev2 if fincore+pread would have sufficed.  

