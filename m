Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3JXIam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:30:42 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59669 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3JXIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:30:39 -0400
MIME-Version: 1.0
In-Reply-To: <52688C42.3030907@asianux.com>
References: <5267AE7D.4080600@asianux.com>
	<C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com>
	<52688C42.3030907@asianux.com>
Date: Thu, 24 Oct 2013 10:30:38 +0200
X-Google-Sender-Auth: iNaKTBXPu4KIFsMIjNDzYutIqSQ
Message-ID: <CAMuHMdWD1ENyrBMimnoYQc4hzJ_Zkob-1RQ3F+wXbSktYcO9xQ@mail.gmail.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info' in "setup.c"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 4:56 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> NAK.
>
> OK, thanks. At least this patch is incorrect.
>
>
>> ARC will never have VGA console. You need to add !ARC to relevant Kconfig. However that approach is frowned upon in general. The current way to doing such things is to define a new Kconfig item which relevant arches can select.
>
> Hmm... it seems necessary to discuss about the 2 fixing ways (which
> already had a long discussion in ARM64):
>
>  - add !ARC in related place, just like another (almost 30-40%) architectures done.
>
>  - add a new Kconfig item (e.g. HAVE_VGA_CONSOLE), and let the left (almost 50%) architectures which use VGA_CONSOLE to set it.
>
> Catalin, Will, Geert (it seems also include you) prefer 2nd way, but I
> prefer 1st, my reasons are below, please help check:
>
>  - 1st way need add some (10-20%) of architectures in one place, which belongs to local wide.
>    2nd way will let the left (almost 50%) architectures need add HAVE_VGA_CONSOLE in various place, which belongs to arch global wide.
>
>  - 1st way will let most (80-90%) of architectures don't care about VGA_CONSOLE (50% need it, 30-40% already mark it in the same place).
>    2nd way will let 50% architectures care about VGA_CONSOLE (although can let the left 10-20% architectures do nothing -- not care about it).
>
>  - 1st way is still easy, sustainable, and clear enough in local wide fixing (although maybe it is not the best, or clearest way).
>    2nd way is also easy, sustainable and clear enough (maybe the best, or clearest for 10-20% architectures), but it will let the fix in global wide
>
> All together, if we can bear and sustainable, I always prefer to fix it
> in local wide, not lead to arch global (especially 80-90% architectures
> already followed 1st way).
>
>
> BTW: for me, if less than 20% architectures need XXX, we can trigger
> defining a new Kconfig item (e.g. HAVE_XXX), or just follow original
> implementation.

Lot's of negative dependencies are missing for VGA_CONSOLE.
I think only alpha, some arm, ia64, some mips, some powerpc, and x86
may use it.

The main reason for introducing HAVE_VGA_CONSOLE is maintainability.
The question to ask is: does the logic have to change when adding a new
architecture?
  - If yes, you're better off with the HAVE_xxx scheme.
  - If no, use the negative dependencies in the common place.

VGA consoles are legacy, and not used on new systems. Witness the
list of architectures I gave above. All of them are (at least) 20 years old
(except for ia64, but that borrows from PC legacy).
So every time when adding a new architecture, you have to add
'&& !NEW_ARCH' to the VGA_CONSOLE dependency, which is in a
common place (drivers/.../Kconfig).
While with the HAVE_xxx scheme, you don't have to change anything.

Compare this to a shiny new feature that available on all new architectures,
but not on a few old one. There it makes sense to have the negative
dependencies on the old architectures, that will never have the new feature.
While new architectures have enabled it by default.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
