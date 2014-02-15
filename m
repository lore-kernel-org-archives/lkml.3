Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaBOSpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:45:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbaBOSph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:45:37 -0500
Date: Sat, 15 Feb 2014 19:45:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215184531.GA27314@redhat.com>
References: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com> <20140213174020.GA14455@redhat.com> <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com> <20140215052531.GX18016@ZenIV.linux.org.uk> <20140215142700.GA15540@redhat.com> <20140215152251.GY18016@ZenIV.linux.org.uk> <20140215153631.GZ18016@ZenIV.linux.org.uk> <20140215155838.GA18016@ZenIV.linux.org.uk> <20140215174345.GA24799@redhat.com> <20140215180520.GC18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215180520.GC18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Al Viro wrote:
>
> On Sat, Feb 15, 2014 at 06:43:45PM +0100, Oleg Nesterov wrote:
> > > So basically we want a different condition for "can we just go ahead and
> > > free that sucker", right?  Instead of "it's on the list, shan't free it"
> > > it ought to be something like "it's on the list or it is referenced by
> > > ksiginfo".  Locking will be interesting, though... ;-/
> >
> > I guess yes... send_sigqueue() checks list_empty() too, probably nobody else.
>
> The trouble being, we might end up with
> 	Q picked by collect_signal and and stuff into ksiginfo
> 	Q resubmitted by timer code

In this case the timer code should simply inc ->si_overrun and do nothing.

IOW, list_empty() should be turned into is_queued(), and is_queued()
should be true until dismiss_siginfo() which should also do
do_schedule_next_timer(). I think.

Oleg.

