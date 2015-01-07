Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbbAGKbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:31:07 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56950 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbAGKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:31:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2015 11:30:26 +0100
From: Stefan Agner <stefan@agner.ch>
To: fugang.duan@freescale.com
Cc: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>,
        linux-kernel@vger.kernel.org, luwei.zhou@freescale.com,
        LW@karo-electronics.de, Frank.Li@freescale.com, davem@davemloft.net
Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
In-Reply-To: <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
 <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
Message-ID: <fe59d331ecef890284cd005ae62bc236@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan  7 11:29:34 2015
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 54ad0a8e12815182712819
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-07 03:11, fugang.duan@freescale.com wrote:
> From: Stefan Agner <stefan@agner.ch> Sent: Tuesday, January 06, 2015 10:52 PM
>> To: Bhuvanchandra DV
>> Cc: linux-kernel@vger.kernel.org; Zhou Luwei-B45643; LW@karo-
>> electronics.de; Li Frank-B20596; Duan Fugang-B38611; davem@davemloft.net
>> Subject: Re: [PATCH] net: fec: Fix dual ethernet issue in VFxx
>>
>> Fwiw, this patch really touches many devices and disables the quirk for
>> some devices, but this is done by intent.
>>
>> The quirk FEC_QUIRK_ENET_MAC was active for i.MX28, i.MX6Q, Vybrid
>> (mvf600-fec) and i.MX6SX. However, the new quirk is only enabled for
>> i.MX28. i.MX6Q doesn't need the quirk since there is one FEC instance
>> only anyway. Vybrid and i.MX6SX have a MDIO bus for each instance.
>>
>> Acked-by: Stefan Agner <stefan@agner.ch>
> 
> We cannot do it by adding a quirk.
> For Vybrid and i.MX6SX and later i.MX7 serial,  there have their own
> MDIO bus for each MAC.
> But, for board design, to save two pin (MDIO, MDC), MAC0 and MAC1
> share the MDIO bus. For example, i.MX6SX sdb/sabreai/arm2 boards did
> like this.

Hm, so those board use a circumstance which was SoC specific back at
i.MX28 time. IMHO, "Out of luck" the shared MDIO bus is the first one
even for those boards, hence this SoC specific work around still works.
So I still think for the i.MX28 case, the quirk would be a viable
solution, but not for those boards, I agree.

> So we must add one dts property to distinguish it, not a quirk. 

Just adding a property to the FEC instance who's MDIO bus is in use
seems somewhat archaic. There is a MDIO bus description for other SoC,
do you have in mind how this should look like for fec?

--
Stefan


>>
>> On 2015-01-06 14:47, Bhuvanchandra DV wrote:
>> > On i.MX28, the MDIO bus is shared between the two RMII interfaces.
>> > However, in newer designs, such as Vybrid, this is not the case. This
>> > patch adds a quirk for the single MDIO case. This allows to use both
>> > FEC interfaces working independently on Vybird.
>> >
>> > Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
>> > ---
>> >  drivers/net/ethernet/freescale/fec.h      |    3 +++
>> >  drivers/net/ethernet/freescale/fec_main.c |    7 ++++---
>> >  2 files changed, 7 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/net/ethernet/freescale/fec.h
>> > b/drivers/net/ethernet/freescale/fec.h
>> > index 469691a..c9515bc 100644
>> > --- a/drivers/net/ethernet/freescale/fec.h
>> > +++ b/drivers/net/ethernet/freescale/fec.h
>> > @@ -425,6 +425,9 @@ struct bufdesc_ex {
>> >   */
>> >  #define FEC_QUIRK_BUG_CAPTURE		(1 << 10)
>> >
>> > +/* Controller has only one MDIO bus for interfacing external PHY's */
>> > +#define FEC_QUIRK_SINGLE_MDIO		(1 << 11)
>> > +
>> >  struct fec_enet_priv_tx_q {
>> >  	int index;
>> >  	unsigned char *tx_bounce[TX_RING_SIZE]; diff --git
>> > a/drivers/net/ethernet/freescale/fec_main.c
>> > b/drivers/net/ethernet/freescale/fec_main.c
>> > index 5ebdf8d..22b7748 100644
>> > --- a/drivers/net/ethernet/freescale/fec_main.c
>> > +++ b/drivers/net/ethernet/freescale/fec_main.c
>> > @@ -91,7 +91,8 @@ static struct platform_device_id fec_devtype[] = {
>> >  		.driver_data = 0,
>> >  	}, {
>> >  		.name = "imx28-fec",
>> > -		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME,
>> > +		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
>> > +				FEC_QUIRK_SINGLE_MDIO,
>> >  	}, {
>> >  		.name = "imx6q-fec",
>> >  		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT | @@ -
>> 1952,7
>> > +1953,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>> >  	 * mdio interface in board design, and need to be configured by
>> >  	 * fec0 mii_bus.
>> >  	 */
>> > -	if ((fep->quirks & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
>> > +	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
>> >  		/* fec1 uses fec0 mii_bus */
>> >  		if (mii_cnt && fec0_mii_bus) {
>> >  			fep->mii_bus = fec0_mii_bus;
>> > @@ -2015,7 +2016,7 @@ static int fec_enet_mii_init(struct
>> platform_device *pdev)
>> >  	mii_cnt++;
>> >
>> >  	/* save fec0 mii_bus */
>> > -	if (fep->quirks & FEC_QUIRK_ENET_MAC)
>> > +	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO)
>> >  		fec0_mii_bus = fep->mii_bus;
>> >
>> >  	return 0;

