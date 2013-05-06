Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3EFSSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:18:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56446 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3EFSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:18:00 -0400
Date: Mon, 6 May 2013 20:17:54 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH] kconfig: sort found symbols by relevance
Message-ID: <20130506181754.GE3958@free.fr>
References: <1367826629.4494.30.camel@chaos.site>
 <1367845365-13316-1-git-send-email-yann.morin.1998@free.fr>
 <1367854112.4569.137.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367854112.4569.137.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, All,

On Mon, May 06, 2013 at 05:28:32PM +0200, Jean Delvare wrote:
> Le Monday 06 May 2013 à 15:02 +0200, Yann E. MORIN a écrit :
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > When searching for symbols, return the symbols sorted by relevance.
> > 
> > Relevance is the ratio of the length of the matched string and the
> > length of the symbol name. Symbols of equal relevance are sorted
> > alphabetically.
> > 
> > Reported-by: Jean Delvare <jdelvare@suse.de>
> > Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Roland Eggner <edvx1@systemanalysen.net>
> > Cc: Wang YanQing <udknight@gmail.com>
> > ---
> >  scripts/kconfig/symbol.c | 66 +++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 57 insertions(+), 9 deletions(-)
> 
> I did not look at the code, only tested it, and it does what I asked for
> originally: exact match is listed first. So thank you :)
> 
> However I am not sure if your implementation is what we want. Your
> definition of "relevance" is somewhat arbitrary and may not be
> immediately to others. For example, my own definition of "relevance" was
> that symbols which start with the subject string are more relevant than
> the symbols which have the string in the middle. Others would possibly
> have other definitions.

Yes, I understand. That was mostly a proposal. I'm open for discussion! :-)

> So in the end you have somewhat complex code for a sort order which may
> surprise or confuse the user. It may put close to each other options
> which are completely unrelated, and suboptions very far from their
> parent.

The notion of "sub-options" is very fuzzy: as symbols are stored in an
hash-based array, it is not possible to now how they relate to each other
order-wise, once the parsing of the Kconfig is done. So we can't expect
the search results to reflect the 'proximity' of symbol declarations.

> I am wondering if it might not be better to go for a more simple
> strategy: exact match on top and then sort alphabetically. Or even just
> sort alphabetically - now that I know regexps are supported, it is easy
> to get the exact match when I need it.

Also, to prefer exact match requires we check how much of the symbol
name was matched (hence my initial 'relevance' heuristic).

However, here is a proposal for another heuristic that seems to work
relatively well for me (but is a very little bit more complex, I'm
afraid), that tries hard to get the most relevant symbols first:

Compare matched symbols as thus:
  - first, symbols with a prompt,   [1]
  - then, smallest offset,          [2]
  - then, shortest match,           [3]
  - then, highest relevance,        [4]
  - finally, alphabetical sort      [5]

When searching for 'P.*CI' :

[1] Symbols of interest are probably those with a prompt, as they can be
    changed, while symbols with no prompt are only for info. Thus:
        PCIEASPM comes before PCI_ATS

[2] Symbols that match earlier in the name are to be preferred over
    symbols which match later. Thus:
        PCI_MSI comes before WDTPCI

[3] The shortest match is (IMHO) more interesting than a longer one.
    Thus:
        PCI comes before PCMCIA

[4] The relevance is the ratio of the length of the match against the
    length of the symbol. The more of a symbol name we match, the more
    instersting that symbol is. Thus:
        PCIEAER comes before PCIEASPM

[5] As fallback, sort symbols alphabetically (no example, it's explicit
    enough, I guess :-) )

Of course 'P.*CI' is really a torture-test search, real searches will
probably be more precise in the first place. This heuristic seems to
also work well with real searches. YMMV, of course...

What do you (and others!) think about this? I'll post the patch shortly
for testing.

> Thanks for your work anyway,

Cheers! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
