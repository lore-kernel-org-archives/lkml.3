Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3GHRfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:35:43 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38501 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3GHRfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:35:41 -0400
Date: Mon, 8 Jul 2013 19:35:35 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH 12/15] kconfig: sort found symbols by relevance
Message-ID: <20130708173535.GB3206@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
 <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
 <1373282357.4298.198.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1373282357.4298.198.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, All,

On 2013-07-08 13:19 +0200, Jean Delvare spake thusly:
> Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
[--SNIP--]
> > Since the search can be a regexp, it is possible that more than one symbol
> > matches exactly. In this case, we can't decide which to sort first, so we
> > fallback to alphabeticall sort.
> 
> Typo: alphabetical.

OK.

> > Explain this (new!) sorting heuristic in the documentation.
> 
> It's more of a rule than a heuristic.

OK.

> > Reported-by: Jean Delvare <jdelvare@suse.de>
> > Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Roland Eggner <edvx1@systemanalysen.net>
> > Cc: Wang YanQing <udknight@gmail.com>
> 
> I tested it and it works fine, thanks!
> 
> Tested-by: Jean Delvare <jdelvare@suse.de>
> 
> Now comes my late review. Overall I like the idea and the code but a few
> things could be improved:

Since this is already in Michal's tree, on should I proceed?
  - send an updated patch that replaces that one, or
  - send another additional patch with your proposed changes?

> > +	When searching, symbols are sorted thus:
> > +	  - exact match first: an exact match is when the search matches
> > +	    the complete symbol name;
> 
> The use of singular seems to imply there can be only one, while there
> could be several as you explained above.

OK.

> > +	  - alphabetical order: when two symbols do not match exactly,
> > +	    they are sorted in alphabetical order (in the user's current
> > +	    locale).
> 
> I think it would be better explained that way:
> 
> 	 - first, exact matches, sorted alphabetically (an exact match
> 	   is when the search matches the complete symbol name);
> 	 - then, other matches, sorted alphabetically.

OK.

> This is more concise and easier to grasp, methinks. I don't think the
> reference to the user's locale is needed, as there's no surprise here,
> and it probably doesn't matter anyway for kernel symbols.

Yes it may matter even for kernel symbols, since some locales may
consider '_' as a character to sort by, while other locales may not.

> BTW I was wondering if it would add value to explicitly print group
> header labels "Exact matches" and "Other matches" in the search results.
> What do you think?

It is not trivial to do, since the search function only returns a single
array, so there's no way for frontends (which do the display) to
differentiate which part of the array are exact matches, and which are
only partial matches.

It is much more involved, and I don't think it would be easy to
implement.

> >  ______________________________________________________________________
> >  User interface options for 'menuconfig'
> >  
> > diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> > index ab8f4c8..387d554 100644
> > --- a/scripts/kconfig/symbol.c
> > +++ b/scripts/kconfig/symbol.c
> > @@ -954,38 +954,98 @@ const char *sym_escape_string_value(const char *in)
> >  	return res;
> >  }
> >  
> > +struct sym_match {
> > +	struct symbol	*sym;
> > +	off_t		so, eo;
> > +};
> > +
> > +/* Compare matched symbols as thus:
> > + * - first, symbols that match exactly
> > + * - then, alphabetical sort
> > + */
> > +static int sym_rel_comp( const void *sym1, const void *sym2 )
> 
> Coding style says no space after/before parentheses.

OK.

> > +{
> > +	struct sym_match *s1 = *(struct sym_match **)sym1;
> > +	struct sym_match *s2 = *(struct sym_match **)sym2;
> 
> You shouldn't need these casts.

Probably not, indeed, but I like to write (and read) what I expect to
happen, and pointer arithmetics is always something I dread to foobar.

OK.

> > +	int l1, l2;
> > +
> > +	/* Exact match:
> > +	 * - if matched length on symbol s1 is the length of that symbol,
> > +	 *   then this symbol should come first;
> > +	 * - if matched length on symbol s2 is the length of that symbol,
> > +	 *   then this symbol should come first.
> > +	 * Note: since the search can be a regexp, both symbols may match
> > +	 * exactly; if this is the case, we can't decide which comes first,
> > +	 * and we fallback to sorting alphabetically.
> > +	 */
> > +	l1 = s1->eo - s1->so;
> > +	l2 = s2->eo - s2->so;
> > +	if (l1 == strlen(s1->sym->name) && l2 != strlen(s2->sym->name))
> > +		return -1;
> > +	if (l1 != strlen(s1->sym->name) && l2 == strlen(s2->sym->name))
> > +		return 1;
> 
> Strlen is expensive so I would avoid calling it twice on the same symbol
> name. You could store the result, together with the result of the
> comparison, while you're at it. Something like:
> 
> 	int exact1, exact2;
> 
> 	exact1 = l1 == strlen(s1->sym->name);
> 	exact2 = l2 == strlen(s2->sym->name);
> 	if (exact1 && !exact2)
> 		return -1;
> 	if (!exact1 && exact2)
> 		return 1;
> 
> You may even no longer need to introduce l1 and l2 as you would use them
> only once.

OK.

> It might be even faster to store the symbol length in struct sym_match,
> but this would increase the structure size and consequently memory
> consumption, and it is questionable if the speed gain is worth it.
> Probably not.

I intended this structure to only hold the result of the regexp match,
and nothing more. The symbol length does not belong there, IMHO.
Besides, it's easy to get back, since the symbol struct is available.

OTOH, we would gain by computing strlen at regexp match, instead of
every time in the sorting function.

But that's micro-optimisation, methinks. Searching for the example
^ATH.K took less than me focusing from the RETURN key to the screen. ;-)
 
[--SNIP--]
> >  	for_all_symbols(i, sym) {
> > +		struct sym_match *tmp_sym_match;
> >  		if (sym->flags & SYMBOL_CONST || !sym->name)
> >  			continue;
> > -		if (regexec(&re, sym->name, 0, NULL, 0))
> > +		if (regexec(&re, sym->name, 1, match, 0))
> >  			continue;
> >  		if (cnt + 1 >= size) {
> 
> I think the "+ 1" can be dropped because the new array is not
> NULL-terminated.

I'll look into that.

> > -			void *tmp = sym_arr;
> > +			void *tmp;
> >  			size += 16;
> > -			sym_arr = realloc(sym_arr, size * sizeof(struct symbol *));
> > -			if (!sym_arr) {
> > -				free(tmp);
> > -				return NULL;
> > +			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match *));
> > +			if (!tmp) {
> > +				goto sym_re_search_free;
> >  			}
> 
> Unnecessary curly braces (as reported by checkpatch.) Checkpatch reports
> a few other issues BTW, you should run it and fix them.

My fault, as I always use curly braces, even around single statements,
in many other projects. ( /me believes this kernel coding style is bad,
but will abide by the rules! ;-) ).

OK.

> > +			sym_match_arr = tmp;
> >  		}
> >  		sym_calc_value(sym);
> > -		sym_arr[cnt++] = sym;
> > +		tmp_sym_match = (struct sym_match*)malloc(sizeof(struct sym_match));
> 
> Cast not needed.

OK.

> In fact I don't think this allocation is needed in the first place.
> Calling malloc for every match is rather costly. If you would have
> allocated an array of struct sym_match (rather than only pointers
> thereto) before, you would not need this per-symbol malloc. Struct
> sym_match is small enough to not warrant an extra level of allocation
> and indirection IMHO.

OK, will look into that.

Thank you for the review! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
