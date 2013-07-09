Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3GIOP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:15:28 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34073 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GIOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:15:23 -0400
Message-ID: <51DC1AF1.3090401@monstr.eu>
Date: Tue, 09 Jul 2013 16:15:13 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com> <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com> <20130708144930.GG27646@sirena.org.uk> <51DADF3E.1000802@monstr.eu> <20130708162642.GM27646@sirena.org.uk>
In-Reply-To: <20130708162642.GM27646@sirena.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2OMKGBNRUKQLHSCLVVLIJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2OMKGBNRUKQLHSCLVVLIJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/08/2013 06:26 PM, Mark Brown wrote:
> On Mon, Jul 08, 2013 at 05:48:14PM +0200, Michal Simek wrote:
>> On 07/08/2013 04:49 PM, Mark Brown wrote:
>=20
>>> Is it definitely safe to leave the IRQ hanging around after the maste=
r
>>> has been freed - there's no possibility of a late error interrupt or
>>> something?
>=20
>> I think it is more generic question if this race condition is fine
>> for all drivers which are using devres groups.
>=20
> Well, it's mainly an issue for IRQs - the other resources don't initiat=
e
> events by themselves which is what causes the issue.  It just needs a
> bit of extra care so I wanted to check that this has been thought of.

That's good and thanks for that.

>> I have just looked at it and devres_release_all() is called where
>> driver is unload and irq are disabled there.
>=20
> The problem is the gap between the resources used to handle the IRQ
> being freed and the IRQ itself being freed - if the hardware can be
> guaranteed to be idle then that's fine but we need to be sure that is
> OK.  Otherwise the interrupt handler may get run and be looking at a
> resource which was freed which would be unfortunate.

I am not sure if I understand you correctly

Here is the current flow which I see.
1. driver_remove() is called
2. spi_bitbang_stop() with spi_unregistered_master()
3. free_irq()
4. spi_master_put()
5. spi_master_release()
6. devres_release()

My patch is changing this flow where irq are freed in point 5.
1. driver_remove() is called
2. spi_bitbang_stop() with spi_unregistered_master()
3. spi_master_put()
4. spi_master_release()
5. devres_release() with irq

If interrupt happends between 4 and 5 than it can be the problem.
Do I understand you correctly?

If this is problematic case we can disable local and global interrupts
and add it between 2 and 3 or 3-4.
	/* Disable all the interrupts just in case */
	xspi->write_fn(0, regs_base + XIPIF_V123B_IIER_OFFSET);
	/* Disable the global IPIF interrupt */
	xspi->write_fn(0, regs_base + XIPIF_V123B_DGIER_OFFSET);

What do you think about this solution?

I have also tried to run one thing with and without this patch
and the results are below.

When I add this irq disable function between 1 and 2 then
module removing stucks.

Thanks,
Michal


~ # modprobe spi-xilinx
xilinx_spi 75600000.spi: master is unqueued, this is deprecated
m25p80 spi0.0: found s25fl064k, expected m25p80
m25p80 spi0.0: s25fl064k (8192 Kbytes)
6 ofpart partitions found on MTD device spi0.0
Creating 6 MTD partitions on "spi0.0":
0x000000000000-0x000000200000 : "fpga"
0x000000200000-0x000000240000 : "boot"
0x000000240000-0x000000260000 : "bootenv"
0x000000260000-0x000000280000 : "config"
0x000000280000-0x000000e80000 : "image"
mtd: partition "image" extends beyond the end of device "spi0.0" -- size =
truncated to 0x580000
0x000000e80000-0x000000800000 : "spare"
mtd: partition "spare" is out of reach -- disabled
xilinx_spi 75600000.spi: at 0x75600000 mapped to 0xf0120000, irq=3D3
~ #
~ # dd if=3D/dev/zero of=3D/dev/mtd1 &
~ # sleep 1 && rmmod spi-xilinx
Removing MTD device #1 (boot) with use count 1
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1307 __queue_work+0xe4/0x258()
Modules linked in: spi_xilinx(-) [last unloaded: spi_xilinx]
CPU: 0 PID: 138 Comm: sh Not tainted 3.10.0-rc4+ #34
Kernel Stack:
c6f1fb10: c0009e98 ffffffff 00000000 00292d28 c6f5c200 00000000 00000009 =
c0009ee4
c6f1fb30: c02880b8 c028d8a8 0000051b c0022bb4 00000400 00005d14 000065a0 =
c6ebaca0
c6f1fb50: c6ed2740 00000001 00000000 c0022bb4 c0035658 c0037028 c6f3cd60 =
c6f3caec
c6f1fb70: c6f3cd8c c6f3caec c0022d88 c0314dd4 c6f3cd60 c0314dd4 c6f3cd8c =
c0314e14
c6f1fb90: 00000001 000065a0 000065a0 c6e9b6c0 c6e9b6c0 c6f1fc48 c01b10c4 =
00000200
c6f1fbb0: c6f1fbc4 c0314dd4 7fffffff c0036694 c6f3ceb8 c6f1fca4 c01aef1c =
00000000
c6f1fbd0: c6f1fbd8 c6f3cac0 c0314dd4 c6f3cac0 c0314e14 000065a2 c6ed2600 =
00000000
c6f1fbf0: c01aef94 c6f1fc00 c6f3cac0 c7829810 c6f1fc10 c6f1fc10 c6f3cd60 =
c01af26c
c6f1fc10: c01af260 c01aef1c c6ed2600 c782fb00 c6ed2740 c0021f2c c6f1fca4 =
c01af2e8
c6f1fc30: c6f1fd40 7fffffff 00000002 00000000 00000000 00000100 00000000 =
c6f1fc4c
c6f1fc50: c6f1fc4c c0022bf0 c7844ca0 c7844ca1 c6f1fca4 00000001 c6f1fd50 =
c01af434
c6f1fc70: c0022d88 c6f1fcf0 c01af2e8 c0044088 00000000 c002d8e0 c01ad7c4 =
000065a0
c6f1fc90: 000065a0 c6e9b6c0 c6e9b6c0 c6f1fd40 c01b10c4 c6f1fcec c6f1fd10 =
c6e9b6c0
c6f1fcb0: 00000000 c01af4c0 c6f1fc48 00000000 ffffff8d c6ed2750 c6ed2750 =
00000000
c6f1fcd0: c7844ca0 00000000 00000001 00000000 00000000 00000800 00bebc20 =
c6f1fd10
c6f1fcf0: c6f1fca4 00000000 c7844ca1 00000001 00000000 00000000 00000800 =
00bebc20
c6f1fd10: c6f1fca4 c6f1fcec ffff8ad8 c6ed2400 00000000 c6f1fea8 c6ed2400 =
00000200
c6f1fd30: 00000000 c01ade30 c6f1fcf0 c6f1fcf0 00000000 c6f1fd44 c6f1fd44 =
00000000
c6f1fd50: c6ed0510 ffff8ad8 c6ed2400 c01adf38 c6ed2400 c01adf30 c6f1fda0 =
00000100
c6f1fd70: c6f1fea8 c6ed2400 c6ed2410 c6f1fda0 c018fafc c0b1a960 c0011db4 =
c0011ea0
c6f1fd90: c0001dac c6f1e000 c6f5ce00 c6f5c206 c6f1fde8 c6f1fe0c 00000000 =
00000000
c6f1fdb0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 =
c6f19620
c6f1fdd0: 00000000 00000004 00000000 00000000 00000000 00000000 c6f1fe0c =
c6f1fda0
c6f1fdf0: c6f5c200 00000000 00000000 00000000 00000000 00000000 00000000 =
c6f1fda0
c6f1fe10: c6f1fde8 00000200 00200000 00000000 0001a800 00000000 10148a38 =
00000000
c6f1fe30: 10148a38 10148a38 c6f757a0 c018cc7c 00000200 10144b50 482b8470 =
c6f5ce00
c6f1fe50: c6f5c200 c6f1feac 00040000 00000000 c0192f94 c0192e60 10148a38 =
c6f757a0
c6f1fe70: c6f3cd60 c01553d8 800045a4 c6f5ce00 c6f5c200 00000200 c6f1ff50 =
c008740c
c6f1fe90: 10144b50 482b8470 00000200 c0087490 c0087620 00000200 00000000 =
00000200
c6f1feb0: 10148a38 10148a38 c017dd68 c6f3cd60 c027b458 00000000 00000000 =
00000000
c6f1fed0: c6f1e000 c0087600 c6f17e40 00000200 10148a38 c6f1ff50 00000200 =
10148a38
c6f1fef0: 1012bd84 10148a38 10148a38 00000001 c0087890 c00877f0 00000001 =
00000003
c6f1ff10: 00000000 00000000 00000000 c6f17e40 00000000 10148a38 00000001 =
00000200
c6f1ff30: 10148a38 c0005488 00000000 00000001 00000000 10145428 10145428 =
00000200
c6f1ff50: 00025800 00000000 00000200 10147440 00000200 10148a38 00000004 =
bfc9f550
c6f1ff70: 00000000 00000000 00000000 00000001 10148a38 00000200 1014829f =
00000000
c6f1ff90: 482b4730 00000006 00000004 00000000 00000000 1000cc50 00000000 =
10007824
c6f1ffb0: 7fffeffd 10147440 10144b50 482b8470 00000200 10148a38 00000001 =
00000200
c6f1ffd0: 10148a38 1012bd84 10148a38 10148a38 00000001 00000000 482097f8 =
000055aa
c6f1fff0: 1000c264 00000000 00000000 00000000


Call Trace:
[<c0003bfc>] microblaze_unwind+0x48/0x68
[<c0003924>] show_stack+0x118/0x158
[<c02775cc>] dump_stack+0x20/0x38
[<c0009e94>] warn_slowpath_common+0x7c/0xbc
[<c0009ee0>] warn_slowpath_null+0xc/0x24
[<c0022bb0>] __queue_work+0xe0/0x258
[<c0022d84>] queue_work_on+0x38/0x60
[<c01b10c0>] spi_bitbang_transfer+0x70/0xa0
[<c01aef18>] __spi_async+0xe4/0x108
[<c01aef90>] spi_async_locked+0x10/0x34
[<c01af268>] __spi_sync+0x70/0xcc
[<c01af2e4>] spi_sync+0x4/0x1c
[<c01af430>] spi_write_then_read+0x134/0x1c4
[<c01ad7c0>] read_sr+0x2c/0x7c
[<c01ade2c>] wait_till_ready+0x1c/0x6c
[<c01adf34>] m25p80_write+0xb8/0x268
[<c018faf8>] part_write+0x24/0x44
[<c018cc78>] mtd_write+0x8c/0xbc
[<c0192f90>] mtdchar_write+0x1d4/0x298
[<c0087408>] vfs_write+0xe8/0x1cc
[<c008788c>] SyS_write+0x50/0xa0
SYSCALL



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2OMKGBNRUKQLHSCLVVLIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHcGvEACgkQykllyylKDCHO+QCcC/iule+Lqj9kSUFRmrRtMAwy
EQ8AoIDLCnUEycLnOy/fMgyYPBGgoTWm
=PbLu
-----END PGP SIGNATURE-----

------enig2OMKGBNRUKQLHSCLVVLIJ--
