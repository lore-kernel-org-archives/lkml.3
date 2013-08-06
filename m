Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3HFXJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:09:05 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:16076
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756827Ab3HFXJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:09:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Message-ID: <1375830520.5600.23.camel@snotra.buserror.net>
Subject: Re: [PATCH V2 5/6] cpuidle/powerpc: Backend-powerpc idle driver for
 powernv and pseries.
From: Scott Wood <scottwood@freescale.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: <benh@kernel.crashing.org>, <daniel.lezcano@linaro.org>,
        <linux-kernel@vger.kernel.org>, <michael@ellerman.id.au>,
        <srivatsa.bhat@linux.vnet.ibm.com>, <preeti@linux.vnet.ibm.com>,
        <svaidy@linux.vnet.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
        <rjw@sisk.pl>, <dongsheng.wang@freescale.com>,
        <linux-pm@vger.kernel.org>
Date: Tue, 6 Aug 2013 18:08:40 -0500
In-Reply-To: <20130731025934.19448.16658.stgit@deepthi>
References: <20130731025840.19448.24468.stgit@deepthi>
	 <20130731025934.19448.16658.stgit@deepthi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 08:29 +0530, Deepthi Dharwar wrote:
>  /*
> - * pseries_idle_probe()
> + * powerpc_idle_probe()
>   * Choose state table for shared versus dedicated partition
>   */
> -static int pseries_idle_probe(void)
> +static int powerpc_idle_probe(void)
>  {
>  
> +#ifndef PPC_POWERNV
>  	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
>  		return -ENODEV;
> +#endif

A bunch of ifdefs is not a good start for a file you're claiming is now
generic for all powerpc.

Certainly you shouldn't be calling pseries stuff based only on the
absence of powernv.

And do you not support building one kernel that supports both pseries
and powernv?

>  	if (cpuidle_disable != IDLE_NO_OVERRIDE)
>  		return -ENODEV;
>  
>  	if (max_idle_state == 0) {
> -		printk(KERN_DEBUG "pseries processor idle disabled.\n");
> +		printk(KERN_DEBUG "powerpc processor idle disabled.\n");
>  		return -EPERM;
>  	}
>  
> +#ifdef PPC_POWERNV
> +	cpuidle_state_table = powernv_states;
> +#else
>  	if (get_lppaca()->shared_proc)

Here's another example.  get_lppaca() will only build on book3s -- and
yet we get requests for e500 code to use this file.

-Scott



