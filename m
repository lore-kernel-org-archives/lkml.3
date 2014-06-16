Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaFPJP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:15:26 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65204 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaFPJPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140616082855.GB1840@name>
References: <1401773445-25256-1-git-send-email-enjoymindful@gmail.com>
	<539C1964.4050504@nod.at>
	<20140616032852.GA1763@name>
	<539E93B9.5070407@nod.at>
	<20140616081238.GA1840@name>
	<20140616082855.GB1840@name>
Date: Mon, 16 Jun 2014 11:15:23 +0200
X-Google-Sender-Auth: s0_7ba8mg8u1r7lr4nCW4vfx1oA
Message-ID: <CAMuHMdV9SA0zZz0u=VKWWXNRL186hunrMYuZ=RUcAjqRes8r8A@mail.gmail.com>
Subject: Re: [PATCH v2] delete unnecessary bootmem struct page array
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Real Name <enjoymindful@gmail.com>
Cc: Richard Weinberger <richard@nod.at>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:28 AM, Real Name <enjoymindful@gmail.com> wrote:
>> > >> Can you please include in the changelog the commit sha1 which made the old init_maps() obsolete?
>
> I think we need find out which commit deleted the line "mem_map = map;" in init_maps function.

marc.info/?l=linux-kernel&m=111024122220474&w=2

v2.6.12-rc1

commit 5678d7fc97ac75f7401ce77897773cc0bb3afee5
Author: Dave Hansen <haveblue@us.ibm.com>
Date:   Sun Mar 13 00:22:56 2005 -0800

    [PATCH] no arch-specific mem_map init

    So, this patch started out with me trying to keep from passing contiguous,
    node-specific mem_map into free_area_init_node() and cousins.  Instead, I
    relied on some calls to pfn_to_page().

    This works fine and dandy when all you need is the pgdat->node_mem_map to
    do pfn_to_page().  However, the non-NUMA/DISCONTIG architectures use the
    real, global mem_map[] instead of a node_mem_map in the pfn_to_page()
    calculation.  So, I ended up effectively trying to initialize mem_map from
    itself, when it was NULL.  That was bad, and caused some very pretty colors
    on someone's screen when he tested it.

    So, I had to make sure to initialize the global mem_map[] before calling
    into free_area_init_node().  Then, I realized how many architectures do
    this on their own, and have comments like this:

            /* XXX: MRB-remove - this doesn't seem sane, should this be done som
            mem_map = NODE_DATA(0)->node_mem_map;

    The following patch does what my first one did (don't pass mem_map into the
    init functions), incorporates Jesse Barnes' ia64 fixes on top of that, and
    gets rid of all but one of the global mem_map initializations (parisc is
    weird).  It also magically removes more code than it adds.  It could be
    smaller, but I shamelessly added some comments.

    Boot-tested on ppc64, i386 (NUMAQ, plain SMP, laptop), UML (i386).

    Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
