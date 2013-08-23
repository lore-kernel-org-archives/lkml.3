Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3HWNSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:18:40 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47295 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3HWNSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6s3wit88ynuzYsBZBvijHmAfJNeY9LH2T5S9iY7kJtg=w@mail.gmail.com>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
	<1326313337-24603-12-git-send-email-grant.likely@secretlab.ca>
	<CAMuHMdV=pSG+CtvGqr1c9nDKeHCU0cVQcFkfAo5iMMna2HOvZg@mail.gmail.com>
	<CACxGe6s3wit88ynuzYsBZBvijHmAfJNeY9LH2T5S9iY7kJtg=w@mail.gmail.com>
Date: Fri, 23 Aug 2013 15:18:36 +0200
X-Google-Sender-Auth: bHPQULBWrsL6WnX4InMdKX7ZBbk
Message-ID: <CAMuHMdW0EE9MiwoOzvg_2VBf5QvYpgJ8bHsjV1HL8iN5HyhxYA@mail.gmail.com>
Subject: Re: [RFC 11/14] powerpc: Eliminate NO_IRQ usage
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 5:56 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Jul 25, 2013 at 3:58 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Wed, Jan 11, 2012 at 9:22 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> NO_IRQ is evil.  Stop using it in arch/powerpc and powerpc device drivers
>>
>>> diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
>>> index 3e06696..55c6ff9 100644
>>> --- a/sound/soc/fsl/fsl_ssi.c
>>> +++ b/sound/soc/fsl/fsl_ssi.c
>>> @@ -666,7 +666,7 @@ static int __devinit fsl_ssi_probe(struct platform_device *pdev)
>>>         ssi_private->ssi_phys = res.start;
>>>
>>>         ssi_private->irq = irq_of_parse_and_map(np, 0);
>>> -       if (ssi_private->irq == NO_IRQ) {
>>> +       if (!ssi_private->irq) {
>>>                 dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
>>>                 ret = -ENXIO;
>>>                 goto error_iomap;
>>
>> What's the plan with this patch?
>>
>> This is now failing on xtensa, as it's one of the architectures that doesn't
>> define NO_IRQ. Only arm, c6x, mn10300, openrisc, parisc, powerpc, and sparc
>> define it.
>
> Wow. I'd pretty much dropped that patch because I didn't have time to
> chase it down. It should be pursued though.
>
> In that particular case it is safe I think to apply the change. PPC
> defines NO_IRQ to be 0 anyway.

Note that we still have arches that define it as nonzero:

arch/arm/include/asm/irq.h:#define NO_IRQ ((unsigned int)(-1))
arch/mn10300/include/asm/irq.h:#define NO_IRQ INT_MAX
arch/openrisc/include/asm/irq.h:#define NO_IRQ (-1)
arch/parisc/include/asm/irq.h:#define NO_IRQ (-1)
arch/sparc/include/asm/irq_32.h:#define NO_IRQ 0xffffffff
arch/sparc/include/asm/irq_64.h:#define NO_IRQ 0xffffffff

Only c6x and powerpc use zero, and thus are ready to drop NO_IRQ.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
