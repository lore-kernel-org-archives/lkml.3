Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbaDIPvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:51:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:65111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbaDIPvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:51:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Date: Wed, 09 Apr 2014 17:50:57 +0200
Message-ID: <5844640.QRALKyBQaa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140409152711.GT16119@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com> <20140409151326.GY29751@pengutronix.de> <20140409152711.GT16119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:oRpeSMvyOY4nCDxpoZZRriH6GLHyI/ph4GCF6L38hOj
 bnrL/xKgsCnNEhSPfdexFzhmvHDOHLKgSWH97xukILGq86jJJ2
 3WPD26+2h+VSRKdunvOFxGo24e1EtImt98rU+x4UFOzRVyn95j
 duhYyiS6qLIIP+AkavIbd+eHwGK/qL5ARDlvExJtKW/wdRYEfU
 3XqlG9VykU854E1HRU1nB5psdJWMqmYFmSEyeu584A6FOPmhtO
 NhELfuI1/EfTMS+JgnB2+EkXib+MsMJ2Dz170olsrsuANT2lcQ
 cz44nqIubY0BXEe8BHfhIuEQMnCRVcpHxF/jibUK1pKYH7Uz+D
 r21U0daiELE7/zX/FA8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014 16:27:11 Russell King - ARM Linux wrote:
> On Wed, Apr 09, 2014 at 05:13:26PM +0200, Uwe Kleine-König wrote:
> > On Wed, Apr 09, 2014 at 04:06:40PM +0100, Russell King - ARM Linux wrote:
> > > On Wed, Apr 09, 2014 at 04:54:16PM +0200, Jonas Jensen wrote:
> > > > On 13 December 2013 12:39, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > > diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> > > > index 1879e8d..de15bfd 100644
> > > > --- a/arch/arm/kernel/entry-armv.S
> > > > +++ b/arch/arm/kernel/entry-armv.S
> > > > @@ -739,6 +739,18 @@ ENDPROC(__switch_to)
> > > > 
> > > >         .macro  usr_ret, reg
> > > >  #ifdef CONFIG_ARM_THUMB
> > > > +       /*
> > > > +        * Having CONFIG_ARM_THUMB isn't a guarantee that the cpu has support
> > > > +        * for Thumb and so the bx instruction. Use a mov if the address to
> > > > +        * jump to is 32 bit aligned. (Note that this code is compiled in ARM
> > > > +        * mode, so this is the right test.)
> > > > +        */
> > > > +#if defined(CONFIG_CPU_32v4)
> > > > +       tst     \reg, #3
> > > > +       moveq   pc, \reg
> > > > +       b       .
> > > > +#endif
> > > > +
> > > >         bx      \reg
> > > 
> > > What's wrong with:
> > >     tst     \reg, #3
> > >     moveq   pc, \reg
> > >     bx      \reg
> > > 
> > > rather than ending in an infinite loop?
> > The added b . was a test to check if the machine then hangs instead of
> > crashing. (And yes, that was the case, so it was tried to return to a
> > non-aligned address.)
> 
> If it's called from ARM code, then \reg will contain a 4-byte aligned
> address.  If it's called from Thumb code, \reg will contain a 2-byte
> aligned address with bit 0 *always* set.

Right, that is the assumption.

> So, with the code originally quoted above, if the helper is called from
> thumb code, and CONFIG_CPU_32v4 is enabled, then we end up falling past
> the moveq to the "b ." and entering an infinite loop.

As Uwe said, that "b ." was not meant to be in the patch used for
submission, it was to check what goes wrong when running this code
on ARMv4 -- either crash user space or hang in an infinite loop.
I forgot what the result of that experiment was.

The trouble is that this code:

       .macro  usr_ret, reg
#ifdef CONFIG_ARM_THUMB
#ifdef CONFIG_CPU_32v4
	tst     \reg, #3
	moveq   pc, \reg
#endif
        bx      \reg
#else
	mov	pc, \reg
#endif
	.endm

for some reason does the wrong thing running on ARMv4 (fa526) with non-thumb
user space when both CONFIG_CPU_32v4 and CONFIG_ARM_THUMB are enabled:
it still tries to do the 'bx' and triggers an invalid opcode exception.

	Arnd
