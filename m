Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaLAR1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:27:40 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:58896 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaLAR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:27:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Dec 2014 18:29:43 +0100
From: Stefan Agner <stefan@agner.ch>
To: Feng Kan <fkan@apm.com>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        sre@kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
In-Reply-To: <CAL85gmBq30pWxP0buKbM8so6QqsJq2YojiSK1EWtMPsH_7foeg@mail.gmail.com>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
 <1417453389-1588-2-git-send-email-stefan@agner.ch>
 <CAL85gmBq30pWxP0buKbM8so6QqsJq2YojiSK1EWtMPsH_7foeg@mail.gmail.com>
Message-ID: <ea4f7a2bfdb9bea45cab9418c211083b@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec  1 18:27:06 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547ca4ea12811690598992
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-01 18:15, Feng Kan wrote:
> On Mon, Dec 1, 2014 at 9:03 AM, Stefan Agner <stefan@agner.ch> wrote:
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
>>  Default will be little endian mode, 32 bit access only.
>>
>>  Examples:
>> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
>> index 815b901..3060d6b 100644
>> --- a/drivers/power/reset/syscon-reboot.c
>> +++ b/drivers/power/reset/syscon-reboot.c
>> @@ -67,8 +67,11 @@ static int syscon_reboot_probe(struct platform_device *pdev)
>>         if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
>>                 return -EINVAL;
>>
>> -       ctx->restart_handler.notifier_call = syscon_restart_handle;
>>         ctx->restart_handler.priority = 128;
>> +       of_property_read_u32(pdev->dev.of_node, "priority",
>> +                            &ctx->restart_handler.priority);
> 
> What is this for?

What do you mean? The moved line "ctx->restart_handler.notifier_call =
syscon_restart_handle;"? When one reads the diff, it looks like that
line was moved, in fact I tried to keep the of_property_read function
calls together. But I had to move the assignation of the default
priority in front of restart_handler.priority. That's what is the
outcome...

--
Stefan

>> +
>> +       ctx->restart_handler.notifier_call = syscon_restart_handle;
>>         err = register_restart_handler(&ctx->restart_handler);
>>         if (err)
>>                 dev_err(dev, "can't register restart notifier (err=%d)\n", err);
>> --
>> 2.1.3
>>

