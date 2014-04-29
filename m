Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbaD2OQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:16:57 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50066 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360AbaD2OQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:16:56 -0400
Message-ID: <535FB453.2060100@windriver.com>
Date: Tue, 29 Apr 2014 10:16:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: Re: [PATCH RT 2/4] net: gianfar: do not try to cleanup TX packets
 if they are not done
References: <20140427143119.898655303@goodmis.org> <20140427143140.384915886@goodmis.org> <535DF744.60606@linutronix.de>
In-Reply-To: <535DF744.60606@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-28 02:37 AM, Sebastian Andrzej Siewior wrote:
> On 04/27/2014 04:31 PM, Steven Rostedt wrote:
>> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
>> index 5c0efcc..8aecc1d 100644
>> --- a/drivers/net/ethernet/freescale/gianfar.c
>> +++ b/drivers/net/ethernet/freescale/gianfar.c
>> @@ -2856,10 +2855,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)
>>  			tx_queue = priv->tx_queue[i];
>>  			/* run Tx cleanup to completion */
>>  			if (tx_queue->tx_skbuff[tx_queue->skb_dirtytx]) {
>> -				gfar_clean_tx_ring(tx_queue);
>> -				has_tx_work = 1;
>> +				int ret;
>> +
>> +				ret = gfar_clean_tx_ring(tx_queue);
>> +				if (ret)
>> +					has_tx_work++;
>>  			}
>>  		}
>> +		work_done += has_tx_work;
>>  
>>  		for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
>>  			/* skip queue if not active */
> 
> The 3.14-RT version of the patch should have an additional return
> statement here which I forgot initially.

Sanity boot tested the 3.10 rc1 on a sbc8548 (UP PPC with gianfar), with
the one-liner added as follows:

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 8aecc1d81395..b87a8c919c3e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2574,6 +2574,7 @@ static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
        tx_queue->dirty_tx = bdp;
 
        netdev_tx_completed_queue(txq, howmany, bytes_sent);
+       return howmany;
 }
 
 static void gfar_schedule_cleanup(struct gfar_priv_grp *gfargrp)

Paul.
--


> 
> Sebastian
> 
