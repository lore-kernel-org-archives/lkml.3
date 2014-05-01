Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaEAOfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:35:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55790 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEAOfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:35:09 -0400
Date: Thu, 1 May 2014 15:34:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140501143434.GA18016@ZenIV.linux.org.uk>
References: <20140430211206.GU18016@ZenIV.linux.org.uk>
 <20140430221238.GV18016@ZenIV.linux.org.uk>
 <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
 <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
 <20140430234341.GX18016@ZenIV.linux.org.uk>
 <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
 <20140501025105.GY18016@ZenIV.linux.org.uk>
 <CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
 <20140501031251.GZ18016@ZenIV.linux.org.uk>
 <20140501094252.GE3113@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501094252.GE3113@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:42:52AM +0200, Miklos Szeredi wrote:
> Two points about latest version (dentry_kill-2):
> 
> - Doing anything with dentry->d_parent in case of DCACHE_DENTRY_KILLED looks
>   seriously wrong.  Parent has been dealt with, at that point, by the other
>   caller, no?

In both branches, actually - we should bugger off earlier *and* return NULL
in that case.  Nice catch.

Hmm... I see why it failed to blow up on that.  It *did* trigger, all right -
udev is stepping into that right on boot.  The thing is, check should be
	if ((int)dentry->d_lockref.count > 0)
since the damn thing is unsigned int.  IOW, they did go through handover
and shrink_dentry_list() proceeded to lose them.  And with that braino
fixed, it steps into the extra dput crap just fine.

OK, fixed and pushed (both branches).

> - "bool foo = flag & FLAG" looks suspicious.  Is this guaranteed not to
>   overflow?

What do you mean, overflow?  It's not a 1-bit unsigned int; conversion to
_Bool is different (which is the only reason why it's more than mere
syntax sugar).  See C99 6.3.2.1 ("When any scalar value is converted
to _Bool, the result is 0 if the value compares equal to 0; otherwise,
the result is 1").

That, BTW, is also the reason why _Bool bitfields exist - try
struct {
	_Bool a:1;
	unsigned b:1;
} x;
x.a = 2;
x.b = 2;
if (x.a)
	printf("A");
if (x.b)
	printf("B");
and see what it does.  The first test triggers, same as if (2) would.
The second does not, since conversion to unsigned integer type other
than _Bool gives the value in range of that type comparable to original
modulo (maximal representable + 1).  And 2 modulo 2 is 0...
