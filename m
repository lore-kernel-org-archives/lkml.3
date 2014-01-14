Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaANCrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:47:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45231 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaANCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:47:31 -0500
Date: Tue, 14 Jan 2014 02:47:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: bug in sscanf()?
Message-ID: <20140114024725.GS10323@ZenIV.linux.org.uk>
References: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
 <20140113233006.GP10323@ZenIV.linux.org.uk>
 <CA+55aFy_V8ze2CPmHY0Ga-K-DX_SATVu-Tb=_nKq_1Rb5WqaUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy_V8ze2CPmHY0Ga-K-DX_SATVu-Tb=_nKq_1Rb5WqaUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 07:22:49AM +0700, Linus Torvalds wrote:
> On Tue, Jan 14, 2014 at 6:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Comments?
> 
> Do we have actual users of this? Because I'd almost be inclined to say
> "we just don't support field widths on sscanf() and will warn" unless
> there are users.
> 
> We've done that before. The kernel has various limited functions. See
> the whole snprint() issue with %n, which we decided that supporting
> the full semantics was actually a big mistake and we actively
> *removed* code that had been misguidedly added just because people
> thought we should do everything a standard user library does..
> 
> Limiting our problem space is a *good* thing, not a bad thing.
> 
> If it's possible, of course, and we don't have nasty users.

We do, unfortunately...  Not the trigger for that bug, but yes, we do have
places that pass things like %2hhx to sscanf().  Or stuff like
        sscanf(oh->name, "timer%2d", &id);
Or
        if (sscanf(location, "%03d%c%02d^%02d#%d",
                rack, &type, bay, slot, slab) != 5)
                return -1;
(nice cargo-culting there, BTW - somebody got too used to printf).

So no, we can't just drop all field width support - in-tree code will break.
Actually, it looks like correct version wouldn't be more complex than what we
have now.  Something like [completely untested]

	while ((c = *fmt) != '\0') {
		/* whitespace matches any amount of whitespace */
		if (isspace(c)) {
			str = skip_spaces(str);
			continue;
		}
		/* non-% matches itself, %% matches solitary % */
		if (c != '%' || (c = *fmt++) == '%') {
			if (c == *str++)
				continue;
			break;
		}
		/* %*conversion means "convert but don't store" */
		suppress = c == '*';
		if (suppress)
			c = *fmt++;

		/* optional field width */
		width = -1;
		if (isdigit(c)) {
			width = c;
			while (isdigit(c = *fmt++)) {
				width = width * 10 + c - '0';
				if (width > MAX_SHRT)
					goto Invalid;
			}
			if (!width)
				goto Invalid;
		}

		/* qualifier */
		switch (c) {
		case 'h':
			if ((c = *fmt++) == 'h')
				qualifier = 'H';	/* hh: char */
			else
				qualifier = 'h';	/* h: short */
			break;
		case 'l':
			if ((c = *fmt++) == 'l')
				qualifier = 'L';	/* ll: long long */
			else
				qualifier = 'l';	/* l: long */
			break;
		case 'j':	/* j: intmax_t, aka long long */
		case 'L':	/* L: long long */
		case 'z':	/* z: size_t */
		case 'Z':	/* Z: alias for 'z' */
		case 't':	/* t: ptrdiff_t */
			qualifier = c;
			c = *fmt++;
			break;
		default:
			qualifier = 0;
		}

		if (c == 'n') {
			if (suppress)
				continue;	/* maybe goto Invalid */
			negative = 0;
			is_signed = 1;
			val = str - buf;
			num--;
			goto Store_it;
		}

		/* %c */
		if (c == 'c') {
			/* might be worth complaining about qualifiers? */
			/* %c is %1c */
			if (width == -1)
				width = 1;
			if (!suppress) {
				char *p = (char *)va_arg(args, char*);
				if (!*str)
					break;
				do {
					*p++ = *str++;
				} while (--width && *str);
				num++;
			} else {
				while (*str++ && --width)
					;
			}
			continue;
		}

		/* everything but %c, %n and %[ skips whitespaces */
		str = skip_spaces(str);
		if (!*str)
			break;

		/* %s */
		if (c == 's') {
			if (width == -1)
				width = SHRT_MAX;
			if (!suppress) {
				char *p = (char *)va_arg(args, char*);
				/* now copy until next white space */
				while (*str && !isspace(*str) && width--)
					*p++ = *str++;
				*p = '\0';
				num++;
			} else {
				while (*str && !isspace(*str) && width--)
					str++;
			}
			continue;
		}
		
		/* at that point it's numeric or bust */
		base = 10;
		is_signed = 0;
		negative = 0;
		sign = 0;
		switch (c) {
		case 'o':
			base = 8;
			break;
		case 'x':
			base = 16;
			break;
		case 'i':
			base = 0;
		case 'd':
			is_signed = 1;
		case 'u':
			break;
		default:
			goto Invalid;
		}

		/* optional sign - counts towards width limit */
		switch (*str) {
		case '-':
			negative = 1;
		case '+':
			str++;
			width--;
		}
		rv = parse_number(str, width, base, &val);
		if (rv < 0)
			goto Conversion_failed;
		str += rv;
		
Store_it:
#define STORE(stype, utype)						\
	if (is_signed) {						\
		if ((val - negative) & (-(u64)(1 + (utype)~0ULL)/2))	\
			goto Conversion_failed;				\
		if (negative)						\
			val = -val;					\
		if (!suppress)						\
			*va_arg(args, stype *) = (stype)val;		\
	} else {							\
		if (val & -(u64)(1 + (utype)~0ULL))			\
			goto Conversion_failed;				\
		if (negative)						\
			val = -val;					\
		if (!suppress)						\
			*va_arg(args, utype *) = (utype)val;		\
	}								\
	if (!suppress)							\
		num++;

		switch (qualifier) {
		case 'H':
			STORE(signed char, unsigned char);
			break;
		case 'h':
			STORE(short, unsigned short);
			break;
		case 'l':
			STORE(long, unsigned long);
		case 'L':
		case 'j':
			STORE(long long, unsigned long long);
		case 'z':
		case 'Z':
			STORE(long, size_t);
		case 't':
			STORE(ptrdiff_t, unsigned long);
			break;
		default:
			STORE(int, unsigned);
		}
	}
out:
	return num;
Invalid:
	/* probably complain about invalid format string */
Conversion_failed:
	return num;

with parse_number(str, width, base, p) being something along the lines of
	const char *s = str;
	u64 val = 0;
	if (!width || !isdigit(*s))
		return -1;
	if (!base) {
		base = 10;
		if (*s == '0' && width > 1) {
			if (s[1] == 'x' || s[1] == 'X') {
				base = 16;
				s += 2;
				if (width == 2 || !isxdigit(*s))
					return -1;
				width -= 2;
			} else {
				base = 8;
			}
		}
	}
	while (*s && width) {
		unsigned d = base;

		if (isdigit(*s))
			d = *s - '0';
		else if (isxdigit(*s))
			d = _tolower(*s) - 'a' + 10;

		if (d >= base)
			break;
		/*
		 * Check for overflow only if we are within range of
		 * it in the max base we support (16)
		 */
		if (unlikely(val & (~0ull << 60))) {
			if (val > div_u64(ULLONG_MAX - d, base))
				return -1;
		}
		val = val * base + d;
		s++;
		width--;
	}
	*p = val;
	return s - str;
