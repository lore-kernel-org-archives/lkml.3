Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaIIPHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:07:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:38031 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaIIPHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:07:08 -0400
Message-ID: <540F1796.7090301@mm-sol.com>
Date: Tue, 09 Sep 2014 18:07:02 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] RFC: add function for localbus address
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca> <1409672700-21697-1-git-send-email-svarbanov@mm-sol.com> <20140908145204.8ADC2C40AE5@trevor.secretlab.ca>
In-Reply-To: <20140908145204.8ADC2C40AE5@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thanks for the comments!

On 09/08/2014 05:52 PM, Grant Likely wrote:
> On Tue,  2 Sep 2014 18:45:00 +0300, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
>> Hi Grant,
>>
>> I came down to this. Could you review? Is that
>> implementation closer to the suggestion made by you.
>>
>> ---
>>  drivers/of/address.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/of/platform.c      |   20 ++++++++++++++---
>>  include/linux/of_address.h |   19 +++++++++++++++++
>>  3 files changed, 84 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/of/address.c b/drivers/of/address.c
>> index e371825..86c2166 100644
>> --- a/drivers/of/address.c
>> +++ b/drivers/of/address.c
>> @@ -601,6 +601,32 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
>>  }
>>  EXPORT_SYMBOL(of_get_address);
>>  
>> +const __be32 *of_get_localbus_address(struct device_node *np, int index,
>> +				      u64 *size)
>> +{
>> +	struct device_node *root, *parent;
>> +	const __be32 *ranges, *prop = NULL;
>> +
>> +	parent = of_get_parent(np);
>> +	if (!parent)
>> +		return NULL;
>> +
>> +	root = of_find_node_by_path("/");
>> +
>> +	if (parent == root) {
>> +		of_node_put(parent);
>> +		return NULL;
>> +	}
>> +
>> +	ranges = of_get_property(parent, "ranges", NULL);
>> +	of_node_put(parent);
>> +
>> +	if (!ranges)
>> +		prop = of_get_address(np, index, size, NULL);
>> +
>> +	return prop;
>> +}
> 
> So, the above doesn't make much sense to me. It looks like the function
> merely decodes the local address, and the below function will stuff it
> into a resource structure, but the tests for if the parent is root or
> the parent has a ranges property are nonsensical. That shouldn't matter
> for the functionality (except for automatically decoding them.. more
> below)
> 
>> +
>>  unsigned long __weak pci_address_to_pio(phys_addr_t address)
>>  {
>>  	if (address > IO_SPACE_LIMIT)
>> @@ -665,6 +691,29 @@ int of_address_to_resource(struct device_node *dev, int index,
>>  }
>>  EXPORT_SYMBOL_GPL(of_address_to_resource);
>>  
>> +int of_localbus_address_to_resource(struct device_node *dev, int index,
>> +				    struct resource *r)
>> +{
>> +	const char *name = NULL;
>> +	const __be32 *addrp;
>> +	u64 size;
>> +
>> +	addrp = of_get_localbus_address(dev, index, &size);
>> +	if (!addrp)
>> +		return -EINVAL;
>> +
>> +	of_property_read_string_index(dev, "reg-names", index, &name);
>> +
>> +	memset(r, 0, sizeof(*r));
>> +	r->start = be32_to_cpup(addrp);
>> +	r->end = r->start + size - 1;
>> +	r->flags = IORESOURCE_REG;
> 
> This is problematic. A resource is created, but there is absolutely no
> indication that the resource represents a localbus address instead of a
> CPU address. platform_device reg resources represent CPU addresses.
> Trying to overload it will cause confusion in drivers.
> 
>> +	r->name = name ? name : dev->full_name;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(of_localbus_address_to_resource);
>> +
>>  struct device_node *of_find_matching_node_by_address(struct device_node *from,
>>  					const struct of_device_id *matches,
>>  					u64 base_address)
>> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> index 0197725..36dcbd7 100644
>> --- a/drivers/of/platform.c
>> +++ b/drivers/of/platform.c
>> @@ -106,8 +106,9 @@ struct platform_device *of_device_alloc(struct device_node *np,
>>  				  struct device *parent)
>>  {
>>  	struct platform_device *dev;
>> -	int rc, i, num_reg = 0, num_irq;
>> +	int rc, i, num_reg = 0, num_localbus_reg = 0, num_irq;
>>  	struct resource *res, temp_res;
>> +	int num_resources;
>>  
>>  	dev = platform_device_alloc("", -1);
>>  	if (!dev)
>> @@ -116,22 +117,33 @@ struct platform_device *of_device_alloc(struct device_node *np,
>>  	/* count the io and irq resources */
>>  	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
>>  		num_reg++;
>> +
>> +	while (of_localbus_address_to_resource(np,
>> +					num_localbus_reg, &temp_res) == 0)
>> +		num_localbus_reg++;
>> +
> 
> No, I don't support doing this. The moment a platform_driver depends on
> a local bus address it is doing something special. It needs to decode
> its own address in that case, which it can easily do.
> 
> Any platform_driver that interprets a IORESOURCE_REG as a localbus
> address instead of a CPU address is *BROKEN*. It should be changed to
> either decode the address itself, of a new bus type should be created
> that can make its own decisions about what address resources mean.

Do you mean new of_bus entry?

> 
> I realize that you want to reuse the platform populate functionality in
> this case. We can refactor some of that code to make it usable for
> customized platform_bus_type instances.

What kind of refactoring? And what you mean by "customized
platform_bus_type"? Please elaborate more.

In fact one of my first attempts to upstream Qualcomm PMIC driver here
[1] I'm using of_get_address() over each child node to get the register
addresses and constructing resources for them manually. After that those
resources are passed to mfd_add_devices().

This implementation does not get accepted from Lee Jones with teh
argument that it re-implement of_platform_populate and he will need an
Ack from OF maintainers.

Do you mean with the statement above "It needs to decode its own address
in that case, which it can easily do" something like what I've done in [1]?

[1] http://www.kernelhub.org/?msg=520233&p=2

-- 
regards,
Stan
