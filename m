Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3FYHXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:23:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35849 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3FYHXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:23:50 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <e6abf12a77bc56dceeb4cba557b726268e71350e.1372097219.git.yann.morin.1998@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
	<e6abf12a77bc56dceeb4cba557b726268e71350e.1372097219.git.yann.morin.1998@free.fr>
Date: Tue, 25 Jun 2013 09:23:49 +0200
Message-ID: <CA+icZUXCfr3ijrRqQEjqK03imcENwUHZWMk536pE265BUtV0Eg@mail.gmail.com>
Subject: Re: [PATCH 09/15] kconfig/conf: fix randconfig setting multiple
 symbols in a choice
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Alexander Kriegisch <Alexander@kriegisch.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 8:11 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
>
> Currently, randconfig may set more than one symbol in a given choice.
> Given this config file:
>     config A
>         bool "A"
>     if A
>     choice
>         bool "B/C/D"
>     config B
>         bool "B"
>     config C
>         bool "C"
>     config D
>         bool "D"
>     endchoice
>     endif # A
>
> Then randconfig generates such .config files (case where A is not set is not
> shown below for brevity), and where only the right-most .config is valid:
>   CONFIG_A=y                  CONFIG_A=y                  CONFIG_A=y
>   CONFIG_B=y                  CONFIG_B=y                  CONFIG_B=y
>   CONFIG_C=y                  # CONFIG_C is not set       # CONFIG_C is not set
>   # CONFIG_D is not set       CONFIG_D=y                  # CONFIG_D is not set
>
> That is, in a randomised choice, the first symbol is always selected,
> and at most one other symbol may be selected.
>
> This is due to symbol randomised in a choice not being properly flagged
> as having a value.
>
> Fix that by flagging those symbols adequately: have a user-defined value,
> and be not valid (to force recalculation of the symbol).
>
> Note: if the choice is not conditional, then the randomisation is properly
> done.
>
> Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
> Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
> [yann.morin.1998@free.fr: independently re-done the same patch as Matthieu,
>                           as pointed out by Sedat]
> Cc: Arnaud Lacombe <lacombar@gmail.com>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

[ CC Alexander ]

Can you or Marek (kbuild maintainer) please add also a Reported-by of
Alexander (see [1])?

     Reported-by: Alexander Kriegisch <Alexander@kriegisch.name>

It's a bit a pity that you discovered this issue by yourself independantly.
As said in PM, the Freetz router project has included it when playing
with Kconfig of Linux-v3.1-rc9.

Thanks for taking care.

- Sedat -

[1] http://www.spinics.net/lists/linux-kbuild/msg05702.html
[2] http://freetz.org/browser/trunk/tools/make/patches/340-fix_randconfig_choice.kconfig.patch

> ---
>  scripts/kconfig/confdata.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 35e0f16..d36bc1f 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -1077,6 +1077,9 @@ static void randomize_choice_values(struct symbol *csym)
>                 else {
>                         sym->def[S_DEF_USER].tri = no;
>                 }
> +               sym->flags |= SYMBOL_DEF_USER;
> +               /* clear VALID to get value calculated */
> +               sym->flags &= ~SYMBOL_VALID;
>         }
>         csym->flags |= SYMBOL_DEF_USER;
>         /* clear VALID to get value calculated */
> --
> 1.8.1.2
>
