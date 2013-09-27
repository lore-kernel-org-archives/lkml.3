Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab3I0K3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:29:01 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:41740 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab3I0K25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:28:57 -0400
Message-ID: <52455D2E.40607@st.com>
Date: Fri, 27 Sep 2013 11:25:50 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] media: st-rc: Add ST remote control driver
References: <1380272544-23514-1-git-send-email-srinivas.kandagatla@st.com> <CA+V-a8uiKdhxe5HfC4O-RYVKPi1Z-mVSXYY_TTV8HD4pseMbUw@mail.gmail.com>
In-Reply-To: <CA+V-a8uiKdhxe5HfC4O-RYVKPi1Z-mVSXYY_TTV8HD4pseMbUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Prabhakar,
>> +config RC_ST
>> +       tristate "ST remote control receiver"
>> +       depends on ARCH_STI && RC_CORE
>> +       help
>> +        Say Y here if you want support for ST remote control driver
>> +        which allows both IR and UHF RX.
>> +        The driver passes raw pluse and space information to the LIRC decoder.
>> +
> s/pluse/pulse
> 
Yep.. Will fix it..
[...]
>> +
>> +/* Registers */
>> +#define IRB_SAMPLE_RATE_COMM   0x64    /* sample freq divisor*/
>> +#define IRB_CLOCK_SEL          0x70    /* clock select       */
>> +#define IRB_CLOCK_SEL_STATUS   0x74    /* clock status       */
>> +/* IRB IR/UHF receiver registers */
>> +#define IRB_RX_ON               0x40   /* pulse time capture */
>> +#define IRB_RX_SYS              0X44   /* sym period capture */
>> +#define IRB_RX_INT_EN           0x48   /* IRQ enable (R/W)   */
>> +#define IRB_RX_INT_STATUS       0x4C   /* IRQ status (R/W)   */
>> +#define IRB_RX_EN               0x50   /* Receive enablei    */
> s/enablei/enable
> 
>> +#define IRB_MAX_SYM_PERIOD      0x54   /* max sym value      */
>> +#define IRB_RX_INT_CLEAR        0x58   /* overrun status     */
>> +#define IRB_RX_STATUS           0x6C   /* receive status     */
>> +#define IRB_RX_NOISE_SUPPR      0x5C   /* noise suppression  */
>> +#define IRB_RX_POLARITY_INV     0x68   /* polarity inverter  */
>> +
> generally smaller case hex letters are preferred
I will change this.
[...]
>> +
>> +static int st_rc_probe(struct platform_device *pdev)
>> +{
>> +       int ret = -EINVAL;
>> +       struct rc_dev *rdev;
>> +       struct device *dev = &pdev->dev;
>> +       struct resource *res;
>> +       struct st_rc_device *rc_dev;
>> +       struct device_node *np = pdev->dev.of_node;
>> +       const char *rx_mode;
>> +
>> +       rc_dev = devm_kzalloc(dev, sizeof(struct st_rc_device), GFP_KERNEL);
>> +
>> +       if (!rc_dev)
>> +               return -ENOMEM;
>> +
>> +       rdev = rc_allocate_device();
>> +
>> +       if (!rdev)
>> +               return -ENOMEM;
>> +
>> +       if (np && !of_property_read_string(np, "rx-mode", &rx_mode)) {
>> +
>> +               if (!strcmp(rx_mode, "uhf")) {
>> +                       rc_dev->rxuhfmode = true;
>> +               } else if (!strcmp(rx_mode, "infrared")) {
>> +                       rc_dev->rxuhfmode = false;
>> +               } else {
>> +                       dev_err(dev, "Unsupported rx mode [%s]\n", rx_mode);
>> +                       goto err;
>> +               }
>> +
>> +       } else {
>> +               goto err;
>> +       }
>> +
>> +       rc_dev->sys_clock = devm_clk_get(dev, NULL);
>> +       if (IS_ERR(rc_dev->sys_clock)) {
>> +               dev_err(dev, "System clock not found\n");
>> +               ret = PTR_ERR(rc_dev->sys_clock);
>> +               goto err;
>> +       }
>> +
>> +       rc_dev->irq = platform_get_irq(pdev, 0);
>> +       if (rc_dev->irq < 0) {
>> +               ret = rc_dev->irq;
>> +               goto clkerr;
>> +       }
>> +
>> +       ret = -ENODEV;
> Not required
yes, its redundant here.
> 
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (!res)
>> +               goto clkerr;
>> +
> This check is not required.
Ok, I see your point.
> 
>> +       rc_dev->base = devm_ioremap_resource(dev, res);
>> +       if (IS_ERR(rc_dev->base))
>> +               goto clkerr;
>> +
> In case of error assin ret to PTR_ERR(rc_dev->base)
Yes It makes sense .. I will assign it to ret.

Also found that there is a typo here.
It should be a goto err instead of goto clkerr.

Will fix that as well in next spin.

> 
>> +       if (rc_dev->rxuhfmode)
>> +               rc_dev->rx_base = rc_dev->base + 0x40;
>> +       else
>> +               rc_dev->rx_base = rc_dev->base;
>> +
>> +       rc_dev->dev = dev;
>> +       platform_set_drvdata(pdev, rc_dev);
>> +       st_rc_hardware_init(rc_dev);
>> +
>> +       rdev->driver_type = RC_DRIVER_IR_RAW;
>> +       rdev->allowed_protos = RC_BIT_ALL;
>> +       /* rx sampling rate is 10Mhz */
>> +       rdev->rx_resolution = 100;
>> +       rdev->timeout = US_TO_NS(MAX_SYMB_TIME);
>> +       rdev->priv = rc_dev;
>> +       rdev->open = st_rc_open;
>> +       rdev->close = st_rc_close;
>> +       rdev->driver_name = IR_ST_NAME;
>> +       rdev->map_name = RC_MAP_LIRC;
>> +       rdev->input_name = "ST Remote Control Receiver";
>> +
>> +       /* enable wake via this device */
>> +       device_set_wakeup_capable(dev, true);
>> +       device_set_wakeup_enable(dev, true);
>> +
>> +       ret = rc_register_device(rdev);
>> +       if (ret < 0)
>> +               goto clkerr;
>> +
>> +       rc_dev->rdev = rdev;
>> +       if (devm_request_irq(dev, rc_dev->irq, st_rc_rx_interrupt,
>> +                       IRQF_NO_SUSPEND, IR_ST_NAME, rc_dev) < 0) {
>> +               dev_err(dev, "IRQ %d register failed\n", rc_dev->irq);
>> +               ret = -EINVAL;
>> +               goto rcerr;
>> +       }
>> +
>> +       /**
>> +        * for LIRC_MODE_MODE2 or LIRC_MODE_PULSE or LIRC_MODE_RAW
>> +        * lircd expects a long space first before a signal train to sync.
>> +        */
>> +       st_rc_send_lirc_timeout(rdev);
>> +
>> +       dev_info(dev, "setup in %s mode\n", rc_dev->rxuhfmode ? "UHF" : "IR");
>> +
>> +       return ret;
>> +rcerr:
>> +       rc_unregister_device(rdev);
>> +       rdev = NULL;
>> +clkerr:
>> +       clk_disable_unprepare(rc_dev->sys_clock);
>> +err:
>> +       rc_free_device(rdev);
>> +       dev_err(dev, "Unable to register device (%d)\n", ret);
>> +       return ret;
>> +}
>> +

thanks,
srini


> 

