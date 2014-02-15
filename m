Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaBOQ76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 11:59:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53250 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaBOQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 11:59:57 -0500
Date: Sat, 15 Feb 2014 16:59:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215165951.GB18016@ZenIV.linux.org.uk>
References: <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140213174020.GA14455@redhat.com>
 <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
 <20140215052531.GX18016@ZenIV.linux.org.uk>
 <20140215142700.GA15540@redhat.com>
 <20140215152251.GY18016@ZenIV.linux.org.uk>
 <20140215153631.GZ18016@ZenIV.linux.org.uk>
 <20140215155838.GA18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215155838.GA18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 03:58:38PM +0000, Al Viro wrote:

> BTW, I really wonder how does that stuff interact with PTRACE_SETSIGINFO.
> What happens if tracer does PTRACE_GETSIGINFO, changes ->si_signo to
> something blocked, shoves it back with PTRACE_SETSIGINFO and does
> PTRACE_CONT with that new signal number?  Would we get two sigqueue instances
> with the same ->si_tid, one of them matching the timer->sigq and another
> - not?

I wonder if it would be simpler to use the pointer *only* for si_code < 0
case.  It still gives us ksiginfo_t much smaller than siginfo_t, avoids
all the mess with timers and AFAICS results in less intrusive patch.
IOW, the split between "we know what that sucker is" and "completely
opaque shit the userland has given us".

I'll try to put together something along those lines and see how well does
that work...
