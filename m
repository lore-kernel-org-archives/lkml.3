Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160993Ab3DKUmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:42:49 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:36056 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DKUmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:42:47 -0400
Message-ID: <1365712962.7355.27.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [ 024/171 ] sfc: lock TX queues when calling
 netif_device_detach()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Thu, 11 Apr 2013 21:42:42 +0100
In-Reply-To: <20130411202550.143721907@goodmis.org>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202550.143721907@goodmis.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19790.000
X-TM-AS-Result: No--22.840000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:25 -0400, Steven Rostedt wrote:

> 3.6.11.2 stable review patch.
> If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Daniel Pieczko <dpieczko@solarflare.com>
> 
> [ Upstream commit c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1 ]
> 
> The assertion of netif_device_present() at the top of
> efx_hard_start_xmit() may fail if we don't do this.

You should also cherry-pick commit 35205b211c8d 'sfc: Disable soft
interrupt handling during efx_device_detach_sync()' on top of this.

Ben.

> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/net/ethernet/sfc/efx.c      |    4 ++--
>  drivers/net/ethernet/sfc/efx.h      |   13 +++++++++++++
>  drivers/net/ethernet/sfc/selftest.c |    2 +-
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 65a8d49..073fd60 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -2224,7 +2224,7 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
>  	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
>  		   RESET_TYPE(method));
>  
> -	netif_device_detach(efx->net_dev);
> +	efx_device_detach_sync(efx);
>  	efx_reset_down(efx, method);
>  
>  	rc = efx->type->reset(efx, method);
> @@ -2719,7 +2719,7 @@ static int efx_pm_freeze(struct device *dev)
>  
>  	efx->state = STATE_FINI;
>  
> -	netif_device_detach(efx->net_dev);
> +	efx_device_detach_sync(efx);
>  
>  	efx_stop_all(efx);
>  	efx_stop_interrupts(efx, false);
> diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
> index 70755c9..320cf7b 100644
> --- a/drivers/net/ethernet/sfc/efx.h
> +++ b/drivers/net/ethernet/sfc/efx.h
> @@ -162,4 +162,17 @@ extern void efx_link_status_changed(struct efx_nic *efx);
>  extern void efx_link_set_advertising(struct efx_nic *efx, u32);
>  extern void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
>  
> +static inline void efx_device_detach_sync(struct efx_nic *efx)
> +{
> +	struct net_device *dev = efx->net_dev;
> +
> +	/* Lock/freeze all TX queues so that we can be sure the
> +	 * TX scheduler is stopped when we're done and before
> +	 * netif_device_present() becomes false.
> +	 */
> +	netif_tx_lock(dev);
> +	netif_device_detach(dev);
> +	netif_tx_unlock(dev);
> +}
> +
>  #endif /* EFX_EFX_H */
> diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
> index 96068d1..57dec37 100644
> --- a/drivers/net/ethernet/sfc/selftest.c
> +++ b/drivers/net/ethernet/sfc/selftest.c
> @@ -721,7 +721,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
>  	/* Detach the device so the kernel doesn't transmit during the
>  	 * loopback test and the watchdog timeout doesn't fire.
>  	 */
> -	netif_device_detach(efx->net_dev);
> +	efx_device_detach_sync(efx);
>  
>  	if (efx->type->test_chip) {
>  		rc_reset = efx->type->test_chip(efx, tests);

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

