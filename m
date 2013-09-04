Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab3IDMOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:14:47 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:60022 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab3IDMOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:14:45 -0400
Message-ID: <52272426.2040504@synopsys.com>
Date: Wed, 4 Sep 2013 17:44:30 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>, <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: Query about TX BD Reclaim in Napi poll path (was Re: [PATCH v3] ethernet/arc/arc_emac
 - Add new driver)
References: <1371134239-4531-1-git-send-email-abrodkin@synopsys.com> <20130613221946.GA16632@electric-eye.fr.zoreil.com>
In-Reply-To: <20130613221946.GA16632@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francois,

Resurrecting an old thread.

On 06/14/2013 03:49 AM, Francois Romieu wrote:
>> +static irqreturn_t arc_emac_intr(int irq, void *dev_instance)
>> > +{
>> > +	struct net_device *ndev = dev_instance;
>> > +	struct arc_emac_priv *priv = netdev_priv(ndev);
>> > +	struct net_device_stats *stats = &priv->stats;
>> > +	unsigned int status;
>> > +
>> > +	status = arc_reg_get(priv, R_STATUS);
>> > +	status &= ~MDIO_MASK;
>> > +
>> > +	/* Reset all flags except "MDIO complete"*/
>> > +	arc_reg_set(priv, R_STATUS, status);
>> > +
>> > +	if (status & RXINT_MASK) {
>> > +		if (likely(napi_schedule_prep(&priv->napi))) {
>> > +			arc_reg_clr(priv, R_ENABLE, RXINT_MASK);
>> > +			__napi_schedule(&priv->napi);
>> > +		}
>> > +	}
>> > +
>> > +	if (status & TXINT_MASK) {
> You may consider moving everything into the napi poll handler.

I has to revisit this now-mainlined driver recently for fixing a bug. Per your
suggestion above, the TX BD reclaim was moved from interrupt context to NAPI
context. I was wondering if that is the right thing to do (I'm not a networking
expert but have worked on this driver heavily before it was mainlined by Alexey).

In case of large burst transfers by networking stack (say a large file copy over
NFS) will it not delay the TX BD reclaim possibly dropping more packets. Ofcourse
doing this requires enabling Tx interrupts which adds to overall cost from a
system perspective, but assuming the controller can coalesce the Tx interrupts,
will it not be better.

I did a quick hack to move the TX reclaim in intr path and it seems to be doing
slightly better than the current code - so the advantages are not sky high, but I
want to understand the implications nevertheless.

TIA,
-Vineet
