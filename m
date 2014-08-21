Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaHURyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:54:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49877 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaHURyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:54:33 -0400
Message-ID: <53F6326F.2050600@wwwdotorg.org>
Date: Thu, 21 Aug 2014 11:54:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        wni@nvidia.com
Subject: Re: [PATCH v2 1/5] of: Add descriptions of thermtrip properties to
 Tegra PMC bindings
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com> <1407933685-12404-2-git-send-email-mperttunen@nvidia.com> <53F50231.5010605@wwwdotorg.org> <20140821065853.GE4486@ulmo> <53F61275.9020508@wwwdotorg.org> <20140821165357.GC1172@ulmo>
In-Reply-To: <20140821165357.GC1172@ulmo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 10:53 AM, Thierry Reding wrote:
> On Thu, Aug 21, 2014 at 09:38:29AM -0600, Stephen Warren wrote:
>> On 08/21/2014 12:58 AM, Thierry Reding wrote:
>>> On Wed, Aug 20, 2014 at 02:16:49PM -0600, Stephen Warren wrote:
>>>> On 08/13/2014 06:41 AM, Mikko Perttunen wrote:
>>>>> Hardware-triggered thermal reset requires configuring the I2C
>>>>> reset procedure. This configuration is read from the device tree,
>>>>> so document the relevant properties in the binding documentation.
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt

>>>>> +- nvidia,pmu : Phandle to power management unit / PMIC handling poweroff
>>>>> +- nvidia,reg-addr : I2C register address to write poweroff command to
>>>>> +- nvidia,reg-data : Poweroff command to write to PMU
>>>>
>>>> Why are both the PMU/PMIC phandle and the register address/data required? I
>>>> thought the purpose of having the phandle was to allow the register address
>>>> and data to be queried from the PMU/PMIC driver.
>>>>
>>>> To me, it seems much simpler to get rid of the phandle and just hard-code
>>>> the I2C bus number, address, and data into this node, rather than having to
>>>> go query it from the PMU/PMIC driver, then find the I2C controller, then
>>>> query it for its ID (and hope that all HW modules that talk to I2C
>>>> controllers directly use the same numbering scheme...)
>>>
>>> I originally requested this to be changed. It seems wrong to duplicate
>>> information about the PMIC in both the PMIC device tree node and the
>>> i2c-thermtrip node if we can get the same information from the driver
>>> directly (via the phandle). It certainly requires a little more code,
>>> but at the advantage of not having to figure out the I2C controller
>>> hardware number and I2C slave addresses when writing the i2c-thermtrip
>>> node.
>>
>> I cant see that argument, but surely the PMIC driver can also supply the

Oops, that was meant to be can not cant.

>> "reg-addr" and "reg-data" values too, if it's already being queried for the
>> I2C device address and bus number? The binding above appears to duplicate
>> part of the information, while requiring querying of the other part.
>
> I suppose that could be done. It would take a new function to do that,
> though, since I'm not aware of a generic mechanism to query this kind of
> information from a PMIC (there's no generic PMIC API, either, so perhaps
> it would be a good time to create one?). The I2C controller and I2C
> slave are generic I2C properties, whereas the register and data to power
> off the device are very device specific.

I don't think it's possible to generically query an I2C device for its 
address from the struct i2c_device object; the code still needs to call 
a function in the PMIC driver to obtain this.

That's because some I2C devices respond to multiple I2C addresses, and 
there's no guarantee that the one I2C address in the DT (and hence the 
struct i2c_device) is the address upon which the regulator function exists.

grep for i2c_new_dummy in drivers/mfd and you'll find quite a few 
examples. The Atmel MXT touchpad/screen is another example.
