Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaFZFIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:08:35 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52535 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaFZFIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:08:34 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 25 Jun 2014 22:08:24 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140626050824.GB1645@thin>
References: <20140625154629.GA21519@thin>
 <1403741107.28663.9.camel@joe-AO725>
 <20140626022448.GA22091@thin>
 <1403749983.7977.6.camel@joe-AO725>
 <20140626034430.GA22836@thin>
 <1403756211.7977.22.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403756211.7977.22.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 09:16:51PM -0700, Joe Perches wrote:
> On Wed, 2014-06-25 at 20:44 -0700, Josh Triplett wrote:
> > On Wed, Jun 25, 2014 at 07:33:03PM -0700, Joe Perches wrote:
> > > On Wed, 2014-06-25 at 19:24 -0700, Josh Triplett wrote:
> > > > On Wed, Jun 25, 2014 at 05:05:07PM -0700, Joe Perches wrote:
> > > > > On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> > > > > > Regardless of the long-standing debate over line width, checkpatch
> > > > > > should not warn about it by default.
> > > > > 
> > > > > I'm not getting involved here.
> > > > > I don't care much one way or another.
> > > []
> > > > I'm not asking you to get involved in the Great Line Length Debate;
> > > > that's why I didn't attempt to patch CodingStyle or similar.  However, I
> > > > think it makes sense for *checkpatch* to stop emitting this warning.
> > > 
> > > I think checkpatch should encourage people to write code in
> > > a style that matches CodingStyle as well as the predominant
> > > styles used in the rest of the kernel.
> > 
> > Not arguing with that, but in this particular case the warning seems
> > counterproductive to that goal, especially compared to the
> > DEEP_INDENTATION warning.  More subjective or "to taste" issues tend
> > to have lower severity in checkpatch.  And CodingStyle *already* says
> > "unless exceeding 80 columns significantly increases
> > readability"
> 
> Just some suggestions off the top of my head.
> 
> If the goal is to reduce long line lengths, then maybe
> more warnings or --strict tests for things like:

The goal is to make code more readable; a length guideline can help with
that, but a hard limit does more harm than good.  And notably, we don't
*have* a hard limit, we have a guideline; however, checkpatch routinely
gets treated as a hard requirement rather than a guideline, and as such
it should avoid tests that have a high false-positive rate, which
LONG_LINE does.

> long variable names: (pick a length)
> 
> 	some_long_variable_name_with_a_color

To avoid encouraging people to disemvowel their variables.  I'd suggest
flagging identifiers_with_too_many_words or IdentifiersWithTooManyWords
instead.

> consecutive dereferences where a temporary might be better:
> 
> 	foo->bar[baz].member1 = 1;
> 	foo->bar[baz].member2 = 2;

That one seems better done with coccinelle, actually.

> Multiple logical tests on a single line:
> 
> 	foo > bar && baz < quz && etc...

If any individual test takes up a significant number of columns, sure.

> Arguments after column 80
>                                                                                                    1
>          1         2         3         4         5         6         7         8         9         0
> 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
> 	result = some_long_function(some_arg(arg1, arg2), another_arg(arg3, arg4), 4);
> 
> where a single argument of a short length before a
> statement terminating ; may be ignored, but a longer
> argument list may not.

That one seems like one of the most common cases where the 80-column
rule can result in less readable code.  On the one hand, in the case
above, something like this would usually (but not always) improve the
code:

	result = some_long_function(
			some_arg(arg1, arg2),
			another_arg(arg1, arg2),
			4);

On the other hand, breaking within the arguments of some_arg or
another_arg seems completely and utterly wrong, and breaking around a
binary operator within the argument list would likewise make it painful
to read.  I've seen things like that in numerous patches. where a single
expression that would only take ~100ish characters gets broken across
half a dozen lines because it starts with a few tabs worth of
indentation and has moderate-length (but completely reasonable) names:

				result = sensible_function_name(
						sensible_variable_name,
						something(smallish)
							+ something_else,
						variable_name
							& ~SOME_BIT_NAME);

That seems far more readable if written as

				result = sensible_function_name(
						sensible_variable_name,
						something(smallish) + something_else,
						variable_name & ~SOME_BIT_NAME);

even though the last two lines extend past 80 characters.

Now, arguably the four leading tabs on those lines suggest the need for
some code refactoring; personally, I'd suggest changing DEEP_INDENTATION
to flag 4+ tabs rather than 6+ tabs as it currently does.  That would
mirror CodingStyle, which says "The answer to that is that if you need
more than 3 levels of indentation, you're screwed anyway, and should fix
your program."  To avoid flagging too much existing code that has >4
levels of indentation but short, simple code, I'd suggest specifically
matching lines that have >4 tabs *and* >80 columns, and flagging the
indentation as the cause of the problem rather than the >80 columns.

I'm going to try sending a patch that keeps the existing 80-column
warning, but changes the message and guidance based on the content of
the line.

> Long trigraphs:
> 
> 	should be on multiple lines

"trigraphs"?  Do you mean ternaries?  Yeah, that's a good case where if
the three components of the ternary together are too long, that's a
natural splitting point that shouldn't make the code less readable.

> Comments beyond 80 column

Yeah, that one makes sense: if you have a comment to the right of a long
line, and the comment is what's making it long, it's easy enough to move
the comment before the line.

- Josh Triplett
