Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab3IAIuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 04:50:55 -0400
Received: from science.horizon.com ([71.41.210.146]:63624 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755298Ab3IAIuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 04:50:52 -0400
Date: 1 Sep 2013 04:50:49 -0400
Message-ID: <20130901085049.21748.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless update of refcount
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, waiman.long@hp.com
In-Reply-To: <CA+55aFz7k5zUvJdZxpZgCgfx_-PT+f-9J50hnC1i3x=8_dXkBw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If "bool" had real advantages (like having a dense array
> representation, for example), that would be one thing. It doesn't.
> Sure, now you can take an address of a bool (which you couldn't
> generally do efficiently if it really was a bit array), but it also
> means that in practice, "bool" is normally nothing but "char" with
> some really odd and special implicit type casting rules.

Huh.  For me, the big advantage is, to paraphrase Michael Palin, that
the number of possible values is two, no more, and no less.  Two is
the number of possibilities, and the number of possibilities is two.
Three is Right Out.

I agree that as a *storage* type (in a data structure), it's of limited
usefulness.  But as a *parameter* type, to pass to and return from
functions, it's wonderful.

There are lots of naming conventions (like the word "flag", or a function
name starting with "is") to indicate that the return value is a simple
true/false, but declaring it that way provides compile-time checking.

> I doubt most people really even understand how "bool" casting works.

There's a reason for that; you rarely need to cast to bool, and you
could forbid it outright with very little impact on bool's usefulness.
What fraction of C programmers remember off the top of their heads that
casting from float to integer rounds toward zero?

Heck, if you asked me which conversions were defined and which were
undefined, I'd have to look it up.  (I'd guess it's the same as the
different overflow rules for signed and unsigned types, but I'd have
to check.)

The place bool is most useful is control flow flags and other things
where all you're doing is assigning literal values and testing it.  And,
if you want to get fancy, assigning to bool variables from boolean-valued
expressions like "flag = value >= limit;"


That said, I agree that the fact that 2 != (bool)2 is a bit subtle, but
doesn't that basic problem apply to *any* narrowing cast?  (And thus,
is not really an *additional* subtlety that a progammer needs to learn
about.)  And in this case, I can't really think of a *better* choice
that could have been made.

I can only see three plausible alternatives:

1) Use the lsbit, (bool)x == x & 1
2) Use zero/nonzero, and make (bool)x == !!x
3) Forbid casting to bool entirely.

Option 1 matches all other narrowing casts in C, and would be how I'd
expect a "bit" type to work.

Option 2 is how C conditional statements already work, so for any value x,
"if (x)" is the same as "if ((bool)x)".  It's a rule that C programmers
already need to know; they only need to know to *apply* it in this one
extra case.

In fact, it arguably makes things *simpler* to explain, since it at least
gives a name to the magic that C condition expressions are subject to.

Option 3 is attractive, but ends up breaking the analogy to conditional
expressions.  I'd recommend it as a coding style, however.

> And bool is actually really *dangerous* to use if you don't understand
> it. There are people who use "bool", but then because they want to be
> portable, they have a compatibility #ifdef or other configuration
> thing that does something like
>
>   typedef int bool;
>   #define true 1
>   #define false 0
>
> and it will actually work. Most of the time. And then the semantic
> differences from a _real_ C compiler that supports the C99 _Bool/bool
> type are really really subtle.

But *all* of the subtleties arise when casting other types to bool.
If you just avoid that one thing (which it's hopefully obvious won't be
faithfully emulated by a compatibility kludge anyway), it all goes away.

And this rule is itself just a special case of "be very careful with
narrowing casts", which is already common wisdom.

For that kludge, I think a better equivalent would be

typedef enum { false, true } bool;

which at least communicates the idea (again, this is an annoying sutlety
that C programmers *already* have to deal with, so no additional cognitive
effort) that "the compiler might not catch you assigning out-of-range
values, but if you do, demons might fly out of your nose."


Anyway, thanks for sharing your opition.  To me, it just looked like exactly
the sort of code where the bool type was a natural fit.
