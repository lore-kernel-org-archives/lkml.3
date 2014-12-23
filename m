Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaLWO7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:59:01 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52333 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbaLWO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:59:00 -0500
Message-ID: <549982BE.3080500@vanguardiasur.com.ar>
Date: Tue, 23 Dec 2014 11:57:02 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        Walter Lozano <walter@vanguardiasur.com.ar>
CC: mika.westerberg@linux.intel.com, Romain.Baeriswyl@abilis.com,
        atull@opensource.altera.com, raymond.tan@intel.com,
        carlpeng008@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] i2c: designware: Avoid initcall and initialize the driver
 like a regular one
References: <1419272149-28716-1-git-send-email-walter@vanguardiasur.com.ar> <20141222190233.GA1014@katana>
In-Reply-To: <20141222190233.GA1014@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 04:02 PM, Wolfram Sang wrote:
> On Mon, Dec 22, 2014 at 03:15:49PM -0300, Walter Lozano wrote:
>> Currently, the driver is relying on a subsys_initcall() to register
>> the platform driver struct. This is typically done to allow early uses
>> of the I2C bus (for instance, I2C regulators used from early machine code).
>>
>> While this might work on some cases, it breaks on others. For instance,
>> I2C devices with GPIO-wired interrupts will fail to request the
>> interrupt because of this initcall usage.
>>
>> This commits attempts to fix the above issue, by converting the I2C
>> driver into a regular kernel platform driver. This guarantees it will
>> probe after GPIOs drivers.
>>
>> Platforms based on devicetree won't be affected by this change.
> 
> Huh, why is that?
> 

Unless I'm missing something here, our beloved DeviceTree guarantees to
model the dependency between I2C slaves devices and the I2C master their
connected to.

So, a machine fully-based on DeviceTree would never attempt to use the I2C
bus without first registering the master, right?

This means there won't be any early users of the I2C platform driver in this
scenario.

>> Legacy platforms, relying on the I2C being available early, might need
>> to implement proper defered mechanisms to overcome potential problems.
> 
> NAK. We can't say "Let's cause a regression to force people to fix
> things that used to work" IMO. You exactly pointed out the problem that using
> subsys_initcall() creates.
> 
> What about fixing the drivers you use to support deferred probing when
> acquitin the irq?
> 

Maybe we can fix the legacy ones instead. However, a quick look shows there
aren't any!

$ git grep i2c_designware
drivers/i2c/busses/i2c-designware-pcidrv.c:MODULE_ALIAS("i2c_designware-pci");
drivers/i2c/busses/i2c-designware-platdrv.c:MODULE_ALIAS("platform:i2c_designware");
drivers/i2c/busses/i2c-designware-platdrv.c:            .name   = "i2c_designware",

Looks like this patch is pretty harmless.

Thanks!
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
