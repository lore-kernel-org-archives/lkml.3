Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3FEKKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:10:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab3FEKKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:10:23 -0400
Date: Wed, 5 Jun 2013 11:10:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Robin Holt <holt@sgi.com>
Cc: Frank Mehnert <frank.mehnert@oracle.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Handling NUMA page migration
Message-ID: <20130605101019.GA18242@suse.de>
References: <201306040922.10235.frank.mehnert@oracle.com>
 <20130604115807.GF3672@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130604115807.GF3672@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 06:58:07AM -0500, Robin Holt wrote:
> > B) 1. allocate memory with alloc_pages()
> >    2. SetPageReserved()
> >    3. vm_mmap() to allocate a userspace mapping
> >    4. vm_insert_page()
> >    5. vm_flags |= (VM_DONTEXPAND | VM_DONTDUMP)
> >       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND | 0xff)
> > 
> > At least the memory allocated like B) is affected by automatic NUMA page
> > migration. I'm not sure about A).
> > 
> > 1. How can I prevent automatic NUMA page migration on this memory?
> > 2. Can NUMA page migration also be handled on such kind of memory without
> >    preventing migration?
> > 

Page migration does not expect a PageReserved && PageLRU page. The only
reserved check that is made by migration is for the zero page and that
happens in the syscall path for move_pages() which is not used by either
compaction or automatic balancing.

At some point you must have a driver that is setting PageReserved on
anonymous pages that is later encountered by automatic numa balancing
during a NUMA hinting fault.  I expect this is an out-of-tree driver or
a custom kernel of some sort. Memory should be pinned by elevating the
reference count of the page, not setting PageReserved.

It's not particularly clear how you avoid hitting the same bug due to THP and
memory compaction to be honest but maybe your setup hits a steady state that
simply never hit the problem or it happens rarely and it was not identified.

-- 
Mel Gorman
SUSE Labs
