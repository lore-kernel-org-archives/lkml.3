Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3IQKdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:33:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55626 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3IQKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:33:31 -0400
Date: Tue, 17 Sep 2013 12:33:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, thierry.reding@gmail.com, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20130917103301.GC30088@pengutronix.de>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	thierry.reding@gmail.com, swarren@wwwdotorg.org, t.figa@samsung.com,
	grant.likely@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
	ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
	rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org
References: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
 <1379051922-4930-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379051922-4930-5-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:45:43 up 23 days, 19:16, 49 users,  load average: 0.02, 0.08,
 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 01:58:42PM +0800, Xiubo Li wrote:
> This adds the Document for Freescale FTM PWM driver under
> Documentation/devicetree/bindings/pwm/.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 36 ++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> new file mode 100644
> index 0000000..e736806
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> @@ -0,0 +1,36 @@
> +Freescale FTM PWM controller
> +
> +Required properties:
> +- compatible: Should be "fsl,vf610-ftm-pwm"
> +- reg: Physical base address and length of the controller's registers
> +- #pwm-cells: Should be 3. See pwm.txt in this directory for a description of
> +  the cells format.
> +- clock-names : Includes the following module clock source entries:
> +    "ftm0" (system clock),
> +    "ftm0_fix_sel" (fixed frequency clock),
> +    "ftm0_ext_sel" (external clock)
> +- clocks : Must contain an entry list for entries in clock-names.
> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
> +  entries in clock-names.
> +- For each channel's pinctrl, the "chN-active" and "chN-idle" states should be
> +  implemented at the same time.

I thought about this active/idle pinctrl stuff again. It should be
removed from the PWM driver. The above is used to control the PWM output
state when the PWM is disabled, so that for example a backlight stays
disabled after a call to pwm_disable.

IMO this is wrong. Instead, the pwm client drivers (pwm_backlight)
shouldn't assume a particular output state of the PWM after a pwm
disable. Instead they should simply set the PWM to a duty cycle of 0%
(or 100% for inverted) to effectively disable it. If then a PWM driver
can optimize this to actually disabling the PWM completely, then fine,
but that's an optimization.

If the handoff of PWM pins from bootloader state to regular state causes
problems like flashing backlights or LEDs due to the pinctrl framework
configuring the iomux before the PWM driver takes over, then the pinctrl
should be done from the client drivers (pwm_backlight, pwm_led), not
from the pwm driver and not from the pinctrl framework before
initializing the clients.

So NACK to this complex pinctrl setup in this pwm driver.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
