Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaAIQWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:22:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaAIQWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:22:31 -0500
Date: Thu, 9 Jan 2014 17:24:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep problem
Message-ID: <20140109162414.GA1719@redhat.com>
References: <52CC474A.7090207@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CC474A.7090207@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 12:28:26PM -0600, Larry Finger wrote:
>   rtnl_mutex --> misc_mtx --> rfkill_global_mutex
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(rfkill_global_mutex);
>                                 lock(misc_mtx);
>                                 lock(rfkill_global_mutex);
>    lock(rtnl_mutex);
> 
>  *** DEADLOCK ***

There are 3 mutexes dependency. The deadlock can happen if on another
cpu, let say CPU2, there will be sequence:

lock(rtnl_mutex);
lock(misc_mtx);

Then on deadlock scenario:
CPU0 waits for rtnl_mutex to unlock, keep rfkill_global_mutex locked
CPU1 waits for rfkill_global_mutex to unlock, keep misc_mtx locked
CPU2 waits for misc_mtx to unlock, keep rtnl_mutex locked.

This dependency can be broken by moving b43_rng_init() outside from
rtnl_mutex scope, like on below patch. IIUC b43 random number generator
works only if we already started network connection, but this should
not be a problem, as b43_rng_read() do not return any data if device
is not prepared.

You could also remove whole b43 rnd. Everyone know, that HW vendors
are influenced by NSA and they random generators do not provide truly
random numbers (just kidding ;-)

Stanislaw

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ccd24f0a..2c153f9 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2475,6 +2475,10 @@ start_ieee80211:
 		goto err_one_core_detach;
 	wl->hw_registred = true;
 	b43_leds_register(wl->current_dev);
+
+	/* Register HW RNG driver */
+	b43_rng_init(wl);
+
 	goto out;
 
 err_one_core_detach:
@@ -4636,9 +4640,6 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
 
-	/* Unregister HW RNG driver */
-	b43_rng_exit(dev->wl);
-
 	b43_set_status(dev, B43_STAT_UNINIT);
 
 	/* Stop the microcode PSM. */
@@ -4795,9 +4796,6 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
-	/* Register HW RNG driver */
-	b43_rng_init(dev->wl);
-
 out:
 	return err;
 
@@ -5464,6 +5462,9 @@ static void b43_bcma_remove(struct bcma_device *core)
 
 	b43_one_core_detach(wldev->dev);
 
+	/* Unregister HW RNG driver */
+	b43_rng_exit(wl);
+
 	b43_leds_unregister(wl);
 
 	ieee80211_free_hw(wl->hw);


