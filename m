Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaAOW6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:58:06 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:52853 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaAOW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:58:01 -0500
Date: Wed, 15 Jan 2014 14:57:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-mm@kvack.org,
        linux-bcache@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        sparclinux@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Make {,set}page_address() static inline if
 WANT_PAGE_VIRTUAL
In-Reply-To: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.02.1401151454440.24121@chino.kir.corp.google.com>
References: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-692950067-1389826679=:24121"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-692950067-1389826679=:24121
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 15 Jan 2014, Geert Uytterhoeven wrote:

> {,set}page_address() are macros if WANT_PAGE_VIRTUAL.
> If !WANT_PAGE_VIRTUAL, they're plain C functions.
> 
> If someone calls them with a void *, this pointer is auto-converted to
> struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
> architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc):

s/sparc/sparc64/

> 
> drivers/md/bcache/bset.c: In function ‘__btree_sort’:
> drivers/md/bcache/bset.c:1190: warning: dereferencing ‘void *’ pointer
> drivers/md/bcache/bset.c:1190: error: request for member ‘virtual’ in something not a structure or union
> 
> Convert them to static inline functions to fix this. There are already
> plenty of  users of struct page members inside <linux/mm.h>, so there's no
> reason to keep them as macros.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Tested-by: David Rientjes <rientjes@google.com>

I'm cringing at the page_address(mempool_alloc(..., GFP_NOIO)) in 
drivers/md/bcache/bset.c, though.  It's relying on that fact that 
mempool_alloc() can never return NULL if __GFP_WAIT but I think this could 
have all been avoided with

	struct page *page = mempool_alloc(state->pool, GFP_NOIO);
	out = page_address(page);

instead of burying the mempool_alloc() in page_address() for what I think 
is cleaner code.  Owell, it fixes the issue.
--531381512-692950067-1389826679=:24121--
