Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCGKel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:34:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41618 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751074AbaCGKek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:34:40 -0500
Date: Fri, 7 Mar 2014 10:34:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/5] i2c: mv64xxx: Add reset deassert call
Message-ID: <20140307103433.GH21483@n2100.arm.linux.org.uk>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com> <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com> <20140307095222.GG21483@n2100.arm.linux.org.uk> <20140307100751.GN607@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307100751.GN607@lukather>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:07:51AM +0100, Maxime Ripard wrote:
> Hi Russell,
> 
> On Fri, Mar 07, 2014 at 09:52:23AM +0000, Russell King - ARM Linux wrote:
> > On Tue, Mar 04, 2014 at 05:28:37PM +0100, Maxime Ripard wrote:
> > > The Allwinner A31 SoC using that IP has a reset controller maintaining
> > > it reset unless told otherwise.
> > > 
> > > Add some optional reset support to the driver.
> > > 
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > > Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > 
> > This appears to be causing some build errors in Olof's next builder
> > for many of the ARM platforms which make use of this:
> > 
> > drivers/i2c/busses/i2c-mv64xxx.c:924: undefined reference to `reset_control_assert'
> > drivers/i2c/busses/i2c-mv64xxx.c:904: undefined reference to `reset_control_assert'
> > drivers/i2c/busses/i2c-mv64xxx.c:771: undefined reference to `devm_reset_control_get'
> > drivers/i2c/busses/i2c-mv64xxx.c:778: undefined reference to `reset_control_deassert'
> 
> The reset framework doesn't define its functions when its not
> selected, and somehow I think it was not here. What's odd is that
> there is an explicit select on RESET_CONTROLLER in the Kconfig. Maybe
> it's the circular dependency issue that has been reported that cause
> this and Wolfram sent a patch for: http://patchwork.ozlabs.org/patch/327573/

If that patch has been taken, then yes, it will have caused the above -
because now we have Dove and Kirkwood platforms trying to build this
driver without RESET_CONTROLLER being set.

The problem with depending on RESET_CONTROLLER is that then these
platforms end up without their I2C controller - because there's nothing
which enables RESET_CONTROLLER in their configuration.

Since RESET_CONTROLLER is not required for those platforms, it really
should be optional - and I think the real fix is for the reset controller
support to provide stub functions.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
