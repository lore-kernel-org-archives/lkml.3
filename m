Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3IEDo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:44:57 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:39251 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3IEDoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <52279082.5010105@wwwdotorg.org>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
 <1378294169-22661-5-git-send-email-acourbot@nvidia.com> <52279082.5010105@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 5 Sep 2013 12:44:34 +0900
Message-ID: <CAAVeFuJCCnx+kY46BTkqTbno-j9YwV=GN3dS1aLzxc+ZYWxEdA@mail.gmail.com>
Subject: Re: [RFC 4/5] gpiolib: add gpiod_get() and gpiod_put() functions
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 4:56 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/04/2013 05:29 AM, Alexandre Courbot wrote:
>> Add gpiod_get() and gpiod_put() functions that provide safer handling of
>> GPIOs.
>>
>> These functions put the GPIO framework in line with the conventions of
>> other frameworks in the kernel, and help ensure every GPIO is declared
>> properly and valid while it is used.
>
>> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
>
>> +struct gpio_desc *__must_check gpiod_get(struct device *dev,
>> +                                      const char *con_id);
>> +void gpiod_put(struct gpio_desc *desc);
>
> It might be nice to add an "int index" parameter to this function. For
> example, a bit-banged parallel bus protocol driver might have 1
> chip-select GPIO, 1 clock GPIO, and 8 data GPIOs. gpiod_get(dev, "bus",
> 0)..gpiod_get(dev, "bus", 7) might be nicer than gpiod_get(dev,
> "bus0")..gpiod_get(dev, "bus7")? Possibly for client-simplicity,
> implement both gpiod_get(dev, con_id) (as an inline wrapper for ...) and
> gpiod_get_index(dev, con_id, index)?
>
> In DT terms, this would map to:
>
> cs-gpios = <&gpio 3 0>;
> clock-gpios = <&gpio 5 0>;
> bus-gpios = <&gpio 10 0 ... &gpio 17 0>;
>
> ... and with the mapping table registration mechanism, we could
> presumably add "int index" to struct gpiod_lookup.

Having the index argument of of_get_named_gpiod_flags() propagated
into gpiod_get() is something I also thought about (see the cover
letter), but I really can't make up my mind about it.

On the one hand, having several GPIO per DT property is already
allowed, and presumably used in bindings already. It might also make
sense to have several lines under the same name, e.g. for bitbanging.

On the other hand, I'm afraid people will abuse this, and group all
the GPIOs for a device under a single property instead of using proper
names.

I guess that if we want gpiod to cover all that gpio allows already
(as the ultimate goal is to superseed the latter) we have no choice
but support this though. A (possibly cleaner) alternative would be to
have a get_gpios(device, name, gpio_desc **descs, int nb_desc)
function that returns all the GPIOs defined under a single property,
and fails if the number of descriptors does not match nb_desc. If that
works it would be more tailored towards grouping GPIOs that serve the
same logical purpose, and discourage the behavior I worried about
above.

Alex.
