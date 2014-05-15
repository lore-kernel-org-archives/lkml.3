Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaEON4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:56:19 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57886 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaEON4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:56:16 -0400
Message-ID: <5374C773.6070402@monstr.eu>
Date: Thu, 15 May 2014 15:56:03 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, grant.likely@linaro.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be> <53748D84.5040005@monstr.eu> <5049141.XmehsUeakV@wuerfel>
In-Reply-To: <5049141.XmehsUeakV@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="otLomWjiM6oLf2rlAlPhA3Ig0fQPLnvFE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--otLomWjiM6oLf2rlAlPhA3Ig0fQPLnvFE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/15/2014 02:20 PM, Arnd Bergmann wrote:
> On Thursday 15 May 2014 11:48:52 Michal Simek wrote:
>> On 05/14/2014 01:26 PM, Bart Tanghe wrote:
>>> 	add Xilinx PWM support - axi timer hardware block=20
>>>
>>> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
>>> diff --git a/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt b/Doc=
umentation/devicetree/bindings/pwm/pwm-xlnx.txt
>>> new file mode 100644
>>> index 0000000..cb48926
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
>>> @@ -0,0 +1,20 @@
>>> +Xilinx PWM controller
>>> +
>>> +Required properties:
>>> +- compatible: should be "xlnx,pwm-xlnx"
>>> +- add a clock source to the description
>>> +
>>> +Examples:
>>> +
>>> +		axi_timer_0: timer@42800000 {
>>> +			clock-frequency =3D <100000000>;
>>
>> just remove this from example it is not needed and unused.
>>
>>
>>> +			clocks =3D <&clkc 15>;
>>> +			compatible =3D "xlnx,xlnx-pwm";
>>> +			reg =3D <0x42800000 0x10000>;
>>> +			xlnx,count-width =3D <0x20>;
>>> +			xlnx,gen0-assert =3D <0x1>;
>>> +			xlnx,gen1-assert =3D <0x1>;
>>> +			xlnx,one-timer-only =3D <0x0>;
>>> +			xlnx,trig0-assert =3D <0x1>;
>>> +			xlnx,trig1-assert =3D <0x1>;
>>> +		} ;
>>
>> ok. This has to be done completely differently.
>> I have looked around and found one a little bit older
>> example but it is in the Linux kernel.
>> It is pwm-atmel-tcb.c driver and atmel_tclib.c and tcb_clksrc.c.
>>
>> Arnd: Isn't there any newer better example how to manage it?
>=20
> Note that we have two atmel pwm drivers: drivers/misc/atmel_pwm.c=20
> and drivers/pwm/pwm-atmel.c. If you want to take that as an example,
> make sure you use base on the latter.

Yes, I have seen that there are two drivers. atmel_pwm is older one
without using that tclib.

>=20
>> Back to atmel example - they are maintaining
>> internal list of timers (atmel_tclib.c)
>> and then clocksource driver (tcb_clksrc.c) is asking with atmel_tc_all=
oc() for it.
>> The same is for pwm driver (pwm-atmel-tcb.c).
>>
>> They probably have all timers the same which is not
>> our case because they can be different but this can be solved
>> with flags.
>>
>> From DT point of view I think this is the reasonable description
>>
>> axi_timer_0: timer@42800000 {
>> 	clocks =3D <&clkc 15>;
>> 	compatible =3D "xlnx,xps-timer-1.00.a";
>> 	interrupt-parent =3D <&xps_intc_0>;
>> 	interrupts =3D < 3 2 >;
>> 	reg =3D <0x42800000 0x10000>;
>> 	xlnx,count-width =3D <0x20>;
>> 	xlnx,gen0-assert =3D <0x1>;
>> 	xlnx,gen1-assert =3D <0x1>;
>> 	xlnx,one-timer-only =3D <0x0>;
>> 	xlnx,trig0-assert =3D <0x1>;
>> 	xlnx,trig1-assert =3D <0x1>;
>> } ;
>>
>>
>> pwm {
>>         compatible =3D "xlnx,timer-pwm";
>>         #pwm-cells =3D <2>;
>>         timer =3D <&axi_timer_0>;
>> };
>>
>>
>> Allocation function will also require to do a change
>> in clocksource driver because currently the first
>> timer in the DTS/system is taken for clocksource/clockevents
>> (others are just ignored).
>> That's why will be necessary to add clock-handle property
>> to cpu node to exactly describe which timer is system timer.
>> The same as is for interrupt-handle (more intc's can be in design).
>=20
> If there is just one set of registers, I wouldn't object to
> having just a single node in DT, and just one driver that registers
> to both the clocksource and the PWM interfaces. That might
> simplify the code.

IP is configurable as is normal for us.
You can select IP with just one timer.
It means register locations for specific timer are fixed.
http://www.xilinx.com/support/documentation/ip_documentation/xps_timer.pd=
f

timer0 - offset 0x0
timer1 - offset 0x10 (doesn't need to be synthesized)

There is one interrupt for both timers.

Timers can be as timers (up/down count/ reload with or without IRQs)
But then one options is to use both timers and generate PWM signal.
=46rom full ip description in DT you can see xlnx,gen0-assert =3D <1>;
which can suggest that this IP can output PMW signal.
(We can also detect if PWM0 signal is connected just to be sure
that PWM can be enabled).

There is also capture trigger mode where external signal start/stop
timer counting.

It means there are 3 modes - timer, capture and PWM.
Timer (clocksource, clockevent) requires specific handling,
PWM has own subsystem and not sure if there is any subsystem for
capture mode. Is there any?

Not every timer configuration is suitable for all things
but fully configured timer can be used in all 3 modes.


I think that make sense to register and map all timers in the system
and classify them with flags (like can't be used for capture or PMW
if there are not outputs connected) and then use the best
timer for clocksource and clockevent. The best candidate is IP
with the lowest IRQ number in dual timer mode but in general
whatever timer can be used that's why we can't probably avoid
timer specification in DT.
In spite of this smells because you are saying via DT
to Linux which timer should be used for what purpose.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--otLomWjiM6oLf2rlAlPhA3Ig0fQPLnvFE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlN0x3MACgkQykllyylKDCFK4ACfeLfOYgnHMnzAR3ORr5lVnkPB
IP8AnRqZrjZ9OJmxhPHsCOJkdLV8BRvB
=gHPk
-----END PGP SIGNATURE-----

--otLomWjiM6oLf2rlAlPhA3Ig0fQPLnvFE--
