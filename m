Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3FXH5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:57:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab3FXH5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:57:48 -0400
Subject: Re: [PATCH 12/14] kconfig: sort found symbols by relevance
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
In-Reply-To: <3e2346029e33ef9405b87d72a32d96d0aafb524a.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
	 <3e2346029e33ef9405b87d72a32d96d0aafb524a.1371595499.git.yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 24 Jun 2013 09:57:39 +0200
Message-ID: <1372060659.4310.41.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,

Sorry for the late reply...

Le Wednesday 19 June 2013 à 00:45 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> When searching for symbols, return the symbols sorted by relevance.
> 
> Sorting is done as thus:
>   - first, symbols with a prompt,   [1]
>   - then, smallest offset,          [2]
>   - then, shortest match,           [3]
>   - then, highest relative match,   [4]
>   - finally, alphabetical sort      [5]
> 
> So, searching (eg.) for 'P.*CI' :

Nobody would actually search for that, so that's not a particularly good
example to determine whether your sort order is sane or not.

> 
> [1] Symbols of interest are probably those with a prompt, as they can be
>     changed, while symbols with no prompt are only for info. Thus:
>         PCIEASPM comes before PCI_ATS

This is not necessarily true. I often look for symbols which have no
prompt, and the information I am looking for is exactly "does this
symbol have a prompt or is its value determined automatically"?

> [2] Symbols that match earlier in the name are to be preferred over
>     symbols which match later. Thus:
>         PCI_MSI comes before WDTPCI

This makes some sense, although it could have some unexpected side
effects (e.g. FOO_BAR_PCI would be listed before SOMETHING_PCI_BAZBAZ,
right?)

> [3] The shortest match is (IMHO) more interesting than a longer one.
>     Thus:
>         PCI comes before PCMCIA

This makes sense too, but I'm sure there are cases where it will be
confusing too, and alphabetical order would do it in part too.

> [4] The relative match is the ratio of the length of the match against
>     the length of the symbol. The more of a symbol name we match, the
>     more instersting that symbol is. Thus:
>         PCIEAER comes before PCIEASPM

This is an obscure sort rule and I'm sure it will add more confusion
than it will help. Alphabetical order should really be good enough at
this point.

> 
> [5] As fallback, sort symbols alphabetically
> 
> This heuristic tries hard to get interesting symbols first in the list.

I know I am the one whose question triggered this work from you, but in
the end the "response" seems disproportionate. Having 5 different
ordering rules is a lot, and that's quite a bit of code, which while not
the most complex in the world, is still far from trivial and may require
maintenance work in the future.

The result of the search will be read by a human. As such, the order of
the results should be immediately obvious. Returning what the user is
most probably looking for first in the list is not as important as
making it possible for the user to search the results for what he/she is
looking for, and this can only be the case if the user understands the
sort order instinctively. The 5 rules you used aren't exactly that IMHO.
This situation is completely different from a web search for example,
where the search engine has to select the most relevant pages because
listing them all is out of the question.

The original order was random and that's the worse possible order, so I
am all for improving it. But I think the sort order should be driven by
simple and instinctive rules. This means 1 or 2 ordering rules, not 5.
As I recall, my original proposal was "exact match first, then
alphabetical order." 2 rules, instinctive and easy to document.

> In any case, exact match can (as previously) be requested by using
> start-of-line and end-of-line in the search regexp: ^PCI$

Actually this solved my original problem just fine. As a matter of fact,
I stopped replying to the original thread shortly after learning this,
because I kind of lost interest in the following discussion.

So I think it is more important to make it clearer that regular
expressions are allowed, than to come up with a brilliant sort order. I
know the help page says it, but the prompt itself only asks for a
"(sub)string" and it is not immediately obvious (to me at least) that
regular expressions are considered substrings.

BTW, if you really decide to commit your proposal despite my concerns,
you will have to document the sorting rules in the help page.

Thanks,
-- 
Jean Delvare
Suse L3

