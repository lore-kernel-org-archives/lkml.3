Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3FDPJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:09:47 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:43726 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483Ab3FDPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:09:43 -0400
Message-ID: <51AE0335.902@calxeda.com>
Date: Tue, 04 Jun 2013 10:09:41 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/2 v2] sata highbank: add bit-banged SGPIO driver support
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com> <1370266538-14211-1-git-send-email-mark.langsdorf@calxeda.com> <20130603203727.GB29989@mtj.dyndns.org>
In-Reply-To: <20130603203727.GB29989@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 03:37 PM, Tejun Heo wrote:
> Hello, Mark.
> 
> In general, please try to reply to reviews addressing each point.  It
> gives much better sense of what's going on to the reviewer and also
> helps the reviewee to avoid misunderstandings or missing points.
> 
>> +static DEFINE_SPINLOCK(sgpio_lock);
>> +#define SCLOCK				0
>> +#define SLOAD				1
>> +#define SDATA				2
>> +#define SGPIO_PINS			3
>> +#define SGPIO_PORTS			8
>> +
>> +/* can be cast as an ahci_host_priv for compatibility with most functions */
> 
> This sounds awfully scary.  What's going on here?  Are you actually
> overriding ahci_host_priv?  If so, please don't ever do things like
> that.  Do it properly.  Add host_priv->platform_priv or whatever and
> chain the pointer there.  If you're worried about the extra deref,
> update ahci core such that it allows specifying extra size and you can
> embed ahci_host_priv in your own priv.  ie.
> 
> 	struct ecx_host_priv {
> 		struct ahci_host_priv	ahci_priv;	/* must be the first field */
> 		/* your own stuff */
> 	};
> 
> And tell ahci core sizeof(ecx_host_priv) some way, but really, just
> having a plain pointer should be enough, I think.

I think I want to do the opposite. For 90% of the AHCI EM functions,
I want ecx_host_priv to be an ahci_host_priv so that I can use those
functions without having to keep a local copy of them.

Would something like this:
struct ahci_host_priv {
	/* standard AHCI existing stuff */
	void *private_data;
};

I shied away from that because a private data structure having a private
data structure doesn't seem right.

>> +static inline int sgpio_bit_shift(struct ecx_host_priv *hpriv, u32 port,
>> +				u32 shift)
>> +{
>> +	return 1 << (3 * hpriv->port_to_sgpio[port] + shift);
>> +}
>> +
>> +static void ecx_parse_sgpio(struct ecx_host_priv *hpriv, u32 port, u32 state)
> 
> Would be kinda nice to have comment explaining what the function does
> as @state == 0 turns off everything while anything else would just
> turn things on.

Okay.

>> +static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
>> +					ssize_t size)
>> +{
> ...
>> +	if (!hpriv->em_msg_type & EM_MSG_TYPE_LED)
>> +		return size;
> 
> Is this really correct?  You first negate and convert it to bool and
> then bit-wise and it with a mask?  How is supposed to work?

Am I confused about the order of operations? It's meant to be "continue
if hpriv->em_msg_type doesn't have EM_MSG_TYPE_LED set".

>> -	ahci_save_initial_config(dev, hpriv, 0, 0);
>> +	ahci_save_initial_config(dev, (struct ahci_host_priv *) hpriv, 0, 0);
> 
> Ugh....... how is this supposed to work?  What if ahci_host_priv grows
> larger than ecx one in the future? :(

For functions like ahci_save_initial_config, I just want to use the
already defined ahci_ functions with my extra data along for the ride.
What's the best way to do that?

--Mark Langsdorf
Calxeda, Inc.


