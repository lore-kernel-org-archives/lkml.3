Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3CCTc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 14:32:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59474 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3CCTcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 14:32:25 -0500
Date: Sun, 3 Mar 2013 19:32:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] making vfree() safe from interrupt contexts
Message-ID: <20130303193223.GN4503@ZenIV.linux.org.uk>
References: <20130303184736.GM4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130303184736.GM4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 06:47:36PM +0000, Al Viro wrote:
> 	To bring back the thing discussed back in, IIRC, December: we have
> a bunch of places where inability to do vfree() from interrupt contexts
> (the most common case is doing that from RCU callback) leads to very
> ugly open-coded schemes that delay it one way or another.  We can let vfree()
> itself do that instead.  AFAICS, it works; the diff below covers several
> obvious cases found just by grep.  I'm fairly sure that there's more code
> that could benefit from that...
> 
> 	I'm not sure which tree should it go through, though.  Suggestions?
> The reason I'm interested in this sucker is the mess in fs/file.c (fdtable
> freeing), but the main change here is in mm/vmalloc.c...
> 
> 	Note that the patch obviously ought to be split - mm/vmalloc.c
> part, allowing vfree() in interrupt contexts (current mainline has
> BUG_ON() triggered in that case) and a chunk for each ad-hoc vfree()
> deferral scheme killed.
> 
> 	Comments?

BTW, looking a bit more shows another place that might benefit from that -
kernel/events/ring_buffer.c:rb_free_work() is called via schedule_work()
and I don't see anything in it besides vfree() that would demand that
kind of treatment.
