Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaK0T4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:56:48 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:43324 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaK0T4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:56:47 -0500
Date: Thu, 27 Nov 2014 19:56:46 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, Hauke Mehrtens <hauke@hauke-m.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Sandeep Nair <sandeep_n@ti.com>,
        linux-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] MIPS: BCM47XX: Move NVRAM driver to the
 drivers/soc/
In-Reply-To: <CACna6rxj8=V8me1_L8SxhV3=kgYRyKeBHkxShSMZa4kbcHimLg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1411271926560.1406@utopia.booyaka.com>
References: <1416736241-12723-1-git-send-email-zajec5@gmail.com> <1416778509-31502-1-git-send-email-zajec5@gmail.com> <alpine.DEB.2.02.1411240910100.16047@utopia.booyaka.com> <CACna6rxwwn5_e86278TAiOFZ3sVu_Exfm2x94vN2KiTJfsFujQ@mail.gmail.com>
 <alpine.DEB.2.02.1411251407290.16047@utopia.booyaka.com> <CACna6rxj8=V8me1_L8SxhV3=kgYRyKeBHkxShSMZa4kbcHimLg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1041491994-1417118206=:1406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1041491994-1417118206=:1406
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

+ lkml

Hi Rafa=C5=82,

On Tue, 25 Nov 2014, Rafa=C5=82 Mi=C5=82ecki wrote:

> On 25 November 2014 at 18:50, Paul Walmsley <paul@pwsan.com> wrote:
> >> I don't think NVRAM can be treated as a standard char device. Also, in
> >> my V1 I tried moving it to the drivers/misc/, but then drivers/soc/
> >> was suggested as a better place, see Arnd's reply:
> >> http://www.linux-mips.org/archives/linux-mips/2014-11/msg00238.html
> >
> > Yeah.  It depends on who is going to merge the patch.  If you can persu=
ade
> > someone else to merge it in drivers/soc, then it doesn't really matter
> > what I think.
>=20
> I'm looking for the solution that will satisfy most ppl.=20

Wow, that's a pretty high bar ;-)  Better IMHO to try for something that=20
seems to make rational sense, then let others convert it into something=20
that makes less sense afterwards, if necessary ;-)

> I understand your arguments against drivers/soc/, but on the other hand=
=20
> I have no idea where else this driver could go.

After looking around the tree to find out where similar code is located,=20
it looks like drivers/firmware is the right place.  These days,=20
drivers/firmware is mainly used for drivers that parse EFI bootloader=20
data, DMI data, that sort of thing.  Quite similar to the CFE-provided=20
data that the bcm47xx-nvram code deals with.  So, by functional analogy,=20
drivers/firmware appears to be the right place to stash this device=20
data-probing code.

> I guess DT is older than CFE, but Broadcom decided to invent own
> solution called NVRAM anyway. This is a bit messy, because it actually
> stores hardware details (CPU, RAM, switch) as well as user settings
> (e.g. LEDs behavior). I can't say why Broadcom decided to implement it
> this way.

Yep, based on what the other drivers in drivers/firmware are used for, I=20
think drivers/firmware is the right place for the CFE parsing code.

> > It sounds to me like this code is a combination of three
> > pieces:
> >
> > 1. code that autoprobes the size of the "nvram" partition in the Broadc=
om
> > platform flash, by reading various locations in the MMIO flash aperture=
,
> > configured by some other system entity
>=20
> That's right, on MIPS we simply detect flash type (drivers/ssb &
> driver/bcma) and using that we init NVRAM passing memory offset where
> the flash is mapped.

OK.

So (as a side issue), I would suggest that when you move this code out of=
=20
arch/mips, the MIPS-isms in it should be removed, like KSEG1ADDR(), etc.,=
=20
and replaced by the standard ioremap()-type approach.  After all, Broadcom=
=20
could build CFE for ARM, and then we'd want to use this same code to parse=
=20
the CFE-provided data.

Also I would suggest getting rid of the #ifdefs for the flash type, and=20
probing it dynamically instead.  The flash setup code under drivers/ssb/=20
and drivers/bcma/ sets up platform_devices for the flash, right?  If so=20
then it would be best if this code could run after the bus setup code,=20
query the Linux device model for the type of platform flash in use, and=20
then extract the appropriate address space to probe from that data.

> > 2. code that shadow copies the device data from the MMIO flash aperture
> > into system RAM
> >
> > 3. code that parses the CPE-generated device data and returns it to oth=
er
> > drivers
> >
> > Does that sound accurate?
>=20
> Correct (s/CPE/CFE).

Thanks for the correction, I must have been dreaming of telecom=20
equipment..

What do you think?  Does this sound reasonable?


- Paul
--843723315-1041491994-1417118206=:1406--
