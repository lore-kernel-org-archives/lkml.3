Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3AUCaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:30:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35698 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3AUCaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:30:13 -0500
Date: Mon, 21 Jan 2013 02:30:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20130121023010.GR4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
 <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk>
 <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
 <20130121012217.GQ4939@ZenIV.linux.org.uk>
 <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 05:40:28PM -0800, Linus Torvalds wrote:
> On Sun, Jan 20, 2013 at 5:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Anyway, that's a separate story - semctl(2) is going to be ugly, no matter
> > what we do, but the rest of those guys doesn't have to.  How about the
> > following (completely untested):
> 
> Hmm.  Looks like the RightThing(tm) to me.
> 
> The thing that stands out that I question the value of that
> HAVE_SYSCALL_WRAPPERS thing. Is there any reason we don't just make
> all architectures use it? What's the downside? I'm not sure I see the
> point of the non-wrapper version.

Neither do I, to be honest.  It might be saving us a few cycles on
some architectures, but I'd like to see examples of that.  amd64
doesn't seem to be one, at least...

FWIW, there's another bit of ugliness around that area - all these
#define __SC_BLAH3, etc., all of the same form.  This stuff begs for
something like
#define __MAP1(m,t,a) m(t,a)
#define __MAP2(m,t,a,...) m(t,a) __MAP1(m,__VA_ARGS__)
#define __MAP3(m,t,a,...) m(t,a) __MAP2(m,__VA_ARGS__)
#define __MAP4(m,t,a,...) m(t,a) __MAP3(m,__VA_ARGS__)
#define __MAP5(m,t,a,...) m(t,a) __MAP4(m,__VA_ARGS__)
#define __MAP6(m,t,a,...) m(t,a) __MAP5(m,__VA_ARGS__)
#define __MAP(n,...) __MAP##n(__VA_ARGS__)
with __MAP(x,__SC_DECL,__VA_ARGS__) instead of __SC_DECL##x(__VA_ARGS__)
etc. in users...
