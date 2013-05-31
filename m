Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3EaBRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:17:49 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:32975 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3EaBRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:17:42 -0400
Date: Fri, 31 May 2013 10:17:37 +0900
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] sata highbank: add bit-banged SGPIO driver support
Message-ID: <20130531011737.GA29975@mtj.dyndns.org>
References: <1369945051-2582-1-git-send-email-mark.langsdorf@calxeda.com>
 <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 03:17:31PM -0500, Mark Langsdorf wrote:
> +static DEFINE_SPINLOCK(sgpio_lock);
> +#define SCLOCK				0
> +#define SLOAD				1
> +#define SDATA				2
> +static unsigned ecx_sgpio[3];
> +static unsigned long ecx_sgpio_pattern;
> +static int port_to_sgpio[] = { 4, 0, 1, 2, 3};
> +static int n_ports;

Please use more specific names for global constants and variables.
Defining something like n_ports as a global variable is silly and
can lead to silly bugs later on.

> +#define ACTIVITY_BITS			0x300000 // 0x7
> +#define ACTIVITY_SHIFT			2
> +#define LOCATE_BITS 			0x80000  // 0x38
> +#define LOCATE_SHIFT			1
> +#define FAULT_BITS 			0x400000 // 0x1c0

No //s please and please pick and use a common prefix.  It doesn't
have to be long or complete.  Even something as short as HB_ is fine.

> +#define FAULT_SHIFT			1
> +#define SGPIO_BIT(port, shift)		1 << (3 * port_to_sgpio[(port)] + \
> +							(shift))

Please make it a function.

> +static void ecx_parse_sgpio(u32 port, u32 state)
> +{
> +	if (state == 0) {
> +		ecx_sgpio_pattern &= ~(SGPIO_BIT(port, ACTIVITY_SHIFT) |
> +					SGPIO_BIT(port, LOCATE_SHIFT) |
> +					SGPIO_BIT(port, FAULT_SHIFT));
> +		return;
> +	}
> +	if (state & ACTIVITY_BITS)
> +		ecx_sgpio_pattern |= SGPIO_BIT(port, ACTIVITY_SHIFT);
> +	if (state & LOCATE_BITS)
> +		ecx_sgpio_pattern |= SGPIO_BIT(port, LOCATE_SHIFT);
> +	if (state & FAULT_BITS)
> +		ecx_sgpio_pattern |= SGPIO_BIT(port, FAULT_SHIFT);
> +}

Maybe I'm misunderstanding the code but things are cleared iff @state
is zero?  Is that intentional?

....
> +static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
> +					ssize_t size)
> +{
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +	struct ahci_port_priv *pp = ap->private_data;
> +	unsigned long flags;
> +	int pmp, i;
> +	struct ahci_em_priv *emp;
> +	u32 sgpio_out;
> +
> +	/* get the slot number from the message */
> +	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
> +	if (pmp < EM_MAX_SLOTS)
> +		emp = &pp->em_priv[pmp];
> +	else
> +		return -EINVAL;
> +
> +	if (!hpriv->em_msg_type & EM_MSG_TYPE_LED) 

Huh?  This can't be right.

> +		return size;
> +
> +	spin_lock_irqsave(&sgpio_lock, flags);
> +	ecx_parse_sgpio(ap->port_no, state);
> +	sgpio_out = ecx_sgpio_pattern;

Hmmm... global data.  Can we at least move it into host private data?

> +	gpio_set_value(ecx_sgpio[SLOAD], 1);
> +	ecx_led_cycle_clock();
> +	gpio_set_value(ecx_sgpio[SLOAD], 0);
> +	for (i = 0; i < (3 * n_ports); i++) {
> +		gpio_set_value(ecx_sgpio[SDATA], sgpio_out & 1);
> +		sgpio_out >>= 1;
> +		ecx_led_cycle_clock();
> +	}

What's the above loop achieving?  Care to add a comment?

> +
> +	/* save off new led state for port/slot */
> +	emp->led_state = state;
> +
> +	spin_unlock_irqrestore(&sgpio_lock, flags);
> +	return size;
> +}
> +
> +void highbank_set_em_messages(struct device *dev, struct ahci_host_priv *hpriv,
> +			  struct ata_port_info *pi)
> +{
> +	struct device_node *np = dev->of_node;
> +	int i;
> +	int err;
> +
> +	for (i = 0;i < 3; i++) {

Missing space after ; and what's this magic 3 I keep seeing?

> +		ecx_sgpio[i] = of_get_named_gpio(np, "calxeda,sgpio-gpio", i);
> +		if (IS_ERR_VALUE(ecx_sgpio[i]))
> +		       return;
> +
> +	        err = gpio_request(ecx_sgpio[i], "CX SGPIO");
> +		if (err) {
> +			printk(KERN_ERR
> +				"sata_highbank gpio_request %d failed: %d\n",
> +					i, err);
> +		                return;

pr_err()?

> +		}
> +		gpio_direction_output(ecx_sgpio[i], 1);
> +	}
> +	/* there's a default ordering, but give it an optional override */
> +	for (i = 0; i < n_ports; i++) {
> +		of_property_read_u32_array(np, "calxeda,led-order", 
> +						port_to_sgpio, i);
> +	}

{ } unnecessary.

Thanks.

-- 
tejun
