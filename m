Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaLARWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:22:36 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:58857 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaLARWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:22:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Dec 2014 18:24:37 +0100
From: Stefan Agner <stefan@agner.ch>
To: Mark Rutland <mark.rutland@arm.com>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net,
        arnd@arndb.de, sre@kernel.org, fkan@apm.com, grant.likely@linaro.org,
        robh+dt@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
In-Reply-To: <20141201171126.GB22708@leverpostej>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
 <1417453389-1588-2-git-send-email-stefan@agner.ch>
 <20141201171126.GB22708@leverpostej>
Message-ID: <e5c5a44c84b95c4e48ed01c4dcffd35a@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Dec  1 18:22:00 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547ca3b812819456611258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-01 18:11, Mark Rutland wrote:
> On Mon, Dec 01, 2014 at 05:03:07PM +0000, Stefan Agner wrote:
>> This patch adds an optional property which allows to specify the
>> reset source priority. This priority is used by the kernel restart
>> handler call chain to sort out the proper reset/restart method.
>> Depending on the power design of a board or other machine/board
>> specific peculiarity, it is not possible to pick a generic priority.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  Documentation/devicetree/bindings/power/reset/syscon-reboot.txt | 3 +++
>>  drivers/power/reset/syscon-reboot.c                             | 5 ++++-
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> index 1190631..ee41d9c 100644
>> --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> @@ -11,6 +11,9 @@ Required properties:
>>  - offset: offset in the register map for the reboot register (in bytes)
>>  - mask: the reset value written to the reboot register (32 bit access)
>>
>> +Optional properties:
>> +- priority: define the priority of the reset (0-255, defaults to 128)
>> +
> 
> NAK. This is a leak of Linux-internal details.
> 
> What is this necessary for?
> 
> Mark.

Hi Mark,

In my case, it is necessary to be called ahead of the watchdog, which
has a priority of 128. This syscon-reboot driver currently has a default
priority of 128 too. I could live with a higher default priority for the
syscon-reboot driver, in fact I proposed that in the discussion of v1 of
that patch:
https://lkml.org/lkml/2014/11/28/484

IMHO, this priority might make sense for most cases, I guess that
dedicated "syscon" capabilities are usually better suited as a reboot
source than watchdog.

If dt, then the question which arises: If there are different
capabilities to reset/reboot a whole system, how do we reflect which is
the best suited one in dt?

--
Stefan

> 
>>  Default will be little endian mode, 32 bit access only.
>>
>>  Examples:
>> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
>> index 815b901..3060d6b 100644
>> --- a/drivers/power/reset/syscon-reboot.c
>> +++ b/drivers/power/reset/syscon-reboot.c
>> @@ -67,8 +67,11 @@ static int syscon_reboot_probe(struct platform_device *pdev)
>>  	if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
>>  		return -EINVAL;
>>
>> -	ctx->restart_handler.notifier_call = syscon_restart_handle;
>>  	ctx->restart_handler.priority = 128;
>> +	of_property_read_u32(pdev->dev.of_node, "priority",
>> +			     &ctx->restart_handler.priority);
>> +
>> +	ctx->restart_handler.notifier_call = syscon_restart_handle;
>>  	err = register_restart_handler(&ctx->restart_handler);
>>  	if (err)
>>  		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
>> --
>> 2.1.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

