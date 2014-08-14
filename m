Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaHNM7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:59:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41148 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaHNM7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:59:19 -0400
Message-ID: <53ECB29C.7070703@ti.com>
Date: Thu, 14 Aug 2014 15:59:08 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Dual-channel DSI
References: <20140805153923.GA3072@ulmo.nvidia.com> <53E3227B.1010000@samsung.com> <20140807072530.GE17340@ulmo> <53E33B48.1080401@samsung.com> <20140807085424.GC13315@ulmo.nvidia.com> <53E47B99.3040105@samsung.com> <20140808101447.GF15852@ulmo>
In-Reply-To: <20140808101447.GF15852@ulmo>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="hQMgF89s0EuI6WejPqQw1AnMlD7WtpCW2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hQMgF89s0EuI6WejPqQw1AnMlD7WtpCW2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/08/14 13:14, Thierry Reding wrote:
> On Fri, Aug 08, 2014 at 09:26:17AM +0200, Andrzej Hajda wrote:
>> On 08/07/2014 10:54 AM, Thierry Reding wrote:
>>> On Thu, Aug 07, 2014 at 10:39:36AM +0200, Andrzej Hajda wrote:
>>>> On 08/07/2014 09:25 AM, Thierry Reding wrote:
>>>>> On Thu, Aug 07, 2014 at 08:53:47AM +0200, Andrzej Hajda wrote:
>>>>>> Hi Thierry,
>>>>>>
>>>>>> Nice case.
>>>>>>
>>>>>> On 08/05/2014 05:39 PM, Thierry Reding wrote:
>>>>>>> Hi everyone,
>>>>>>>
>>>>>>> I've been working on adding support for a panel that uses what's
>>>>>>> commonly known as dual-channel DSI. Sometimes this is referred to=
 as
>>>>>>> ganged-mode as well.
>>>>>>>
>>>>>>> What is it, you ask? It's essentially a hack to work around the b=
and-
>>>>>>> width restrictions of DSI, albeit one that's been commonly implem=
ented
>>>>>>> by several SoC vendors.
>>>>>>>
>>>>>>> This typically works by equipping a peripheral with two DSI inter=
faces,
>>>>>>> each of which driving one half of the screen (symmetric left-righ=
t mode)
>>>>>>> or every other line (symmetric odd-even mode). Apparently there c=
an be
>>>>>>> asymmetric modes in addition to those two, but they seem to be th=
e
>>>>>>> common ones. Often both of the DSI interfaces need to be configur=
ed
>>>>>>> using DCS commands and vendor specific registers.
>>>>>>>
>>>>>>> A single display controller is typically used video data transmis=
sion.
>>>>>>> This is necessary to provide synchronization and avoid tearing an=
d all
>>>>>>> kinds of other ugliness. For this to work both DSI controllers ne=
ed to
>>>>>>> be made aware of which chunk of the video data stream is addressi=
ng
>>>>>>> them.
>>>>>>>
>>>>>>> From a software perspective, this poses two problems:
>>>>>>>
>>>>>>> 1) A dual-channel device is composed of two DSI peripheral device=
s which
>>>>>>>    cannot be programmed independently of each other. A typical ex=
ample
>>>>>>>    is that the frame memory extents need to be configured differe=
ntly
>>>>>>>    for each of the devices (using the DCS set_column_address and
>>>>>>>    set_page_address commands). Therefore each device must know of=
 the
>>>>>>>    other, or there must be a driver that binds against a dummy de=
vice
>>>>>>>    that pulls in the two real devices.

I once almost had to write a driver for similar panel, but luckily the pr=
oject
was canceled. =3D)

Here are some thoughts:

If we had a panel which is controlled via i2c, but receives the video str=
eam
from two DSI interfaces, I think the DT would look something like:

&i2c1 {
	display@48 {
		compatible =3D "sharp,lq101r1sx01";
		reg =3D <0x48>;

		ports {
			port@0 {
				reg =3D <0>;
				lcd_in0: endpoint {
					remote-endpoint =3D <&dsi1_out_ep>;
				};
			};

			port@1 {
				reg =3D <1>;
				lcd_in1: endpoint {
					remote-endpoint =3D <&dsi2_out_ep>;
				};
			};
		};
	};
};

&dsi1 {
	port {
		dsi1_out_ep: endpoint {
			remote-endpoint =3D <&lcd_in0>;
			lanes =3D <0 1 2 3 4 5>;
		};
	};

};

&dsi2 {
	port {
		dsi2_out_ep: endpoint {
			remote-endpoint =3D <&lcd_in1>;
			lanes =3D <0 1 2 3 4 5>;
		};
	};
};

And similarly, if the panel would be controlled via DSI, but only via one=
 DSI
interface, I think the DT would look quite similar, except the "display" =
node
would be a child of "dsi1".

Now, a panel controlled via two DSI interfaces. I have to say the design =
sounds
rather nasty. What were the HW people thinking about? I guess you are _su=
re_
that you cannot do the configuration via just a single interface? =3D)

If you really need the control via two DSI interfaces, I'd suggest someth=
ing
like this:

&dsi1 {
	port {
		dsi1_out_ep: endpoint {
			remote-endpoint =3D <&lcd_in0>;
			lanes =3D <0 1 2 3 4 5>;
		};
	};

	display {
		compatible =3D "sharp,lq101r1sx01";

		secondary =3D <&panel_secondary>;

		port {
			lcd_in0: endpoint {
				remote-endpoint =3D <&dsi1_out_ep>;
			};
		};
	};
};

&dsi2 {
	port {
		dsi2_out_ep: endpoint {
			remote-endpoint =3D <&lcd_in1>;
			lanes =3D <0 1 2 3 4 5>;
		};
	};

	panel_secondary: display {
		compatible =3D "sharp,lq101r1sx01-secondary";

		port {
			lcd_in1: endpoint {
				remote-endpoint =3D <&dsi2_out_ep>;
			};
		};
	};
};

I guess the above was already more or less presented in the thread, but I=

didn't see it written out.

So there would two two devices, a master and a slave, and in the driver s=
ide
the slave would not do anything by itself.

 Tomi



--hQMgF89s0EuI6WejPqQw1AnMlD7WtpCW2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7LKcAAoJEPo9qoy8lh71hQcP/jEJQvegRy7VhW+CnI8rMyv5
MQKZxoBMBbOONPid+ha7rOaVmgLtcUad0uYaWHg5jh+TE9S0x+AItkMBuDOBgK2S
+0gnZIU1QUlOx/UGI34YyI3QQvOKKIZIo3mOHbVWj600GfuUrQ3cWPUI4+Fcu+QE
Tu9M3zSy+D/lmZ9QcG5BhWXYJAH+km6MhjUXa9uklqcch1g199p4VIM9obin456x
U5O89oBhveR3cHBf6sUHtK2Bpv11NGbWEbRwjXfTJQFoLp6Tu9wevSGotVMsITZH
sNvFLfFXjxWpaiPzt/62AHJEa8PzlWjqaUtEE24TEEJgA2OG8ILYyCjB4VGf/okt
jPrKSD3peJd941eY3ZBXSYo5NX4OHgX2fHy5jofLIp9Kws1cNK7wQ3MoCld0KzoO
Hsb7gHQ7YsE0UOk8M34Fa9FicKAakWFvnSciV6hFDD/eJAwNyXnLJqoQLaekK/P5
MRpLMSYHGE5lPFeHTQc/5FlXQzC8+K94mP25HSs1M/mBLxlQeT6Dp7Xe87shXyWG
FR63Zk6pCMF4muSOsZWoGBstK2WJ0DPN93ig8nltMbNGU+xHGA5RY51WgoUSapWH
cMCBoXAcDW9oQbHCIqnGudlRWHbbyBl9+Ae7wRvdT4tObUYWsyZ6iaMo++aRAO3g
lziLHey+qX7WqOMdeTZz
=7ovo
-----END PGP SIGNATURE-----

--hQMgF89s0EuI6WejPqQw1AnMlD7WtpCW2--
