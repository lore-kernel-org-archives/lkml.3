Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3FCUig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:38:36 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59162 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab3FCUhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:37:32 -0400
Date: Mon, 3 Jun 2013 13:37:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2 v2] sata highbank: add bit-banged SGPIO driver support
Message-ID: <20130603203727.GB29989@mtj.dyndns.org>
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
 <1370266538-14211-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370266538-14211-1-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mark.

In general, please try to reply to reviews addressing each point.  It
gives much better sense of what's going on to the reviewer and also
helps the reviewee to avoid misunderstandings or missing points.

> +static DEFINE_SPINLOCK(sgpio_lock);
> +#define SCLOCK				0
> +#define SLOAD				1
> +#define SDATA				2
> +#define SGPIO_PINS			3
> +#define SGPIO_PORTS			8
> +
> +/* can be cast as an ahci_host_priv for compatibility with most functions */

This sounds awfully scary.  What's going on here?  Are you actually
overriding ahci_host_priv?  If so, please don't ever do things like
that.  Do it properly.  Add host_priv->platform_priv or whatever and
chain the pointer there.  If you're worried about the extra deref,
update ahci core such that it allows specifying extra size and you can
embed ahci_host_priv in your own priv.  ie.

	struct ecx_host_priv {
		struct ahci_host_priv	ahci_priv;	/* must be the first field */
		/* your own stuff */
	};

And tell ahci core sizeof(ecx_host_priv) some way, but really, just
having a plain pointer should be enough, I think.

> +struct ecx_host_priv {
> +	void __iomem	*mmio;		/* bus-independent mem map */
> +	unsigned int	flags;		/* AHCI_HFLAG_* */
> +	u32		cap;		/* cap to use */
> +	u32		cap2;		/* cap2 to use */
> +	u32		port_map;	/* port map to use */
> +	u32		saved_cap;	/* saved initial cap */
> +	u32		saved_cap2;	/* saved initial cap2 */
> +	u32		saved_port_map;	/* saved initial port_map */
> +	u32		em_loc;		/* enclosure management location */
> +	u32		em_buf_sz;      /* EM buffer size in byte */
> +	u32		em_msg_type;    /* EM message type */
> +	struct clk	*clk;		/* Only for platforms supporting clk */
> +	u32		n_ports;
> +	unsigned	sgpio_gpio[SGPIO_PINS];
> +	u32		sgpio_pattern;
> +	u32		port_to_sgpio[SGPIO_PORTS];
> +};
> +
> +#define SGPIO_SIGNALS			3
> +#define ECX_ACTIVITY_BITS		0x300000
> +#define ECX_ACTIVITY_SHIFT		2
> +#define ECX_LOCATE_BITS		0x80000
> +#define ECX_LOCATE_SHIFT		1
> +#define ECX_FAULT_BITS			0x400000
> +#define ECX_FAULT_SHIFT			0
> +static inline int sgpio_bit_shift(struct ecx_host_priv *hpriv, u32 port,
> +				u32 shift)
> +{
> +	return 1 << (3 * hpriv->port_to_sgpio[port] + shift);
> +}
> +
> +static void ecx_parse_sgpio(struct ecx_host_priv *hpriv, u32 port, u32 state)

Would be kinda nice to have comment explaining what the function does
as @state == 0 turns off everything while anything else would just
turn things on.

> +static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
> +					ssize_t size)
> +{
...
> +	if (!hpriv->em_msg_type & EM_MSG_TYPE_LED)
> +		return size;

Is this really correct?  You first negate and convert it to bool and
then bit-wise and it with a mask?  How is supposed to work?

> -	ahci_save_initial_config(dev, hpriv, 0, 0);
> +	ahci_save_initial_config(dev, (struct ahci_host_priv *) hpriv, 0, 0);

Ugh....... how is this supposed to work?  What if ahci_host_priv grows
larger than ecx one in the future? :(

-- 
tejun
