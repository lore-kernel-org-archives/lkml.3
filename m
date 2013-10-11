Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3JKLnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:43:31 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46218 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3JKLn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130908170355.GA3154@katana>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1377077077-20896-1-git-send-email-ch.naveen@samsung.com> <20130908170355.GA3154@katana>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 11 Oct 2013 17:13:08 +0530
Message-ID: <CAHfPSqBP66wj3Z1YktGsJTsbT_C9YmkGQW6r4iG649uE+0TjbQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: exynos5: add High Speed I2C controller driver
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        w.sang@pengutronix.de, t.figa@samsung.com,
        Ben Dooks <ben-linux@fluff.org>, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 September 2013 22:33, Wolfram Sang <wsa@the-dreams.de> wrote:
>
> On Wed, Aug 21, 2013 at 02:54:37PM +0530, Naveen Krishna Ch wrote:
>> Adds support for High Speed I2C driver found in Exynos5 and
>> later SoCs from Samsung.
>>
>> Highspeed mode is a minor change in the i2c protocol.
>> Starts with
>> 1. start condition,
>> 2. 8-bit master ID code (00001xxx)
>> 3. followed by a NACK bit
>> Once the above conditions are met, the bus is now operates in highspeed mode.
>> The rest of the I2C protocol applies the same.
>
> The description is correct, but it is not a change in the protocol. This
> is fully specified in the I2C specs.
Understood
>
>> Driver only supports Device Tree method.
>>
>> Changes since v1:
>> 1. Added FIFO functionality
>> 2. Added High speed mode functionality
>> 3. Remove SMBUS_QUICK
>> 4. Remove the debugfs functionality
>> 5. Use devm_* functions where ever possible
>> 6. Driver is free from GPIO configs
>> 7. Use OF data string "clock-frequency" to get the bus operating frequencies
>> 8. Split the clock divisor calculation function
>> 9. Add resets for the failed transacton cases
>> 10. Removed retries as core does retries if -EAGAIN is returned
>> 11. Removed mode from device tree info (use speed to distinguish
>>     the mode of operation)
>> 12. Use wait_for_completion_timeout as the interruptible case is not tested well
>> 13. few other bug fixes and cosmetic changes
>> 14. Removed the untested runtime_pm code
>> 15. Removed the retries as core does that
>> 16. Use adap.nr instead of alias
>> 17. Added spinlocks around the irq code
>> 18. Use i2c_add_numbered_adapter() instead of using aliases
>
> Changes since v1 are irrelevant for the patch description.
Will remove
>
>>
>> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Reviewed-by: Simon Glass <sjg@google.com>
>> Tested-by: Andrew Bresticker <abrestic@google.com>
>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
>> Signed-off-by: Andrew Bresticker <abrestic@google.com>
>>
>> ---
>> Wolfram and Thomas Figa thanks for reviewing the code.
>>
>> Changes since v10:
>> 1. Remove the incomplete runtime_pm code
>> 2. Correct the error checks as suggested by Thomas
>> 3. Use i2c_add_numbered_adapter() as suggested
>> 4. Modified the irq routine to handle the specific interrupts
>> 5. Added spinlocks around the irq code
>> 6. Remove the "mode" of operation field from device tree node and use the
>>    clock-frequency to decide the mode.
>>
>>  .../devicetree/bindings/i2c/i2c-exynos5.txt        |   44 ++
>>  drivers/i2c/busses/Kconfig                         |    7 +
>>  drivers/i2c/busses/Makefile                        |    1 +
>>  drivers/i2c/busses/i2c-exynos5.c                   |  799 ++++++++++++++++++++
>>  4 files changed, 851 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
>>  create mode 100644 drivers/i2c/busses/i2c-exynos5.c
>>
>> diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
>> new file mode 100644
>> index 0000000..805e018
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
>> @@ -0,0 +1,44 @@
>> +* Samsung's High Speed I2C controller
>> +
>> +The Samsung's High Speed I2C controller is used to interface with I2C devices
>> +at various speeds ranging from 100khz to 3.4Mhz.
>> +
>> +Required properties:
>> +  - compatible: value should be.
>> +      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
>> +  - reg: physical base address of the controller and length of memory mapped
>> +    region.
>> +  - interrupts: interrupt number to the cpu.
>> +  - #address-cells: always 1 (for i2c addresses)
>> +  - #size-cells: always 0
>> +
>> +  - Pinctrl:
>> +    - pinctrl-0: Pin control group to be used for this controller.
>> +    - pinctrl-names: Should contain only one value - "default".
>> +
>> +Optional properties:
>> +  - clock-frequency: Desired operating frequency in Hz of the bus.
>> +    -> If not specified, the default value is 100khz in fast-speed mode and
>> +       1Mhz in high-speed mode.
>
> Description doesn't match the current code.
Will correct
>
>> +    -> If specified, The bus operates in high-speed mode only if the
>> +       clock-frequency is >= 1Mhz.
>
> s/The/the/
Will correct
>
> ...
>
>> +/*
>> + * exynos5_i2c_init: configures the controller for I2C functionality
>> + * Programs I2C controller for Master mode operation
>> + */
>> +static void exynos5_i2c_init(struct exynos5_i2c *i2c)
>> +{
>> +     u32 i2c_conf = readl(i2c->regs + HSI2C_CONF);
>> +     u32 i2c_timeout = readl(i2c->regs + HSI2C_TIMEOUT);
>> +
>> +     /* Disable timeout */
>> +     i2c_timeout &= ~HSI2C_TIMEOUT_EN;
>> +     writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);
>
> Just curious: Can't you use HSI2C_TIMEOUT and wait_for_completion
> instead of wait_for_completion_timeout? If so, it might save you a
> little bit of overhead.
With timeout enabled, few transactions were timing out.
wait_for_completion_timeout seems to be very stable.

>
>> +
>> +     writel((HSI2C_FUNC_MODE_I2C | HSI2C_MASTER),
>> +                                     i2c->regs + HSI2C_CTL);
>> +     writel(HSI2C_TRAILING_COUNT, i2c->regs + HSI2C_TRAILIG_CTL);
>> +
>> +     if (i2c->speed_mode == HSI2C_HIGH_SPD) {
>> +             writel(HSI2C_MASTER_ID(MASTER_ID(i2c->adap.nr)),
>> +                                     i2c->regs + HSI2C_ADDR);
>> +             i2c_conf |= HSI2C_HS_MODE;
>> +     }
>> +
>> +     writel(i2c_conf | HSI2C_AUTO_MODE, i2c->regs + HSI2C_CONF);
>> +}
>> +
>> +
>> +     if ((i2c->msg->flags & I2C_M_RD) && (int_status &
>> +                     (HSI2C_INT_TRAILING | HSI2C_INT_RX_ALMOSTFULL))) {
>> +             fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
>> +             fifo_level = HSI2C_RX_FIFO_LVL(fifo_status);
>> +             len = min(fifo_level, i2c->msg->len - i2c->msg_ptr);
>> +
>> +             while (len > 0) {
>> +                     byte = (unsigned char)
>> +                             readl(i2c->regs + HSI2C_RX_DATA);
>> +                     i2c->msg->buf[i2c->msg_ptr++] = byte;
>> +                     len--;
>> +             }
>
> With all this copying going on, this should be threaded irq probably.
HSI2C driver is heavily dependent on irqs and trans_status register bits.
modifying the code to work with threaded_irq was not successful.

>
>> +             i2c->state = 0;
>> +     } else if (int_status & HSI2C_INT_TX_ALMOSTEMPTY) {
>> +             fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
>> +             fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
>> +
>> +             len = HSI2C_FIFO_MAX - fifo_level;
>> +             if (len > (i2c->msg->len - i2c->msg_ptr))
>> +                     len = i2c->msg->len - i2c->msg_ptr;
>> +
>> +             while (len > 0) {
>> +                     byte = i2c->msg->buf[i2c->msg_ptr++];
>> +                     writel(byte, i2c->regs + HSI2C_TX_DATA);
>> +                     len--;
>> +             }
>> +             i2c->state = 0;
>> +     }
>> +
>> + stop:
>> +     if ((i2c->msg_ptr == i2c->msg->len) || (i2c->state < 0)) {
>> +             writel(0, i2c->regs + HSI2C_INT_ENABLE);
>> +             exynos5_i2c_clr_pend_irq(i2c);
>> +             complete(&i2c->msg_complete);
>> +     } else {
>> +             exynos5_i2c_clr_pend_irq(i2c);
>> +     }
>> +
>> +     spin_unlock_irqrestore(&i2c->lock, flags);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>
> ...
>
>> +static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
>> +                           struct i2c_msg *msgs, int stop)
>> +{
>> +     unsigned long timeout;
>> +     int ret;
>> +
>> +     INIT_COMPLETION(i2c->msg_complete);
>> +
>> +     spin_lock_irq(&i2c->lock);
>> +     i2c->msg = msgs;
>> +     i2c->msg_ptr = 0;
>> +     i2c->trans_done = 0;
>> +
>> +     exynos5_i2c_message_start(i2c, stop);
>> +
>> +     spin_unlock_irq(&i2c->lock);
>> +     timeout = wait_for_completion_timeout(&i2c->msg_complete,
>> +                                           EXYNOS5_I2C_TIMEOUT);
>> +     if (timeout == 0)
>> +             ret = -ETIMEDOUT;
>> +     else
>> +             ret = i2c->state;
>> +
>> +     if (ret < 0) {
>> +             exynos5_i2c_reset(i2c);
>
> Do you really need to reset the core after a failed transaction?
Not needed for every transaction failed. intention is to do it for timeout cases
where the master_busy bit in TRANS_STATUS register won't get cleared.
>
>> +             if (ret == -ETIMEDOUT) {
>> +                     dev_warn(i2c->dev, "%s timeout\n",
>> +                              (msgs->flags & I2C_M_RD) ? "rx" : "tx");
>> +                     return ret;
>> +             } else if (ret == -EAGAIN) {
>> +                     return ret;
>> +             }
>> +     }
>> +
>> +     /*
>> +      * If this is the last message to be transfered (stop == 1)
>> +      * Then check if the bus can be brought back to idle.
>> +      *
>> +      * Return -EBUSY if the bus still busy.
>> +      */
>> +     if (exynos5_i2c_wait_bus_idle(i2c, stop))
>> +             return -EBUSY;
>
> Why do you need this after the transaction?
Spec says we should wait for the master_busy bit be cleared as the
proper transaction complete condition.
Thus, we wait for bus idle. Also, we also do a check for the missed
out trans_done bit.
>
>> +
>> +     /* Return the state as in interrupt routine */
>> +     return ret;
>> +}
>> +
>> +static int exynos5_i2c_xfer(struct i2c_adapter *adap,
>> +                     struct i2c_msg *msgs, int num)
>> +{
>> +     struct exynos5_i2c *i2c = (struct exynos5_i2c *)adap->algo_data;
>> +     int i = 0, ret = 0, stop = 0;
>> +
>> +     if (i2c->suspended) {
>> +             dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
>> +             return -EIO;
>> +     }
>> +
>> +     clk_prepare_enable(i2c->clk);
>> +
>> +     for (i = 0; i < num; i++) {
>> +             stop = (i == num - 1);
>> +
>> +             if (msgs->len == 0) {
>
> Did you need that? It shouldn't happen since you are not advertising
> SMBUS_QUICK.
Will remove this
>
>> +                     msgs++;
>> +                     continue;
>> +             }
>> +
>> +             ret = exynos5_i2c_xfer_msg(i2c, msgs, stop);
>> +             if (!stop)
>> +                     msgs++;
>
> Probably better put in the for-body (i.e. i++, msgs++).
thanks
>
>> +
>> +             if (ret < 0)
>> +                     goto out;
>> +     }
>> +
>> +     if (i == num) {
>> +             ret = num;
>> +     } else {
>> +             /* Only one message, cannot access the device */
>> +             if (i == 1)
>> +                     ret = -EREMOTEIO;
>> +             else
>> +                     ret = i;
>> +
>> +             dev_warn(i2c->dev, "xfer message failed\n");
>> +     }
>> +
>> + out:
>> +     clk_disable_unprepare(i2c->clk);
>> +     return ret;
>> +}
>> +
>> +static u32 exynos5_i2c_func(struct i2c_adapter *adap)
>> +{
>> +     return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
>> +}
>> +
>> +static const struct i2c_algorithm exynos5_i2c_algorithm = {
>> +     .master_xfer            = exynos5_i2c_xfer,
>> +     .functionality          = exynos5_i2c_func,
>> +};
>> +
>> +static int exynos5_i2c_probe(struct platform_device *pdev)
>> +{
>> +     struct device_node *np = pdev->dev.of_node;
>> +     struct exynos5_i2c *i2c;
>> +     struct resource *mem;
>> +     unsigned int op_clock;
>> +     int ret;
>> +
>> +     if (!np) {
>> +             dev_err(&pdev->dev, "no device node\n");
>> +             return -ENOENT;
>> +     }
>
> How should this happen?
Taken from legacy code, will remove.
>
>> +
>> +     i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
>> +     if (!i2c) {
>> +             dev_err(&pdev->dev, "no memory for state\n");
>> +             return -ENOMEM;
>> +     }
>> +
>
> ...
>
>> +     i2c->adap.nr = -1;
>> +     ret = i2c_add_numbered_adapter(&i2c->adap);
>
> Just use i2c_add_adapter and skip setting nr to -1.
Will do.
>
> ...
>
>> +static const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
>> +     .suspend_noirq = exynos5_i2c_suspend_noirq,
>> +     .resume_noirq   = exynos5_i2c_resume_noirq,
>> +};
>> +
>> +#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
>> +#else
>> +#define EXYNOS5_DEV_PM_OPS NULL
>> +#endif
>
> Isn't there a macro for this? SIMPLE_DEV_PM_OPS*? Not sure, I always mix
> them up...
You are right, will modify.
>
> Regards,
>
>    Wolfram
>
Sorry for the very delayed response.
Will submit the next version.
Thanks for your review and time.

-- 
Shine bright,
(: Nav :)
