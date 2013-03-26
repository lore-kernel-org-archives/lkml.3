Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972Ab3CZQO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:14:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46404 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090Ab3CZQOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:14:24 -0400
Message-ID: <5151C95A.6080508@wwwdotorg.org>
Date: Tue, 26 Mar 2013 10:14:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "s-guiriec@ti.com" <s-guiriec@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] USB: PHY: Palmas USB Transceiver Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1364203926-24488-1-git-send-email-kishon@ti.com> <51501CFB.4020905@nvidia.com> <51513A40.7080905@ti.com> <515163F6.3010400@slimlogic.co.uk> <20130326102100.GD11244@arwen.pp.htv.fi> <51517859.2020407@nvidia.com>
In-Reply-To: <51517859.2020407@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 04:28 AM, Laxman Dewangan wrote:
> On Tuesday 26 March 2013 03:51 PM, Felipe Balbi wrote:
>> On Tue, Mar 26, 2013 at 09:01:42AM +0000, Graeme Gregory wrote:
...
>>>>> +       return regmap_read(palmas->regmap[slave], addr, dest);
>>>>>
>>>>>
>>>>> Please use the generic api for palmas_read()/palmas_write(0 as it will
>>>>> be ease on debugging on register access.
>>>>> Direct regmap_read() does not help much on this.
>>>>
>>>> Any reason why you dint use palmas_read()/palmas_write here?
>>>> Btw palmas_read()/palmas_write() internally uses regmap APIs.
>>>
>>> Because I was not a fan of tightly coupling the child devices to the
>>> parent MFD. palmas_read/write were added by Laxman.
>>
>> I guess regmap would also help abstracting SPI versus I2C connection.
>> IMHO, palmas_read/write should be removed.
>>
>> Laxman's complaint that it doesn't help with debugging is utter
>> nonsense.
>
> palams read/write api uses the regmap only and hence not break anything
> on abstraction.
> in place of doing the following three statement in whole word, it
> provides wrapper of palmas_read()
> which actually does the same.
> 
> slave = PALMAS_BASE_TO_SLAVE(PALMAS_USB_OTG_BASE);
> addr = PALMAS_BASE_TO_REG(PALMAS_USB_OTG_BASE, reg);
> regmap_read(palmas->regmap[slave], addr, dest);

Why would you ever do that? Surely each module's probe should create or
obtain a regmap object somehow, and then all other code in that driver
should simply use regmap_read()/regmap_write() without having to perform
any kind of calculations at all.

If the MFD components truly are pluggable mix/match IP blocks, then all
the register offset #defines must all be relative to the base of the IP
block, so there would be no need for any calculations there.

The I2C address and base register address for the regmap object should
come from DT or platform data, and be used one time in probe() to create
the regmap object.

Then, there would be no need for palmas_read()/palmas_write().

> Above 3 lines in all the places for resgister access or make single call:
> palmas_read(palmas, PALMAS_USB_OTG_BASE, PALMAS_USB_OTG_BASE, dest).
> 
> This function implement the above 3 lines.
