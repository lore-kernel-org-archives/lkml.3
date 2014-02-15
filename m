Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaBOSF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:05:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53440 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaBOSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:05:26 -0500
Date: Sat, 15 Feb 2014 18:05:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215180520.GC18016@ZenIV.linux.org.uk>
References: <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140213174020.GA14455@redhat.com>
 <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
 <20140215052531.GX18016@ZenIV.linux.org.uk>
 <20140215142700.GA15540@redhat.com>
 <20140215152251.GY18016@ZenIV.linux.org.uk>
 <20140215153631.GZ18016@ZenIV.linux.org.uk>
 <20140215155838.GA18016@ZenIV.linux.org.uk>
 <20140215174345.GA24799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215174345.GA24799@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 06:43:45PM +0100, Oleg Nesterov wrote:
> > So basically we want a different condition for "can we just go ahead and
> > free that sucker", right?  Instead of "it's on the list, shan't free it"
> > it ought to be something like "it's on the list or it is referenced by
> > ksiginfo".  Locking will be interesting, though... ;-/
> 
> I guess yes... send_sigqueue() checks list_empty() too, probably nobody else.

The trouble being, we might end up with
	Q picked by collect_signal and and stuff into ksiginfo
	Q resubmitted by timer code
	Q picked by *another* thread into its ksiginfo
	the first thread finally done with signal
and at that point we still have a reference in the second thread's ksiginfo.
Hell knows - my first reflex in that kind of situation is to replace
that flag with refcount, so that timer code would hold a reference from
timer_create(2) to timer_delete(2), send_sigqueue() would bump it and
dismiss_siginfo() - drop the sucker.  But that means either grabbing
siglock in dismiss_siginfo() or making the counter atomic; either way
it's a cacheline ping-pong.  Atomic counter is less painful in that respect -
it would be right next to the list, so we dirty that cacheline anyway...

I'm still trying another approach (slightly bigger ksiginfo used to store
all variants with si_code >= 0), but it has messiness of its own; we'll
see how it goes...
