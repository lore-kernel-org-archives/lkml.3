Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbaEFEFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:05:20 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52440 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbaEFEFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:05:16 -0400
Message-ID: <53685F7E.2000100@linaro.org>
Date: Mon, 05 May 2014 23:05:18 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: mporter@linaro.org, bcm@fixthebug.org, devicetree@vger.kernel.org,
        arnd@arndb.de, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: add SMP support for Broadcom mobile SoCs
References: <1396577891-2713-1-git-send-email-elder@linaro.org> <1396577891-2713-3-git-send-email-elder@linaro.org> <533EF21C.6000909@codeaurora.org> <53680A5B.4060208@linaro.org> <53683E40.1060909@codeaurora.org>
In-Reply-To: <53683E40.1060909@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 08:43 PM, Stephen Boyd wrote:
> On 05/05/14 15:02, Alex Elder wrote:
>> On 04/04/2014 12:55 PM, Stephen Boyd wrote:
>>> On 04/03/14 19:18, Alex Elder wrote:
>>>> +
>>>> +/*
>>>> + * Secondary startup method setup routine to extract the location of
>>>> + * the secondary boot register from a "cpu" or "cpus" device tree
>>>> + * node.  Only the first seen secondary boot register value is used;
>>>> + * any others are ignored.  The secondary boot register value must be
>>>> + * non-zero.
>>>> + *
>>>> + * Returns 0 if successful or an error code otherwise.
>>>> + */
>>>> +static int __init of_enable_method_setup(struct device_node *node)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	/* Ignore all but the first one specified */
>>>> +	if (secondary_boot)
>>>> +		return 0;
>>>> +
>>>> +	ret = of_property_read_u32(node, OF_SECONDARY_BOOT, &secondary_boot);
>>>> +	if (ret)
>>>> +		pr_err("%s: missing/invalid " OF_SECONDARY_BOOT " property\n",
>>>> +			node->name);
>>>> +
>>>> +	return ret;
>>>> +}
>>> I don't understand why we need this. Why can't we get the secondary boot
>>> address from the /cpus node in the smp_prepare_cpus op. It isn't that
>>> hard to get access to the cpus node there via of_find_node_by_path().
>>> Then we don't need patch 1 at all. If it turns out to be common stuff,
>>> we can always have the common function live in arm common code or maybe
>>> even be a devicetree API.
>> I already responded to this, but never got any response.  I
>> was preparing to re-send this series and wanted to try to
>> pull the added feature (patch 1) out and not be dependent on
>> it.  But I think it's a bit ugly so I'm hoping to get a
>> blessing to proceed with what I originally proposed.  For
>> reference, here's the thread:
>>     https://lkml.org/lkml/2014/4/3/421
>>
>> What I'm trying to do is get the value of a "secondary-boot-reg"
>> property from a node known to have an "enable-method" property
>> that matches the method name supplied in CPU_METHOD_OF_DECLARE().
> 
> I don't recall seeing any documentation about the secondary-boot-reg
> property. Please make sure it is documented in the next patch series.

I omitted the documentation, hoping to get some input about how
best to go about it.  I talked with Mark Rutland last week and
agreed to split off the "enable-method" descriptions into a file
separate from "Documentation/devicetree/bindings/arm/cpus.txt"
because it seemed like there might be a proliferation of them.
I will definitely include it this time around.

>> Using the callback function as I originally proposed, this is
>> very easy.  When arm_dt_init_cpu_maps() parses the "cpus" portion
>> of the device tree it calls set_smp_ops_by_method() for a
>> matching "cpu" or "cpus" node, and that function supplies
>> the node to the callback function. The callback can extract
>> additional property values if needed.
>>
>> If I hold off until smp_prepare_cpus() is called, I have to
>> re-parse the device tree to find the "cpus" node (this is
>> in itself trivial).  I then need to re-parse that node to
>> verify the matching "enable-method" property is found before
>> looking for the parameter information I need for that enable
>> method.  I would really prefer not to re-do this parsing
>> step.  It's imprecise and a little inefficient, and it
>> duplicates (but not exactly) logic that's already performed
>> by arm_dt_init_cpu_maps().
> 
> Do you have any devices where the enable-method and secondary-boot-reg
> isn't the same across all CPUs? A lot of the complexity comes from

To be clear, my discussion here is thinking more broadly than
this specific case--beyond the Broadcom SoCs I'm adding support for.

But to answer your question, I am not aware of any such devices.

> broken DTs that don't specify a secondary-boot-reg along with the
> enable-method. From the description and the code it seems that we should
> just always put these two properties in the cpus node to make things
> simple and precise. I agree it's a minor duplication to read the DT

Yes, I agree that specifying it only in "cpus" is preferable
in general, and specifically that was how I was going to
describe this binding.

I could imagine a big.LITTLE machine could have different
methods but I have no experience with that.  It seems we should
just dictate using the "cpus" node (not "cpu" nodes) unless/until
there comes along a real machine that requires multiple methods.
(But as the code now stands, only the first matching "cpu" node
is ever used--any others are ignored--so it wouldn't support such
a theoretical case anyway.)

> again to get the /cpus node and read a property out of it, but I doubt
> you could even measure the difference.

No, that's why I said "a little inefficient."

My bigger issue has to do with the fact that arm_dt_init_cpu_maps()
already does a comprehensive job of parsing device tree nodes and
finding matching "enable-method" entries.  I view this extra
"secondary-boot-reg" property as a *parameter* of this particular
enable method.

With this view I think the parameter properties (if any) should
be parsed in the same context that the "enable-method" was found.
Having it get parsed much later, in a separate pass through the
device tree just seems like splitting up something that should be
logically grouped.

A different enable method might require a different parameter.
So for a specific example, I might define a setup function to
get the "cpu-release-address" property for a "spin-table"
enable method, if one were to be defined.

If we were restricted to the single "cpus" node this would
be much simpler, but I'd still argue the enable method and
its related properties should be treated together.

>> One more point of clarification.  This "secondary-boot-reg"
>> value is *not* the secondary boot address--that is, it's
>> not the address secondary cores jump to when they are
>> activated.  Instead, this is the address of a register
>> that's used to request the ROM code release a core from
>> its ROM-implemented holding pen.  For this machine,
>> control jumps at that point to secondary_startup(),
>> defined in arch/arm/kernel/head.S.
> 
> Yes it wouldn't be possible to specify the entry address in DT (depends
> on compile time factors). How is this different from cpu-release-addr

Sorry, I misstated that.  I meant it's not the cpu-release-addr
(which is the location of the register into which the secondary
boot address should be written).

> though? It looks like it describes something similar to what ePAPR
> describes and how arm64 uses it (although those two slightly differ).
> Assuming it's paired with a different enable-method than spin-table I
> don't see a problem reusing the same name.

I suppose.  I hate to use the same name for something whose
use is semantically different.  I'm not sure why there's value
to reusing the name.

To be honest I don't think the set_smp_ops_by_method() call(s)
necessarily belongs in arm_dt_init_cpu_maps().  It seems like
it could just as easily be done inside smp_init_cpus().  I
don't think the smp_operations vector needs to be set at that
early stage, and it was done where it is as more a matter of
convenience.

Note that arm64 uses cpu_operations rather than smp_operations
and there are some differences.  The cpu_init() method gets
called from smp_init_cpus(), right after the "enable-method"
property is parsed.  That method passes the matching device
node, so it really does something very much like what I'm
proposing.

>>
>> So...
>>
>> Stephen, I'd like to hear from you whether my explanation
>> is adequate, and whether you think my addition and use of
>> CPU_METHOD_OF_DECLARE_SETUP() is reasonable.  (If you have
>> a suggestion for a better name, I'm open.)
>>
>> If you still don't like it, I'll follow up with a
>> new version of the patches, this time parsing the
>> device tree in the smp_prepare_cpus() method as
>> you suggested.  I don't want this to hold up getting
>> this SMP support into the kernel.
>>
> 
> This was my train of thought. It annoys me that we have smp ops at two
> levels. We already have SMP ops that deal with SMP things and now we
> have another level that is associated with the enable-method. If we

I could add the callback as a new member of the smp_operations
struct but it doesn't really fit there (like you said, it's tied
to the enable method more than SMP).

> really need this callback why couldn't we just collapse it with the
> smp_ops we already have? When we do that we realize that
> smp_prepare_cpus() is a fairly similar place to do this sort of thing,
> but changing that callback to take the node is annoying to propagate to

I have no problem making such a change if it's the right thing
to do.  I found the existing interfaces didn't support what
I wanted to do so I tried to make them more flexible.

> all users. But do we really need that node? It seems simple enough to
> just get the cpus node and then read out the property we care about and
> we can do all that in smp_prepare_cpus() one time (and keep the mapping
> around forever) without requiring any core ARM changes.

(I don't really like leaking mappings either, trivial as
that may seem.)

> Do you have any more complicated use cases for this setup hook? RIght
> now I'm not convinced that we need to add all this framework for
> something that looks like it could be done in a couple lines in the
> prepare_cpus() step.
> 
> 	cpus = of_find_node_by_path("/cpus")
> 	ret = of_property_read_u32(cpus, "secondary-boot-reg", &addr);

For the case of these Broadcom SoCs, I think this is sufficient.
I'll put together a new version of the series in the morning.
I think I can do what you suggest or very similar.

I think there's more improvement that can be made in this
SMP setup code though, so I think this is good discussion.
I appreciate your responses.

					-Alex
