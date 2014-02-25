Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaBYJPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:15:10 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45212 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBYJPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:15:07 -0500
Date: Tue, 25 Feb 2014 10:14:52 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] time: Improve negative offset handling in
 timekeeping_inject_offset
Message-ID: <20140225091451.GA5024@netboy>
References: <1393019430-13200-1-git-send-email-john.stultz@linaro.org>
 <alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 11:54:35PM +0100, Thomas Gleixner wrote:
> To be honest, it's not the prettiest thing, but timespec is not pretty
> to begin with.

yes...

> Sure our normalize function can cope with that, but where is the
> point?

and yes...

> Now if we allow that we also need to allow
> 
>         5, -987654321
> 
> versus
> 
> 	4,   12345679
> 
> It's all unreadable in one way or the other. 

and again yes...

> Aside of that, if we allow that for adjtimex, then how do we argue the
> restriction on all other timespec related interfaces?

(John already heard my opinion off list, but I would so much like to
state it again ;)

The timespec was already an ugly thing, even before we added the
ADJ_SETOFFSET. Our addition means that timespecs can also be negative
values, but no matter how you define it, someone will think another
way is more natural.

When implementing the clock shifting code in linuxptp, I simply followed
the existing "rule" that tv_nsec is non-negative, and so that program
just normalizes the timespec to make the kernel happy.

I think we should just leave the kernel/user interfaces as is because,

1. Applications can deal with the "rule" as is. It isn't hard. After
   all, making the clock jump is an unusual thing to do in any case.
2. The "rule" is consistent with existing posix interfaces.
3. The kernel actually outputs timespecs in this way.

When I first looked at this from the user space POV, I took the
trouble to shift the clock back before 1970 in order to watch the
kernel timespecs counting down (or up?). Yes, it is weird, but the
nanoseconds field decreases as time goes forward.

[ You used to be able to do this before:
  4e8b1452 "time: Improve sanity checking of timekeeping inputs" ]

My two Euro-Cents,
Richard
