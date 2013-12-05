Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3LEEPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:15:22 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:51695 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3LEEPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:15:19 -0500
Message-ID: <529FFDD2.3030103@gtsys.com.hk>
Date: Thu, 05 Dec 2013 12:15:14 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk> <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk> <20131203081556.GA26423@xps8300> <529ED6C5.3000608@gtsys.com.hk> <20131204094936.GA21055@xps8300>
In-Reply-To: <20131204094936.GA21055@xps8300>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday, December 04, 2013 05:49 PM, Heikki Krogerus wrote:
> Hi Chris,
>
> On Wed, Dec 04, 2013 at 03:16:21PM +0800, Chris Ruehl wrote:
>> On Tuesday, December 03, 2013 04:15 PM, Heikki Krogerus wrote:
>>> On Mon, Dec 02, 2013 at 03:05:19PM +0800, Chris Ruehl wrote:
>>>> @@ -154,6 +164,27 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *nop,
>>>>   {
>>>>   	int err;
>>>>
>>>> +	if (nop->ulpi_vbus>   0) {
>>>> +		unsigned int flags = 0;
>>>> +
>>>> +		if (nop->ulpi_vbus&   0x1)
>>>> +			flags |= ULPI_OTG_DRVVBUS;
>>>> +		if (nop->ulpi_vbus&   0x2)
>>>> +			flags |= ULPI_OTG_DRVVBUS_EXT;
>>>> +		if (nop->ulpi_vbus&   0x4)
>>>> +			flags |= ULPI_OTG_EXTVBUSIND;
>>>> +		if (nop->ulpi_vbus&   0x8)
>>>> +			flags |= ULPI_OTG_CHRGVBUS;
>>>> +
>>>> +		nop->ulpi = otg_ulpi_create(&ulpi_viewport_access_ops, flags);
>>>> +		if (!nop->ulpi) {
>>>> +			dev_err(dev, "Failed create ULPI Phy\n");
>>>> +			return -ENOMEM;
>>>> +		}
>>>> +		dev_dbg(dev, "Create ULPI Phy\n");
>>>> +		nop->ulpi->io_priv =  nop->viewport;
>>>> +	}
>>>
>>> This is so wrong. You are registering one kind of usb phy driver from
>>> an other. Change drivers/usb/phy/ulpi.c to be a platform device. The
>>> whole flag system in it is pretty horrid. While you are at it, change
>>> that so it sets the values based on boolean flags from OF properties
>>> or platform data.
>>>
>>> NAK for the whole set.
>>>
>>>
>>
>> Heikki,
>>
>> Thanks for your comments, even not much positive to me.. any how.
>> My intention on the "horrid" path was to reduce kernel code where
>> one of_read32 vs. four of_boolean. And mentioned logic is simple.
>> But that's history.
>
> I should probable explain why I have problems with them. First of all,
> things like driving the vbus should be a function that can be called
> from upper layers. struct usb_otg has the set_vbus hook for that. You
> can call it for example from your host controller's init routine. I'm
> assuming you have a host controller since you are driving vbus.

My platform is Freescale imx27 and the host controller the ChipIdea, where I 
have already send some patches for. I uses the set_vbus it in the wrong place
nop->ulpi->otg->set_vbus(nop->ulpi->otg,true); (phy-generic:usb_gen_phy_init())

and now I start to understand where is the issue. I must tell chipidea to init 
the vbus using the platform....

>
> You don't need to set the ULPI_OTG_CHRGVBUS. It's used for the VBUS
> pulsing of SRP, which btw. is not anymore supported in OTG&EH2.0 spec,
> so just don't use that bit even if you want to start SRP.

OK, got it. Test it right away, yes my USB still works great even I omit the 
flag. The reason I introduced it was the fact that plat-mxc/isp1504xc.c of the 
2.6.22 with the freescale patches set this flag.

>
> The only of_booleans you should need are for the DRV_VBUS_EXT and
> USE_EXT_VBUS_IND. In my case I could not use even those. My controller
> provides it's own control for them, so even if I set them to my ULPI
> phy, the controller would simply override the values.
>
> Secondly, why those silly flags in the first place. Those flags are
> just bits in the registers. It would have been much easier and cleaner
> to deliver a small struct with default values for the registers
> instead.
>
>> On my way to find a solution for my board I'd look around and found using of
>> phy-ulpi.c functions in phy-tegra-usb.c and don't mind to use them too.
>
> OK, IC. I have not followed what is happening with USB in linux for a
> while.
>
> The whole otg_ulpi_create() thing, and the flags with it, were
> originally planned to be used from platform code. It's evil and it
> should have never been accepted into upstream kernel. The time it was
> introduced I was on vacation and nobody else seemed to care :(. All I
> was able to do was to protest afterwards.
>

Checked!


>> I accept your NAK and will work on a patch to make phy-ulpi.c
>> working as platform device.
>>
>> Last question to you. What you don't like on the patch to support
>> chip-select gpio of my patch-set.. I ask because you NAK the whole
>> set.
>> I really need the ChipSelect function to make my hardware work!
>
> OK, I did not explain my problem with that patch. I'm sorry about
> that. It also looks like I made wrong assumption with it. I thought
> that your phy (is was ISP1504 right) is just like isp1704 that I have
> worked with. On isp1704 you only have the chip_sel pin (no reset pin),
> so I thought you can not have any reason to add handler for an other
> gpio to this driver. After a quick look at isp1504 data sheet, it
> looks like you have both reset and chip_sel pins on it, which I guess
> are both connected to gpios on your platform.
>
Yes 1504, and my hardware guys make otg using the chipselect with gpio
and the usbh2 is fixed selected via pull down resistor.


> So I don't have a problem with that. Though I'm not sure is this
> driver the right place to handle things like these gpios, which are
> pretty phy specific, in the first place. The phy-generic was
> originally meant to be pure NOP phy driver.
May then change the meaning back to "generic" when support generic requirements
like chip-select(1704+1504) reset(1504).
If the 1504 missed a proper reset its ends up in weird errors ..

>
> One comment about how to handle the gpios. You should move to the new
> gpio descriptor API. The legacy gpio API is now just a wrapper on top
> of it.
>
Back to the Manuals.. :-) OK its on the list.


>
>> Chris
>>
>
> Thanks,
>

I thank you!
Chris

-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
