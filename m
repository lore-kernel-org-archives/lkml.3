Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbaDHXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:02:17 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40399 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbaDHXCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <1396532680-30352-1-git-send-email-bart.tanghe@thomasmore.be>
References: <1396532680-30352-1-git-send-email-bart.tanghe@thomasmore.be>
Date: Tue, 8 Apr 2014 16:02:15 -0700
Message-ID: <CAAYSxhpTV1-k7ROzJnnOhNcrZRUTzAfFc6YtLKLx6oZVUEHNxQ@mail.gmail.com>
Subject: Re: [rfc]pwm: add BCM2835 PWM driver
From: Tim Kryger <tim.kryger@linaro.org>
To: Bart Tanghe <bart.tanghe@thomasmore.be>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 6:44 AM, Bart Tanghe <bart.tanghe@thomasmore.be> wrote:
> need some recommendation
> the memory mapped io registers of the bcm2835 pwm hardware are spreaded
> over the memory mapped io
> gpio config 0x20200004 - clk config 0x201010A0 - pwm configuration 0x2020C000
> to handle this, I've used the base address of the memory mapped io
> so I can use positive offsets

So the registers for this PWM are located in three distinct memory regions?

Just define those three regions in your platform data or device tree.

> +/*mmio regiser mapping*/
> +#define OFFSET_PWM             0x0020C000

You won't need this guy.

> +#define DUTY                   0x14
> +#define PERIOD                 0x10
> +#define CHANNEL                0x10
> +
> +#define OFFSET_CLK             0x001010A0

Also unnecessary.

> +#define DIV                    0x04
> +
> +#define OFFSET_ALT             0x00200004

This can go too.

> +
> +/*Value defines*/
> +/*pwm clock configuration*/
> +#define PWMCLK_CNTL_OFF (0x5A000000 | (1 << 5))
> +#define PWMCLK_CNTL_ON (0x5A000000 | 0x11)
> +
> +#define PWM_ENABLE     0x00000001
> +#define PWM_POLARITY   0x00000010
> +/*+-1MHz pwm clock*/
> +#define PWMCLK_DIV     (0x5A000000 | (19 << 12))
> +/*ALT5 mask gpio18*/
> +#define ALTOR          0x02000000
> +#define ALTAND         0xFAFFFFFF
> +/*pwm configuration*/
> +#define MASK_CTL_PWM   0x000000FF
> +#define CTL_PWM        0x00000081
> +
> +#define DRIVER_AUTHOR "Bart Tanghe <bart.tanghe@thomasmore.be>"
> +#define DRIVER_DESC   "A bcm2835 pwm driver - raspberry pi development platform\
> +- only gpio 18 channel0 available"
> +
> +unsigned long *ptrPWM;
> +unsigned long *ptrPERIOD;
> +unsigned long *ptrDUTY;
> +unsigned long *ptrCLK;
> +unsigned long *ptrALT;
> +unsigned long *ptrDIV;

You don't need any of these pointers and they most certainly should
not be globals.

> +
> +struct bcm2835_pwm_chip {
> +       struct pwm_chip chip;
> +       struct device *dev;
> +       int channel;
> +       void __iomem *mmio;

One pointer isn't going to be enough.  You need three.

I suggest renaming the first and adding two more:

void __iomem *base_pwm;
void __iomem *base_clk;
void __iomem *base_alt;

> +};
> +
> +static inline struct bcm2835_pwm_chip *to_bcm2835_pwm_chip(
> +struct pwm_chip *chip){
> +       return container_of(chip, struct bcm2835_pwm_chip, chip);
> +}
> +
> +static int bcm2835_pwm_config(struct pwm_chip *chip,
> +struct pwm_device *pwm, int duty_ns, int period_ns){

Please align arguments on subsequent lines with those on the first line.

> +
> +       struct bcm2835_pwm_chip *pc;
> +
> +       pc = container_of(chip, struct bcm2835_pwm_chip, chip);

You defined to_bcm2835_pwm_chip but aren't using it here.  Why?

> +
> +       iowrite32(duty_ns/1000, ptrDUTY);
> +       iowrite32(period_ns/1000, ptrPERIOD);
> +
> +       #ifdef DEBUG
> +               printk(KERN_DEBUG "period %x\n", (unsigned int)ptrPERIOD);
> +               printk(KERN_DEBUG "duty %x\n", (unsigned int)ptrDUTY);
> +       #endif
> +
> +       return 0;
> +}
> +
> +static int bcm2835_pwm_enable(struct pwm_chip *chip,
> +struct pwm_device *pwm){

Again, please line up arguments on subsequent lines with those on the first.

This applies to pretty much all subsequent functions as well.

> +       struct bcm2835_pwm_chip *pc;
> +
> +       pc = container_of(chip, struct bcm2835_pwm_chip, chip);
> +
> +       /*TODO: channel 1 enable*/
> +       #ifdef DEBUG
> +               printk(KERN_DEBUG "pwm label: %s\n", pwm->label);
> +               printk(KERN_DEBUG "pwm hwpwm: %d\n", pwm->hwpwm);
> +               printk(KERN_DEBUG "pwm pwm: %d\n", pwm->pwm);
> +       #endif
> +
> +       iowrite32(ioread32(ptrPWM) | PWM_ENABLE, ptrPWM);
> +       #ifdef DEBUG
> +               printk(KERN_DEBUG "pwm: %x\n", ioread32(ptrPWM));
> +       #endif
> +       return 0;
> +}
> +
> +static void bcm2835_pwm_disable(struct pwm_chip *chip,
> +                       struct pwm_device *pwm)
> +{
> +       struct bcm2835_pwm_chip *pc;
> +
> +       pc = to_bcm2835_pwm_chip(chip);
> +
> +       #ifdef DEBUG
> +               printk(KERN_DEBUG "pwm label: %s\n", pwm->label);
> +               printk(KERN_DEBUG "pwm hwpwm: %d\n", pwm->hwpwm);
> +               printk(KERN_DEBUG "pwm pwm: %d\n", pwm->pwm);
> +       #endif
> +
> +       iowrite32(ioread32(ptrPWM) & ~PWM_ENABLE, ptrPWM);
> +}
> +
> +static int bcm2835_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
> +enum pwm_polarity polarity)
> +{
> +       if (polarity == PWM_POLARITY_NORMAL)
> +               iowrite32((ioread32(ptrPWM) & ~PWM_POLARITY), ptrPWM);
> +       else if (polarity == PWM_POLARITY_INVERSED)
> +               iowrite32((ioread32(ptrPWM) | PWM_POLARITY), ptrPWM);
> +
> +       return 0;
> +}
> +
> +static const struct pwm_ops bcm2835_pwm_ops = {
> +       .config = bcm2835_pwm_config,
> +       .enable = bcm2835_pwm_enable,
> +       .disable = bcm2835_pwm_disable,
> +       .set_polarity = bcm2835_set_polarity,
> +       .owner = THIS_MODULE,
> +};
> +
> +static int bcm2835_pwm_probe(struct platform_device *pdev)
> +{
> +       struct bcm2835_pwm_chip *pwm;
> +
> +       int ret;
> +       struct resource *r;
> +       u32 start, end;
> +
> +       printk(KERN_DEBUG "pwm probe\n");

This seems a bit unnecessary and also not particularly informative.

> +
> +       pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
> +       if (!pwm) {
> +               dev_err(&pdev->dev, "failed to allocate memory\n");

No need to print your own warning here, you get one for free.

> +               return -ENOMEM;
> +       }
> +
> +       pwm->dev = &pdev->dev;
> +
> +       #ifdef DEBUG
> +               printk(KERN_DEBUG "id:%d\n", pdev->id);
> +       #endif
> +
> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       pwm->mmio = devm_ioremap_resource(&pdev->dev, r);

You need to do this two more times for the other two regions.

something like:

r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
pwm->base_pwm = devm_ioremap_resource(&pdev->dev, r);

r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
pwm->base_clk = devm_ioremap_resource(&pdev->dev, r);

r = platform_get_resource(pdev, IORESOURCE_MEM, 2);
pwm->base_alt = devm_ioremap_resource(&pdev->dev, r);


> +       if (IS_ERR(pwm->mmio))
> +               return PTR_ERR(pwm->mmio);
> +
> +       start = r->start;
> +       end = r->end;

You don't need these.

Perform reads/writes with the base_pwm, base_clk, and base_alt pointers.

> +       ptrPWM = (long *)ioremap_nocache(start + OFFSET_PWM, 4);
> +       if (ptrPWM == NULL) {
> +               printk(KERN_ERR "ioremap REG_PWM failed\n");
> +               goto map_failed;
> +       }
> +
> +       ptrDUTY = (long *)ioremap_nocache(start + OFFSET_PWM + DUTY, 4);
> +       if (ptrDUTY == NULL) {
> +               printk(KERN_ERR "ioremap REG_DUTY failed\n");
> +               goto map_failed;
> +       }
> +
> +       ptrPERIOD = (long *)ioremap_nocache(
> +               start + OFFSET_PWM + PERIOD, 4);
> +       if (ptrDUTY == NULL) {
> +               printk(KERN_ERR "ioremap REG_DUTY failed\n");
> +               goto map_failed;
> +       }
> +
> +       ptrCLK = (long *)ioremap_nocache(start + OFFSET_CLK, 4);
> +       if (ptrCLK == NULL) {
> +               printk(KERN_ERR "ioremap PWMCLK_CNTL failed\n");
> +               goto map_failed;
> +       }
> +
> +       ptrALT = (long *)ioremap_nocache(start + OFFSET_ALT, 4);
> +       if (ptrALT == NULL) {
> +               printk(KERN_ERR "ioremap FUNC_SLCT_HEAT_PWM failed\n");
> +               goto map_failed;
> +       }
> +
> +       ptrDIV = (long *)ioremap_nocache(start + OFFSET_CLK + DIV, 4);
> +       if (ptrALT == NULL) {
> +               printk(KERN_ERR "ioremap pwmDIV failed\n");
> +               goto map_failed;
> +       }

You can remove all of these ioremap_nocache calls.

> +
> +       #ifdef DEBUG
> +               printk(KERN_DEBUG "io mem adres:%x %x %x\n",
> +                       (unsigned int)start+OFFSET_PWM, (unsigned int)start +
> +                       OFFSET_CLK, (unsigned int)start + OFFSET_ALT);
> +               printk(KERN_DEBUG "%x %x %x\n", (unsigned int)ptrPWM,
> +                       (unsigned int)ptrCLK, (unsigned int)ptrALT);
> +       #endif
> +
> +
> +       iowrite32((ioread32(ptrALT) & ALTAND) | ALTOR, ptrALT);
> +       /*disable the clock to set the dividere*/
> +       iowrite32(PWMCLK_CNTL_OFF, ptrCLK);
> +       /*pwm clock set to 1Mhz.*/
> +       iowrite32(PWMCLK_DIV, ptrDIV);
> +       /*enable the clock, load the new configuration*/
> +       iowrite32(PWMCLK_CNTL_ON, ptrCLK);
> +       /*set the pwm0 configuration*/
> +       iowrite32((ioread32(ptrPWM) & ~MASK_CTL_PWM) | CTL_PWM, ptrPWM);
> +
> +       #ifdef DEBUG
> +               /*duty cycle 1ms*/
> +               iowrite32(100000/1000, (unsigned long *)ptrDUTY);
> +               /*period 300 us*/
> +               iowrite32(300000/1000, (unsigned long *)ptrPERIOD);
> +               iowrite32(ioread32(ptrPWM) | PWM_ENABLE, ptrPWM);
> +       #endif

What is going on here?

> +
> +       return 0;
> +
> +map_failed:
> +       pwmchip_remove(&pwm->chip);
> +
> +chip_failed:
> +       devm_kfree(&pdev->dev, pwm);
> +       return -1;
> +
> +}
> +
> +static int bcm2835_pwm_remove(struct platform_device *pdev)
> +{
> +
> +       struct bcm2835_pwm_chip *pc;
> +       pc  = platform_get_drvdata(pdev);
> +
> +       if (WARN_ON(!pc))
> +               return -ENODEV;
> +
> +       iounmap(ptrALT);
> +       iounmap(ptrPWM);
> +       iounmap(ptrCLK);
> +       iounmap(ptrDUTY);
> +       iounmap(ptrPERIOD);

Not necessary since you will be removing all the ioremaps

> +
> +
> +       return pwmchip_remove(&pc->chip);
> +}
> +
> +static const struct of_device_id bcm2835_pwm_of_match[] = {
> +       { .compatible = "rpi,pwm-bcm2835" },

Compatible string should be "brcm,bcm2835-pwm" in order to follow the
vendor prefix docs and align with what is done elsewhere.

Where is your binding description doc?

> +       { }
> +};
> +
> +static struct platform_driver bcm2835_pwm_driver = {
> +       .driver = {
> +               .name = "pwm-bcm2835",
> +               .owner = THIS_MODULE,
> +               .of_match_table = bcm2835_pwm_of_match,
> +       },
> +       .probe = bcm2835_pwm_probe,
> +       .remove = bcm2835_pwm_remove,
> +};
> +module_platform_driver(bcm2835_pwm_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);

Additionally, you should switch over to using dev_dbg and pr_err as appropriate.
