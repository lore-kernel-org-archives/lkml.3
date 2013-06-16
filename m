Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3FPSBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 14:01:47 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58819 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3FPSBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 14:01:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
	<CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
Date: Sun, 16 Jun 2013 08:01:44 -1000
X-Google-Sender-Auth: 4V09zy1nWqAo2wAFXY_nrrLfkt4
Message-ID: <CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com>
Subject: Re: Linux 3.10-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:36 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> On Sun, Jun 16, 2013 at 12:12 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > David Daney (3):
> >       smp.h: Use local_irq_{save,restore}() in !SMP version of on_each_cpu().
>
> This change (commit f21afc25f9ed45b8ffe200d0f071b0caec3ed2ef, which hasn't
> been in linux-next), broke at least mn10300 and ia64:
>
> include/linux/smp.h:148:2: error: implicit declaration of function 'local_irq_save' [-Werror=implicit-function-declaration]

Hmm. DavidD already added the include for <linux/irqflags.h>, I wonder
why that doesn't end up working. Do we have some silly header file
circular include that means that we're already half-way through that
irqflags.h file and thus will skip it the second time we see it, or
why does it end up being undeclared?

Anyway, I see a few options:

 - we could just make it a macro like it used to be (keeping the
include and assuming that will sort out any circular include mess) and
use a rare name for the internal "flags" variable (just prepending
double underscores is the common one we tend to use in situations like
this)

 - we could just make it a real function, the way the SMP one is, and
take the extra call overhead (it's not like this should be all that
critical in an UP environment).

 - somebody figures out why the <linux/irqflags.h> include ends up not
working on nm10300 and ia64..

Hmm?

                 Linus
