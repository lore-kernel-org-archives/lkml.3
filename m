Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3ETUUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:20:06 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:58705 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3ETUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:20:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	<20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
Date: Mon, 20 May 2013 23:20:03 +0300
Message-ID: <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 1:16 PM, Eliezer Tamir
<eliezer.tamir@linux.intel.com> wrote:
> Add the ixgbe driver code implementing ndo_ll_poll.
> It should be easy for other drivers to do something similar
> in order to enable support for CONFIG_INET_LL_RX_POLL

I am not sure,


> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
[...]
> @@ -144,6 +145,14 @@ static int debug = -1;
>  module_param(debug, int, 0);
>  MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
>
> +#ifdef CONFIG_INET_LL_RX_POLL
> +static int allow_unsafe_removal;
> +static int unsafe_to_remove;
> +module_param(allow_unsafe_removal, int, 0);
> +MODULE_PARM_DESC(allow_unsafe_removal,
> +       "Allow removal of module after low latency receive was used");
> +#endif

what?!

[...]

> +#ifdef CONFIG_INET_LL_RX_POLL
> +/* must be called with local_bh_disable()d */
> +static int ixgbe_low_latency_recv(struct napi_struct *napi)
> +{
> +       struct ixgbe_q_vector *q_vector =
> +                       container_of(napi, struct ixgbe_q_vector, napi);
> +       struct ixgbe_adapter *adapter = q_vector->adapter;
> +       struct ixgbe_ring  *ring;
> +       int found;
> +
> +       if (unlikely(!unsafe_to_remove)) {
> +               unsafe_to_remove = 1;
> +               if (!allow_unsafe_removal) {
> +                       pr_info("module may no longer be removed\n");
> +                       try_module_get(THIS_MODULE);
> +               }
> +       }

guys, so what is going here, you were asking to put this series in
net-next, and you expect each other driver implementing this ndo to
follow this undocumented hack? or maybe this code was just left here
by mistake from previous implementations and just needed to be
removed?  please clarify.

Or.
