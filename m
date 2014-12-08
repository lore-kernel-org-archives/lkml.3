Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaLHSUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:20:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59209 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaLHSUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:20:19 -0500
Date: Mon, 8 Dec 2014 18:20:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
Message-ID: <20141208182012.GE22149@ZenIV.linux.org.uk>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
 <20141208164650.GB29028@node.dhcp.inet.fi>
 <20141208175805.GB22149@ZenIV.linux.org.uk>
 <20141208180824.GC22149@ZenIV.linux.org.uk>
 <CA+55aFxwrH4vsyw2ix=HqDK9Z=fw98xtOL8=57prm8qgVmAFfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwrH4vsyw2ix=HqDK9Z=fw98xtOL8=57prm8qgVmAFfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:14:13AM -0800, Linus Torvalds wrote:

> For a vmalloc() address, you'd have to actually walk the page tables.
> Which is a f*cking horrible idea. Don't do it. We do have a
> "vmalloc_to_page()" that does it, but the basic issue is that you damn
> well shouldn't do IO on vmalloc'ed addresses.  vmalloc'ed addresses
> only exist in the first place to give a linear *virtual* mapping, if
> you want physical pages you shouldn't have mixed it up with vmalloc in
> the first place!
> 
> Where the hell does this crop up, and who does this insane thing
> anyway? It's wrong. How did it ever work before?

finit_module() with O_DIRECT descriptor.  And I suspect that "not well"
is the answer - it used to call get_user_pages_fast() in that case.

I certainly had missed that insanity during the analysis - we don't do
a lot of O_DIRECT IO to/from kernel addresses of any sort...  This
codepath allows it ;-/  Ability to trigger it is equivalent to ability
to run any code in kernel mode, so it's not an additional security hole,
but...
