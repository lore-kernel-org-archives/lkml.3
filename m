Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaLHT2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:28:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaLHT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:28:20 -0500
Date: Mon, 8 Dec 2014 19:28:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
Message-ID: <20141208192816.GH22149@ZenIV.linux.org.uk>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
 <20141208164650.GB29028@node.dhcp.inet.fi>
 <20141208175805.GB22149@ZenIV.linux.org.uk>
 <20141208180824.GC22149@ZenIV.linux.org.uk>
 <CA+55aFxwrH4vsyw2ix=HqDK9Z=fw98xtOL8=57prm8qgVmAFfA@mail.gmail.com>
 <20141208182012.GE22149@ZenIV.linux.org.uk>
 <CA+55aFxrrTV-xBbvEzVKsXRVKyvZhQZj-6BNDpTsG4J5k6CJEg@mail.gmail.com>
 <20141208184632.GG22149@ZenIV.linux.org.uk>
 <CA+55aFyh0cV+ztK47mu1QN6aF4VvPE1V5zF7_X2TdYxZ38zZRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyh0cV+ztK47mu1QN6aF4VvPE1V5zF7_X2TdYxZ38zZRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:57:31AM -0800, Linus Torvalds wrote:
> So the whole "get_page()" thing is broken. Iterating over pages in a
> KVEC is simply wrong, wrong, wrong. It needs to fail.

Well, _that_ is easy to do, of course...  E.g. by replacing that thing in
iov_iter_get_pages()/iov_iter_get_pages_alloc() with ({ return -EFAULT; })
will do it.

> Iterating over a KVEC to *copy* data is ok. But no page lookup stuff
> or page reference things.
> 
> The old code that apparently used "get_user_pages_fast()" was ok
> almost by mistake, because it fails on all kernel pages.

On x86 it does, but I don't see anything obvious in generic version in
mm/gup.c, so the old code might still have a problem on some architectures.
What am I missing here?
