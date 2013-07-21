Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3GUUYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 16:24:40 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:41055 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3GUUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 16:24:38 -0400
Message-ID: <1374438274.2804.80.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] via-rhine: Fix tx_timeout handling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Richard Weinberger <richard@nod.at>
CC: <rl@hellgate.ch>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Sun, 21 Jul 2013 21:24:34 +0100
In-Reply-To: <51EC0D03.4070508@nod.at>
References: <1374269428-6827-1-git-send-email-richard@nod.at>
	 <1374423530.2804.13.camel@deadeye.wl.decadent.org.uk>
	 <51EC0D03.4070508@nod.at>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20028.005
X-TM-AS-Result: No--31.445100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-21 at 18:32 +0200, Richard Weinberger wrote:
> Am 21.07.2013 18:18, schrieb Ben Hutchings:
> > On Fri, 2013-07-19 at 23:30 +0200, Richard Weinberger wrote:
> >> rhine_reset_task() misses to call netif_stop_queue(),
> >> this can lead to a crash if work is still scheduled while
> >> we're resetting the tx queue.
> >>
> >> Fixes:
> >> [   93.591707] BUG: unable to handle kernel NULL pointer dereference at 0000004c
> >> [   93.595514] IP: [<c119d10d>] rhine_napipoll+0x491/0x6e
> >>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> >> ---
> >>  drivers/net/ethernet/via/via-rhine.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
> >> index b75eb9e..57e1b40 100644
> >> --- a/drivers/net/ethernet/via/via-rhine.c
> >> +++ b/drivers/net/ethernet/via/via-rhine.c
> >> @@ -1615,6 +1615,7 @@ static void rhine_reset_task(struct work_struct *work)
> >>  		goto out_unlock;
> >>  
> >>  	napi_disable(&rp->napi);
> >> +	netif_stop_queue(dev);
> > 
> > This is not really fixing the bug because there is no synchronisation
> > with the TX scheduler.  You can call netif_tx_disable() instead to do
> > that.
> 
> I guess other drivers suffer from that too.
> A quick grep showed that not many drivers are using netif_tx_disable().
> 
> > (I also think that it is preferable to use
> > netif_device_{detach,attach}() to stop the queue during reconfiguration,
> > as this is independent of TX completions and the watchdog.)

Actually, this is not independent of TX completions - netif_wake_queue()
will still start the TX scheduler while the device is not present, so
you have to avoid that.

> So the correct down sequence is napi_disable() -> netif_tx_disable() -> netif_device_detach()?

No, that's redundant.  You can do:

	napi_disable();
	netif_tx_lock_bh(); /* sync with TX scheduler */
	netif_device_detach();
	netif_tx_unlock_bh();

and then when the queue is ready to use again:

	netif_device_attach();
	napi_enable();

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

