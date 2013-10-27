Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3J0ThV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:37:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3J0ThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:37:20 -0400
Message-ID: <526D6B6D.2000605@canonical.com>
Date: Sun, 27 Oct 2013 20:37:17 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
References: <20131026121902.GA24890@gmail.com>	<CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>	<526D62D8.8050001@canonical.com> <CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
In-Reply-To: <CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 27-10-13 20:23, Linus Torvalds schreef:
> On Sun, Oct 27, 2013 at 12:00 PM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> op 27-10-13 18:28, Linus Torvalds schreef:
>>> That expression is largely equivalent to
>>> "__builtin_constant_p(ww_ctx)" (because iff ww_ctx is constant, then
>>> the comparison to NULL is constant), which is actually much easier to
>>> read, while carrying a totally different semantic meaning. Making
>>> things worse, the comparison to NULL *may* be marked constant under
>>> some very random situations (ie the compiler could turn a "taking an
>>> address of a variable is never NULL" kind of knowledge and combining
>>> it with other knowledge, and turn a complicated "ctx" expression into
>>> a "I know this cannot be NULL" thing, and thus the "== NULL" is a
>>> constant, even though ctx itself is some dynamic calculation).
>>>
>>> Whoever wrote the original should be shot. And this commit shouldn't
>>> have been marked as being somehow about gcc-version dependence, but
>>> about removing completely crap code.
>>>
>> Unfortunately gcc disagreed there, which was another compiler bug.
> Stop this idiotic "blame gcc bug" crap. Which part of my explanation
> for why it was *NOT* a compiler bug did you not understand?
>
>> __builtin_constant_p(ww_ctx) was NOT equal to __builtin_constant_p(ww_ctx == NULL), iirc.
> See my "largely equivalent" comment, with the *EXTRA* logic that gcc
> may actually find cases where the comparison is a constant even if the
> ww_ctx thing itself isn't a constant.
Sure in the theoretical case it's possible.
>>  __builtin_constant_p(ww_ctx == NULL) is equal to __builtin_constant_p(ww_ctx != NULL), but
>> the former is more readable, since it shows we expect ww_ctx to be null.
> Stop the f*cking around already! The  whole "we expect ww_ctx to be
> null" thing shows that YOU DO NOT SEEM TO UNDERSTAND WHAT THE TEST
> ACTUALLY IS!
>
> The expression
>
>    __builtin_constant_p(ww_ctx == NULL)
>
> has ABSOLUTELY NOTHING to do with whether ww_ctx is NULL or not!
> Christ, can you really not understand that?
I'm fully aware, I just think the compiler cannot know that the address is always non-null for a generic function that takes an argument and isn't inlined.

> For example, ww_ctx could be "&static_variable", and the compiler can
> - and some compiles _will_ - say that ww_ctx clearly cannot be NULL,
> so "ww_ctx == NULL" is 0, which is a constant, so the
> __builtin_constant_p() expression returns true. See? That expression
> has absolutely NOTHING to do with whether you passed in NULL or not.
> NOTHING.
but __ww_mutex_lock isn't inlined..
> That __builtin_constant_p() tests whether the comparison is
> *CONSTANT*. And "0" is just as much a constant as "1" is. Really. So
> the whole f*cking expression is total and utter crap, because it is
> entirely and utterly senseless. It lacks all meaning. It's not
> actually testing for NULL at all. Never was, never will.
>
> The *ONLY* thing it is testing for is "how much can the compiler
> optimize this", and as such the *ONLY* thing it tests for is compiler
> differences.
>
> Really. Seriously. If you start blaming the compiler for different
> compilers giving different results, the only thing *that* shows is
> that you didn't understand the expression to begin with.
>
>> But yeah I guess it was too broken in gcc after all, so that's why it had to be killed altogether.
> NO NO NO NO. No a f*cking thousand times. It's not "too broken in
> gcc". It's too broken in the source code, and the fact that you don't
> even understand that is sad. You wrote the code, and you seem to be
> unable to admit that *your* code was buggy.
>
> It's not a compiler bug. It's your bug. Stand up like a man, instead
> of trying to flail around and blame anything else but yourself.
>
> So guys, get your act together, and stop blaming the compiler already.
I never denied my original code didn't contain bugs, which is why I wrote that fix. I just don't believe gcc
will ever be smart enough to determine that ww_ctx is a non-null argument in all calls to __ww_mutex_lock,
and then determine for that reason ww_ctx != NULL would be an invariant.

I would love for a compiler to become that smart though, but I do not think it's likely.

But hey it was a bug, my code was buggy and I helped by suggesting how to write the correct fix.

~Maarten

