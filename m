Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3LSAux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:50:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3LSAuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:50:50 -0500
Date: Wed, 18 Dec 2013 16:50:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] mm/rmap: fix BUG at rmap_walk
Message-Id: <20131218165049.32462271f314185aed81de39@linux-foundation.org>
In-Reply-To: <52B240C8.5070805@oracle.com>
References: <1387412195-26498-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<20131218162858.6ec808c067baf4644532e110@linux-foundation.org>
	<52B240C8.5070805@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 19:41:44 -0500 Sasha Levin <sasha.levin@oracle.com> wrote:

> On 12/18/2013 07:28 PM, Andrew Morton wrote:
> > On Thu, 19 Dec 2013 08:16:35 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> >
> >> page_get_anon_vma() called in page_referenced_anon() will lock and
> >> increase the refcount of anon_vma, page won't be locked for anonymous
> >> page. This patch fix it by skip check anonymous page locked.
> >>
> >> [  588.698828] kernel BUG at mm/rmap.c:1663!
> >
> > Why is all this suddenly happening.  Did we change something, or did a
> > new test get added to trinity?
> 
> Dave has improved mmap testing in trinity, maybe it's related?

Dave, can you please summarise recent trinity changes for us?

> > Or if there is no reason why the page must be locked for
> > rmap_walk_ksm() and rmap_walk_file(), let's just remove rmap_walk()'s
> > VM_BUG_ON()?  And rmap_walk_ksm()'s as well - it's duplicative anyway.
> 
> IMO, removing all these VM_BUG_ON()s (which is happening quite often recently) will
> lead to having bugs sneak by causing obscure undetected corruption instead of
> being very obvious through a BUG.
> 

Well.  a) My patch was functionally the same as the one Wanpeng
proposed, only better ;) and b) we shouldn't just assert X because we
observed that the existing code does X.  If a particular function
*needs* PageLocked(page) then sure, it can and should assert that the
page is locked.  Preferably with a comment explaining *why*
PageLocked() is needed.  That way we don't end up with years-old
assertions which nobody understands any more, which is what we have
now.

