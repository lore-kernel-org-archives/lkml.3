Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaLBQQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:16:45 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56339 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaLBQQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:16:44 -0500
Message-ID: <547DE5A4.4010506@gmail.com>
Date: Tue, 02 Dec 2014 18:15:32 +0200
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>, Borislav Petkov <bp@alien8.de>
CC: Giedrius Statkevicius <giedriuswork@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH] platform: x86: hp_wireless: Inform the user if hp_wireless_input_setup()/add()
 fails
References: <1417212867-25187-1-git-send-email-giedriuswork@gmail.com> <20141128231555.GA31468@pd.tnic> <547909CF.8060907@gmail.com> <20141129000417.GG30997@pd.tnic> <20141125225719.GA32102@vmdeb7>
In-Reply-To: <20141125225719.GA32102@vmdeb7>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.11.26 00:57, Darren Hart wrote:
> On Sat, Nov 29, 2014 at 01:04:17AM +0100, Borislav Petkov wrote:
>> On Sat, Nov 29, 2014 at 01:48:31AM +0200, Giedrius Statkevicius wrote:
>>> On 2014.11.29 01:15, Borislav Petkov wrote:
>>>> On Sat, Nov 29, 2014 at 12:14:27AM +0200, Giedrius Statkevicius wrote:
>>>>> In hpwl_add() there is a unused variable err to which we assign the
>>>>> result of hp_wireless_input_setup() but we don't do anything depending
>>>>> on the result so print out a message that informs the user if add()
>>>>> (hp_wireless_input_setup()) fails since acpi_device_probe() doesn't
>>>>> print anything in this case.
>>>>>
>>>>> Signed-off-by: Giedrius Statkevicius <giedriuswork@gmail.com>
>>>>> ---
>>>>>  drivers/platform/x86/hp-wireless.c | 3 +++
>>>>>  1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
>>>>> index 415348f..4e4cc8b 100644
>>>>> --- a/drivers/platform/x86/hp-wireless.c
>>>>> +++ b/drivers/platform/x86/hp-wireless.c
>>>>> @@ -85,6 +85,9 @@ static int hpwl_add(struct acpi_device *device)
>>>>>  	int err;
>>>>>  
>>>>>  	err = hp_wireless_input_setup();
>>>>> +	if (err)
>>>>> +		pr_err("Failed to setup hp wireless hotkeys\n");
>>>>> +
>>>>
>>>> I don't think there's need for that. Just do:
>>>>
>>>> 	return hp_wireless_input_setup();
>>>>
>>>> and drop err completely.
>>>>
>>>> The upper layer which calls the ->add() method should propagate the
>>>> error properly.
> 
> This is the key. If the caller already prints a message, we don't need to. If
> nothing is displayed and the user would be left confused, then an appropriate
> message should be displayed.
> 
> If the upper level already handles this, then we can just drop the unused
> variable.
> 
> Have a look and decide which is the most appropriate. And thanks for preparing a
> fix.
> 
To start with I've looked at all modules in drivers/platform/x86 that
have a struct acpi_driver and calculated some statistics about
whether the module informs the user if add() fails or not to find out
the current policy on whether we should inform the user or not:

Module             Does it use any pr_/dev_ function to give info?
asus-laptop        Yes
classmate-laptop   No
dell-smo8800       Yes
dell-wireless      No
eeepc-laptop       Yes
fujitsu-laptop     Yes
hp-wireless        No
hp_accel           Yes
intel-rst          No
intel-smartconnect Yes
intel_menlow       No
panasonic-laptop   No (but it uses ACPI_DEBUG_PRINT)
pvpanic            No
sony-laptop        Yes (has a message for failing to setup input devices)
topstar-laptop     No
toshiba_acpi       Yes
toshiba_haps       Yes
toshiba_bluetooth  Yes
wmi                Yes
xo15-ebook         Yes

That being said it looks like most add()s inform the user. So maybe we
should make a patch that does it for other modules with struct
acpi_driver? That being said, I've also took a look at if any messages
are printed out about add() failing.

There is acpi_device_probe() that's hooked into acpi_bus_type which
defines names and some actions of a bus. There it simply returns any
non-zero value:

990         ret = acpi_drv->ops.add(acpi_dev);
991         if (ret)
992                 return ret;

Delving a bit deeper I've found about driver_probe_device() and
really_probe(). And in these lines I think is what the user would get if
the probe failed:

330         } else if (ret != -ENODEV && ret != -ENXIO) {
331                 /* driver matched but the probe failed */
332                 printk(KERN_WARNING
333                        "%s: probe of %s failed with error %d\n",
334                        drv->name, dev_name(dev), ret);

So the user would get only the numerical value of a error and thus a
pr_err or printing any other message in the add() is useful to make more
sense of what really happened and allow to quickly find where the issue
happened. In the end I think that this patch is better than the last one
(the one where add() simply returns the result of another function).

Please correct me if I'm wrong.

Thanks,
Giedrius
