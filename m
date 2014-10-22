Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbaJVUIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:08:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaJVUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:08:50 -0400
Date: Wed, 22 Oct 2014 16:08:45 -0400 (EDT)
Message-Id: <20141022.160845.1338578429923954456.davem@davemloft.net>
To: oleg@redhat.com
Cc: peterz@infradead.org, cl@linux.com, tkhai@yandex.ru, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, vdavydov@parallels.com
Subject: Re: introduce probe_slab_address?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141022194228.GA10995@redhat.com>
References: <20141022181412.GA8159@redhat.com>
	<20141022.145950.1585224138048242923.davem@davemloft.net>
	<20141022194228.GA10995@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Oct 2014 13:08:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>
Date: Wed, 22 Oct 2014 21:42:28 +0200

> Now the question: is this LOAD is safe in case when this (freed) page
> already has another mapping? This is black magic to me, I do not know.
> And Peter has some concerns.

It is immatieral, because you can read garbage and it's "don't care"
in this context.

And later if it is used again at this virtual address, it will be
initialized with stores at that virtual address first.

So no problem.

> And, say, copy_from_user_page() on sparc does
> 
> 	flush_cache_page();
> 	memcpy();
> 	flush_ptrace_access();

In this case, as I tried to explain, it matters because the physical
address is being accessed from two virtual address at the same time
"for the same usage".

That's what distinguishes this from the SLAB and RCU cases you cite.

Illegal aliases only matter within a specific usage of a piece of
memory.

So if a page is mapped into userspace, and we touch the kernel side
PAGE_OFFSET alias mapping of it, we can have problems.  And that is
what is happening in the ptrace case above.

But if we are using the page later in SLAB, the previous userspace
mapping will not cause problems wrt. aliasing.  It cannot, because
once SLAB gets the page it will initialize it at the new virtual
address.
