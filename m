Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3ENBkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:40:55 -0400
Received: from bosmailout12.eigbox.net ([66.96.186.12]:52955 "EHLO
	bosmailout12.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3ENBkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:40:53 -0400
X-Greylist: delayed 2480 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 21:40:53 EDT
X-Authority-Analysis: v=2.0 cv=dt1Z+ic4 c=1 sm=1
 a=i0WiXTmbFXIwRF3IvSVw8w==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=MiQ8TEe4tdQA:10 a=8nJEP1OIZ-IA:10 a=flkWhlLGwC4A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=jAfPOIUMAAAA:8 a=BoYRlNAJlvoDRk6VjrIA:9
 a=wPNLvfGTeEIA:10 a=gE_ZUhsuebIA:10 a=eBvjjtMVdWwtQGedh7GyLg==:117
X-EN-OrigOutIP: 10.20.18.5
X-EN-IMPSID: bczT1l00C06Zqne01czTot
Message-ID: <51918C23.7040106@yahoo.es>
Date: Tue, 14 May 2013 08:58:11 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: michal.simek@xilinx.com, Ludovic Desroches <ludovic.desroches@atmel.com>,
        s.trumtrar@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/macb: fix ISR clear-on-write behavior only for some
 SoC
References: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com> <FE065E51-1EAA-47ED-8C7B-0F2E6418F349@jcrosoft.com>
In-Reply-To: <FE065E51-1EAA-47ED-8C7B-0F2E6418F349@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.60.61
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/2013 12:05 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On May 14, 2013, at 12:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>
>> Commit 749a2b6 (net/macb: clear tx/rx completion flags in ISR)
>> introduces clear-on-write on ISR register. This behavior is not always
>> implemented when using Cadence MACB/GEM and is breaking other platforms.
>> We are using a new Device Tree compatibility string and a capability
>> property to actually activate this clear-on-write behavior on ISR.
>>
>> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> can we detect it via the IP?

This was my first proposal, have it based on the value of MACB's
register 'MID' (offset 0x00fc, lower 16 bits).
On avr32 it reads: 0x0000010D, on Zynq it reports 0x00000119

So for the moment, CAPS_ISR_CLEAR_ON_WRITE could be set if the revision
equals to 0x00000119?

>> ---
>> Documentation/devicetree/bindings/net/macb.txt |  2 ++
>> drivers/net/ethernet/cadence/macb.c            | 15 +++++++++++++--
>> drivers/net/ethernet/cadence/macb.h            |  5 +++++
>> 3 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
>> index 44afa0e..13ec4f6 100644
>>
>> <snip>
>>
>> @@ -1474,6 +1476,10 @@ static const struct of_device_id macb_dt_ids[] = {
>> 	{ .compatible = "cdns,macb" },
>> 	{ .compatible = "cdns,pc302-gem" },
>> 	{ .compatible = "cdns,gem" },
>> +	{
>> +		.compatible = "cdns,zynq-7000-gem",
>> +		.data = (void *)MACB_CAPS_ISR_CLEAR_ON_WRITE,
>> +	},
>> 	{ /* sentinel */ }
>> };
>> MODULE_DEVICE_TABLE(of, macb_dt_ids);
>> @@ -1484,6 +1490,7 @@ static int __init macb_probe(struct platform_device *pdev)
>> 	struct macb_platform_data *pdata;
>> 	struct resource *regs;
>> 	struct net_device *dev;
>> +	const struct of_device_id *dev_id;
>> 	struct macb *bp;
>> 	struct phy_device *phydev;
>> 	u32 config;
>> @@ -1558,6 +1565,10 @@ static int __init macb_probe(struct platform_device *pdev)
>>
>> 	dev->base_addr = regs->start;
>>
>> +	dev_id = of_match_device(macb_dt_ids, &pdev->dev);
As avr32 doesn't yet define CONFIG_OF:
    macb.c:1601: error:  'macb_dt_ids' undeclared

Hein
