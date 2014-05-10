Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaEJODH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:03:07 -0400
Received: from ns.horizon.com ([71.41.210.147]:16108 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756798AbaEJODF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:03:05 -0400
Date: 10 May 2014 10:03:04 -0400
Message-ID: <20140510140304.15690.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tj@kernel.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
In-Reply-To: <20140510122309.GB4721@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for the feedback!

> On Fri, May 09, 2014 at 11:13:56PM -0400, George Spelvin wrote:
>> +/**
>> + * glob_match - Shell-style pattern matching, like !fnmatch(pat, str, 0)
>> + * @pat: Pattern to match.  Metacharacters are ?, *, [ and \.
>> + *       (And, inside character classes, !, - and ].)

> @ARG lines should be contained in a single line.  Just "Pattern to
> match." should do.  With detailed description in the body.

Huh, Documentation/kernel-doc-nano-HOWTO.txt (lines 57-59, to be precise)
implies otherwise pretty strongly.  But I can certainly change it.

> Just adding glob.o to lib-y should be enough.  It will be excluded
> from linking if unused.

Will that work right if the caller is a module?  What will it get linked
into, the main kernel binary or the module?

A significant and very helpful simplification; I just want to be sure
it works right.

>> +#ifdef UNITTEST
>> +/* To do a basic sanity test, "cc -DUNITTEST glob.c" and run a.out. */
>> +
>> +#include <stdbool.h>
>> +#define __pure __attribute__((pure))
>> +#define NOP(x)
>> +#define EXPORT_SYMBOL NOP	/* Two stages to avoid checkpatch complaints */

> These things tend to bitrot.  Let's please keep testing harness out of
> tree.

Damn, when separated it bitrots a lot faster.  That's *is* my testing
harness, and I wanted to keep it close so it has a chance on hell of
being used by someone who updates it.

Especially given that the function's interface is quite rigidly defined,
do you really think there will be a lot of rot?

> Do we make library routines separate modules usually?

A large number of files in lib/ are implemented that way (lib/crc-ccitt.c,
just for one example), and that's what I copied.  But if I just do the
obj-y thing, all that goes away

>> +bool __pure
>> +glob_match(char const *pat, char const *str)
>
> The whole thing fits in a single 80 column line, right?
> 
> bool __pure glob_match(char const *pat, char const *str)

Whoops, a residue of my personal code style.  (I like to left-align
function names in definitions so they're easy to search for with ^func.)
But it's not kernel style.  Will fix.

>> +{
>> +	/*
>> +	 * Backtrack to previous * on mismatch and retry starting one
>> +	 * character later in the string.  Because * matches all characters
>> +	 * (no exception for /), it can be easily proved that there's
>> +	 * never a need to backtrack multiple levels.
>> +	 */
>> +	char const *back_pat = 0, *back_str = back_str;

> Blank line here.

I had considered the "/*" start of the following block comment as visually
enough separation between variable declarations and statements, but sure,
I can add one.

> I haven't delved into the actual implementation.  Looks sane on the
> first glance.

That's the part I'm least worried about, actually.

> Again, I don't really think the userland testing code belongs here.
> If you want to keep them, please make it in-kernel selftesting.  We
> don't really want to keep code which can't get built and tested in
> kernel tree proper.

I'll see if I can figure out how to do that.  Simple as it is, I hate to
throw away regression tests.

Thank you very much.
