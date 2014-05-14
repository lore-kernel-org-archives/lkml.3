Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaENOto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:49:44 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48216 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaENOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:49:42 -0400
Message-ID: <53738261.4000000@ahsoftware.de>
Date: Wed, 14 May 2014 16:49:05 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-3-git-send-email-holler@ahsoftware.de> <20140514140534.897F8C4153D@trevor.secretlab.ca>
In-Reply-To: <20140514140534.897F8C4153D@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 16:05, schrieb Grant Likely:
> On Mon, 12 May 2014 18:47:53 +0200, Alexander Holler <holler@ahsoftware.de> wrote:
>> Use the properties named 'dependencies' in binary device tree blobs to build
>> a dependency based initialization order for platform devices and drivers.
>>
>> This is done by building a directed acyclic graph using an adjacency list
>> and doing a topological sort to retrieve the order in which devices/drivers
>> should be created/initialized.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>
> Hi Alexander,
>
> Thanks for looking at this. It is a difficult problem. I've made
> comments below, but first I've got some general comments...
>
> First, I'm going to be very cautious about this. It is a complicated
> piece of code making the device initialization process a lot more
> complicated than it already is. I'm the first one to admit that deferred
> probe handles the problem in quite a naive manner, but it is simple,
> correct (when drivers support deferred probe) and easy to audit. This
> series digs deep into the registration order of *both* devices and
> drivers which gives me the heebee jeebees.

Sure, but the approach I present is deterministic. The deferred stuff, 
while it's simple and works, is imho just a workaround. Besides that 
this series isn't about pro or cons of the deferred probe, the deferred 
probes I have seen where just the reason why I had a look at what 
happens. To conclude, I like the deferred probe because it fixes 
problems, but trying to do things right is much better. And there are 
already many workarounds trying fix the initialization order (e.g. 
drivers which classify themself as a subsys), so starting do it right 
makes imho sense.

So, I'm sorry if you see this feature as an attack on the deferred probe 
stuff, it isn't meant as such, no offense here or there.

> Personally, I think the parts of this patch that manipulate the device registration
> order is entirely the wrong way to handle it. If anything, I would say
> continue to register the devices, even if the dependencies are unmet.

That would just be a removal of 2 lines. I've no problem with that. ;)

> Instead, I would focus on the driver core (drivers/base) to catch
> device probe attempts when a known dependency is not met, remember it,
> and perform the probe after the other driver shows up. That is also
> going to be a complicated bit of code, but it works for every kind of
> device, not just platform_devices, and has far less impact on the
> platform setup code.
>
> BTW, this has to be able to work at the level of struct device instead
> of struct platform_device. There are far more kinds of devices than just
> platform_device, and they all have the same problem.

Changing to care for devices instead of just drivers is easy to do.

> Also, may I suggest that the more pieces that you can break this series
> up into, the greater chance you'll have of getting a smaller subset
> merged earlier if it can be proven to be useful on its own.

Hmm, I don't really care if that will be merged. I have no motivation to 
fight with Linux kernel maintainers and I don't know if I will spend the 
necessary time to do so.


>> +#ifdef CONFIG_OF_DEPENDENCIES
>> +		if (!of_init_build_order(NULL, NULL))
>> +			of_init_create_devices(NULL, NULL);
>> +		else
>> +			of_init_free_order();
>
> What happens when of_init_build_order() fails? Does the whole system
> fall over?

Yes. The only reason it can fail is when there is a cycle, and dtc 
checks (and fails) for that when building the blob (dtb).

>
>> +#else
>>   		of_platform_populate(NULL, of_default_bus_match_table,
>>   					NULL, NULL);
>>   #endif
>> +	}
>> +#endif
>> +
>>   	return 0;
>>   }
>>   arch_initcall(customize_machine);
>> @@ -914,7 +924,13 @@ void __init setup_arch(char **cmdline_p)
>>   		arm_pm_restart = mdesc->restart;
>>
>>   	unflatten_device_tree();
>> -
>> +#ifdef CONFIG_OF_DEPENDENCIES
>> +	/*
>> +	 * No alloc used in of_init_build_order(), therefor it would work
>> +	 * already here too.
>> +	 */
>> +	/* of_init_build_order(NULL, NULL); */
>> +#endif
>
> Stale hunk left in patch?

See here: https://lkml.org/lkml/2014/5/14/102

This are NOT patches meant for final merging!


> I would suggest splitting the core graph support into a separate patch
> to keep things smaller and to keep the behaviour changes separate from
> the support function additions.

Could be done.

>
>> +
>> +
>> +/* Copied from drivers/of/base.c (because it's lockless). */
>
> Copying isn't a good idea. The function will need to be made accessible
> to other files in the drivers/of directory.

See above.


>> +int __init of_init_build_order(struct device_node *root,
>> +			const struct of_device_id *matches)
>> +{
>> +	struct device_node *child;
>> +	int rc = 0;
>> +
>> +	root = root ? of_node_get(root) : of_find_node_by_path("/");
>> +	if (unlikely(!root))
>> +		return -EINVAL;
>> +
>> +	calc_max_phandle();
>> +	order.old_max_phandle = order.max_phandle;
>> +
>> +	for_each_child_of_node(root, child) {
>> +		rc = add_deps(root, child, matches);
>> +		if (unlikely(rc))
>> +			break;
>> +	}
>> +
>> +	of_node_put(root);
>> +	topological_sort();
>
> Can the sort be performed incrementally? The DT is a dynamic structure
> on some platforms. Search for OF_RECONFIG_. There is work in progress to
> add overlay support to the device tree so that batches of new nodes can
> be added to the tree after userspace has started. The dependency code
> will need to handle that situation gracefully.

The stuff I present is only about what happens before userspace starts 
and is all gone away when userspace start. I know about the overlay 
support (e.g. for bbb-capes), but I don't care. So there is no need to 
think about what happens if such happens.

> I don't like that of_init_create_devices() has a completely different
> calling convention from of_platform_populate(). of_platform_populate()
> is passed a match table for devices that are to act as buses (which
> means register the children also). This function is passed a blacklist
> instead which is a completely different semantic.

Acting on buses is a workaround.

>
> That means it cannot be used by device drivers that register their own
> children and it has to make a lot of assumptions about what should and
> should not be registered as platform_devices.
>
> How does the dependency code decide which devices can be
> platform_devices? It's not clear to me from what I've read so far.

Dependencies currently are only considered on stuff which has a 
"compatibility" property, thus drivers. I wanted to get the drivers 
loaded in order, not really caring for devices. Let me quote from 
(outdated) ldd3:

"For the most part, the Linux device model code takes care of all these 
considerations without imposing itself upon driver authors. It sits 
mostly in the background; direct interaction with the device model is 
generally handled by bus-level logic and various other kernel 
subsystems. As a result, many driver authors can ignore the device model 
entirely, and trust it to take care of itself."

So do I. ;)

>
>> +
>> +	for (i = 0; i < order.count; ++i) {
>> +		struct device_node *node = order.order[i];
>> +		uint32_t parent_ph = order.parent_by_phandle[node->phandle];
>> +
>> +		if (unlikely(blacklist &&
>> +				of_match_node(blacklist, node))) {
>> +			of_node_put(node);
>> +			continue;
>> +		}
>> +		if (unlikely(parent_ph &&
>> +			!order.device_by_phandle[parent_ph])) {
>> +			/* init of parent failed */
>> +			of_node_put(node);
>> +			continue;
>> +		}
>> +		dev = of_dependencies_device_create(node, lookup,
>> +			order.device_by_phandle[parent_ph]);
>> +		if (dev)
>> +			order.device_by_phandle[node->phandle] = &dev->dev;
>> +		of_node_put(node);
>> +	}
>> +	/* remove_new_phandles(); */
>> +}
>
> I could use some help understanding what is being done here. It looks
> like it is going through and only registering devices that have a
> dependency parent already created, or don't have a parent at all. Am I
> correct?

Yes, that part assumes that if a parent is present, the parent is needed 
and it doesn't make sense to create a device if the parent already 
failed. That are those two lines I mentioned above.

>
> It looks like this patch alone will break the kernel because it depends
> also on the functionality in patch 5. The patches would need to be
> reordered to handle that situation.

I currently don't care if this feature breaks something. Therefor it is 
marked in big letters as experimental. But I already see you don't want 
it and you see it all as an offense.

Regards,

Alexander Holler
