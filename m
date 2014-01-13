Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaAMXa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:30:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45112 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaAMXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:30:12 -0500
Date: Mon, 13 Jan 2014 23:30:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: bug in sscanf()?
Message-ID: <20140113233006.GP10323@ZenIV.linux.org.uk>
References: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:57:29PM +0000, Allan, Bruce W wrote:
> The kernel version of sscanf() does not allow for scanning a string with multiple concatenated integers even when maximum field widths are specified to stop reading the string to delineate the individual integers.  For example, trying to read the (3) 32-bit hexadecimal integers deadbeef, 12345678 and deadc0de when provided as a concatenated string with:
> 
> 	int num;
> 	u32 i, j, k;
> 	
> 	num = sscanf("deadbeef12345678deadc0de", "%8x%8x%8x", &i, &j, &k);
> 
> will return the number of input items successfully matched and assigned as 3, the 32-bit integers j and k will have the expected values, but i will be 0.
> 
> The libc version of sscanf(), however, will set the value of i to deadbeef.
> 
> Should this be expected with the kernel version or is it a bug?

It's a bug, all right, and rather amusing one, at that.  What happens is
that vsscanf() does optimistic strtoul(), _then_ checks if we'd eaten more
than field_width characters, then essentially divides by base^overshot.
In your case it gets the last 16 digits from the string (the first 8 got lost
on overflow in simple_strtoul()) and proceeds to divide by 16^16 (aka 2^64),
discarding excessive digits it has eaten.  Which is to say, all that hadn't
been lost to overflow...  Next time we take the same last 16 digits (this time
- without overflows) and divides by 16^8, which yields the correct result.
The last one takes last 8 digits and doesn't bother with divisions at all -
again, correct result.

It's definitely a bug, introduced in commit 538097.  Behaviour prior to
that had also been buggy, but in a more straightforward way - width used to be
completely ignored, so this sscanf() call would've returned 1, with
i equal to 0x12345678deadc0de after it.  From commit message:
"   This is another step towards better standard conformance.  Rather than
    adding a local buffer to store the specified portion of the string (with
    the need to enforce an arbitrary maximum supported width to limit the
    buffer size), do a maximum width conversion and then drop as much of it as
    is necessary to meet the caller's request."

This "drop as much of it as necessary" is where it went wrong; we are dealing
with finite-width type...

FWIW, there's enough weirdness in userland sscanf() - handling of overflows
is, er, underspecified both in C99 and in C11.  Userland implementations
tend to fail conversion with ERANGE in errno if the value wouldn't fit
into intmax_t/uintmax_t and silently downcast in other cases, but according
to ANSI C it's all nasal daemon territory, which makes the sucker rather
useless on unsanitized inputs...  As far as I understand the rationale is
more or less "if that happens on fscanf(3), you are fscked anyway - no
way to unread more than one character", which wouldn't apply to sscanf(3),
but since it's modelled after fscanf/scanf and not the other way round...

In any case, field width semantics *is* clear - conversion should act as if
there had been no input beyond that many characters.  Overflows or no
overflows, %8x should never step into one on targets where int is >= 32
bits.

Other fun there:
	* j is a valid size modifier, meaning intmax_t/uintmax_t.
Easily fixed - just turn it into 'L'.
	* %ln and friends are legitimate; the meaning of size modifier
is the same as for %d - next argument is treated as signed long * and
result is stored there.  Valid modifiers: h/hh/l/ll/j/z/t.  Again,
easily fixed - instead of buggering off in "if (*fmt == 'n')", put the
value into val.s, set is_sign to 1, decrement the assignment count to
balance the increment to be done downstream and jump to the handling of
modifiers.
	* we do not support wide chars (%lc, %ls) and floating point stuff.
Fair enough.
	* we do not support %[<scanset>] either.  OK, we'd lived without it
so far and there's not too many *scanf() users in the kernel.
	* our handling of %* assumes that input items cannot contain
whitespace; that's obviously not true for e.g. %*c.  While we are at it,
handling of %*d is also broken - "%*d%c" on "12345z" should, AFAICS, return 1
and store 'z'.  What we ought to do is remember whether there'd been a * and
skip the va_arg(), stores and increment of conversion count in handling of
'c', 's' and integer conversions past the switch.  Not pretty for %*n,
but that's a nasal daemon country anyway.
	* "%x%s" on "0xz".  AFAICS, we share a bug with glibc - split the
input into "0x" and "z" (correct from standard POV - "0x" is a prefix of
admissible string for %x) and pretend that conversion succeeded.  BTW,
FreeBSD splits into "0" and "xz" instead, which is not good for another
reason - fine for sscanf(), but scanf(3) would have to unget two characters
here and ANSI explicitly talks about consuming the longest prefix of a
matching string and failing conversion if that prefix doesn't match by
itself.  Not sure if we care about that mess...
	* leading '-' or '+' appears to be allowed on *all* integer input
items.  Yes, including %u et.al.  What standard says for %u is "Matches an
optionally signed decimal integer, whose format is the same as expected for
the subject sequence of strtoul function with the value 10 for the base
argument".  And yes, userland implementations will accept "-1" for "%u" and
convert it to ~0U.  The same goes for strtoul(3) and friends - basically,
they consider everything from -ULONG_MAX to ULONG_MAX as representable in
unsigned long.  Hell knows whether we want to allow that - kstrto...()
family has different calling conventions anyway, so it's hard to confuse for
strto...().  In principle, things like "-1" for %u are sometimes convenient...

I'm not sure what's the right approach here; the real PITA is overflow
semantics.  AFAICS, kernel-side there are only two sensible options -
fail the conversion (as if the string had been truncated at the point
before that input item) or silently convert the value, overflows or
no overflows.  We should honour the field width in any case, of course;
this bug is a separate story and it needs to be fixed.

What we obviously can't do is reporting details of overflow - errno doesn't
exist in the kernel and returning a negative value would confuse the hell
out of all callers.

How about the following semantics: the longest string no longer than
field width and matching a prefix of
	[-+]?(0[xX][0-9a-fA-F]*|[1-9][0-9]*|0[0-7]*) (for %i)
	[-+]?[0-9]* (for %d and %u)
	[-+]?[0-7]* (for %o)
	[-+]?[0-9a-fA-F]* (for %x)
is chosen.  If it doesn't match the regex by itself (e.g. "0x" for %i or
"-" for any of them), we fail the conversion.  If it does, the string
represents some integer (say, X).  The rest depends on the target type -
for signed ones we fail unless X is in range for that type (and store
X otherwise), for unsigned ones we fail unless |X| is in range (and store
X cast to the target type otherwise).

It's reasonably consistent and cheap to implement - we'd need a variant
of _parse_integer() that would take maximal length as explicit argument,
parse the sign right in vsscanf() and use that sucker to get the absolute
value.  Overflow of u64 => conversion failure, otherwise we need to compare
absolute_value - is_negative with limit for type, i.e. check if there are
non-zero bits beyond type_width - is_type_signed...

Comments?

I'll put together something along those lines once I dig myself from under
the pile of mail that had been growing since mid-December when I got sick ;-/
