Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaJGIP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:15:58 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:55267 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaJGIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:15:49 -0400
X-ASG-Debug-ID: 1412669746-0759e748286ac20002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 7 Oct 2014 10:15:45 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Sebastian Reichel <sre@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] power: reset: add LTC2952 poweroff support
Message-ID: <20141007081544.GA25568@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH v3 1/2] power: reset: add LTC2952 poweroff support
References: <1412584836-27677-1-git-send-email-frans.klaver@xsens.com>
 <1412584836-27677-2-git-send-email-frans.klaver@xsens.com>
 <20141006213210.GA11926@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141006213210.GA11926@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1412669746
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10289
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 02:32:10PM -0700, Guenter Roeck wrote:
> On Mon, Oct 06, 2014 at 10:40:35AM +0200, Frans Klaver wrote:
> > + * - kill (output)
> > + *     The last action during shut down is triggering this signalling, such
> > + *     that the PowerPath Control will power down the hardware.
> > + *
> 
> poweroff might be a better name.

Kill is the name used in the data sheet, but fair enough, poweroff does
describe the function better.


> > +static int ltc2952_poweroff_suspend(struct platform_device *pdev,
> > +				    pm_message_t state)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> > +static int ltc2952_poweroff_resume(struct platform_device *pdev)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> What is the value of those functions if they don't do anything but return an
> error ?

This is because of a passage in Documentation/SubmittingDrivers on PM
support:

  ... it should support basic power management by implementing, if
  necessary, the .suspend and .resume methods used during the
  system-wide suspend and resume transitions.  You should verify that
  your driver correctly handles the suspend and resume, but if you are
  unable to ensure that, please at least define the .suspend method
  returning the -ENOSYS ("Function not implemented") error.

I'm not sure what the actual difference is between doing this and just
not implementing them. I frankly don't care if they stay or go.


> > +static void ltc2952_poweroff_default(struct ltc2952_poweroff_data *data)
> > +{
> > +	data->wde_interval = ktime_set(0, 300L*1E6L);
> > +	data->trigger_delay = ktime_set(2, 500L*1E6L);
> > +
> > +	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > +	data->timer_trigger.function = &ltc2952_poweroff_timer_trigger;
> > +
> > +	hrtimer_init(&data->timer_wde, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > +	data->timer_wde.function = &ltc2952_poweroff_timer_wde;
> > +}
> > +
> > +static int ltc2952_poweroff_init(struct platform_device *pdev)
> > +{
> > +	int ret;
> > +
> > +	ltc2952_poweroff_default(ltc2952_data);
> > +
> > +	ltc2952_data->gpio_watchdog = gpiod_get(&pdev->dev, "watchdog");
> 
> Any reason for not using devm_gpiod_get() for those functions ?

René said in the first review round:

> > >  devm_* functions do not seem to common to me and are sparsely
> > >  documented, therefore I preferred the regular functions. This
> > >  error jump should go to err_io and the clean-up loop must check
> > >  if the gpio entry is actually filled in

I now unrolled these loops, and quite frankly I'm not that sure devm_*
functions are actually that sparsely used. The way to get around that is
to use them more. I'll see about using those instead, maybe add some
documentation as well.


> > +	if (IS_ERR(ltc2952_data->gpio_watchdog)) {
> > +		ret = PTR_ERR(ltc2952_data->gpio_watchdog);
> > +		dev_err(&pdev->dev, "unable to claim watchdog-gpio\n");
> > +		goto err;
> 
> Unnecessary goto. Just return the ERR_PTR directly.

Check.


> > +	ltc2952_data->gpio_trigger = gpiod_get(&pdev->dev, "trigger");
> > +	if (IS_ERR(ltc2952_data->gpio_trigger)) {
> > +		ret = PTR_ERR(ltc2952_data->gpio_trigger);
> > +
> > +		if (ret != -ENOENT) {
> > +			dev_err(&pdev->dev, "unable to claim trigger-gpio\n");
> > +			goto err_kill;
> > +		}
> > +
> > +		dev_info(&pdev->dev, "No trigger input defined\n");
> > +		ltc2952_data->gpio_trigger = NULL;
> > +		ltc2952_poweroff_start_wde();
> 
> Can you explain this in more detail ? It is not entirely clear (at least not
> to me) why you start the timer in this case.

The ltc2952 is designed around pushing a button for a configurable
length of time to trigger the powerdown. If we don't have the powerdown
trigger, we don't know when this happens. To be certain that the system
won't be powered down without us knowing about it, we have to start the
watchdog. If the ltc2952 gets into shutdown state, at least we know for
sure that the system will be kept alive. This is basically a way to
ignore the powerdown sequence imposed by the ltc2952.

I guess it could do with some explanation in the code.

 
> > +		return 0;
> > +	}
> > +
> > +	ltc2952_data->virq = gpiod_to_irq(ltc2952_data->gpio_trigger);
> > +	if (ltc2952_data->virq < 0) {
> > +		dev_err(&pdev->dev, "cannot map GPIO as interrupt");
> > +		goto err_trigger;
> > +	}
> > +
> > +	ret = request_irq(ltc2952_data->virq,
> > +			  ltc2952_poweroff_handler,
> > +			  (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
> > +			  "ltc2952-poweroff",
> > +			  ltc2952_data);
> 
> Why not devm_request_irq ?
> 
> Overall, seems to me that using devm_ functions would simplify error cleanup
> and removal code significantly.

Refer to devm_gpiod_get()


> > +	if (ret) {
> > +		dev_err(&pdev->dev, "cannot configure an interrupt handler\n");
> > +		goto err_trigger;
> 
> Wouldn't those cases be logically identical to the "have no trigger" case ?
> Maybe not, but poweroff would presumably still work, and it is not entirely
> clear to me why you would refuse to power off the system if triggered by the
> "poweroff" command just because you failed to install an interrupt handler
> for the trigger button.

I think the reasoning was that once the gpio trigger is there, you
really want to respond to the interrupt. You're right though. We
shouldn't completely fail this function in this case and the poweroff
driver should just fall back to the no-gpio-trigger case.


> > +	}
> > +	return 0;
> > +
> > +err_trigger:
> > +	gpiod_put(ltc2952_data->gpio_trigger);
> > +err_kill:
> > +	gpiod_put(ltc2952_data->gpio_kill);
> > +err_watchdog:
> > +	gpiod_put(ltc2952_data->gpio_watchdog);
> > +err:
> > +	return ret;
> > +}
> > +
> > +static int ltc2952_poweroff_probe(struct platform_device *pdev)
> > +{
> > +	int ret;
> > +
> > +	if (pm_power_off) {
> > +		dev_err(&pdev->dev, "pm_power_off already registered");
> > +		return -EBUSY;
> > +	}
> > +
> > +	ltc2952_data = kzalloc(sizeof(*ltc2952_data), GFP_KERNEL);
> 
> Why not devm_kzalloc ?

See devm_gpiod_get() above.


> > +	if (!ltc2952_data)
> > +		return -ENOMEM;
> > +
> > +	ltc2952_data->dev = &pdev->dev;
> > +
> > +	ret = ltc2952_poweroff_init(pdev);
> > +	if (ret)
> > +		goto err;
> > +
> > +	pm_power_off = &ltc2952_poweroff_kill;
> 
> That '&' is unnecessary.

ooh, a c++ism...

Somewhat off-topic: In the next round I think I'll add a patch that will
use your new poweroff handler api. I like that approach better.


> > +static struct platform_driver ltc2952_poweroff_driver = {
> > +	.probe = ltc2952_poweroff_probe,
> > +	.remove = ltc2952_poweroff_remove,
> > +	.driver = {
> > +		.name = "ltc2952-poweroff",
> > +		.owner = THIS_MODULE,
> > +		.of_match_table = of_ltc2952_poweroff_match,
> > +	},
> > +	.suspend = ltc2952_poweroff_suspend,
> > +	.resume = ltc2952_poweroff_resume,
> 
> I think you are supposed to put the suspend and resume calls into the driver
> structure. The platform code names the callbacks here 'legacy'.

I'll check that out.

Thanks for the review,
Frans
