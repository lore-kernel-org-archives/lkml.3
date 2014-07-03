Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbaGCHci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:32:38 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39552 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaGCHcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:32:35 -0400
Date: Thu, 3 Jul 2014 08:32:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        dmitry.torokhov@gmail.com, sameo@linux.intel.com, geert@linux-m68k.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/10] mfd: cros_ec: move EC interrupt to cros_ec_keyb
Message-ID: <20140703073228.GH30534@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-11-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-11-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Andrew Bresticker <abrestic@chromium.org>
> 
> If we receive EC interrupts after the cros_ec driver has probed, but
> before the cros_ec_keyb driver has probed, the cros_ec IRQ handler
> will not run the cros_ec_keyb notifier and the EC will leave the IRQ
> line asserted.  The cros_ec IRQ handler then returns IRQ_HANDLED and
> the resulting flood of interrupts causes the machine to hang.
> 
> Since the EC interrupt is currently only used for the keyboard, move
> the setup and handling of the EC interrupt to the cros_ec_keyb driver.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - IRQs should be optional => move EC interrupt to keyboard.
> 
>  drivers/input/keyboard/cros_ec_keyb.c | 58 ++++++++++++++++++++---------------
>  drivers/mfd/cros_ec.c                 | 35 +--------------------
>  include/linux/mfd/cros_ec.h           |  2 --
>  3 files changed, 34 insertions(+), 61 deletions(-)

Patch applied with Simon's Reviewed-by.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

> diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
> index b8341ab..791781a 100644
> --- a/drivers/input/keyboard/cros_ec_keyb.c
> +++ b/drivers/input/keyboard/cros_ec_keyb.c
> @@ -24,8 +24,8 @@
>  #include <linux/module.h>
>  #include <linux/i2c.h>
>  #include <linux/input.h>
> +#include <linux/interrupt.h>
>  #include <linux/kernel.h>
> -#include <linux/notifier.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/input/matrix_keypad.h>
> @@ -42,7 +42,6 @@
>   * @dev: Device pointer
>   * @idev: Input device
>   * @ec: Top level ChromeOS device to use to talk to EC
> - * @event_notifier: interrupt event notifier for transport devices
>   */
>  struct cros_ec_keyb {
>  	unsigned int rows;
> @@ -55,7 +54,6 @@ struct cros_ec_keyb {
>  	struct device *dev;
>  	struct input_dev *idev;
>  	struct cros_ec_device *ec;
> -	struct notifier_block notifier;
>  };
>  
>  
> @@ -173,22 +171,6 @@ static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
>  	input_sync(ckdev->idev);
>  }
>  
> -static int cros_ec_keyb_open(struct input_dev *dev)
> -{
> -	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
> -
> -	return blocking_notifier_chain_register(&ckdev->ec->event_notifier,
> -						&ckdev->notifier);
> -}
> -
> -static void cros_ec_keyb_close(struct input_dev *dev)
> -{
> -	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
> -
> -	blocking_notifier_chain_unregister(&ckdev->ec->event_notifier,
> -					   &ckdev->notifier);
> -}
> -
>  static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
>  {
>  	struct cros_ec_command msg = {
> @@ -203,19 +185,41 @@ static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
>  	return ckdev->ec->cmd_xfer(ckdev->ec, &msg);
>  }
>  
> -static int cros_ec_keyb_work(struct notifier_block *nb,
> -		     unsigned long state, void *_notify)
> +static irqreturn_t cros_ec_keyb_irq(int irq, void *data)
>  {
> +	struct cros_ec_keyb *ckdev = data;
> +	struct cros_ec_device *ec = ckdev->ec;
>  	int ret;
> -	struct cros_ec_keyb *ckdev = container_of(nb, struct cros_ec_keyb,
> -						    notifier);
>  	uint8_t kb_state[ckdev->cols];
>  
> +	if (device_may_wakeup(ec->dev))
> +		pm_wakeup_event(ec->dev, 0);
> +
>  	ret = cros_ec_keyb_get_state(ckdev, kb_state);
>  	if (ret >= 0)
>  		cros_ec_keyb_process(ckdev, kb_state, ret);
> +	else
> +		dev_err(ec->dev, "failed to get keyboard state: %d\n", ret);
>  
> -	return NOTIFY_DONE;
> +	return IRQ_HANDLED;
> +}
> +
> +static int cros_ec_keyb_open(struct input_dev *dev)
> +{
> +	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
> +	struct cros_ec_device *ec = ckdev->ec;
> +
> +	return request_threaded_irq(ec->irq, NULL, cros_ec_keyb_irq,
> +					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +					"cros_ec_keyb", ckdev);
> +}
> +
> +static void cros_ec_keyb_close(struct input_dev *dev)
> +{
> +	struct cros_ec_keyb *ckdev = input_get_drvdata(dev);
> +	struct cros_ec_device *ec = ckdev->ec;
> +
> +	free_irq(ec->irq, ckdev);
>  }
>  
>  static int cros_ec_keyb_probe(struct platform_device *pdev)
> @@ -246,8 +250,12 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
>  	if (!idev)
>  		return -ENOMEM;
>  
> +	if (!ec->irq) {
> +		dev_err(dev, "no EC IRQ specified\n");
> +		return -EINVAL;
> +	}
> +
>  	ckdev->ec = ec;
> -	ckdev->notifier.notifier_call = cros_ec_keyb_work;
>  	ckdev->dev = dev;
>  	dev_set_drvdata(&pdev->dev, ckdev);
>  
> diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
> index 83e30c6..4873f9c 100644
> --- a/drivers/mfd/cros_ec.c
> +++ b/drivers/mfd/cros_ec.c
> @@ -62,18 +62,6 @@ int cros_ec_check_result(struct cros_ec_device *ec_dev,
>  }
>  EXPORT_SYMBOL(cros_ec_check_result);
>  
> -static irqreturn_t ec_irq_thread(int irq, void *data)
> -{
> -	struct cros_ec_device *ec_dev = data;
> -
> -	if (device_may_wakeup(ec_dev->dev))
> -		pm_wakeup_event(ec_dev->dev, 0);
> -
> -	blocking_notifier_call_chain(&ec_dev->event_notifier, 1, ec_dev);
> -
> -	return IRQ_HANDLED;
> -}
> -
>  static const struct mfd_cell cros_devs[] = {
>  	{
>  		.name = "cros-ec-keyb",
> @@ -92,8 +80,6 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
>  	struct device *dev = ec_dev->dev;
>  	int err = 0;
>  
> -	BLOCKING_INIT_NOTIFIER_HEAD(&ec_dev->event_notifier);
> -
>  	if (ec_dev->din_size) {
>  		ec_dev->din = devm_kzalloc(dev, ec_dev->din_size, GFP_KERNEL);
>  		if (!ec_dev->din)
> @@ -105,42 +91,23 @@ int cros_ec_register(struct cros_ec_device *ec_dev)
>  			return -ENOMEM;
>  	}
>  
> -	if (!ec_dev->irq) {
> -		dev_dbg(dev, "no valid IRQ: %d\n", ec_dev->irq);
> -		return err;
> -	}
> -
> -	err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
> -				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> -				   "chromeos-ec", ec_dev);
> -	if (err) {
> -		dev_err(dev, "request irq %d: error %d\n", ec_dev->irq, err);
> -		return err;
> -	}
> -
>  	err = mfd_add_devices(dev, 0, cros_devs,
>  			      ARRAY_SIZE(cros_devs),
>  			      NULL, ec_dev->irq, NULL);
>  	if (err) {
>  		dev_err(dev, "failed to add mfd devices\n");
> -		goto fail_mfd;
> +		return err;
>  	}
>  
>  	dev_info(dev, "Chrome EC device registered\n");
>  
>  	return 0;
> -
> -fail_mfd:
> -	free_irq(ec_dev->irq, ec_dev);
> -
> -	return err;
>  }
>  EXPORT_SYMBOL(cros_ec_register);
>  
>  int cros_ec_remove(struct cros_ec_device *ec_dev)
>  {
>  	mfd_remove_devices(ec_dev->dev);
> -	free_irq(ec_dev->irq, ec_dev);
>  
>  	return 0;
>  }
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 0ebf26f..fcbe9d1 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -62,7 +62,6 @@ struct cros_ec_command {
>   * @dev: Device pointer
>   * @was_wake_device: true if this device was set to wake the system from
>   * sleep at the last suspend
> - * @event_notifier: interrupt event notifier for transport devices
>   * @cmd_xfer: send command to EC and get response
>   *     Returns the number of bytes received if the communication succeeded, but
>   *     that doesn't mean the EC was happy with the command. The caller
> @@ -93,7 +92,6 @@ struct cros_ec_device {
>  	struct device *dev;
>  	bool was_wake_device;
>  	struct class *cros_class;
> -	struct blocking_notifier_head event_notifier;
>  	int (*cmd_xfer)(struct cros_ec_device *ec,
>  			struct cros_ec_command *msg);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
