Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaCNIdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:33:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20295 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaCNIdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:33:40 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-92-5322bee17af4
Message-id: <5322BEDF.4080408@samsung.com>
Date: Fri, 14 Mar 2014 09:33:35 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 2/4] mfd: max8997: handle IRQs using regmap
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-3-git-send-email-r.baldyga@samsung.com>
 <53218C30.9000707@samsung.com>
In-reply-to: <53218C30.9000707@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xy7oP9ykFG9x4wm6x5OJVdoupD5+w
	WRzdOZHJ4vqX56wWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF
	1jfrGC3WHrnLbnG7cQWbxbW9x5ktdu96ymqxv7OD0eJ0N6uDsMfOWXfZPfZMPMnmsXmFlsem
	VZ1sHneu7WHzmHcy0GPP/B+sHn1bVjF6TJ/3k8nj8yY5j/VbtjIFcEdx2aSk5mSWpRbp2yVw
	ZVzp6GIseMhfcWpmN1sD4z2eLkZODgkBE4lHP4+yQthiEhfurWfrYuTiEBJYyiixe/cmsISQ
	wEdGiU9/rEBsXgEtiUePPoPFWQRUJT7dWswIYrMJ6Ehs+T4BzBYViJCYO3EzG0S9oMSPyfdY
	QGwRAQ2JmX+vgNUwCxxllnjfIAdiCws4STx818MEsXgeo8TdU4fAmjkFtCUmz/gA1aAjsb91
	GhuELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJi
	8usOxqXHrA4xCnAwKvHwzjiqGCzEmlhWXJl7iFGCg1lJhJdhnlKwEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsbIlWrL4vX4/fwfKAT2n6q5pr/20dGy7rCDxiFJV468LX8fPeMD27+P71ZeEI1e
	ffky76+g8/v47cqEz6jkCCScmtdpci1t1oaDE2s6pqaXbi6q2en8uPBiR/oDwYk7pYUVbmru
	rN903cVSn6edLbN0X7ad/v/Ql1N3ySs+spv502/tbr+0/nAlluKMREMt5qLiRABmgyzlpwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 11:45 AM, Chanwoo Choi wrote:
> Hi Robert,
> 
> On 03/13/2014 06:38 PM, Robert Baldyga wrote:
>> This patch modifies mfd driver to use regmap for handling interrupts.
>> It allows to simplify irq handling process. This modifications needed
>> to make small changes in function drivers, which use interrupts.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

(...)

>> @@ -468,8 +560,11 @@ static int max8997_suspend(struct device *dev)
>>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>>  	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>>  
>> -	if (device_may_wakeup(dev))
>> -		irq_set_irq_wake(max8997->irq, 1);
>> +	if (device_may_wakeup(dev)) {
>> +		enable_irq_wake(max8997->irq);
>> +		disable_irq(max8997->irq);
> 
> irq_set_irq_wake() is same as enable_irq_wake().

It's more intuitive name and makes code reading easier.

> Why is it necessary for disable_irq(max8997->irq)?

It's because we don't want to get interrupts before i2c controller will
be ready. So we disable irq in drivers suspend, and enable in resume.

If some iqr will come before enable_irq() call, it will be noticed, and
IRQ_PENDING flag will be set. In this case irq will be handled
immediately after enable_irq() call.

In previous version there was call of max8997_irq_resume() in resume
function, which caused forced interrupt handling, which has similar effect.

> 
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -478,9 +573,12 @@ static int max8997_resume(struct device *dev)
>>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>>  	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
>>  
>> -	if (device_may_wakeup(dev))
>> -		irq_set_irq_wake(max8997->irq, 0);
>> -	return max8997_irq_resume(max8997);
>> +	if (device_may_wakeup(dev)) {
>> +		disable_irq_wake(max8997->irq);
>> +		enable_irq(max8997->irq);
> 
> ditto.
> 
>> +	}
>> +
>> +	return 0;
>>  }
>>  

Thanks,
Robert Baldyga
