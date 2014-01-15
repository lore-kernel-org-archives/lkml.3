Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaAOXCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:02:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaAOXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:02:16 -0500
Date: Wed, 15 Jan 2014 15:02:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-mm@kvack.org,
        linux-bcache@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        sparclinux@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Make {,set}page_address() static inline if
 WANT_PAGE_VIRTUAL
Message-Id: <20140115150214.d30aa6ab15b02c24b6923821@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1401151454440.24121@chino.kir.corp.google.com>
References: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
	<alpine.DEB.2.02.1401151454440.24121@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 14:57:56 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Wed, 15 Jan 2014, Geert Uytterhoeven wrote:
> 
> > {,set}page_address() are macros if WANT_PAGE_VIRTUAL.
> > If !WANT_PAGE_VIRTUAL, they're plain C functions.
> > 
> > If someone calls them with a void *, this pointer is auto-converted to
> > struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
> > architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc):
> 
> s/sparc/sparc64/
> 
> > 
> > drivers/md/bcache/bset.c: In function _____btree_sort___:
> > drivers/md/bcache/bset.c:1190: warning: dereferencing ___void *___ pointer
> > drivers/md/bcache/bset.c:1190: error: request for member ___virtual___ in something not a structure or union
> > 
> > Convert them to static inline functions to fix this. There are already
> > plenty of  users of struct page members inside <linux/mm.h>, so there's no
> > reason to keep them as macros.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Tested-by: David Rientjes <rientjes@google.com>
> 
> I'm cringing at the page_address(mempool_alloc(..., GFP_NOIO)) in 
> drivers/md/bcache/bset.c, though.

Yes, I was staring suspiciously at that as well.  Ended up deciding
that I wouldn't have coded it that way, but we should support the
casting.

>  It's relying on that fact that 
> mempool_alloc() can never return NULL if __GFP_WAIT but I think this could 
> have all been avoided with
> 
> 	struct page *page = mempool_alloc(state->pool, GFP_NOIO);
> 	out = page_address(page);
> 
> instead of burying the mempool_alloc() in page_address() for what I think 
> is cleaner code.  Owell, it fixes the issue.

And that would make the later virt_to_page() unnecessary.
