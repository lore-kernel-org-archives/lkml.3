Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab3FDUc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:32:57 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45667 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3FDUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:32:55 -0400
Date: Tue, 4 Jun 2013 13:32:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/2 v2] sata highbank: add bit-banged SGPIO driver support
Message-ID: <20130604203251.GF14916@htj.dyndns.org>
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
 <1370266538-14211-1-git-send-email-mark.langsdorf@calxeda.com>
 <20130603203727.GB29989@mtj.dyndns.org>
 <51AE0335.902@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AE0335.902@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mark.

On Tue, Jun 04, 2013 at 10:09:41AM -0500, Mark Langsdorf wrote:
> > And tell ahci core sizeof(ecx_host_priv) some way, but really, just
> > having a plain pointer should be enough, I think.
> 
> I think I want to do the opposite. For 90% of the AHCI EM functions,
> I want ecx_host_priv to be an ahci_host_priv so that I can use those
> functions without having to keep a local copy of them.
> 
> Would something like this:
> struct ahci_host_priv {
> 	/* standard AHCI existing stuff */
> 	void *private_data;
> };
> 
> I shied away from that because a private data structure having a private
> data structure doesn't seem right.

Aren't we talking about the same thing?  I'm perfectly fine with
adding a pointer to ahci_host_priv.  Maybe you can name it slightly
differently - say, *impl_data, *platform_data, whatever.

> >> +static ssize_t ecx_transmit_led_message(struct ata_port *ap, u32 state,
> >> +					ssize_t size)
> >> +{
> > ...
> >> +	if (!hpriv->em_msg_type & EM_MSG_TYPE_LED)
> >> +		return size;
> > 
> > Is this really correct?  You first negate and convert it to bool and
> > then bit-wise and it with a mask?  How is supposed to work?
> 
> Am I confused about the order of operations? It's meant to be "continue
> if hpriv->em_msg_type doesn't have EM_MSG_TYPE_LED set".

Shouldn't that be

	if (!(hpriv->em_msg_type & EM_MSG_TYPE_LED))

! has higher priority than &.  You're converting em_msg_type to 1 or 0
  and then and'ing EM_MSG_TYPE_LED to it.

> >> -	ahci_save_initial_config(dev, hpriv, 0, 0);
> >> +	ahci_save_initial_config(dev, (struct ahci_host_priv *) hpriv, 0, 0);
> > 
> > Ugh....... how is this supposed to work?  What if ahci_host_priv grows
> > larger than ecx one in the future? :(
> 
> For functions like ahci_save_initial_config, I just want to use the
> already defined ahci_ functions with my extra data along for the ride.
> What's the best way to do that?

Please don't override different types on the same area.  Having the
driver specific data in a separate struct pointed to by ahci_host_priv
should work fine, right?

Thanks.

-- 
tejun
