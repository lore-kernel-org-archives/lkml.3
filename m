Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3GXHll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:41:41 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40393 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:41:39 -0400
Message-ID: <51EF8530.90809@monstr.eu>
Date: Wed, 24 Jul 2013 09:41:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Jingoo Han <jg1.han@samsung.com>,
        "'Michal Simek'" <michal.simek@xilinx.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stepan Moskovchenko'" <stepanm@codeaurora.org>
Subject: Re: [PATCH] video: xilinxfb: Fix compilation warning
References: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com> <007401ce8833$22ce0600$686a1200$@samsung.com> <51EF7FBD.8070103@monstr.eu>
In-Reply-To: <51EF7FBD.8070103@monstr.eu>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HANLVQSOSCBPJCHCTXJH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HANLVQSOSCBPJCHCTXJH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/24/2013 09:18 AM, Michal Simek wrote:
> On 07/24/2013 08:00 AM, Jingoo Han wrote:
>> On Wednesday, July 24, 2013 2:32 PM, Michal Simek wrote:
>>>
>>> regs_phys is phys_addr_t (u32 or u64).
>>> Lets retype it to u64.
>>>
>>> Fixes compilation warning introduced by:
>>> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
>>> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
>>
>> CC'ed Stepan Moskovchenko
>>
>>
>> phys_addr_t is defined as below:
>>
>> #ifdef CONFIG_PHYS_ADDR_T_64BIT
>> typedef u64 phys_addr_t;
>> #else
>> typedef u32 phys_addr_t;
>> #endif
>>
>> According to 'Documentation/printk-formats.txt',
>> Physical addresses:
>>        %pa     0x01234567 or 0x0123456789abcdef
>>        For printing a phys_addr_t type (and its derivatives, such as
>>        resource_size_t) which can vary based on build options, regardl=
ess of
>>        the width of the CPU data path. Passed by reference.
>>
>> Thus, '%pa' option looks proper, instead of casting (unsigned long lon=
g).
>>
>> 		dev_dbg(dev, "regs: phys=3D%pa, virt=3D%p\n", drvdata->regs_phys,
>> 					drvdata->regs);
>>
>=20
> Ah. Wasn't aware about that.
> Will retest.

On ppc44x_defconfig

$ powerpc-unknown-linux-gnu-gcc --version
powerpc-unknown-linux-gnu-gcc (crosstool-NG-svn_unknown@20110406.104745) =
4.3.2

This fix
diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 79175a6..a9a1167 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -341,12 +341,12 @@ static int xilinxfb_assign(struct platform_device *=
pdev,

        if (drvdata->flags & BUS_ACCESS_FLAG) {
                /* Put a banner in the log (for DEBUG) */
-               dev_dbg(dev, "regs: phys=3D%llx, virt=3D%p\n",
-                       (unsigned long long)drvdata->regs_phys, drvdata->=
regs);
+               dev_dbg(dev, "regs: phys=3D%pa, virt=3D%p\n",
+                       drvdata->regs_phys, drvdata->regs);
        }
        /* Put a banner in the log (for DEBUG) */
-       dev_dbg(dev, "fb: phys=3D%llx, virt=3D%p, size=3D%x\n",
-               (unsigned long long)drvdata->fb_phys, drvdata->fb_virt, f=
bsize);
+       dev_dbg(dev, "fb: phys=3D%pa, virt=3D%p, size=3D%x\n",
+               drvdata->fb_phys, drvdata->fb_virt, fbsize);

        return 0;       /* success */

Generates two warnings even it should be ok according to link to specific=
ation you sent.
  CC [M]  drivers/video/xilinxfb.o
drivers/video/xilinxfb.c: In function 'xilinxfb_assign':
drivers/video/xilinxfb.c:344: warning: format '%p' expects type 'void *',=
 but argument 4 has type 'phys_addr_t'
drivers/video/xilinxfb.c:348: warning: format '%p' expects type 'void *',=
 but argument 4 has type 'dma_addr_t'

On microblaze toolchain I see the same warnings. (mmu_defconfig)

I have also grepped the kernel and I see that it is used in 4 c files whi=
ch seems to me
weird because phy_addr_t or dma_addr_t are used on a lot of places.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2HANLVQSOSCBPJCHCTXJH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHvhTAACgkQykllyylKDCEgRACeNWnSgJlLmbdaOTrgdSln4oEI
VxEAmwTMRWKGfD9yIgj6bSvoPil5c9Ie
=j2WA
-----END PGP SIGNATURE-----

------enig2HANLVQSOSCBPJCHCTXJH--
