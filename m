Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaEEVoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:44:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60905 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbaEEVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:44:53 -0400
Message-ID: <53680639.1080405@ti.com>
Date: Mon, 5 May 2014 16:44:25 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robherring2@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 RFC 12/15] hwspinlock/core: add OF helper to parse reserved
 locks
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-13-git-send-email-s-anna@ti.com>
In-Reply-To: <1398904476-26200-13-git-send-email-s-anna@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 04/30/2014 07:34 PM, Suman Anna wrote:
> The property 'hwlock-reserved-locks' will be used to represent
> the number of locks to be reserved for clients that would need
> to request/operate on specific locks. A new OF helper function,
> of_hwspin_lock_get_num_reserved_locks(), is added to minimize
> duplication in different platform implementations.
> 
> The function will return a value of 0 if the property is not
> defined, so as to support a default behavior of marking all
> locks as unused and open for anonymous allocations.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  .../devicetree/bindings/hwlock/hwlock.txt          |  3 +++
>  drivers/hwspinlock/hwspinlock_core.c               | 25 ++++++++++++++++++++++
>  include/linux/hwspinlock.h                         |  1 +
>  3 files changed, 29 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
> index d538a9b..88d16d2 100644
> --- a/Documentation/devicetree/bindings/hwlock/hwlock.txt
> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
> @@ -18,6 +18,9 @@ Common properties:
>  			property is needed on hwlock devices, where the number
>  			of supported locks within a hwlock device cannot be
>  			read from a register.
> +- hwlock-reserved-locks: Number of locks to reserve for clients requiring
> +			specific locks. This value cannot exceed the value of
> +			hwlock-num-locks.

Any suggestions here on the approach? This property falls into a gray
area as well, as the current approach is somewhat limiting (it doesn't
support sparse reserved locks, and expects them at the beginning of the
lock range).

regards
Suman

>  - hwlock-base-id:	An unique base Id for the locks for a particular hwlock
>  			device. This property is mandatory ONLY if a SoC has
>  			several hwlock devices.
> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
> index e05cea8..e74b55b 100644
> --- a/drivers/hwspinlock/hwspinlock_core.c
> +++ b/drivers/hwspinlock/hwspinlock_core.c
> @@ -286,6 +286,31 @@ int of_hwspin_lock_get_base_id(struct device_node *dn)
>  EXPORT_SYMBOL_GPL(of_hwspin_lock_get_base_id);
>  
>  /**
> + * of_hwspin_lock_get_num_reserved_locks() - retrieve number of reserved locks
> + * @dn: device node pointer
> + *
> + * This is an OF helper function that can be called by the underlying platform
> + * specific implementations, to retrieve the number of locks to reserve from
> + * the hwspinlock device instance's base id. The hwlock-reserved-locks DT
> + * property needs to be defined for requesting any DT-based locks.
> + *
> + * Returns a positive number of locks on success, a default value of 0 if the
> + * property is missing or an appropriate error code as returned by the OF layer
> + */
> +int of_hwspin_lock_get_num_reserved_locks(struct device_node *dn)
> +{
> +	unsigned int val = 0;
> +	int ret;
> +
> +	ret = of_property_read_u32(dn, "hwlock-reserved-locks", &val);
> +	if (!ret || ret == -EINVAL)
> +		ret = val;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(of_hwspin_lock_get_num_reserved_locks);
> +
> +/**
>   * of_hwspin_lock_get_num_locks() - OF helper to retrieve number of locks
>   * @dn: device node pointer
>   *
> diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
> index d120035..d18431f 100644
> --- a/include/linux/hwspinlock.h
> +++ b/include/linux/hwspinlock.h
> @@ -69,6 +69,7 @@ int of_hwspin_lock_simple_xlate(struct hwspinlock_device *bank,
>  				const struct of_phandle_args *hwlock_spec);
>  int of_hwspin_lock_get_base_id(struct device_node *dn);
>  int of_hwspin_lock_get_num_locks(struct device_node *dn);
> +int of_hwspin_lock_get_num_reserved_locks(struct device_node *dn);
>  int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
>  		const struct hwspinlock_ops *ops, int base_id, int num_locks,
>  		int num_reserved_locks);
> 

