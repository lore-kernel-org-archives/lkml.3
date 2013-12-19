Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3LSBEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:04:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3LSBEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:04:30 -0500
Date: Wed, 18 Dec 2013 17:04:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: fix BUG at rmap_walk
Message-Id: <20131218170429.0858bb069d51a469e8c237d8@linux-foundation.org>
In-Reply-To: <20131219005805.GA25161@lge.com>
References: <1387412195-26498-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<20131218162858.6ec808c067baf4644532e110@linux-foundation.org>
	<20131219005805.GA25161@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 09:58:05 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> On Wed, Dec 18, 2013 at 04:28:58PM -0800, Andrew Morton wrote:
> > On Thu, 19 Dec 2013 08:16:35 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> > 
> > > page_get_anon_vma() called in page_referenced_anon() will lock and 
> > > increase the refcount of anon_vma, page won't be locked for anonymous 
> > > page. This patch fix it by skip check anonymous page locked.
> > > 
> > > [  588.698828] kernel BUG at mm/rmap.c:1663!
> > 
> > Why is all this suddenly happening.  Did we change something, or did a
> > new test get added to trinity?
> 
> It is my fault.
> I should remove this VM_BUG_ON() since rmap_walk() can be called
> without holding PageLock() in this case.
> 
> I think that adding VM_BUG_ON() to each rmap_walk calllers is better
> than this patch, because, now, rmap_walk() is called by many places and
> each places has different contexts.

I don't think that putting the assertion into the caller makes a lot of
sense, particularly if that code just did a lock_page()!  If a *callee*
needs PageLocked() then that callee should assert that the page is
locked.  So

	VM_BUG_ON(!PageLocked(page));

means "this code requires that the page be locked".  And if that code
requires PageLocked(), there must be reasons for this.  Let's also
include an explanation of those reasons.
