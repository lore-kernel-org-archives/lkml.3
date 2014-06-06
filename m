Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaFFSto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:49:44 -0400
Received: from mta-out1.inet.fi ([62.71.2.230]:36721 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaFFStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:49:43 -0400
Date: Fri, 6 Jun 2014 21:49:26 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>
Subject: Re: 3.15-rc8 oops in copy_page_rep after page fault.
Message-ID: <20140606184926.GA16083@node.dhcp.inet.fi>
References: <20140606174317.GA1741@redhat.com>
 <CA+55aFxiOsceOsm7zYyvFAxDF3=gxUXj=_61Nce3VkELfJr7cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiOsceOsm7zYyvFAxDF3=gxUXj=_61Nce3VkELfJr7cg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:26:14AM -0700, Linus Torvalds wrote:
> On Fri, Jun 6, 2014 at 10:43 AM, Dave Jones <davej@redhat.com> wrote:
> >
> > RIP: 0010:[<ffffffff8b3287b5>]  [<ffffffff8b3287b5>] copy_page_rep+0x5/0x10
> 
> Ok, it's the first iteration of "rep movsq" (%rcx is still 0x200) for
> copying a page, and the pages are
> 
>   RSI: ffff880052766000
>   RDI: ffff880014efe000
> 
> which both look like reasonable kernel addresses. So I'm assuming it's
> DEBUG_PAGEALLOC that makes this trigger, and since the error code is
> 0, and the CR2 value matches RSI, it's the source page that seems to
> have been freed.
> 
> And I see absolutely _zero_ reason for wht your 64k mmap_min_addr
> should make any difference what-so-ever. That's just odd.
> 
> Anyway, can you try to figure out _which_ copy_user_highpage() it is
> (by looking at what is around the call-site at
> "handle_mm_fault+0x1e0". The fact that we have a stale
> do_huge_pmd_wp_page() on the stack makes me suspect that we have hit
> that VM_FAULT_FALLBACK case and this is related to splitting. Adding a
> few more people explicitly to the cc in case anybody sees anything
> (original email on lkml and linux-mm for context, guys).

Looks like a known false positive from DEBUG_PAGEALLOC:

https://lkml.org/lkml/2013/3/29/103

We huge copy page in do_huge_pmd_wp_page() without ptl taken and the page
can be splitted and freed under us. Once page is copied we take ptl again
and recheck that PMD is not changed. If changed, we don't use new page.
Not a bug, never triggered with DEBUG_PAGEALLOC disabled.

It would be nice to have a way to mark this kind of speculative access.

-- 
 Kirill A. Shutemov
