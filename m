Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaB0AUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:20:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54056 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaB0AUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:20:14 -0500
Message-ID: <530E84BD.4010403@codeaurora.org>
Date: Wed, 26 Feb 2014 16:20:13 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/9] Input: pmic8xxx-keypad - Migrate to devm_* APIs
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org> <1393441562-685-3-git-send-email-sboyd@codeaurora.org> <20140227000919.GE18563@joshc.qualcomm.com>
In-Reply-To: <20140227000919.GE18563@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/14 16:09, Josh Cartwright wrote:
> On Wed, Feb 26, 2014 at 11:05:55AM -0800, Stephen Boyd wrote:
>> Simplify the error paths and reduce the lines of code in this
>> driver by using the devm_* APIs.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  drivers/input/keyboard/pmic8xxx-keypad.c | 62 +++++++++-----------------------
>>  1 file changed, 17 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
>> index 2c9f19ac35ea..4e6bfbf94ae4 100644
>> --- a/drivers/input/keyboard/pmic8xxx-keypad.c
>> +++ b/drivers/input/keyboard/pmic8xxx-keypad.c
> [..]
>> @@ -634,7 +629,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>>  					kp->keycodes, kp->input);
>>  	if (rc) {
>>  		dev_err(&pdev->dev, "failed to build keymap\n");
>> -		goto err_get_irq;
>> +		return rc;
>>  	}
>>  
>>  	if (pdata->rep)
>> @@ -650,7 +645,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>>  	rc = pmic8xxx_kpd_init(kp);
>>  	if (rc < 0) {
>>  		dev_err(&pdev->dev, "unable to initialize keypad controller\n");
>> -		goto err_get_irq;
>> +		return rc;
>>  	}
>>  
>>  	rc = pmic8xxx_kp_config_gpio(pdata->cols_gpio_start,
>> @@ -667,24 +662,26 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>>  		goto err_gpio_config;
> See below.
>
>>  	}
>>  
>> -	rc = request_any_context_irq(kp->key_sense_irq, pmic8xxx_kp_irq,
>> -				 IRQF_TRIGGER_RISING, "pmic-keypad", kp);
>> +	rc = devm_request_any_context_irq(&pdev->dev, kp->key_sense_irq,
>> +			pmic8xxx_kp_irq, IRQF_TRIGGER_RISING, "pmic-keypad",
>> +			kp);
>>  	if (rc < 0) {
>>  		dev_err(&pdev->dev, "failed to request keypad sense irq\n");
>> -		goto err_get_irq;
>> +		return rc;
>>  	}
>>  
>> -	rc = request_any_context_irq(kp->key_stuck_irq, pmic8xxx_kp_stuck_irq,
>> -				 IRQF_TRIGGER_RISING, "pmic-keypad-stuck", kp);
>> +	rc = devm_request_any_context_irq(&pdev->dev, kp->key_stuck_irq,
>> +			pmic8xxx_kp_stuck_irq, IRQF_TRIGGER_RISING,
>> +			"pmic-keypad-stuck", kp);
>>  	if (rc < 0) {
>>  		dev_err(&pdev->dev, "failed to request keypad stuck irq\n");
>> -		goto err_req_stuck_irq;
>> +		return rc;
>>  	}
>>  
>>  	rc = pmic8xxx_kp_read_u8(kp, &ctrl_val, KEYP_CTRL);
>>  	if (rc < 0) {
>>  		dev_err(&pdev->dev, "failed to read KEYP_CTRL register\n");
>> -		goto err_pmic_reg_read;
>> +		return rc;
>>  	}
>>  
>>  	kp->ctrl_reg = ctrl_val;
>> @@ -692,36 +689,12 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>>  	rc = input_register_device(kp->input);
>>  	if (rc < 0) {
>>  		dev_err(&pdev->dev, "unable to register keypad input device\n");
>> -		goto err_pmic_reg_read;
>> +		return rc;
>>  	}
>>  
>>  	device_init_wakeup(&pdev->dev, pdata->wakeup);
>>  
>>  	return 0;
>> -
>> -err_pmic_reg_read:
>> -	free_irq(kp->key_stuck_irq, kp);
>> -err_req_stuck_irq:
>> -	free_irq(kp->key_sense_irq, kp);
>> -err_gpio_config:
> You're removing this label, even though it's still used above. :(
>

Ah, thanks. Will fix.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

