Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab3A1AgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:36:14 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:46299 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3A1AgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:36:12 -0500
Message-ID: <1359333371.6763.12.camel@kernel>
Subject: Re: [PATCH 5/11] ksm: get_ksm_page locked
From: Simon Jeons <simon.jeons@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Sun, 27 Jan 2013 18:36:11 -0600
In-Reply-To: <alpine.LNX.2.00.1301271355430.17144@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
	 <alpine.LNX.2.00.1301251759470.29196@eggly.anvils>
	 <1359254187.4159.10.camel@kernel>
	 <alpine.LNX.2.00.1301271355430.17144@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 14:08 -0800, Hugh Dickins wrote:
> On Sat, 26 Jan 2013, Simon Jeons wrote:
> > On Fri, 2013-01-25 at 18:00 -0800, Hugh Dickins wrote:
> > > In some places where get_ksm_page() is used, we need the page to be locked.
> > > 
> > 
> > In function get_ksm_page, why check page->mapping =>
> > get_page_unless_zero => check page->mapping instead of
> > get_page_unless_zero => check page->mapping, because
> > get_page_unless_zero is expensive?
> 
> Yes, it's more expensive.
> 
> > 
> > > When KSM migration is fully enabled, we shall want that to make sure that
> > > the page just acquired cannot be migrated beneath us (raised page count is
> > > only effective when there is serialization to make sure migration notices).
> > > Whereas when navigating through the stable tree, we certainly do not want
> > 
> > What's the meaning of "navigating through the stable tree"?
> 
> Finding the right place in the stable tree,
> as stable_tree_search() and stable_tree_insert() do.
> 
> > 
> > > to lock each node (raised page count is enough to guarantee the memcmps,
> > > even if page is migrated to another node).
> > > 
> > > Since we're about to add another use case, add the locked argument to
> > > get_ksm_page() now.
> > 
> > Why the parameter lock passed from stable_tree_search/insert is true,
> > but remove_rmap_item_from_tree is false?
> 
> The other way round?  remove_rmap_item_from_tree needs the page locked,
> because it's about to modify the list: that's secured (e.g. against
> concurrent KSM page reclaim) by the page lock.

How can KSM page reclaim path call remove_rmap_item_from_tree? I have
already track every callsites but can't find it. BTW, I'm curious about
KSM page reclaim, it seems that there're no special handle in vmscan.c
for KSM page reclaim, is it will be reclaimed similiar with normal
page? 

> 
> stable_tree_search and stable_tree_insert do not need intermediate nodes
> to be locked: get_page is enough to secure the page contents for memcmp,
> and we don't want a pointless wait for exclusive page lock on every
> intermediate node.


