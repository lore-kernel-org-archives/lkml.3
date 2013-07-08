Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3GHLTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:19:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3GHLTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:19:34 -0400
Subject: Re: [PATCH 12/15] kconfig: sort found symbols by relevance
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
In-Reply-To: <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
	 <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 08 Jul 2013 13:19:17 +0200
Message-ID: <1373282357.4298.198.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,

Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> When searching for symbols, return the symbols sorted by relevance.
> 
> Sorting is done as thus:
>   - first, symbols that match exactly
>   - then, alphabetical sort

I like it, this is simple and efficient.

> Since the search can be a regexp, it is possible that more than one symbol
> matches exactly. In this case, we can't decide which to sort first, so we
> fallback to alphabeticall sort.

Typo: alphabetical.

> Explain this (new!) sorting heuristic in the documentation.

It's more of a rule than a heuristic.

> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Roland Eggner <edvx1@systemanalysen.net>
> Cc: Wang YanQing <udknight@gmail.com>

I tested it and it works fine, thanks!

Tested-by: Jean Delvare <jdelvare@suse.de>

Now comes my late review. Overall I like the idea and the code but a few
things could be improved:

> --
> Changes v1->v2:
>   - drop the previous, complex heuristic in favour of a simpler heuristic
>     that is both easier to understand, *and* to maintain (Jean)
>   - explain sorting heuristic in the doc  (Jean)
> ---
>  Documentation/kbuild/kconfig.txt | 13 +++++++
>  scripts/kconfig/symbol.c         | 78 +++++++++++++++++++++++++++++++++++-----
>  2 files changed, 82 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
> index 3f429ed..e9f9e76 100644
> --- a/Documentation/kbuild/kconfig.txt
> +++ b/Documentation/kbuild/kconfig.txt
> @@ -174,6 +174,19 @@ Searching in menuconfig:
>  
>  		/^hotplug
>  
> +	When searching, symbols are sorted thus:
> +	  - exact match first: an exact match is when the search matches
> +	    the complete symbol name;

The use of singular seems to imply there can be only one, while there
could be several as you explained above.

> +	  - alphabetical order: when two symbols do not match exactly,
> +	    they are sorted in alphabetical order (in the user's current
> +	    locale).

I think it would be better explained that way:

	 - first, exact matches, sorted alphabetically (an exact match
	   is when the search matches the complete symbol name);
	 - then, other matches, sorted alphabetically.

This is more concise and easier to grasp, methinks. I don't think the
reference to the user's locale is needed, as there's no surprise here,
and it probably doesn't matter anyway for kernel symbols.

BTW I was wondering if it would add value to explicitly print group
header labels "Exact matches" and "Other matches" in the search results.
What do you think?

> +	For example: ^ATH.K matches:
> +	    ATH5K ATH9K ATH5K_AHB ATH5K_DEBUG [...] ATH6KL ATH6KL_DEBUG
> +	    [...] ATH9K_AHB ATH9K_BTCOEX_SUPPORT ATH9K_COMMON [...]
> +	of which only ATH5K and ATH9K match exactly and so are sorted
> +	first (and in alphabetical order), then come all other symbols,
> +	sorted in alphabetical order.

Very clear example :)

>  ______________________________________________________________________
>  User interface options for 'menuconfig'
>  
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index ab8f4c8..387d554 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -954,38 +954,98 @@ const char *sym_escape_string_value(const char *in)
>  	return res;
>  }
>  
> +struct sym_match {
> +	struct symbol	*sym;
> +	off_t		so, eo;
> +};
> +
> +/* Compare matched symbols as thus:
> + * - first, symbols that match exactly
> + * - then, alphabetical sort
> + */
> +static int sym_rel_comp( const void *sym1, const void *sym2 )

Coding style says no space after/before parentheses.

> +{
> +	struct sym_match *s1 = *(struct sym_match **)sym1;
> +	struct sym_match *s2 = *(struct sym_match **)sym2;

You shouldn't need these casts.

> +	int l1, l2;
> +
> +	/* Exact match:
> +	 * - if matched length on symbol s1 is the length of that symbol,
> +	 *   then this symbol should come first;
> +	 * - if matched length on symbol s2 is the length of that symbol,
> +	 *   then this symbol should come first.
> +	 * Note: since the search can be a regexp, both symbols may match
> +	 * exactly; if this is the case, we can't decide which comes first,
> +	 * and we fallback to sorting alphabetically.
> +	 */
> +	l1 = s1->eo - s1->so;
> +	l2 = s2->eo - s2->so;
> +	if (l1 == strlen(s1->sym->name) && l2 != strlen(s2->sym->name))
> +		return -1;
> +	if (l1 != strlen(s1->sym->name) && l2 == strlen(s2->sym->name))
> +		return 1;

Strlen is expensive so I would avoid calling it twice on the same symbol
name. You could store the result, together with the result of the
comparison, while you're at it. Something like:

	int exact1, exact2;

	exact1 = l1 == strlen(s1->sym->name);
	exact2 = l2 == strlen(s2->sym->name);
	if (exact1 && !exact2)
		return -1;
	if (!exact1 && exact2)
		return 1;

You may even no longer need to introduce l1 and l2 as you would use them
only once.

It might be even faster to store the symbol length in struct sym_match,
but this would increase the structure size and consequently memory
consumption, and it is questionable if the speed gain is worth it.
Probably not.

> +
> +	/* As a fallback, sort symbols alphabetically */
> +	return strcmp(s1->sym->name, s2->sym->name);
> +}
> +
>  struct symbol **sym_re_search(const char *pattern)
>  {
>  	struct symbol *sym, **sym_arr = NULL;
> +	struct sym_match **sym_match_arr = NULL;
>  	int i, cnt, size;
>  	regex_t re;
> +	regmatch_t match[1];
>  
>  	cnt = size = 0;
>  	/* Skip if empty */
>  	if (strlen(pattern) == 0)
>  		return NULL;
> -	if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB|REG_ICASE))
> +	if (regcomp(&re, pattern, REG_EXTENDED|REG_ICASE))
>  		return NULL;
>  
>  	for_all_symbols(i, sym) {
> +		struct sym_match *tmp_sym_match;
>  		if (sym->flags & SYMBOL_CONST || !sym->name)
>  			continue;
> -		if (regexec(&re, sym->name, 0, NULL, 0))
> +		if (regexec(&re, sym->name, 1, match, 0))
>  			continue;
>  		if (cnt + 1 >= size) {

I think the "+ 1" can be dropped because the new array is not
NULL-terminated.

> -			void *tmp = sym_arr;
> +			void *tmp;
>  			size += 16;
> -			sym_arr = realloc(sym_arr, size * sizeof(struct symbol *));
> -			if (!sym_arr) {
> -				free(tmp);
> -				return NULL;
> +			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match *));
> +			if (!tmp) {
> +				goto sym_re_search_free;
>  			}

Unnecessary curly braces (as reported by checkpatch.) Checkpatch reports
a few other issues BTW, you should run it and fix them.

> +			sym_match_arr = tmp;
>  		}
>  		sym_calc_value(sym);
> -		sym_arr[cnt++] = sym;
> +		tmp_sym_match = (struct sym_match*)malloc(sizeof(struct sym_match));

Cast not needed.

In fact I don't think this allocation is needed in the first place.
Calling malloc for every match is rather costly. If you would have
allocated an array of struct sym_match (rather than only pointers
thereto) before, you would not need this per-symbol malloc. Struct
sym_match is small enough to not warrant an extra level of allocation
and indirection IMHO.

> +		if (!tmp_sym_match)
> +			goto sym_re_search_free;
> +		tmp_sym_match->sym = sym;
> +		/* As regexec return 0, we know we have a match, so
> +		 * we can use match[0].rm_[se]o without further checks
> +		 */
> +		tmp_sym_match->so = match[0].rm_so;
> +		tmp_sym_match->eo = match[0].rm_eo;
> +		sym_match_arr[cnt++] = tmp_sym_match;
>  	}
> -	if (sym_arr)
> +	if (sym_match_arr) {
> +		qsort(sym_match_arr, cnt, sizeof(struct sym_match*), sym_rel_comp);
> +		sym_arr = malloc((cnt+1) * sizeof(struct symbol));
> +		if (!sym_arr)
> +			goto sym_re_search_free;
> +		for (i = 0; i < cnt; i++)
> +			sym_arr[i] = sym_match_arr[i]->sym;
>  		sym_arr[cnt] = NULL;
> +	}
> +sym_re_search_free:
> +	if (sym_match_arr) {
> +		for (i = 0; i < cnt; i++)
> +			free(sym_match_arr[i]);
> +		free(sym_match_arr);
> +	}
>  	regfree(&re);
>  
>  	return sym_arr;


-- 
Jean Delvare
Suse L3


