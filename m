Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3FDLnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:43:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60116 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3FDLni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:43:38 -0400
Message-ID: <51ADD1F8.7070405@ti.com>
Date: Tue, 4 Jun 2013 14:39:36 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Hebbar Gururaja <gururaja.hebbar@ti.com>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, Tony Lindgren <tony@atomide.com>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 11/11] i2c: omap: enhance pinctrl support
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com> <1369995191-20855-12-git-send-email-gururaja.hebbar@ti.com> <87k3mf2gu4.fsf@linaro.org>
In-Reply-To: <87k3mf2gu4.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin, Gururaja

On 05/31/2013 08:34 PM, Kevin Hilman wrote:
> Hebbar Gururaja <gururaja.hebbar@ti.com> writes:
>
>> Amend the I2C omap pin controller to optionally take a pin control
>> handle and set the state of the pins to:
>>
>> - "default" on boot, resume and before performing an i2c transfer
>> - "idle" after initial default, after resume default, and after each
>> i2c xfer
>> - "sleep" on suspend()
>>
>> By optionally putting the pins into sleep state in the suspend callback
>> we can accomplish two things.
>> - One is to minimize current leakage from pins and thus save power,
>> - second, we can prevent the IP from driving pins output in an
>> uncontrolled manner, which may happen if the power domain drops the
>> domain regulator.
>>
>> Note:
>> A .suspend & .resume callback is added which simply puts the pins to sleep
>> state upon suspend & are moved to default & idle state upon resume.
>>
>> If any of the above pin states are missing in dt, a warning message
>> about the missing state is displayed.
>> If certain pin-states are not available, to remove this warning message
>> pass respective state name with null phandler.
>>
>> (Changes based on i2c-nomadik.c)
>>
>> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Wolfram Sang <wsa@the-dreams.de>
>> Cc: linux-omap@vger.kernel.org
>> Cc: linux-i2c@vger.kernel.org
> [...]
>
>> @@ -664,7 +673,13 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>>   
>>   out:
>>   	pm_runtime_mark_last_busy(dev->dev);
>> +
>>   	pm_runtime_put_autosuspend(dev->dev);
>> +	/* Optionally let pins go into idle state */
>> +	if (!IS_ERR(dev->pins_idle))
>> +		if (pinctrl_select_state(dev->pinctrl, dev->pins_idle))
>> +			dev_err(dev->dev, "could not set pins to idle state\n");
> This is wrong.  You're changing the muxing before the device actually
> goes idle.  Anything you want to happen when the device actually idles
> for real has to be in runtime PM callbacks.
>
> Looking below, I see it's already in the callbacks, so why is it here also?

I have two questions regarding this patch & the whole series:

1) PM runtime suspend/resume
Current sequence:
- resume
   |- omap_hwmod_enable()
      |- _enable()
          |- omap_hwmod_mux(oh->mux, _HWMOD_STATE_ENABLED)
             |- enable module (sysc&clocks)
   |- omap_i2c_runtime_resume()
- suspend
   |- omap_i2c_runtime_suspend()
   |- omap_hwmod_idle()
      |- _idle()
          |- disbale module (sysc&clocks)
          |- omap_hwmod_mux(oh->mux, _HWMOD_STATE_IDLE);

The new order will change this sequence - *Is it safe?*:
- resume
   |- omap_hwmod_enable()
      |- _enable()
         |- enable module (sysc&clocks) <---- Is it valid to enable 
module before PINs?
   |- omap_i2c_runtime_resume()
      |- PINs state set to DEFAULT
- suspend
   |- omap_i2c_runtime_suspend()
      |- PINs state set to IDLE
   |- omap_hwmod_idle()
      |- _idle()
          |- disbale module (sysc&clocks) <---- Is it valid to disable 
module after PINs?

2) System suspend (OFF-mode) with assumption that "noirq" stage will be 
used for PINs cfg
Current implementation: handled in the same way as PM runtime


The new implementation:   -- total mess is here((:
- suspend_noirq - I2C device can be still active because of PM auto-suspend
   |-_od_suspend_noirq
      |- omap_i2c_suspend_noirq
         |- PINs state set to SLEEP
   |- pm_generic_runtime_suspend
      |- omap_i2c_runtime_suspend()
         |- PINs state set to IDLE  <--- *oops* PINs state is IDLE and 
not SLEEP
   |- omap_device_idle()
      |- omap_hwmod_idle()
         |- _idle()
            |- disbale module (sysc&clocks)

- resume_noirq - I2C was active before suspend
   |-_od_resume_noirq
      |- omap_hwmod_enable()
         |- _enable()
            |- enable module (sysc&clocks)
      |- pm_generic_runtime_resume
         |- omap_i2c_runtime_resume()
            |- PINs state set to DEFAULT  <--- !!!!
      |- omap_i2c_resume_noirq
         |- PINs state set to DEFAULT
         |- PINs state set to IDLE        <--- *big oops* we have active 
module and its
                                               PINs state is IDLE

All mentioned above, applicable for most of all patches in series.
And It seems, that this functionality can't be implemented in such way (
- OMAP device FW and Driver core might handle PINs states changing and
   drivers (DT) should provide set of available states only.

Am I wrong?

Regards,
-grygorii


>
> [...]
>
>> @@ -1300,6 +1348,10 @@ static int omap_i2c_runtime_suspend(struct device *dev)
>>   		omap_i2c_read_reg(_dev, OMAP_I2C_STAT_REG);
>>   	}
>>   
>> +	if (!IS_ERR(_dev->pins_idle))
>> +		if (pinctrl_select_state(_dev->pinctrl, _dev->pins_idle))
>> +			dev_err(dev, "could not set pins to idle state\n");
>> +
>>   	return 0;
>>   }
>>   
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

