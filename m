Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab3B0S0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:26:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab3B0S0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:26:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFyGr5J2nPwgbX9U_6WPnwnQ6t2AKpnoxrEqerM5Yv+WqA@mail.gmail.com>
References: <CA+55aFyGr5J2nPwgbX9U_6WPnwnQ6t2AKpnoxrEqerM5Yv+WqA@mail.gmail.com> <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org> <20121119072525.GA16730@core.coreip.homeip.net> <CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com> <CA+55aFysXNSJMHL-rKZ_fvPP3t357zTC-6hyHmh=S6K-Qx0WbQ@mail.gmail.com> <512E4954.6060601@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dave Airlie <airlied@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arve@android.com, kernel-team@android.com,
        John Stultz <john.stultz@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in sysRQ
Date: Wed, 27 Feb 2013 18:26:18 +0000
Message-ID: <8629.1361989578@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Your fix is compiling, running and yielding the correct results -
> > apologies about that.
> >
> > Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Ok, good. Committed and pushed out. Adding rmk and dhowells to the cc
> just to let them know, since Dave said they were debugging this on
> irc.

Seems reasonable to me.  After dissecting stuff this morning, we noted that
the code dump in the oops shows that the MOV insn that gets the value to test
does not load 0.

The first five bytes of:

	ba 00 00 40 ff | 31 c0 | 8b 1d 0c 0e a0

correspond to this:

	mov $0xff400000,%edx

when the linker should've made it this:

	mov $0x00000000,%edx

I suspect that the number may be some metadata reference that didn't get
substituted.

Dave Airlie tried disassembling his vmlinux with gdb - and that apparently did
show a load of 0, but the EIP in his oops doesn't match the addresses from
gdb's disassembly - so I'm not sure what's happening there.

In the oops, the %cr2 value was 0xff400000, but the offending instruction
bytes of the actual faulting instruction in the code dump were cropped by his
photo of the screen.

David
