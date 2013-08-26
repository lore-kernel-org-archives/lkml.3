Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3HZLPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:15:25 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:39977 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3HZLPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:15:24 -0400
Message-ID: <521B38BF.6040400@monstr.eu>
Date: Mon, 26 Aug 2013 13:15:11 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com> <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local> <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local> <20130823073250.GB30135@pengutronix.de>
In-Reply-To: <20130823073250.GB30135@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="egBuROVQsWpp7avJQGAUxhvXwAMQKFfp7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--egBuROVQsWpp7avJQGAUxhvXwAMQKFfp7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/23/2013 09:32 AM, Steffen Trumtrar wrote:
> Hi!
>=20
> On Thu, Aug 22, 2013 at 05:59:36PM -0700, S=F6ren Brinkmann wrote:
>> On Thu, Aug 22, 2013 at 05:26:47PM -0700, S=F6ren Brinkmann wrote:
>>> Hi Sebastian,
>>>
>>> On Tue, Aug 20, 2013 at 04:04:31AM +0200, Sebastian Hesselbarth wrote=
:
>>>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now=

>>>> remove it from corresponding drivers/clk code.
>>>
>>> I think that would break Zynq.
>>> If I see this correctly you call of_clk_init() from common code,
>>> _before_ the SOC specific time init function is called.
>>> The problem is, that we have code setting up a global pointer which i=
s
>>> required by zynq_clk_setup() which is triggered when of_clk_init() is=

>>> called.
>>>
>>> Let me try to illustrate the current call graph:
>>>
>>> time_init()
>>> 	zynq_timer_init()		// this machines init_time()
>>> 		zynq_slcr_init()	// setup System Level Control Registers including =
a global pointer
>>> 			zynq_clock_init()
>>> 				of_clk_init()
>>> 					zynq_clk_setup()   // requires pointer setup in zynq_slcr_init()=

>>> 					...
>>>
>>> IIUC, your series would change this to:
>>> time_init()
>>> 	of_clk_init()
>>> 		zynq_clk_setup()	// SLCR pointer is not setup/NULL
>>> 		...
>>> 	zynq_timer_init()
>>> 		zynq_slcr_init()	// now the pointer becomes valid
>>
>> I guess we could move zynq_slcr_init() into init_irq(). I'll give that=
 a
>> shot tomorrow.
>>
>=20
> I propose getting rid of the whole global pointer and let the clkc map =
the
> address itself instead.
>=20
> Then there is no need to shuffle stuff around in the initcalls.
> I have some WIP patches (not rebased on next and not even tested with i=
t,
> but with v3.11-rc4)
>=20
> The dtsi would be something like:
>=20
>        control-register@f8000000 {

This name is incorrect - it still should be slcr (system level control re=
gisters)

> 	       compatible =3D "simple-bus";

I expect that syscon compatible should be here not in the lock part becau=
se
you want to map the whole reg space.

>                #address-cells =3D <1>;
>                #size-cells =3D <1>;
>                reg =3D <0xf8000000 0x1000>;
>                ranges;
>=20
>                slcr: slcr@f8000000 {

we should use different name here - lock/locks/etc.

>                        compatible =3D "xlnx,zynq-slcr", "syscon";
>                        reg =3D <0xf8000000 0x10>;
>                };



>=20
>                clkc: clkc@f8000100 {
>                        #clock-cells =3D <1>;
>                        compatible =3D "xlnx,ps7-clkc";
>                        reg =3D <0xf8000100 0x100>;
>                        ps-clk-frequency =3D <33333333>;
> 		       xlnx,slcr =3D <&slcr>;

Currently there is no code which handles locks that's why I think at leas=
t
for now it is not necessary to extend binding which feature which is not =
used.

>                        clock-output-names =3D "armpll", "ddrpll", "iopl=
l", "cpu_6or4x",
>                                        "cpu_3or2x", "cpu_2x", "cpu_1x",=
 "ddr2x", "ddr3x",
>                                        "dci", "lqspi", "smc", "pcap", "=
gem0", "gem1",
>                                        "fclk0", "fclk1", "fclk2", "fclk=
3", "can0", "can1",
>                                        "sdio0", "sdio1", "uart0", "uart=
1", "spi0", "spi1",
>                                        "dma", "usb0_aper", "usb1_aper",=
 "gem0_aper",
>                                        "gem1_aper", "sdio0_aper", "sdio=
1_aper",
>                                        "spi0_aper", "spi1_aper", "can0_=
aper", "can1_aper",
>                                        "i2c0_aper", "i2c1_aper", "uart0=
_aper", "uart1_aper",
>                                        "gpio_aper", "lqspi_aper", "smc_=
aper", "swdt",
>                                        "dbg_trc", "dbg_apb";
>                };
>=20
>                mio: pinmux@f8000700 {
>                        compatible =3D "xlnx,ps7-pinctrl";

Have you created any driver for pinmuxing stuff?

I agree with Soren - let's fix the current problem and then when Steffen =
has patches with syscon
we can look at them.

If there is any discussion about early syscon registration please let me =
know.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--egBuROVQsWpp7avJQGAUxhvXwAMQKFfp7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIbOMcACgkQykllyylKDCGaKACeLgXZVmv1dCWOy66zMpoMXwmQ
V3cAnjJjJed//mJ2dzeAMv+IHCV/0bJ4
=07gJ
-----END PGP SIGNATURE-----

--egBuROVQsWpp7avJQGAUxhvXwAMQKFfp7--
