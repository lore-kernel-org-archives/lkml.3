Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaK1Ndx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:33:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaK1Ndw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:33:52 -0500
Message-ID: <547879BE.4050502@suse.cz>
Date: Fri, 28 Nov 2014 14:33:50 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/kconfig/menu.c warning for uninitialized "jump"
References: <CAHnt0GXeTAmAaa3queHDP2kssYESgHLmohXj41F04gQvcB__ug@mail.gmail.com>
In-Reply-To: <CAHnt0GXeTAmAaa3queHDP2kssYESgHLmohXj41F04gQvcB__ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-21 05:22, Peter Teoh wrote:
> This warning was found in v3.18-rc3-68-g20f3963 of Linus git-tree.
> 
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
> In file included from scripts/kconfig/zconf.tab.c:2537:0:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>      jump->offset = strlen(r->s);
>                   ^
> scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
>   struct jump_key *jump;
>                    ^

First of all, the warning is bogus (the condition under which 'jump' is
used is stronger than that under which 'jump' is initialized). But since
people have been reporting the warning on and off for some time, we have
to shut it up somehow, as the affected gcc versions are not dying out,
apparently.


> -                       if (head && location && menu == location)
> +                       if (head && location && (menu == location) && (jump))
>                                 jump->offset = strlen(r->s);

Let's assume, for the sake of argument, that gcc is right and jump may
be uninitialized here. Then the added check for jump being non-null just
tests an uninitialized variable and thus behaves randomly. It prevents
the code from writing to NULL->offset, but does not prevent it from
writing to <random address>->offset.

Michal
