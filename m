Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbaD3Xnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:43:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49611 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaD3Xno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:43:44 -0400
Date: Thu, 1 May 2014 00:43:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430234341.GX18016@ZenIV.linux.org.uk>
References: <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
 <20140430190227.GR18016@ZenIV.linux.org.uk>
 <20140430195918.GS18016@ZenIV.linux.org.uk>
 <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
 <20140430203823.GT18016@ZenIV.linux.org.uk>
 <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
 <20140430211206.GU18016@ZenIV.linux.org.uk>
 <20140430221238.GV18016@ZenIV.linux.org.uk>
 <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
 <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:14:14PM -0700, Linus Torvalds wrote:
> On Wed, Apr 30, 2014 at 4:04 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Let me go talk to the paravirt people. Maybe they don't need this, and
> > I don't know exactly *how* they use that lock pointer after the unlock
> > in the "kick waiters" part. Maybe it's all good.
> 
> .. looking at current users (xen and kvm) it does in fact look all
> good. Yes, we "kick" possible waiters after the unlock, but the lock
> itself is not touched by that, it just uses the pointer to the lock as
> a way to figure out who to kick.
> 
> In fact, I kind of knew that, but had forgotten. We very much depend
> on spin_unlock being safe wrt immediate deleton already: the
> "completion" code very much depends on it. It does a "spin_unlock()"
> to release the completion, and it can get reused immediately (it might
> be on the stack, it might be in some data structure that gets freed).
> 
> So I'd suggest removing that whole RCU thing, because it should be
> safe to unlock something that can go away immediately. We'd have huge
> problems elsewhere if it wasn't safe.

OK, done and force-pushed.  Should propagate in a few...
