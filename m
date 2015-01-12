Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbbALMus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:50:48 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53495 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751968AbbALMup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:50:45 -0500
Message-ID: <54B3C2F4.4010007@free-electrons.com>
Date: Mon, 12 Jan 2015 13:49:56 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Mark Brown <broonie@kernel.org>
CC: Chen-Yu Tsai <wens@csie.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        devicetree <devicetree@vger.kernel.org>,
        =?windows-1252?Q?Antoine_T=E9?= =?windows-1252?Q?nart?= 
	<antoine.tenart@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-ide@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 2/4] Documentation: bindings: Add the regulator property
 to the sub-nodes AHCI bindings
References: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com> <1420799989-10645-3-git-send-email-gregory.clement@free-electrons.com> <54AFF7E3.4070506@redhat.com> <54AFFFDC.7020307@free-electrons.com> <CAGb2v674q4Cjp9qy9CbUXe2j5pT_ez98CKxXHC8u4Diap2TT1A@mail.gmail.com> <20150109171131.GH2634@sirena.org.uk> <54B0FCDD.7000300@redhat.com> <20150110111748.GB4160@sirena.org.uk> <54B12E54.7000704@redhat.com>
In-Reply-To: <54B12E54.7000704@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2015 14:51, Hans de Goede wrote:
> Hi,
> 
> On 10-01-15 12:17, Mark Brown wrote:
>> On Sat, Jan 10, 2015 at 11:20:13AM +0100, Hans de Goede wrote:
>>> On 09-01-15 18:11, Mark Brown wrote:
>>
>>>> Or if the supply is for the device at the other end of the link (which
>>>> is what it sounded like) then use that.  This just sounds like the same
>>>> problem we have for all the enumerable buses in embedded systems where
>>>> we need to be able to understand that the device exists prior to it
>>>> being fully ready to appear in the system.  Having the link/slot be a
>>>> device in Linux does indeed seem to be a common way people think about
>>>> doing this, it sounds like for this one it might be the most direct.
>>
>>> I think we should be careful to not think too much from an implementation
>>> pov here, the purpose of the devicetree description is to describe the hardware,
>>> as is.
>>
>> I don't think anyone is talking about changing the DT here, only the way
>> it's represented inside Linux.
>>
>>>                  sata0: sata-port@0 {
>>>                          reg = <0>;
>>>                          phys = <&sata_phy 0>;
>>> 			target-supply = <&reg_sata0>;
>>>                  };
>>>
>>>                  sata1: sata-port@1 {
>>>                          reg = <1>;
>>>                          phys = <&sata_phy 1>;
>>> 			target-supply = <&reg_sata1>;
>>>                  };
>>>          };
>>
>>> Seems to match the hardware pretty exactly, and also matches how we've
>>> been describing similar devices with only one sata port + power plug sofar,
>>> so from a consistency pov it also is a good model.
>>
>> Right, I think that makes sense
> 
> Good, as said I think getting the dt bit rights is the most important
> thing here. So if we agree that the above dt example looks sane, lets see
> how we can best implement that.
> 
>  > it also looks to me like these things
>> should be representable as devices within Linux.
> 
> I guess we could manually instantiate platform devices for each of the
> subnodes which represent an sata port here, yes that should not be
> hard to do, it feels like a bit overkill though.
> 
> So for our this should likely look something like this:
> 
>          if (IS_ENABLED(CONFIG_OF_ADDRESS) && dev->of_node) {
>                  for_each_child_of_node(dev->of_node, np) {
>                          pdev[i++] = of_platform_device_create(np, NULL, NULL);
>                  }
>          }
> 
> and then loop over the pdev[] array and get the regulator, and phy for each.
> 
> I wonder if of_platform_device_create can deal with nodes with
> #size-cells = <0>; is 0 though, if it cannot maybe we need to teach it.
> 
>>> So supporting this model requires having a regulator_get API which allows
>>> specifying which of_node to get the regulator from, e.g. the proposed
>>
>> It requires nothing of the sort.
> 
> You're proposed solution of instantiating devices does more or less exactly
> what I say is required, it is a way to pass an of_node into regulator_get,
> but you're hiding the node inside dev->of_node. I can see the appeal in
> that.
> 
>>> of_regulator_get function. I know you (Mark) do not like this, but all
>>> other subsystems have an of_foo_get function taking an of_node as argument,
>>> I do not see how the regulator subsys is so special that it cannot have one,
>>> and also notice that this is only a kernel internal API which we can always
>>> change later.
>>
>> Two things there.  One is that mostly those APIs are legacy APIs from
>> before we made DT a first class citizen and generally they shouldn't be
>> used these days.  The other is that at least for regulators we have
>> constant problems with people abusing the API in various ways, as a
>> result the API has a goal of not helping undesirable usage patterns in
>> order to help people spot problems.  Having an API which makes it easy
>> create broken bindings means that it is much more likely that people
>> will do just that.
> 
> Hmm I can see where you're coming from, and your proposed solution may
> also be useful for when we get similar boards requiring explicit regulator
> handling with the sata ports described in ACPI tables.
> 
> Gregory, can you give the setup using per sata port devices a try, and
> see how that works out code wise ?

OK, I am taking care of it.


Thanks,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
