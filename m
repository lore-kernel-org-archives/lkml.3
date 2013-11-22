Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3KVJRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:17:24 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:37400 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3KVJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:17:18 -0500
MIME-Version: 1.0
In-Reply-To: <20131121211920.GC10691@einon.net>
References: <cover.1384933520.git.gamerh2o@gmail.com>
	<c55eeb3252a868e9e62655baed8d6b11992b9cbe.1384933520.git.gamerh2o@gmail.com>
	<20131121211920.GC10691@einon.net>
Date: Fri, 22 Nov 2013 13:17:16 +0400
Message-ID: <CAHj3AV=xiW76y_bqP5h6sprokfphj5WquF32EGzJ-YqOyoj9-w@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] staging: et131x: drop packet when error occurs in et131x_tx
From: Denis Kirjanov <kirjanov@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: ZHAO Gang <gamerh2o@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/13, Mark Einon <mark.einon@gmail.com> wrote:
> On Wed, Nov 20, 2013 at 03:55:27PM +0800, ZHAO Gang wrote:
>> As TODO file suggested, drop packet instead of return NETDEV_TX_BUSY
>> when tx failed.
>>
>> et131x_tx calls function et131x_send_packets, I put the work of
>> et131x_send_packets directly into et131x_tx, and made some changes to
>> let the code more readable.
>>
>> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
>
> Acked-by: Mark Einon <mark.einon@gmail.com>
>
>> ---
>>  drivers/staging/et131x/et131x.c | 84
>> +++++++++++------------------------------
>>  1 file changed, 22 insertions(+), 62 deletions(-)
>>
>> diff --git a/drivers/staging/et131x/et131x.c
>> b/drivers/staging/et131x/et131x.c
>> index 836a4db..cda037a 100644
>> --- a/drivers/staging/et131x/et131x.c
>> +++ b/drivers/staging/et131x/et131x.c
>> @@ -3123,55 +3123,6 @@ static int send_packet(struct sk_buff *skb, struct
>> et131x_adapter *adapter)
>>  	return 0;
>>  }
>>
>> -/* et131x_send_packets - This function is called by the OS to send
>> packets
>> - * @skb: the packet(s) to send
>> - * @netdev:device on which to TX the above packet(s)
>> - *
>> - * Return 0 in almost all cases; non-zero value in extreme hard failure
>> only
>> - */
>> -static int et131x_send_packets(struct sk_buff *skb, struct net_device
>> *netdev)
>> -{
>> -	int status = 0;
>> -	struct et131x_adapter *adapter = netdev_priv(netdev);
>> -
>> -	/* Send these packets
>> -	 *
>> -	 * NOTE: The Linux Tx entry point is only given one packet at a time
>> -	 * to Tx, so the PacketCount and it's array used makes no sense here
>> -	 */
>> -
>> -	/* TCB is not available */
>> -	if (adapter->tx_ring.used >= NUM_TCB) {
>> -		/* NOTE: If there's an error on send, no need to queue the
>> -		 * packet under Linux; if we just send an error up to the
>> -		 * netif layer, it will resend the skb to us.
>> -		 */
>> -		status = -ENOMEM;
>> -	} else {
>> -		/* We need to see if the link is up; if it's not, make the
>> -		 * netif layer think we're good and drop the packet
>> -		 */
>> -		if ((adapter->flags & FMP_ADAPTER_FAIL_SEND_MASK) ||
>> -					!netif_carrier_ok(netdev)) {
>> -			dev_kfree_skb_any(skb);
>> -			skb = NULL;
>> -
>> -			adapter->net_stats.tx_dropped++;
>> -		} else {
>> -			status = send_packet(skb, adapter);
>> -			if (status != 0 && status != -ENOMEM) {
>> -				/* On any other error, make netif think we're
>> -				 * OK and drop the packet
>> -				 */
>> -				dev_kfree_skb_any(skb);
>> -				skb = NULL;
>> -				adapter->net_stats.tx_dropped++;
>> -			}
>> -		}
>> -	}
>> -	return status;
>> -}
>> -
>>  /* free_send_packet - Recycle a struct tcb
>>   * @adapter: pointer to our adapter
>>   * @tcb: pointer to struct tcb
>> @@ -4537,12 +4488,9 @@ static void et131x_multicast(struct net_device
>> *netdev)
>>  /* et131x_tx - The handler to tx a packet on the device
>>   * @skb: data to be Tx'd
>>   * @netdev: device on which data is to be Tx'd
>> - *
>> - * Returns 0 on success, errno on failure (as defined in errno.h)
>>   */
>> -static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
>> +static netdev_tx_t et131x_tx(struct sk_buff *skb, struct net_device
>> *netdev)
>>  {
>> -	int status = 0;
>>  	struct et131x_adapter *adapter = netdev_priv(netdev);
>>
>>  	/* stop the queue if it's getting full */
>> @@ -4553,17 +4501,29 @@ static int et131x_tx(struct sk_buff *skb, struct
>> net_device *netdev)
>>  	/* Save the timestamp for the TX timeout watchdog */
>>  	netdev->trans_start = jiffies;
>>
>> -	/* Call the device-specific data Tx routine */
>> -	status = et131x_send_packets(skb, netdev);
>> +	/* TCB is not available */
>> +	if (adapter->tx_ring.used >= NUM_TCB)
>> +		goto drop;

That's wrong. You have to properly manage tx queue and not just drop packets

>> -	/* Check status and manage the netif queue if necessary */
>> -	if (status != 0) {
>> -		if (status == -ENOMEM)
>> -			status = NETDEV_TX_BUSY;
>> -		else
>> -			status = NETDEV_TX_OK;
>> +	/* We need to see if the link is up; if it's not, make the
>> +	 * netif layer think we're good and drop the packet
>> +	 */
>> +	if ((adapter->flags & FMP_ADAPTER_FAIL_SEND_MASK) ||
>> +	    !netif_carrier_ok(netdev)) {
>> +		goto drop;
>> +	} else {
>> +		if (!send_packet(skb, adapter))
>> +			goto out;
>> +		/* On error (send_packet returns != 0), make netif
>> +		 * think we're OK and drop the packet
>> +		 */
>>  	}
>> -	return status;
>> +
>> +drop:
>> +	dev_kfree_skb_any(skb);
>> +	adapter->net_stats.tx_dropped++;
>> +out:
>> +	return NETDEV_TX_OK;
>>  }
>>
>>  /* et131x_tx_timeout - Timeout handler
>> --
>> 1.8.3.1
>>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
>


-- 
Regards,
Denis
