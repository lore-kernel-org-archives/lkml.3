Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaLDGno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:43:44 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:54584 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbaLDGnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:43:42 -0500
Date: Thu, 4 Dec 2014 06:43:41 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Sandeep Nair <sandeep_n@ti.com>,
        linux-soc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] MIPS: BCM47XX: Move NVRAM driver to the
 drivers/soc/
In-Reply-To: <alpine.DEB.2.02.1411281659190.1406@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.02.1412040603450.8865@utopia.booyaka.com>
References: <1416736241-12723-1-git-send-email-zajec5@gmail.com> <1416778509-31502-1-git-send-email-zajec5@gmail.com> <alpine.DEB.2.02.1411240910100.16047@utopia.booyaka.com> <CACna6rxwwn5_e86278TAiOFZ3sVu_Exfm2x94vN2KiTJfsFujQ@mail.gmail.com>
 <alpine.DEB.2.02.1411251407290.16047@utopia.booyaka.com> <CACna6rxj8=V8me1_L8SxhV3=kgYRyKeBHkxShSMZa4kbcHimLg@mail.gmail.com> <alpine.DEB.2.02.1411271926560.1406@utopia.booyaka.com> <CACna6rwMjOfmnA-926udNx7jQHQ2JMnmiutQZkTxtJ85qmUw8A@mail.gmail.com>
 <alpine.DEB.2.02.1411281659190.1406@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-390432641-1417675421=:8865"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-390432641-1417675421=:8865
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello Rafa=C5=82,

On Fri, 28 Nov 2014, Paul Walmsley wrote:

> On Thu, 27 Nov 2014, Rafa=C5=82 Mi=C5=82ecki wrote:
>=20
> > I'm pretty sure you look at some old version of arch/bcm47xx/nvram.c.
> > I wouldn't dare to move such a MIPS-focused driver to some common
> > place ;)
> >=20
> > Please check for the version of nvram.c in Ralf's upstream-sfr tree. I
> > think you'll like it much more. Hopefully you will even consider it
> > ready for moving to the drivers/firmware/ or whatever :)
>=20
> OK I will take a look at this, and will either send comments, or will=20
> send a Reviewed-By:.

I had the chance to take a brief look at this file, and you are right: I
like your newer version better than the older one :-)

It is too bad that it seems this flash area has to be accessed very early=
=20
in boot.  That certainly makes it more difficult to write something=20
particularly elegant.  It is also a pity that it is unknown how to verify=
=20
that the flash MMIO window has been configured before reading from these=20
areas of the address space.  But under the circumstances, calling=20
bcm47xx_nvram_init_from_mem() with the appropriate addresses from the bus=
=20
code during early init, as you did, seems rather reasonable.  I also like=
=20
the code that you added to read the flash data from MTD later in boot.

Here are a few very minor comments that you are welcome to take or leave=20
as you wish.

1. In nvram_find_and_copy(), the flash header copy loop uses:

=09for (i =3D 0; i < sizeof(struct nvram_header); i +=3D 4)
=09=09*dst++ =3D *src++;

Consider using either __raw_readl() to read from the MMIO window, or=20
possibly memcpy_fromio().  In theory, all MMIO accesses should use=20
functions like these.


2. In nvram_find_and_copy(), the flash payload copy loop uses:

=09for (; i < header->len && i < NVRAM_SPACE && i < size; i +=3D 4)
=09=09*dst++ =3D le32_to_cpu(*src++);

Consider using readl() instead of the direct MMIO read & endianness=20
conversion. =20


3. In nvram_find_and_copy(), I don't believe that this is necessary:

memset(dst, 0x0, NVRAM_SPACE - i);

since nvram_buf[] is a file-static variable, and thus should have been
initialized to all zeroes.


4. As with #3 above, in nvram_init(), I don't believe that this is=20
necessary:

memset(dst + bytes_read, 0x0, NVRAM_SPACE - bytes_read);


5. In bcm47xx_nvram_getenv(), this multiple assignment exists:

end[0] =3D end[1] =3D '\0';

Best to avoid multiple assignments, per Chapter 1 of=20
Documentation/CodingStyle.  You might consider running checkpatch.pl on=20
the file:

$ scripts/checkpatch.pl -f --strict arch/mips/bcm47xx/nvram.c
CHECK: No space is necessary after a cast
#101: FILE: arch/mips/bcm47xx/nvram.c:101:
+=09src =3D (u32 *) header;

CHECK: No space is necessary after a cast
#102: FILE: arch/mips/bcm47xx/nvram.c:102:
+=09dst =3D (u32 *) nvram_buf;

CHECK: multiple assignments should be avoided
#195: FILE: arch/mips/bcm47xx/nvram.c:195:
+=09end[0] =3D end[1] =3D '\0';

CHECK: Alignment should match open parenthesis
#202: FILE: arch/mips/bcm47xx/nvram.c:202:
+=09=09if ((eq - var) =3D=3D strlen(name) &&
+=09=09=09strncmp(var, name, (eq - var)) =3D=3D 0) {


6. bcm47xx_nvram_getenv() calls strchr().  Perhaps it would be better to=20
use strnchr(), in case the flash data is corrupted or in an invalid=20
format?


7. There are a few magic numbers in this code, mostly in=20
bcm47xx_nvram_gpio_pin().  It might be worth converting those to macros=20
and documenting the expectations there in a comment above the macro.


8.  The way that bcm47xx_nvram_gpio_pin() calls bcm47xx_nvram_getenv()=20
seems a bit inefficient.  It might be better to loop over all of the keys=
=20
in the shadowed flash, looking for values that match "name".  Then if the=
=20
key name matches "gpio" plus one or two digits, the code could just return=
=20
the digits.  That way, only one pass is needed, rather than 32 (in the=20
worst case).  Well, at least the reads should be coming from cached DRAM,=
=20
rather than flash...

If you fix/address those (or correct my review ;-) ), then you're=20
welcome to add my Reviewed-by: to a patch that moves this file out to=20
drivers/firmware.


regards,=20

- Paul
--843723315-390432641-1417675421=:8865--
