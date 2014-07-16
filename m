Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030411AbaGPQqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:46:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58461 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030376AbaGPQqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:46:21 -0400
Date: Wed, 16 Jul 2014 11:45:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Steven Rostedt <rostedt@goodmis.org>, <will.deacon@arm.com>,
        <mingo@redhat.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: Function Profiler broken on today's linux-next
Message-ID: <20140716164511.GB3016@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140716162328.GJ1365@saruman.home>
 <20140716122921.71b118a9@gandalf.local.home>
 <20140716164141.GA3016@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <20140716164141.GA3016@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, Jul 16, 2014 at 11:41:41AM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Wed, Jul 16, 2014 at 12:29:21PM -0400, Steven Rostedt wrote:
> > On Wed, 16 Jul 2014 11:23:28 -0500
> > Felipe Balbi <balbi@ti.com> wrote:
> >=20
> > > Hi folks,
> > >=20
> > > I was trying to use Kernel Function Profiler to figure out why my
> > > driver's IRQ handler is taking so much CPU time but to my surprise,
> > > whenever I try to trace anything, I get a "Unable to handle kernel
> > > paging request at virtual address XXXX" error.
> > >=20
> > > Is anybody else seen that or did I screw up my Kernel config ?
> >=20
> > No, it's probably my fault. The ftrace infrastructure is going through
> > an overhaul and some dramatic changes are happening. Although it has
> > passed all my tests, I can't cover everyone's configs and use cases.
> >=20
> > Please send me your config and the steps you did to enable function
> > profiling. This is x86 correct? Other archs are already known to be
> > broken and I'm working on fixing them now.
>=20
> .config attached. It's actually an ARM platform, I can help out with
> testing anything you need.

for the steps:

# mount -t debugfs none /debug
# cd /debug/tracing
# echo dwc3* > set_graph_function
# echo dwc3* > set_function_filter
# echo 1 > function_profile_enabled
# echo 1 > tracing_on
# modprobe g_zero # this binds g_zero to dwc3 and a few functions from
		  # dwc3 are called

KABOOM! (see below)

[   41.135792] Unable to handle kernel paging request at virtual address ed=
6c9170
[   41.143375] pgd =3D ec290000
[   41.146207] [ed6c9170] *pgd=3Dad60041e(bad)
[   41.150420] Internal error: Oops: 8000000d [#1] SMP ARM
[   41.155898] Modules linked in: g_zero(+) libcomposite configfs matrix_ke=
ypad lis3lv02d_i2c lis3lv02d input_polldev
[   41.166801] CPU: 0 PID: 1710 Comm: modprobe Tainted: G        W      3.1=
6.0-rc5-next-20140715-00031-gb041877 #529
[   41.177559] task: ec0050c0 ti: ec288000 task.ti: ec288000
[   41.183217] PC is at 0xed6c9170
[   41.186507] LR is at 0xec289d44
[   41.189799] pc : [<ed6c9170>]    lr : [<ec289d44>]    psr: 00000013
[   41.189799] sp : ec289d1c  ip : ed6c9170  fp : ec289d24
[   41.201831] r10: 00000000  r9 : bf0288d8  r8 : bf0288b8
[   41.207303] r7 : bf03a7c4  r6 : ed6c9170  r5 : ed6c9170  r4 : ed465740
[   41.214139] r3 : ed6c9170  r2 : ed465740  r1 : c04d6bdc  r0 : bf0285c0
[   41.220977] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 user
[   41.228452] Control: 10c5387d  Table: ac290059  DAC: 00000015
[   41.234467] Process modprobe (pid: 1710, stack limit =3D 0xec288248)
[   41.240937] Stack: (0xec289d1c to 0xec28a000)
[   41.245510] 9d00:                                                       =
         ec289d28
[   41.254095] 9d20: c000ecec c04d6be8 ed465740 bf03a7ec ed6c9170 bf03a7c4 =
ec289d7c ec289d48
[   41.262661] 9d40: bf028954 bf028594 ec289d74 ec289d58 c0419b9c ed4a9c00 =
bf03a7ec bf03a7ec
[   41.271239] 9d60: ed4a9c08 bf0288b8 bf0288d8 00000000 ec289d9c ec289d80 =
c04fc6fc bf0288e4
[   41.279817] 9d80: bf03a7ec c0b0ba8c bf03a7ec bf026e40 ec289db4 ec289da0 =
c04fca70 c04fc6b0
[   41.288387] 9da0: bf03a7c4 bf03a448 ec289ddc ec289db8 bf026c38 c04fc9fc =
c0a84060 c0a84060
[   41.296958] 9dc0: bf03d264 ec288030 00000000 ec2bea40 ec289dec ec289de0 =
bf03d278 bf026b98
[   41.305527] 9de0: ec289e84 ec289df0 c0008a54 bf03d270 ed000040 a0000013 =
ec289e14 ec289e08
[   41.314090] 9e00: c008cbb4 c008c9d4 ec289e4c ec289e18 c014afa4 c008cbac =
0000001d ec2bea40
[   41.322634] 9e20: f0614000 ec2bea40 00000000 00000000 0000001e ec2bea40 =
f0614000 00000001
[   41.331190] 9e40: ec289e6c ec289e50 c0140f38 c014aed8 ec289f48 00000000 =
bf03a854 ec289f48
[   41.339739] 9e60: 00000000 bf03a854 00000018 00000000 00000000 bf03a848 =
ec289f44 ec289e88
[   41.348286] 9e80: c00c54ec c00089d0 ffff8000 00007fff c00c2854 c015aa78 =
0001d579 00000000
[   41.356835] 9ea0: f0614000 ec289f7c ec289f50 000000cc f06299e8 bf03a854 =
bf03aa44 b6fb27a0
[   41.365412] 9ec0: ec288008 00000000 00120720 00000000 0b300002 c0a881a4 =
00000001 00000000
[   41.373963] 9ee0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[   41.382513] 9f00: 00000000 00000000 00000000 00000000 00000000 00000000 =
ec289f34 00000000
[   41.391066] 9f20: 00000005 b6fb27a0 0000017b c000ee04 ec288000 00000000 =
ec289fa4 ec289f48
[   41.399635] 9f40: c00c5ad4 c00c3ed0 f0614000 0001d579 f0629218 f0629020 =
f0630ad8 00000a44
[   41.408192] 9f60: 00001024 00000000 00000000 00000000 00000032 00000033 =
00000019 0000001d
[   41.416747] 9f80: 0000000e 00000000 00000000 b6fb3d10 00000000 70f62c00 =
00000000 ec289fa8
[   41.425293] 9fa0: c000eb80 c00c5a68 b6fb3d10 00000000 00000005 b6fb27a0 =
00000000 b6fb40b8
[   41.433838] 9fc0: b6fb3d10 00000000 70f62c00 0000017b 00000000 00000000 =
00000000 b6fbe2d8
[   41.442401] 9fe0: becaa6d8 becaa6c8 b6fa70a4 b6ee4160 60000010 00000005 =
00000000 00000000
[   41.450958] Code: ed4a83c0 ed4a8b40 ed4a8340 00000000 (00000000)=20
[   41.457327] ---[ end trace cb88537fdc8fa202 ]---
Segmentation fault

cheers

--=20
balbi

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxqwXAAoJEIaOsuA1yqREk3QP/2EmDfo4ivTSpIzsmKY58DO5
MyIaWiQ1mzDMpi6YD0brOVfx1JN4b414JwoRRHi20n2kp5WoW9OF1TA4zdgwkvm6
IZ772mB/jB7ADRzD0mks5JDE/R2wyN8bQ4w0Lv+duV98BHZ8YT6pF901vWYGLxgN
j8ofYm9pkuLndjsHuysrDToqLSlkf8KSUcaJnJ9LEF+CfPi7uPDYUBXif16wWxqW
PpDNC9qYqRo2TiX1U5WtCVwQsyAsyWUey7jMusntsRIBBGYY3UXXc1/7Y33gWlTX
QEgWYby9VLqFqrYE7pTJDxQJ4L/pfcBvegdsz6AC1ZOhT5deUcFui13IXRbSYEFz
9AJNAdD4EXBVSn7HQcnJ93BBG/pCjrugkQBYo3V4u5Wh6oBFA4oYt/YqZ+stjFYd
Z/ESri/azeA3/ou4AiXE46Mj7aUxNhoHBDZgwt/n2cEMtyZp7ankhQ8yBenl89Wu
FlNnfhUJ61/p1cB6wTK1gVwmqGNUsjc/gaEL2gGoNEQsh/unFu2mBehRNgmUPY07
79zLooFL3D7PzltR4wPn8MWtk4KNWRfko6J1B+Rsoc/NVfaMqdVCGo7pqe7iqWiQ
V7ST80VZz3Oc3rOH+u64+IP59XqNfBzNqfNkpoqocaVdoCQiKFwcOHVelbx229p7
akpmNeU80xt7bJwuS8Qh
=CW5V
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
