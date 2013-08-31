Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3HaRQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 13:16:55 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:34064 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3HaRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 13:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130831030633.28455.qmail@science.horizon.com>
References: <20130831030633.28455.qmail@science.horizon.com>
Date: Sat, 31 Aug 2013 10:16:52 -0700
X-Google-Sender-Auth: ZeurL6RMxyZaD0nxedwKLwHljkg
Message-ID: <CA+55aFz7k5zUvJdZxpZgCgfx_-PT+f-9J50hnC1i3x=8_dXkBw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <waiman.long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 8:06 PM, George Spelvin <linux@horizon.com> wrote:
> Just noticing that you are adding several functions that return a boolean
> value as an int.  And a "gotref" local variable.
>
> Is that just not wanting to bother with thse newfangled C99 innovations,
> or do you dislike the "bool" type for some reason?

I don't use "bool" in code I write. I don't think it adds any actual
value, and I think the data type is badly designed and of dubious
value in C. It has very few actual advantages.

That said, it's not like I *hate* the type, and I won't remove bool
from code other people write. I just think it's superfluous and
stupid, and another case of C++ people thinking too much "this is a
cool feature" without then actually doing it well. The C people then
picked it up because it was less onerous than some other C++ features,
and all the compilers had the logic anyway.

If "bool" had real advantages (like having a dense array
representation, for example), that would be one thing. It doesn't.
Sure, now you can take an address of a bool (which you couldn't
generally do efficiently if it really was a bit array), but it also
means that in practice, "bool" is normally nothing but "char" with
some really odd and special implicit type casting rules.

I doubt most people really even understand how "bool" casting works.

And bool is actually really *dangerous* to use if you don't understand
it. There are people who use "bool", but then because they want to be
portable, they have a compatibility #ifdef or other configuration
thing that does something like

   typedef int bool;
   #define true 1
   #define false 0

and it will actually work. Most of the time. And then the semantic
differences from a _real_ C compiler that supports the C99 _Bool/bool
type are really really subtle.

IOW, bool has very few real upsides, and it has a real downside: it's
subtle, and people really never even seem to _realize_ just how subtle
it is.  I suspect that if you ask ten random average C programmers if
the above is equivalent to stdbool.h, nine of them will say "sure".

And they'd be *COMPLETELY* wrong.

So no. I'm definitely not a fan of bool. I think there are better
types, and I think there are better ways to document things.

                     Linus
