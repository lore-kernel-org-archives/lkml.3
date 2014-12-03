Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaLCQKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:10:15 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:53341 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaLCQKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:10:12 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6s-dKRtwjBhVE2d1L-qOYX_71hQOT9svu4m_+kDZESPaw@mail.gmail.com>
References: <CAL8zT=iXizKqJjWDcLT-chZ7=ioPYtQcB4GeqZpiL7kCpGOKZw@mail.gmail.com>
 <CACxGe6sRULEmOvdxFvR=Mcbf4Cgd3YijrJg1q9Uz1vgYw5tG+w@mail.gmail.com>
 <CAL8zT=geUOJnmUHvqyYk651U+HF3NSy3XU7hiWUn3gPX0sVjPg@mail.gmail.com>
 <CACxGe6skTZDe40eJN06BDapfKuN-KzMqgbEWNyLiTeXTt5dw5g@mail.gmail.com>
 <CAOMZO5AmA5-Ji6SDUv6b3qrhSi-KvSNYDV=ZaL7HoOhh-6SnsA@mail.gmail.com> <CACxGe6s-dKRtwjBhVE2d1L-qOYX_71hQOT9svu4m_+kDZESPaw@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 3 Dec 2014 17:09:56 +0100
X-Google-Sender-Auth: ZiOmi6qOMFVlr4YHQXufP7zxgxc
Message-ID: <CAL8zT=jF4CtvTqTQWvZUFuZKOdgjGXFr-T-jRxZ9khPN0ykeSA@mail.gmail.com>
Subject: Re: DT parsing : duplicate name error
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Fabio Estevam <festevam@gmail.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bryan Wu <cooloney@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-03 17:07 GMT+01:00 Grant Likely <grant.likely@secretlab.ca>:
> On Wed, Dec 3, 2014 at 4:04 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> On Wed, Dec 3, 2014 at 1:41 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>>> From a quick reading of the backlog, for some reason the new device is
>>> getting assigned NULL as the device name in led_classdev_register().
>>> Probably because led_cdev->name is set to NULL. The leds are getting
>>> bound to the LED driver in gpio_led_probe() which is the non-DT path
>>> for creating LED devices. That would mean there is pdata attached to
>>> the LED device, but I haven't dug any farther than that. Really need
>>> the bisect to narrow down what is going on.
>>
>> Ok, so this issue happens when two or more gpio-leds do not contain
>> the 'label' property.
>>
>> 'label' is an optional property according to
>> Documentation/devicetree/bindings/leds/common.txt:
>>
>> "Optional properties for child nodes:
>> - label : The label for this LED.  If omitted, the label is
>>   taken from the node name (excluding the unit address)."
>>
>> This works fine on 3.17.1 as we used to have this logic in leds-gpio:
>> led.name = of_get_property(child, "label", NULL) ? : child->name;
>>
>> ,but since commit a43f2cbbb009f96 ("leds: leds-gpio: Make use of
>> device property API "), this is no longer true:
>>
>>  + fwnode_property_read_string(child, "label", &led.name);
>>
>> If 'label' is not present then both of the LEDs will have the same
>> name and then the duplicate name error will happen.
>>
>> So we would need something like this:
>>
>>  if (fwnode_property_present(child, "label"))
>>        fwnode_property_read_string(child, "label", &led.name);
>>  else
>>      get the name from the child ---> This is what I am not sure how
>> to do after the conversion to use fwnode_handle.
>
> Ah, that makes sense. The device properties change needs to be
> reworked/fixed up to have a DT specific part when the label property
> is missing. Either that or the device properties API needs to gain the
> ability to return the node name.

Nice catch Fabio :).
I like the idea of returning of node name when label is not specified in DT.

> Rafael, Thoughts?
