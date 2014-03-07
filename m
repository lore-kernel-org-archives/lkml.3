Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaCGPzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:55:15 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:58912 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaCGPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:55:12 -0500
Message-ID: <5319EBDD.5050100@grandegger.com>
Date: Fri, 07 Mar 2014 16:55:09 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: FlexCAN on i.MX28 interrupt flooding retrying send
References: <53197E8A.5050409@meduna.org> <53198753.8000900@pengutronix.de> <5319CB58.4070708@meduna.org>
In-Reply-To: <5319CB58.4070708@meduna.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 02:36 PM, Stanislav Meduna wrote:
> On 07.03.2014 09:46, Marc Kleine-Budde wrote:
> 
>> Adding the linux-can mailinglist to Cc.
> 
> I am not subscribed so maybe that's why the original mail
> did not get through - I did Cc: linux-can@vger.kernel.org
> 
>> Your kernel is missing the patch:
>>
>> e358784 can: flexcan: fix mx28 detection by rearanging OF match table
>>
>> With this patch the CAN core properly detected as an mx28, so that bus
>> errors stay disabled (unless you enable them). If you need bus errors to
>> detect not connected CAN busses, you need another patchset berr_limit,
>> which is not yet mainline. I can repost it here, if you need it.
> 
> Ah ok.
> 
> Thank you, this probably points me to the right direction - I'll try
> to implement this behaviour in my kernel (unfortunately
> I cannot move to more recent one at the moment).

The following hack should fix the problem:

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index eb4014a..a6be018 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -727,7 +727,16 @@ static int flexcan_chip_start(struct net_device *dev)
 	reg_ctrl = flexcan_read(&regs->ctrl);
 	reg_ctrl &= ~FLEXCAN_CTRL_TSYN;
 	reg_ctrl |= FLEXCAN_CTRL_BOFF_REC | FLEXCAN_CTRL_LBUF |
-		FLEXCAN_CTRL_ERR_STATE | FLEXCAN_CTRL_ERR_MSK;
+		FLEXCAN_CTRL_ERR_STATE;
+
+	/*
+	 * Quick and dirty hack to enable the "error interrupt"
+	 * (FLEXCAN_CTRL_ERR_MSK) for the i.MX8. Warning: this
+	 * does not work on most other Flexcan cores. There, we
+	 * then don't get any error warning or passive interrupts.
+	 */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
+		reg_ctrl |= FLEXCAN_CTRL_ERR_MSK;
 
 	/* save for later use */
 	priv->reg_ctrl_default = reg_ctrl;

Anyway, you should check if there are other important improvement and
fixes a pending.

Wolfgang.
