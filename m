Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab3GPMG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:06:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48768 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3GPMG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:06:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2mujhxHDuJV0R1Sb4qzaX
Date: Tue, 16 Jul 2013 05:06:50 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130716120650.GW7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <20130716093541.GK8880@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716093541.GK8880@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130716 02:42]:
> Hi,
> 
> On Tue, Jul 16, 2013 at 02:05:36AM -0700, Tony Lindgren wrote:
> > +int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *st1,
> > +			  struct pinctrl_state *st2)
> > +{
> > +	struct pinctrl_setting *s1, *s2;
> > +
> > +	list_for_each_entry(s1, &st1->settings, node) {
> > +		struct pinctrl_dev *pctldev1;
> > +		const struct pinctrl_ops *pctlops1;
> > +		const unsigned *pins1;
> > +		unsigned num_pins1;
> > +		int res;
> > +
> > +		if (s1->type != PIN_MAP_TYPE_MUX_GROUP)
> > +			continue;
> > +
> > +		pctldev1 = s1->pctldev;
> > +		pctlops1 = pctldev1->desc->pctlops;
> > +		res = pctlops1->get_group_pins(pctldev1, s1->data.mux.group,
> > +					       &pins1, &num_pins1);
> > +		if (res) {
> > +			dev_dbg(dev, "could not get state1 group pins\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		list_for_each_entry(s2, &st2->settings, node) {
> > +			struct pinctrl_dev *pctldev2;
> > +			const struct pinctrl_ops *pctlops2;
> > +			const unsigned *pins2;
> > +			unsigned num_pins2;
> > +			int i, j, found = 0;
> > +
> > +			if (s2->type != PIN_MAP_TYPE_MUX_GROUP)
> > +				continue;
> > +
> > +			pctldev2 = s2->pctldev;
> > +			if (pctldev1 != pctldev2) {
> > +				dev_dbg(dev, "pctldev must be the same for states\n");
> > +				return -EINVAL;
> > +			}
> > +			pctlops2 = pctldev2->desc->pctlops;
> > +			res = pctlops2->get_group_pins(pctldev2,
> > +						       s2->data.mux.group,
> > +						       &pins2, &num_pins2);
> > +			if (res) {
> > +				dev_dbg(dev, "could not get state2 group pins\n");
> > +				return -EINVAL;
> > +			}
> > +
> > +			for (i = 0; i < num_pins1; i++) {
> > +				int pin1 = pins1[i];
> > +
> > +				for (j = 0; j < num_pins2; j++) {
> > +					int pin2 = pins2[j];
> > +
> > +					if (pin1 == pin2) {
> > +						found++;
> > +						break;
> > +					}
> > +				}
> > +			}
> 
> 4 levels of nested loops ? Isn't this way too much ? OTOH, it points to
> the fact that, perhaps, a list isn't the best data structure for
> pinctrl ??

This check is only done during init to avoid constantly diffing the
pins during runtime like we currently do. And it's only done for the
pins that need to change during runtime for wake-up events etc. So
that's typically few to ten pins per device that need to be checked.

I agree there are things to improve for the data structures,
but that's a different patch set.
 
> Or perhaps you could just assume that if num_pins1 == num_pins2 it's
> enough ? But that will, likely, leave some uncovered corners...

Yes I considered that, but checking for the number of pins is not
enough. It's best to check them properly during init.

Regards,

Tony
