Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaA2ScX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:32:23 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39574 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaA2ScS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:32:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAGVrzcboHp8-qHZseGOVm14u1-cTcOjRZGExFxNu_nbK__XCSA@mail.gmail.com>
References: <1390975218-13863-1-git-send-email-jcmvbkbc@gmail.com>
	<1390975218-13863-3-git-send-email-jcmvbkbc@gmail.com>
	<52E8A407.1020809@gmail.com>
	<CAMo8BfJ_nce_H_8HJ7iw9ME=8C+sjF_Q43RaDG+1eVrpxWRvdQ@mail.gmail.com>
	<CAGVrzcboHp8-qHZseGOVm14u1-cTcOjRZGExFxNu_nbK__XCSA@mail.gmail.com>
Date: Wed, 29 Jan 2014 22:32:18 +0400
Message-ID: <CAMo8BfK-3-B-n7gxLaSO3JXSNNT_HwF0yTAMd+L5pp6odJKFTg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] net: ethoc: don't advertise gigabit speed on
 attached PHY
From: Max Filippov <jcmvbkbc@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Marc Gauthier <marc@cadence.com>, Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 9:12 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On Jan 28, 2014 11:01 PM, "Max Filippov" <jcmvbkbc@gmail.com> wrote:
>>
>> On Wed, Jan 29, 2014 at 10:47 AM, Florian Fainelli <f.fainelli@gmail.com>
>> wrote:
>> > Hi Max,
>> >
>> > Le 28/01/2014 22:00, Max Filippov a écrit :
>> >
>> >> OpenCores 10/100 Mbps MAC does not support speeds above 100 Mbps, but
>> >> does
>> >> not disable advertisement when PHY supports them. This results in
>> >> non-functioning network when the MAC is connected to a gigabit PHY
>> >> connected
>> >> to a gigabit switch.
>> >>
>> >> The fix is to disable gigabit speed advertisement on attached PHY
>> >> unconditionally.
>> >>
>> >> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
>> >> ---
>> >> Changes v1->v2:
>> >> - disable both gigabit advertisement and support.
>> >>
>> >>   drivers/net/ethernet/ethoc.c | 8 ++++++++
>> >>   1 file changed, 8 insertions(+)
>> >>
>> >> diff --git a/drivers/net/ethernet/ethoc.c
>> >> b/drivers/net/ethernet/ethoc.c
>> >> index 4de8cfd..5643b2d 100644
>> >> --- a/drivers/net/ethernet/ethoc.c
>> >> +++ b/drivers/net/ethernet/ethoc.c
>> >> @@ -688,6 +688,14 @@ static int ethoc_mdio_probe(struct net_device
>> >> *dev)
>> >>         }
>> >>
>> >>         priv->phy = phy;
>> >> +       phy_update_advert(phy,
>> >> +                         ADVERTISED_1000baseT_Full |
>> >> +                         ADVERTISED_1000baseT_Half, 0);
>> >> +       phy_start_aneg(phy);
>> >
>> >
>> > This does not look necessary, you should not have to call
>> > phy_start_aneg()
>> > because the PHY state machine is not yet started, at best this calls
>> > does
>> > nothing.
>>
>> This call actually makes the whole thing work, because otherwise once
>> gigabit
>> support is cleared from the supported mask genphy_config_advert does not
>> update gigabit advertisement register, leaving it enabled.
>
> OK, then we need to figure out what is wrong with ethoc since this is
> unusual.

Maybe they boot up with gigabit advertisement disabled in their PHY
and thus they don't see the problem?

> Other drivers do the following:
>
> - connect to the PHY
> - phydev->supported = PHY_BASIC_FEATURES
> - phydev->advertising &= phydev->supported
> - start the PHY state machine
>
> And they work just fine. Is the PHY driver you are bound to the "Generic
> PHY" or something else which does something funky in config_aneg()?

It's marvell 88E1111 from the KC-705 board, but the behaviour doesn't
change if I disable it and the generic phy is used.

-- 
Thanks.
-- Max
