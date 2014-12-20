Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaLTRJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:09:36 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40779 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaLTRJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:09:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141219034918.GX24110@csclub.uwaterloo.ca>
References: <20141219034918.GX24110@csclub.uwaterloo.ca>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sat, 20 Dec 2014 09:08:51 -0800
Message-ID: <CAGVrzcbCCV_AL48R3iTGQqvdAM6NWuC1yDW5P+eh7rExE3fcow@mail.gmail.com>
Subject: Re: net: ucc: tbi phy detection broken by 058112c7efc9ef43bb511c137293dddbe6e42908
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Li Yang <leoli@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-18 19:49 GMT-08:00 Lennart Sorensen <lsorense@csclub.uwaterloo.ca>:
> I have been trying to move an 8360 based system from a 3.0 kernel to a
> 3.12 (on the way to 3.14 with ipipe/xenomai) kernel and encountered an
> oops in the ucc_geth driver when using RTBI mode on one of the ucc
> ports.  I haven't managed to find any commits to of_mdio or ucc_geth or
> fsl_pq_mdio that would appear to address this problem, so I believe it
> is still present in the latest kernel, but have not confirmed that with
> testing yet.
>
> Commit 058112c7efc9ef43bb511c137293dddbe6e42908 appears to have broken
> ucc support for tbi phy detection.
>
> With the patch in place, I am unable to get the mdio bus to create phy
> devices for the tbi phy in the ucc on an 8360e, and the ucc_geth driver
> causes a kernel oops, while with the patch reverted, it does create them
> and the driver comes up and works.
>
> The tbi phy is needed when using a ucc in RTBI, TBI or SGMII mode.
>
> I am not convinced that the tbi phy really behaves quite like a real phy,
> which may be why get_phy_device does not work with it.  Perhaps there
> is a better way to deal with the tbi phy on the ucc for this purpose.

There are some comments in ucc_geth that also lead me to believe this
is a just a hack instead of a real Ethernet PHY device. Part of what I
think got broken is because of this comment:

/* Initialize TBI PHY interface for communicating with the
 * SERDES lynx PHY on the chip.  We communicate with this PHY
 * through the MDIO bus on each controller, treating it as a
 * "normal" PHY at the address found in the UTBIPA register.  We assume
 * that the UTBIPA register is valid.  Either the MDIO bus code will set
 * it to a value that doesn't conflict with other PHYs on the bus, or the
 * value doesn't matter, as there are no other PHYs on the bus.
 */

In particular this one:

"Either the MDIO bus code will set
 * it to a value that doesn't conflict with other PHYs on the bus, or the
 * value doesn't matter, as there are no other PHYs on the bus."

and what Sebastian removed did exactly that, we used the special MDIO
broadcast address 0 to provide this "whatever". If this is such a
requirement from the ucc_geth driver and TBI PHYs, maybe we should
have this hack somewhere in the actual MDIO driver used by the
ucc_geth driver instead, or set a flag/read the PHY connection mode
and do this in drivers/of/of_mdio.c

>
> Certainly as it is, this patch has caused a regression though, although
> probably not very many systems with ucc ports actually use one of the
> affected modes so the damage isn't that great.
>
> --
> Len Sorensen



-- 
Florian
