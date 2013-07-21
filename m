Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3GUQcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 12:32:14 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755828Ab3GUQcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 12:32:13 -0400
Message-ID: <51EC0D03.4070508@nod.at>
Date: Sun, 21 Jul 2013 18:32:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: rl@hellgate.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] via-rhine: Fix tx_timeout handling
References: <1374269428-6827-1-git-send-email-richard@nod.at> <1374423530.2804.13.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1374423530.2804.13.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.07.2013 18:18, schrieb Ben Hutchings:
> On Fri, 2013-07-19 at 23:30 +0200, Richard Weinberger wrote:
>> rhine_reset_task() misses to call netif_stop_queue(),
>> this can lead to a crash if work is still scheduled while
>> we're resetting the tx queue.
>>
>> Fixes:
>> [   93.591707] BUG: unable to handle kernel NULL pointer dereference at 0000004c
>> [   93.595514] IP: [<c119d10d>] rhine_napipoll+0x491/0x6e
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/net/ethernet/via/via-rhine.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
>> index b75eb9e..57e1b40 100644
>> --- a/drivers/net/ethernet/via/via-rhine.c
>> +++ b/drivers/net/ethernet/via/via-rhine.c
>> @@ -1615,6 +1615,7 @@ static void rhine_reset_task(struct work_struct *work)
>>  		goto out_unlock;
>>  
>>  	napi_disable(&rp->napi);
>> +	netif_stop_queue(dev);
> 
> This is not really fixing the bug because there is no synchronisation
> with the TX scheduler.  You can call netif_tx_disable() instead to do
> that.

I guess other drivers suffer from that too.
A quick grep showed that not many drivers are using netif_tx_disable().

> (I also think that it is preferable to use
> netif_device_{detach,attach}() to stop the queue during reconfiguration,
> as this is independent of TX completions and the watchdog.)

So the correct down sequence is napi_disable() -> netif_tx_disable() -> netif_device_detach()?

Thanks,
//richard
