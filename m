Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3CER1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:27:08 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:64620 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3CER1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:27:07 -0500
Message-ID: <1362504410.2791.44.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 3/5] ixgbe: Add support for ndo_ll_poll
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 5 Mar 2013 17:26:50 +0000
In-Reply-To: <20130227175606.10611.55498.stgit@gitlad.jf.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175606.10611.55498.stgit@gitlad.jf.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19688.000
X-TM-AS-Result: No--9.327700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 09:56 -0800, Eliezer Tamir wrote:
> Add the ixgbe driver code implementing ndo_ll_poll.
> It should be easy for other drivers to do something similar
> in order to enable support for CONFIG_INET_LL_RX_POLL

Yes... in fact I wonder whether the lock and state couldn't be added to
napi_struct instead of being driver-specific.

[...]
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
[...]
>  static void ixgbe_napi_disable_all(struct ixgbe_adapter *adapter)
>  {
>  	int q_idx;
>  
> -	for (q_idx = 0; q_idx < adapter->num_q_vectors; q_idx++)
> +	local_bh_disable(); /* for ixgbe_qv_lock_napi() */
> +	for (q_idx = 0; q_idx < adapter->num_q_vectors; q_idx++) {
>  		napi_disable(&adapter->q_vector[q_idx]->napi);
> +		while (!ixgbe_qv_lock_napi(adapter->q_vector[q_idx])) {
> +			pr_info("QV %d locked\n", q_idx);
> +			msleep(1);
> +		}
> +	}
> +	local_bh_enable();
>  }

Sleeping with preemption disabled?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

