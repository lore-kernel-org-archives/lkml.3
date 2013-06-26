Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3FZVWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:22:25 -0400
Received: from one.firstfloor.org ([193.170.194.197]:38878 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3FZVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:22:23 -0400
Date: Wed, 26 Jun 2013 23:22:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
Message-ID: <20130626212221.GI6123@two.firstfloor.org>
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
 <1372268603-46748-2-git-send-email-Waiman.Long@hp.com>
 <20130626201713.GH6123@two.firstfloor.org>
 <51CB57F6.6010003@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB57F6.6010003@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 05:07:02PM -0400, Waiman Long wrote:
> On 06/26/2013 04:17 PM, Andi Kleen wrote:
> >>+ * The combined data structure is 8-byte aligned. So proper placement of this
> >>+ * structure in the larger embedding data structure is needed to ensure that
> >>+ * there is no hole in it.
> >On i386 u64 is only 4 bytes aligned. So you need to explicitely align
> >it to 8 bytes. Otherwise you risk the two members crossing a cache line, which
> >would be really expensive with atomics.
> 
> Do you mean the original i386 or the i586 that are now used by most
> distribution now? If it is the former, I recall that i386 is now no
> longer supported.

I mean i386, as in the 32bit x86 architecture.

> 
> I also look around some existing codes that use cmpxchg64. It
> doesn't seem like they use explicit alignment. I will need more
> investigation to see if it is a real problem.

Adding the alignment is basically free. If 32bit users don't enforce
it they're likely potentially broken yes, but they may be lucky.
> >>+	get_lock = ((threshold>= 0)&&  (old.count == threshold));
> >>+	if (likely(!get_lock&&  spin_can_lock(&old.lock))) {
> >What is that for? Why can't you do the CMPXCHG unconditially ?
> 
> An unconditional CMPXCHG can be as bad as acquiring the spinlock. So
> we need to check the conditions are ready before doing an actual
> CMPXCHG.

But this isn't a cheap check. Especially spin_unlock_wait can be 
very expensive.

And all these functions have weird semantics. Perhaps just a quick
spin_is_locked.

> 
> Looking from the other perspective, we may want the locking code to
> have the same behavior whether spinlock debugging is enabled or not.
> Disabling the optimization will cause the code path to differ which
> may not be what we want. Of course, I can change it if other people
> also think it is the right way to do it.

Lock debugging already has quite different timing/lock semantics.

-Andi
