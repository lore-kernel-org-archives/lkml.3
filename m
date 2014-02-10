Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBJRJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:09:42 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43043 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaBJRJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:09:40 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH V3] net/dt: Add support for overriding phy configuration from device tree
Date: Mon, 10 Feb 2014 09:09:36 -0800
Message-ID: <29007785.iYrLORbRAN@lenovo>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52F8FB03.6040606@keymile.com>
References: <7510122.cayuQ6qt8r@wuerfel> <CAGVrzcZ4TFd=9KP+aoG47QbmqDJ1i23WBcEWDbzNRUfGmPvZHQ@mail.gmail.com> <52F8FB03.6040606@keymile.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerlando,

Le lundi 10 février 2014, 17:14:59 Gerlando Falauto a écrit :
> Hi,
> 
> I'm currently trying to fix an issue for which this patch provides a
> partial solution, so apologies in advance for jumping into the
> discussion for my own purposes...
> 
> On 02/04/2014 09:39 PM, Florian Fainelli wrote:> 2014-01-17 Matthew
> 
> Garrett <matthew.garrett@nebula.com>:
>  >> Some hardware may be broken in interesting and board-specific ways, such
>  >> that various bits of functionality don't work. This patch provides a
>  >> mechanism for overriding mii registers during init based on the
> 
> contents of
> 
>  >> the device tree data, allowing board-specific fixups without having to
>  >> pollute generic code.
>  > 
>  > It would be good to explain exactly how your hardware is broken
>  > exactly. I really do not think that such a fine-grained setting where
>  > you could disable, e.g: 100BaseT_Full, but allow 100BaseT_Half to
>  > remain usable makes that much sense. In general, Gigabit might be
>  > badly broken, but 100 and 10Mbits/sec should work fine. How about the
>  > MASTER-SLAVE bit, is overriding it really required?
>  > 
>  > Is not a PHY fixup registered for a specific OUI the solution you are
>  > looking for? I am also concerned that this creates PHY troubleshooting
>  > issues much harder to debug than before as we may have no idea about
>  > how much information has been put in Device Tree to override that.
>  > 
>  > Finally, how about making this more general just like the BCM87xx PHY
>  > driver, which is supplied value/reg pairs directly? There are 16
>  > common MII registers, and 16 others for vendor specific registers,
>  > this is just covering for about 2% of the possible changes.
> 
> Good point. That would easily help me with my current issue, which
> requires autoneg to be disabled to begin with (by clearing BMCR_ANENABLE
> from register 0).

Is there a point in time (e.g: after some specific initial configuration has 
been made) where BMCR_ANENABLE can be used?

> This would not however fix it entirely (I tried a quick hardwired
> implementation), as the whole PHY machinery would not take that into
> account and would re-enable autoneg anyway.
> I also tried changing the patch so that phydev->support gets updated

There are multiple things that you could try doing here:

- override the PHY state machine in your read_status callback to make sure 
that you always set phydev->autoneg set to AUTONEG_ENABLE

- clear the SUPPORTED_Autoneg bits from phydev->supported right after PHY 
registration and before the call to phy_start()

- set the PHY_HAS_MAGICANEG bit in your PHY driver flag

> 
> (instead of phydev->advertising):
>  >> +               if (!of_property_read_u32(np, override->prop, &tmp)) {
>  >> +                       if (tmp) {
>  >> +                               *val |= override->value;
>  >> +                               phydev->advertising |=
> 
> override->supported;
> 
>  >> +                       } else {
>  >> +                               phydev->advertising &=
> 
> ~(override->supported);
> 
>  >> +                       }
>  >> +
>  >> +                       *mask |= override->value;
> 
> What I find weird is that the only way phydev->autoneg could ever be set
> to disabled is from here (phy.c):
> 
> static void phy_sanitize_settings(struct phy_device *phydev)
> {
> 	u32 features = phydev->supported;
> 	int idx;
> 
> 	/* Sanitize settings based on PHY capabilities */
> 	if ((features & SUPPORTED_Autoneg) == 0)
> 		phydev->autoneg = AUTONEG_DISABLE;
> 
> which is in turn only called when phydev->autoneg is set to
> AUTONEG_DISABLE to begin with:
> 
> int phy_start_aneg(struct phy_device *phydev)
> {
> 	int err;
> 
> 	mutex_lock(&phydev->lock);
> 
> 	if (AUTONEG_DISABLE == phydev->autoneg)
> 		phy_sanitize_settings(phydev);
> 
> So could someone please help me figure out what I'm missing here?

At first glance it looks like the PHY driver should be reading the phydev-
>autoneg value when the PHY driver config_aneg() callback is called to be 
allowed to set the forced speed and settings.

The way phy_sanitize_settings() is coded does not make it return a mask of 
features, but only the forced supported speed and duplex. Then when the link 
is forced but we are having some issues getting a link status, libphy tries 
lower speeds and this function is used again to provide the next speed/duplex 
pair to try.
-- 
Florian
