Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab3E1HiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:38:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57268 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab3E1HiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:38:09 -0400
Date: Tue, 28 May 2013 09:38:01 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] pwm: add pca9685 driver
Message-ID: <20130528073801.GD31991@pengutronix.de>
References: <1369646907-18424-1-git-send-email-s.trumtrar@pengutronix.de>
 <20130527191333.GA10219@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130527191333.GA10219@mithrandir>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:57:31 up 79 days, 16:37, 18 users,  load average: 0.15, 0.10,
 0.10
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, May 27, 2013 at 09:13:34PM +0200, Thierry Reding wrote:
> On Mon, May 27, 2013 at 11:28:27AM +0200, Steffen Trumtrar wrote:
> > Add pwm driver for the NXP pca9685 16 channel pwm-led controller.
> 
> Please stick to the all-caps spelling of PWM in prose. Also why is this
> called pwm-led? Can't the generated PWM signal be used for other
> purposes?
> 

Hm, sure. They can. The unit is marketed as a PWM LED controller, but you can
use it for whatever PWM needs you have. I will change that.

> > The driver is really barebones at this stage. E.g. the OE' pin and
> > therefore the according registers are not supported.
> 
> s/according/corresponding/?

Yes. Better.

> 
> > The driver was tested on a HW where this pin is tied to GND.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > ---
> > Changes since v1:
> > 	- fix typo in documentation example
> > 
> >  .../devicetree/bindings/pwm/nxp,pca9685-pwmled.txt |  28 +++
> >  drivers/pwm/Kconfig                                |   9 +
> >  drivers/pwm/Makefile                               |   1 +
> >  drivers/pwm/pwm-pca9685-led.c                      | 245 +++++++++++++++++++++
> >  4 files changed, 283 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
> >  create mode 100644 drivers/pwm/pwm-pca9685-led.c
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
> > new file mode 100644
> > index 0000000..6646980
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/nxp,pca9685-pwmled.txt
> > @@ -0,0 +1,28 @@
> > +NXP PCA9685 16-channel 12-bit PWM LED controller
> > +================================================
> > +
> > +Required properties:
> > +  - compatible: "nxp,pca9685-pwmled"
> > +  - #pwm-cells: should be 2.  The first cell specifies the per-chip index
> > +    of the PWM to use and the second cell is the period in nanoseconds.
> > +    The index 16 is the ALLCALL channel, that sets all pwm channels at the same
> 
> "PWM channels" please.
> 

Okay.

> > +Optional properties:
> > +  - invrt:  <0> output logic state not inverted
> > +	    <1> output logic state inverted
> 
> Why not make this "invert"?
> 

I used the naming of NXPs datasheet, but I can change that.

> > +  - outdrv: <0> configure outputs with open-drain structure
> > +	    <1> configure outputs with totem pole structure
> 
> And this could be a boolean property called "totem-pole"? I think that's
> much more intuitive to use.
> 

This is also a register field from NXP. The datasheet references the invrt and
outdrv bit in different locations to describe some use case and the corresponding
setting of this two bits. That is why I thought it might be easier to use.
Get use case from datasheet -> put corresponding value in DT -> done.
On the other hand, the DT might be easier to understand with a boolean property.
I would than go for "open-drain" though, as totem-pole is the reset default.

> > +Example:
> > +
> > +For LEDs that are directly connected to the pca, the following setting is
> 
> "to the PCA"?
> 

Okay.

> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 115b644..8696f61 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -97,6 +97,15 @@ config PWM_MXS
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-mxs.
> >  
> > +config PWM_PCA9685_LED
> > +	tristate "NXP PCA9685 PWM support for LED drivers"
> > +	depends on OF
> 
> Isn't this missing a "depends on REGMAP_I2C"? And again, why is this LED
> specific? Even if only LEDs are driven by the PWM signals, the part does
> not have other functionality than driving PWM signals, right? So adding
> an -led suffix isn't meaningful.
>

Yes, you are right. I will change that.

> > diff --git a/drivers/pwm/pwm-pca9685-led.c b/drivers/pwm/pwm-pca9685-led.c
> [...]
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +#include <linux/i2c.h>
> 
> I know I'm being picky here, but can you leave a blank line between the
> end of the comment and the first #include, please?
> 

Okay.

> > +#define PCA9685_MODE1		0x00
> > +#define PCA9685_MODE2		0x01
> > +#define PCA9685_SUBADDR1	0x02
> > +#define PCA9685_SUBADDR2	0x03
> > +#define PCA9685_SUBADDR3	0x04
> > +#define PCA9685_ALLCALLADDR	0x05
> > +#define PCA9685_LEDX_ON_L	0x06
> > +#define PCA9685_LEDX_ON_H	0x07
> > +#define PCA9685_LEDX_OFF_L	0x08
> > +#define PCA9685_LEDX_OFF_H	0x09
> > +
> > +#define PCA9685_ALL_LED_ON_L	0xFA
> > +#define PCA9685_ALL_LED_ON_H	0xFB
> > +#define PCA9685_ALL_LED_OFF_L	0xFC
> > +#define PCA9685_ALL_LED_OFF_H	0xFD
> > +#define PCA9685_PRESCALE	0xFE
> > +
> > +#define PCA9685_NUMREGS		0xFF
> > +#define PCA9685_MAXCHAN		0x10
> > +
> > +#define LED_FULL		(1 << 4)
> > +#define MODE1_SLEEP		(1 << 4)
> > +#define MODE2_INVRT		(1 << 4)
> > +#define MODE2_OUTDRV		(1 << 2)
> > +
> > +#define LED_N_ON_H(N)		(PCA9685_LEDX_ON_H + (4 * (N)))
> > +#define LED_N_ON_L(N)		(PCA9685_LEDX_ON_L + (4 * (N)))
> > +#define LED_N_OFF_H(N)		(PCA9685_LEDX_OFF_H + (4 * (N)))
> > +#define LED_N_OFF_L(N)		(PCA9685_LEDX_OFF_L + (4 * (N)))
> > +
> > +struct pca9685 {
> > +	struct pwm_chip chip;
> > +	struct regmap *regmap;
> > +	struct device *dev;
> > +};
> > +
> > +static inline struct pca9685 *to_pca(struct pwm_chip *chip)
> > +{
> > +	return container_of(chip, struct pca9685, chip);
> > +}
> > +
> > +static int pca9685_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
> > +			      int duty_ns, int period_ns)
> 
> The alignment doesn't look right here.
> 
> > +{
> > +	struct pca9685 *pca = to_pca(chip);
> > +	unsigned long long duty;
> > +	unsigned int reg;
> > +
> > +	if (duty_ns < 1)
> > +		return 0;
> 
> Doesn't duty_ns < 1 mean the signal is off? Why are you ignoring this
> case?
> 

I just tested with led-pwm which calls config and then disable.
So, I don't need to do any setup in this case. I don't know, if that is
PWM framework or driver specific. Maybe I do have to do something in this
case? I will have a look.

> > +
> > +	if (duty_ns == period_ns) {
> > +		reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_ON_H
> > +						: LED_N_ON_H(pwm->hwpwm);
> 
> There's a few occurrences of this style in the driver. I don't like it
> much because it makes things hard to read. How about writing it this
> way?
> 
> 	if (pwm->hwpwm < PCA9685_MAXCHAN)
> 		reg = LED_N_ON_H(pwm->hwpwm);
> 	else
> 		reg = PCA9685_ALL_LED_ON_H;
> 
> And similar for the other cases.
> 

If it is preferred, I can change that. No problem.

> > +	duty = 4096 * (unsigned long long)duty_ns;
> > +	duty = DIV_ROUND_UP_ULL(duty, period_ns);
> > +
> > +	reg = (pwm->hwpwm == PCA9685_MAXCHAN) ? PCA9685_ALL_LED_OFF_L
> > +					: LED_N_OFF_L(pwm->hwpwm);
> 
> Like here.
> 
> > +	regmap_write(pca->regmap, reg, 0xff & (int)duty);
> 
> "(int)duty & 0xff", please.
> 
> > +	regmap_write(pca->regmap, reg, 0xf & ((int)duty >> 8));
> 
> Same here.
> 

I will change all three.

> > +static int pca9685_pwmled_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> > +{
> > +	struct pca9685 *pca = to_pca(chip);
> > +	unsigned int reg;
> > +
> > +	/* the PWM subsystem does not support a pre-delay */
> 
> What do you mean by that? How is it relevant to this code. Maybe there's
> a case to be made to add functionality that you miss.
> 

Well, you are right. The PCA supports setting two delays: start of duty cycle and end of
duty cycle. The PWM subsystem AFAIK only supports setting the length of the duty cycle.
Which results in me setting the start of duty cycle to 0.
If other PWM chips also support this and there actually is a use case for this,
than that might be a functionality missing from the PWM subsystem.

> > +static int pca9685_pwmled_request(struct pwm_chip *chip, struct pwm_device *pwm)
> > +{
> > +	struct pca9685 *pca = to_pca(chip);
> > +
> > +	return regmap_update_bits(pca->regmap, PCA9685_MODE1, MODE1_SLEEP, 0x0);
> > +}
> 
> Don't you need to set the SLEEP bit in a pca9685_pwmled_free() function?
> Since the SLEEP bit is for all PWM channels, you probably need some
> reference counting to make sure you only set it when all channels have
> been released.
> 

Hm, yes. I might have to add that.

> > +static int pca9685_pwmled_probe(struct i2c_client *client,
> > +				const struct i2c_device_id *id)
> > +{
> > +	struct device_node *np = client->dev.of_node;
> > +	struct pca9685 *pca;
> > +	int ret;
> > +	int val;
> > +	int mode2;
> > +
> > +	pca = devm_kzalloc(&client->dev, sizeof(*pca), GFP_KERNEL);
> > +	if (!pca)
> > +		return -ENOMEM;
> > +
> > +	pca->regmap = devm_regmap_init_i2c(client, &pca9685_regmap_i2c_config);
> > +	if (IS_ERR(pca->regmap)) {
> > +		ret = PTR_ERR(pca->regmap);
> > +		dev_err(&client->dev, "Failed to initialize register map: %d\n",
> > +				ret);
> > +		return ret;
> > +	}
> > +
> > +	i2c_set_clientdata(client, pca);
> > +	pca->dev = &client->dev;
> > +
> > +	regmap_read(pca->regmap, PCA9685_MODE2, &mode2);
> > +	if (!of_property_read_u32(np, "invrt", &val)) {
> 
> These two lines could use a blank line as a separator.
> 
> > +		if (val)
> > +			mode2 |= MODE2_INVRT;
> > +		else
> > +			mode2 &= ~MODE2_INVRT;
> > +	}
> > +	if (!of_property_read_u32(np, "outdrv", &val)) {
> 
> These too.
> 
> > +		if (val)
> > +			mode2 |= MODE2_OUTDRV;
> > +		else
> > +			mode2 &= ~MODE2_OUTDRV;
> > +	}
> > +	regmap_write(pca->regmap, PCA9685_MODE2, mode2);
> 
> And these.
> 
> > +	ret = pwmchip_add(&pca->chip);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> 
> "return pwmchip_add(&pca->chip);"?
> 
> > +static const struct i2c_device_id pca9685_id[] = {
> > +	{"pca9685", 0},
> 
> Spaces between '{' and '"' as well as '0' and '}', please.
> 
> > +	{},
> 
> "{ }", please. Or "{ /* sentinel */ }" as in the "of" table.
> 
> > +static struct i2c_driver pca9685_i2c_driver = {
> > +	.driver = {
> > +		   .name = "pca9685",
> > +		   .owner = THIS_MODULE,
> > +		   .of_match_table = pca9685_dt_ids,
> > +		   },
> 
> This uses weird identing. Please fix.
> 

All of the above: I will fix those.

Thanks,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
