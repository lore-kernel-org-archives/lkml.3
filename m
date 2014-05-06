Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaEFSMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:12:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46873 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaEFSMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:12:05 -0400
Date: Tue, 6 May 2014 20:11:51 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Brian Lilly <brian@crystalfontz.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jim Baxter <jim_baxter@mentor.com>, Frank Li <Frank.Li@freescale.com>,
        Fugang Duan <B38611@freescale.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: i.MX28 based system losing eth0 on boot
Message-ID: <20140506181151.GU28564@pengutronix.de>
References: <CAOk88BLR=nwNGdT++39vLdOt=TwZmemF-trSQPY8AdMN9tKtKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOk88BLR=nwNGdT++39vLdOt=TwZmemF-trSQPY8AdMN9tKtKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Brian,

On Tue, May 06, 2014 at 09:44:34AM -0700, Brian Lilly wrote:
> With commit a264b981f2c76e281ef27e7232774bf6c54ec865 we're having eth0
> come up, then brought right back down with an MDIO rx timeout moments
> after.  Adding back in the removed code keeps the interface alive and
> it's working afterward without trouble.  I've tested the re-inserted
> code in 3.12, 3.14 without issue on our boards.
So you can reliably trigger that problem? You're just doing

	ifconfig eth0 1.2.3.4 up

(or equivalent) and the interface goes down without further
interference with the above mentioned commit? The exact error you're
seeing is

	MDIO read timeout

(with some prefix saying something about fec and eth0 I think)?

This error is also present with a264b981f2 reverted, just doesn't affect
eth0 being functional? Does the timeout always happen, or only on
specific addresses?

This is not a proper fix, but does it help to increment FEC_MII_TIMEOUT?
 
> Is there something else that can be done to prevent the MDIO timeouts?
> We are using basically the same schematic for networking as the
> imx28evk.
Hard to say, but assuming it works just fine on the imx28evk for you,
too, there seems to be some hardware difference that makes your machine
fail. (That doesn't mean it's not fixable in software.)

I don't know if a mdio read error is intended to make the device go
down, maybe one the the netdev guys can answer that.
Assuming that it's not intended, instrument the code, find out how that
timeout makes your device go down and find the wrong branch. I'd start
with adding stackdumps when the mdio timeout happens and when
fec_enet_start_xmit is called with fep->link == 0.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
