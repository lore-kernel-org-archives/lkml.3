Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3F0OHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:07:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36075 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3F0OHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:07:07 -0400
Message-ID: <51CC45D3.2000305@ti.com>
Date: Thu, 27 Jun 2013 17:01:55 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com> <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com> <20130625065811.GZ5523@atomide.com> <51CAEA90.90200@ti.com> <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
In-Reply-To: <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
On 06/26/2013 10:31 PM, Linus Walleij wrote:
> On Wed, Jun 26, 2013 at 3:20 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>
>> The "Sleep" pinctrl state is optional - if "sleep" state isn't defined
>> then "Idle" pinctrl state will be used during suspend.
>
> Why? If we have a clear cut semantic that "idle" is for runtime
> suspend, why should it be a fallback for suspend?

Seems, some misunderstanding is here :)

This is OMAP specific - for OMAP the "Idle" state is typically used, and 
"sleep" state is rather optional. Historically, three states have been 
defined for OMAP:
- "enabled"
- "idle"
- "off"

Most of OMAP drivers use Runtime PM only to manage their states - but, 
any calls to pm_runtime_xxx() helpers are redirected to *OMAP device* 
framework which physically configures power state/clocks/pins of device.

It's the usual situation, when the device is in "Active/ON" state when 
system is going to suspend, because PM runtime *do not allow* to disable 
device during system wide suspend. To workaround this, the *OMAP device* 
framework disables all active devices forcibly at .suspend_noirq() stage 
- and, at this moment, it should apply "Idle" or "Sleep" configuration 
on PINs.

I need to note here that "Sleep" state is/will be *not* used during PM 
runtime operation - it's very specific.

"off" state is used very rare now - and for the cases when device driver 
is removed or device need to completely switched off (HSI omap_hsi.c and 
RPROC remoteproc.c).

I think, In the future the OMAP pinctrl configurations would be manged 
in more flexible way then now (thanks to "pinctrl PM helpers" and you;))
- "Idle" state will be splitted to "Idle"/"sleep"
- "default" state will be splitted to "default"/"active"

>
> You do realize that can just be turned around (as common suspend
> is more widely implemented than runtime suspend) so that we
> could say that if "idle" does not exist, we go to "sleep" in
> runtime suspend.
>
>> So, final list of default pnctrl states may be defined as "default",
>> "active", "idle", "sleep", "off":
>> - "active", "idle", "sleep": will be handled by omap_device core
>> - "default", "off": will be handled by driver itself (or Device core).
>
> Currently the pinctrl system combines what is called "default"
> and "active" into one, assuming that all devices shall come up
> in the active state.
>
> Also we haven't seen a device that need some "off" state that
> is different from "sleep".
>
> If you want to drive this state list home you have to give a
> *real world example*.
>
> I want to see a *real* example, for a device and it's pins,
> that define totally different things for these states, as a
> rationale.
>
> Else we are just defining states to make nice figures or mental
> maps and that is not helpful for drivers writers.
OK. Please pay attention to the following example (taken from TI Android 
product kernel 3.4 - need to have the same in mainline kernel):
static const struct omap_device_pad port1_phy_pads[] __initconst = {
	{
		.name = "usbb1_ulpitll_stp.usbb1_ulpiphy_stp",
		.flags  = OMAP_DEVICE_PAD_REMUX,
		.enable = OMAP_PIN_OUTPUT | OMAP_MUX_MODE4,
		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE7,
		.off = OMAP_PIN_OFF_OUTPUT_LOW | OMAP_MUX_MODE7,
	},
	{
		.name = "usbb1_ulpitll_clk.usbb1_ulpiphy_clk",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dir.usbb1_ulpiphy_dir",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0",
		.flags  = OMAP_DEVICE_PAD_REMUX |OMAP_DEVICE_PAD_WAKEUP,
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1",
		.flags  = OMAP_DEVICE_PAD_REMUX |OMAP_DEVICE_PAD_WAKEUP,
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat2.usbb1_ulpiphy_dat2",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat3.usbb1_ulpiphy_dat3",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat4.usbb1_ulpiphy_dat4",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat5.usbb1_ulpiphy_dat5",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat6.usbb1_ulpiphy_dat6",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
	{
		.name = "usbb1_ulpitll_dat7.usbb1_ulpiphy_dat7",
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
	},
};

As you can see, from 12 pins only 3 pins need to be reconfigured while 
switching from "active"->"idle" states and back (and as I mentioned 
above for OMAP "idle" == "sleep" now).

Regarding "OFF" state:
OMAP mux HW defines special state for unused pins which is selected by 
default after reset and need to be selected when device isn't used, for 
example:
_MUXMODE - Functional multiplexing selection for pad
0x0: Select usbb1_hsic_data
0x3: Select gpio_96
0x7: Select safe_mode <<--- pin unused

In opposite, in "sleep" state some pins need to be reconfigured in 
special way to avoid glitches/support wake up/follow HW requirements:
	{
		.name = "usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0",
		.flags  = OMAP_DEVICE_PAD_REMUX |OMAP_DEVICE_PAD_WAKEUP,
		.enable = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
<<- "active" PIN is input+pulldown
		.idle = OMAP_PIN_INPUT_PULLDOWN | OMAP_MUX_MODE4,
<<- "idle/sleep" PIN is input+pulldown+wakeup_en
	},
- or -
	{
		.name	= "uart2_rts.uart2_rts",
		.flags  = OMAP_DEVICE_PAD_REMUX,
		.enable	= OMAP_PIN_OUTPUT | OMAP_MUX_MODE0,
<<- "active" PIN is output
		.idle   = OMAP_PIN_OFF_INPUT_PULLUP | OMAP_MUX_MODE7,
<<- "idle/sleep" PIN is input+pullup+safe
	},


More over, OAMP mux HW allow to define special state for PIN which
will be applied in suspend/OFF mode (OFF-mode deepest possible PM state 
for OMAP) automatically.
X_OFFMODEPULLTYPESELECT OffMode mode pullup/down selection for pad
X_OFFMODEPULLUDENABLE OffMode mode pullup/down enable for pad
X_OFFMODEOUTVALUE OffMode mode output value for pad
X_OFFMODEOUTENABLE OffMode mode output enable value for pad
X_OFFMODEENABLE OffMode mode override control for pad

>
> Yours,
> Linus Walleij
>

Regards,
-grygorii
