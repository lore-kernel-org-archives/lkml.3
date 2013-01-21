Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3AUCjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:39:32 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46692 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3AUCjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:39:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130121023010.GR4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com> <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk> <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
 <20130121012217.GQ4939@ZenIV.linux.org.uk> <CA+55aFwG2j_+2pjUJuZqT1yk0xDEyeFMgCxHmxAzfGXHO5qCXQ@mail.gmail.com>
 <20130121023010.GR4939@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 18:39:09 -0800
X-Google-Sender-Auth: 43HJTW99k4LINGfjKG5maosVv08
Message-ID: <CA+55aFwPM3qWE7F7nwUVKphVTJb7WE7zPF5artdVw7Xq5Z1UgQ@mail.gmail.com>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 6:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Neither do I, to be honest.  It might be saving us a few cycles on
> some architectures, but I'd like to see examples of that.  amd64
> doesn't seem to be one, at least...

I think that the inlining of the body should make it basically be
pretty much free even on architectures that would want to do something
about the casts.

.. and thinking about it, the architectures that do actually generate
code for casting to a narrower type should already have selected that
HAVE_SYSCALL_WRAPPERS option anyway, so the only reason *not* to
select it is for a n architecture that doesn't generate any extra
code.

And right now, that HAVE_SYSCALL_WRAPPERS does make it much harder to
think about the header file changes.

> FWIW, there's another bit of ugliness around that area - all these
> #define __SC_BLAH3, etc., all of the same form.  This stuff begs for
> something like
> #define __MAP1(m,t,a) m(t,a)
> #define __MAP2(m,t,a,...) m(t,a) __MAP1(m,__VA_ARGS__)
> #define __MAP3(m,t,a,...) m(t,a) __MAP2(m,__VA_ARGS__)
> #define __MAP4(m,t,a,...) m(t,a) __MAP3(m,__VA_ARGS__)
> #define __MAP5(m,t,a,...) m(t,a) __MAP4(m,__VA_ARGS__)
> #define __MAP6(m,t,a,...) m(t,a) __MAP5(m,__VA_ARGS__)
> #define __MAP(n,...) __MAP##n(__VA_ARGS__)
> with __MAP(x,__SC_DECL,__VA_ARGS__) instead of __SC_DECL##x(__VA_ARGS__)
> etc. in users...

Well, I can see both sides. The above is the nice and dense
declaration model with less duplication, but christ, it's hard for
people to wrap their minds around unless they've seen it a million
times. It really does take some getting used to, and the long-form can
be easier to understand.

That said, we have so many of those things now when it comes to the
syscall stuff that the dense form seems to be called for just to be
consistent.

So go wild if you have the energy for it. I'm not going to pull that
for 3.8, though.

                 Linus
