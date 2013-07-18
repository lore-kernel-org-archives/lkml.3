Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3GRHgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:36:44 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22388 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751088Ab3GRHgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:36:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195NJT8xDYlEUqb7DVXQ6A2
Date: Thu, 18 Jul 2013 00:36:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130718073638.GP7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <51E70B5D.6030802@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E70B5D.6030802@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130717 14:30]:
> On 07/16/2013 03:05 AM, Tony Lindgren wrote:
> > To toggle dynamic states, let's add the optional active state in
> > addition to the static default state. Then if the optional active
> > state is defined, we can require that idle and sleep states cover
> > the same pingroups as the active state.
> > 
> > Then let's add pinctrl_check_dynamic() and pinctrl_select_dynamic()
> > to use instead of pinctrl_select() to avoid breaking existing users.
> > 
> > With pinctrl_check_dynamic() we can check that idle and sleep states
> > match the active state for pingroups during init, and don't need to
> > do it during runtime.
> > 
> > Then with the states pre-validated, pinctrl_select_dynamic() can
> > just toggle between the dynamic states without extra checks.
> > 
> > Note that pinctr_select_state() still has valid use cases, such as
> > changing states when the pins can be shared between two drivers
> > and don't necessarily cover the same pingroups. For dynamic runtime
> > toggling of pin states, we should eventually always use just
> > pinctrl_select_dynamic().
> 
> Something in this series should edit Documentation/pinctrl.txt to
> explain the philosophy behind the static/dynamic state split. That
> philosophy and/or semantics are more important to review than the code...

Sure, I'll write up something on that.
 
> Related to that, I'm worried that using pinctrl_select_state() and
> pinctrl_select_dynamic() appear to be mutually-exclusive options here.

Not currently, but eventually I think that's a good idea. We should
use pinctrl_select_state() only during init time eventually because
of the diffing of states it does.

> Why shouldn't e.g. a pinctrl-based I2C mux also be able to do runtime
> PM? Does the mux setting select which states are used for runtime PM, or
> does runtime PM override the basic mux setting, or must the pincrl-I2C
> mux manually implement custom runtime-PM/pinctrl interaction since
> there's no generic answer to those questions? How many more custom
> exceptions will there be?

The idea is that runtime PM will never touch the basic mux settings
at all. The "default" state should be considered a static state
that is claimed during driver probe, and released when the driver
is unloaded. This is typically let's say 90% of the pins for any
device.

For runtime PM, we can just toggle the PM related pinctrl states as
they have been verified to match the active state during init.

So I don't see why pinctrl-I2C would have to do anything specific.
All that is required is that the pins are grouped for the consumer
driver, and we can provide some automated checks on the states for
runtime PM.

Regards,

Tony
