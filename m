Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaG2OGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:06:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53197 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbaG2OGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:06:46 -0400
Message-ID: <53D7AA72.6010309@mm-sol.com>
Date: Tue, 29 Jul 2014 17:06:42 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@linaro.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, Mark Brown <broonie@linaro.org>
Subject: Re: use IORESOURCE_REG resource type for non-translatable addresses
 in DT
References: <53D788A7.4020303@mm-sol.com> <3794875.CZFbAag5Sv@wuerfel>
In-Reply-To: <3794875.CZFbAag5Sv@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, thanks for the comments.

On 07/29/2014 03:00 PM, Arnd Bergmann wrote:
> On Tuesday 29 July 2014 14:42:31 Stanimir Varbanov wrote:
>>         taddr = of_translate_address(dev, addrp);
>> -       if (taddr == OF_BAD_ADDR)
>> -               return -EINVAL;
>> +       /*
>> +        * if the address is non-translatable to cpu physical address
>> +        * fallback to a IORESOURCE_REG resource.
>> +        */
>> +       if (taddr == OF_BAD_ADDR) {
>> +               memset(r, 0, sizeof(*r));
>> +               taddr = of_read_number(addrp, 1);
>> +               if (taddr == OF_BAD_ADDR)
>> +                       return -EINVAL;
>> +               r->start = taddr;
>> +               r->end = taddr + size - 1;
>> +               r->flags = IORESOURCE_REG;
>> +               r->name = name ? name : dev->full_name;
>> +               return 0;
>> +       }
>> +
> 
> I don't think that everything returning OF_BAD_ADDR makes sense
> to turn into IORESOURCE_REG. It could be an e.g. invalid DT
> representation, a node with #size-cells=<0>, or it could be
> something that gets translated one or more nodes up in the
> tree before it reaches a bus without a ranges property.
> 
> Also, you should not rely on #address-cells being hardcoded
> to <1> above.
> 

This was just an example. Of course it has many issues and probaly it is
wrong:) The main goal was to understand does IORESOURCE_REG resource
type and parsing the *reg* properties for non-translatable addresses are
feasible. And also does it acceptable by community and OF platform
maintainers.

> How about modifying of_get_address() rather than
> __of_address_to_resource() instead? You could introduce
> a new of_bus entry for each bus you expect to return
> an IORESOURCE_REG, or you could change of_bus_default_get_flags
> to return IORESOURCE_REG if the parent node has no ranges property
> and is not the root node.

IMO the clearer solution is to introduce a new of_bus bus. In that case
one possible problem will be how to distinguish the non-translatable and
the other buses. Also the *device_type* property is deprecated for non
PCI devices.

The second option will need to change the prototype of .get_flags method
to receive device_node structure.

Thoughts?

-- 
regards,
Stan
