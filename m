Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaCRBZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 21:25:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45050 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaCRBZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 21:25:39 -0400
Date: Mon, 17 Mar 2014 21:25:34 -0400 (EDT)
Message-Id: <20140317.212534.579591104509436501.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        christian.riesch@omicron.at, stefan.sorensen@spectralink.com
Subject: Re: [PATCH net-next v2 1/9] ptp: introduce programmable pins.
From: David Miller <davem@davemloft.net>
In-Reply-To: <5faff8ea096044a48e4edcc6391844f8d428383f.1394975663.git.richardcochran@gmail.com>
References: <cover.1394975663.git.richardcochran@gmail.com>
	<5faff8ea096044a48e4edcc6391844f8d428383f.1394975663.git.richardcochran@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Mar 2014 18:25:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sun, 16 Mar 2014 14:29:22 +0100

> +	/* Check to see if any other pin previously had this function. */
> +	if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +		return -ERESTARTSYS;
> +	for (i = 0; i < info->n_pins; i++) {
> +		if (info->pin_config[i].func == func &&
> +		    info->pin_config[i].chan == chan) {
> +			pin1 = &info->pin_config[i];
> +			break;
> +		}
> +	}
> +	mutex_unlock(&ptp->pincfg_mux);
 ...
> +	if (mutex_lock_interruptible(&ptp->pincfg_mux))
> +		return -ERESTARTSYS;
> +	pin2->func = func;
> +	pin2->chan = chan;
> +	if (pin1) {
> +		pin1->func = PTP_PF_NONE;
> +		pin1->chan = 0;
> +	}
> +	mutex_unlock(&ptp->pincfg_mux);
> +
> +	return 0;

This locking seems unnecessarily complex to me.  You should be able to
do the stateless sanity checks, take the mutex, then do all of the
rest of the operations until the end of the function before
dropping the lock.

So just take the lock once over the operations that need it.
