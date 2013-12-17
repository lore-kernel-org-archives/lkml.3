Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3LQIsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:48:16 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:63046 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3LQIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:48:15 -0500
MIME-Version: 1.0
In-Reply-To: <1386700403.10013.109.camel@snotra.buserror.net>
References: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com>
	<1386357684.7375.124.camel@snotra.buserror.net>
	<52A6EDE8.5060903@freescale.com>
	<1386700403.10013.109.camel@snotra.buserror.net>
Date: Tue, 17 Dec 2013 16:48:14 +0800
X-Google-Sender-Auth: f09U35_Xwvuj5PMQt2RKCkhyPpw
Message-ID: <CADRPPNRy9SLauRPy0Ucm-xffuAhA7bMsA+9X4a=8XNRaJVMH5A@mail.gmail.com>
Subject: Re: [PATCH] DTS: DMA: Fix DMA3 interrupts
From: Li Yang <leoli@freescale.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Hongbo Zhang <hongbo.zhang@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 2:33 AM, Scott Wood <scottwood@freescale.com> wrote:
> On Tue, 2013-12-10 at 18:33 +0800, Hongbo Zhang wrote:
>> Scott,
>> This issue is due to the non-continuous MPIC register, I think there is
>> two ways to fix it.
>>
>> The first one is as what we are discussing, in fact the Bman/Qman DT
>> author had introduced this way, and I had to follow it, it is a trick,
>> adding 208 is a bit ugly I think, and even difficult to explain it to
>> customers etc, but this way changes less codes.
>>
>> The second one is editing MPIC related codes without adding 208 to high
>> interrupts. The point of translate interrupt number to MPIC register
>> address is a so called 'isu' mechanism, we can do like the following
>> example codes, then the tricky adding 208 isn't needed any more.
>>
>> Which one do you prefer?
>> In fact I myself prefer the second, if the idea is acceptable, I will
>> send a patch instead of this one. (and also alone with the internal
>> patch decreasing 208 for the Bman/Qman)
>>
>> void __init corenet_ds_pic_init(void)
>> {
>>      ......
>>
>>      mpic = mpic_alloc(NULL, 0, flags, 0, 512, "OpenPIC");
>>      BUG_ON(mpic == NULL);
>>
>> // Add this start
>>      for (i = 0; i < 17; i++) {
>>          if (i < 11)
>>              addr_off = 0x10000 + 0x20 * 16 * i;
>>          else
>>              addr_off = 0x13000 + 0x20 * 16 * (i - 11);  /* scape the
>> address not for interrupts */
>>          mpic_assign_isu(mpic, i, mpic->paddr + addr_off);
>>      }
>> // Add this end
>>
>>      mpic_init(mpic);
>> }
>
> NACK
>
> We already have a binding that states that the interrupt number is based
> on the register offset, rather than whatever arbitrary numbers hardware
> documenters decide to use next week.
>
> While I'm not terribly happy with the usability of this, especially now
> that it's not a simple "add 16", redefining the existing binding is not
> OK (and in any case the code above seems obfuscatory).  If we decide to
> do something other than continue with register offset divided by 32,
> then we need to define a new interrupt type (similar to current defined
> types of error interrupt, timer, and IPI) for the new numberspace -- and
> it should be handled when decoding that type of interrupt specifier,
> rather than with the isu mechanism.

I had to say that the current binding is terribly confusing.  I know a
lot of people who were confused while looking into the device tree and
I had to help them out now and then.  I even got confused for some
time at the very beginning.  :(  If we want to keep the current
binding, a big warning message is well deserved at the very beginning
of the binding document to clarify that the interrupt number used in
device tree has nothing to do with the interrupt number mentioned in
the silicon reference manuals.  I think we should even mention the
"add 16" magic rule also to make it more intuitive.

Adding a new interrupt type for external interrupts is good to make
the interrupt number consistent with the Reference Manuals.  But doing
that requires changing all the device trees that used the previous
binding, and we need a mechanism of judging which binding a device
tree is complying to.

Hongbo's proposal is not a complete fix for the readability issue.
But it makes the "add 16" magic rule continue to work, instead of
making it even worse by introducing the "+208" interrupts.  The DMA3
patch is the first time that we add the "+208" interrupts in the
device trees of mainline kernel.  It is a good time now to prevent us
making the readability even worse while not breaking things out there.
 ISU is a standard mechanism in MPIC to deal with sparse configuration
register space, and IMO a good fit for this situation.

Regards,
Leo
