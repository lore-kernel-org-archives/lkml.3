Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaHTPoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:44:05 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47849 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHTPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:44:03 -0400
Date: Wed, 20 Aug 2014 16:43:58 +0100
From: "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi-private@linaro.org" <linaro-acpi-private@linaro.org>
Subject: Re: [PATCH 06/19] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
Message-ID: <20140820154358.GA27927@xora-yoga-deb.xora.org.uk>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <1406206825-15590-7-git-send-email-hanjun.guo@linaro.org>
 <20140820150029.0BB3FC41205@trevor.secretlab.ca>
 <20140820152944.GR24600@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820152944.GR24600@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 04:29:44PM +0100, Catalin Marinas wrote:
> On Wed, Aug 20, 2014 at 04:00:28PM +0100, Grant Likely wrote:
> > On Thu, 24 Jul 2014 21:00:12 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > > @@ -345,13 +378,19 @@ int __init psci_init(void)
> > >  	const struct of_device_id *matched_np;
> > >  	psci_initcall_t init_fn;
> > >  
> > > -	np = of_find_matching_node_and_match(NULL, psci_of_match, &matched_np);
> > > +	if (acpi_disabled) {
> > > +		np = of_find_matching_node_and_match(NULL,
> > > +				psci_of_match, &matched_np);
> > >  
> > > -	if (!np)
> > > -		return -ENODEV;
> > > +		if (!np)
> > > +			return -ENODEV;
> > > +
> > > +		init_fn = (psci_initcall_t)matched_np->data;
> > > +
> > > +		return init_fn(np);
> > > +	}
> > >  
> > > -	init_fn = (psci_initcall_t)matched_np->data;
> > > -	return init_fn(np);
> > > +	return psci_0_2_init_acpi();
> > >  }
> > 
> > So, while the functionality is sound, this is kind of a stinky diff. The
> > ACPI path should not push the OF code into a sub branch. Make it look
> > like this instead (with the advantage that the diff will be simpler):
> > 
> > +	if (IS_ENABLED(CONFIG_ACPI) && !acpi_disabled)
> > +		return psci_0_2_init_acpi();
> 
> Minor point: we should define acpi_disabled to 1 when !CONFIG_ACPI and
> avoid additional IS_ENABLED(CONFIG_ACPI) checks (unless already don this
> way).
> 
This is the default behaviour already.

Graeme

