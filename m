Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3FRKIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:08:54 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54986 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab3FRKIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130613164730.65273fbd@mschwide>
References: <20130613164730.65273fbd@mschwide>
Date: Tue, 18 Jun 2013 12:08:51 +0200
X-Google-Sender-Auth: h_6miM4WhzdQJIge7qO1mrmMFKM
Message-ID: <CAMuHMdW+C=kQh+0XM1m1W5EPOPYCmq1KoJOKSbT+-VZWdK-9Ww@mail.gmail.com>
Subject: Re: [GIT PULL] s390 patches for the 3.10-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 4:47 PM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> please pull from the 'for-linus' branch of
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
>
> to receive the following updates:
>
> Three kvm related memory management fixes, a fix for show_trace,
> a fix for early console output and a patch from Ben to help prevent
> compile errors in regard to irq functions (or our lack thereof).
>
> Ben Hutchings (1):
>       s390/pci: Implement IRQ functions if !PCI

> --- a/arch/s390/kernel/irq.c
> +++ b/arch/s390/kernel/irq.c
> @@ -311,3 +311,67 @@ void measurement_alert_subclass_unregister(void)
>         spin_unlock(&ma_subclass_lock);
>  }
>  EXPORT_SYMBOL(measurement_alert_subclass_unregister);
> +
> +void synchronize_irq(unsigned int irq)
> +{
> +       /*
> +        * Not needed, the handler is protected by a lock and IRQs that occur
> +        * after the handler is deleted are just NOPs.
> +        */
> +}

allnoconfig:

arch/s390/kernel/irq.c:315:6: error: expected identifier or '(' before '__asm__'
http://kisskb.ellerman.id.au/kisskb/buildresult/8987667/

The function is expanded to:

    void __asm__ __volatile__("": : :"memory")
    {

    }

include/linux/hardirq.h: # define synchronize_irq(irq)   barrier()
include/linux/compiler-gcc.h: #define barrier() __asm__
__volatile__("": : :"memory")

Turning synchronize_irq() into a static inline function doesn't help as then
it becomes a redefinition.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
