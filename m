Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaBEUmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:42:32 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:48989 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753750AbaBEUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:42:29 -0500
Date: Wed, 5 Feb 2014 14:42:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, rientjes@google.com,
        akpm@linux-foundation.org, penberg@kernel.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <20140205195837.GA6857@home.goodmis.org>
Message-ID: <alpine.DEB.2.10.1402051439100.23701@nuc>
References: <52F1F25F.20402@parallels.com> <1391588133-15469-1-git-send-email-vdavydov@parallels.com> <20140205195837.GA6857@home.goodmis.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Steven Rostedt wrote:

> Really? We are adding a spin lock for a case where it is not needed just to
> quiet lockdep?

Well its a very rarely used code path. Doesnt matter performance wise
since a slab cache should have no objects when its going to be removed.

> Now if it really isn't needed, then why don't we do the following instead of
> adding the overhead of taking a lock?
>
> static inline
> __remove_partial(struct kmem_cache_node *n, struct page *page)
> {
> 	list_del(&page->lru);
> 	n->nr_partial--;
> }
>
> static inline remove_partial(struct kmem_cache_node *n,
> 			     struct page *page)
> {
> 	lockdep_assert_held(&n->list_lock);
> 	__remove_partial(n, page);
> }
>
> And then just call __remove_partial() where we don't need to check if the
> lock is held or not with a big comment to it.
>
> That, IMNSHO, is a much better solution

Ok with me. It just adds another variant of remove_partial.

