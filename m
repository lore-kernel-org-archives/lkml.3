Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaJTVi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:38:59 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39996 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753391AbaJTVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:38:57 -0400
Message-ID: <544580ED.3050604@hurleysoftware.com>
Date: Mon, 20 Oct 2014 17:38:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] tty: serial: msm: Fix lock init issue with earlycon
References: <1413551588-14877-1-git-send-email-galak@codeaurora.org> <544553F6.1020409@codeaurora.org>
In-Reply-To: <544553F6.1020409@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 02:27 PM, Stephen Boyd wrote:
> On 10/17/2014 06:13 AM, Kumar Gala wrote:
>> With CONFIG_DEBUG_SPINLOCK enabled we see:
>>
>> BUG: spinlock bad magic on CPU#0, swapper/0
>>   lock: early_console_dev+0x8/0x160, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>> CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-09733-gb446b33-dirty #18
> 
> [...]
> 
>> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
>> index 4b6c783..8ab27c9 100644
>> --- a/drivers/tty/serial/msm_serial.c
>> +++ b/drivers/tty/serial/msm_serial.c
>> @@ -973,6 +973,8 @@ msm_serial_early_console_setup(struct earlycon_device *device, const char *opt)
>>       if (!device->port.membase)
>>           return -ENODEV;
>>   +    spin_lock_init(&device->port.lock);
>> +
>>       device->con->write = msm_serial_early_write;
>>       return 0;
>>   }
>> @@ -995,6 +997,8 @@ msm_serial_early_console_setup_dm(struct earlycon_device *device,
>>       if (!device->port.membase)
>>           return -ENODEV;
>>   +    spin_lock_init(&device->port.lock);
>> +
>>       device->con->write = msm_serial_early_write_dm;
>>       return 0;
>>   }
> 
> Could this be done in the tty core instead?

Or even better: refactor __msm_console_write() so no spin_lock() is required
for the earlycon write.

FWIW, __msm_console_write() is a deadlock-waiting-to_happen since it does
not disable interrupts with spin_lock_irqsave().

Regards,
Peter Hurley
