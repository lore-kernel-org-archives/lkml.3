Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaHDKAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:00:41 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:59682 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaHDKAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140714145543.GB11477@kroah.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1401972778-5880-6-git-send-email-heikki.krogerus@linux.intel.com>
	<53C3767A.9000203@ti.com>
	<20140714145543.GB11477@kroah.com>
Date: Mon, 4 Aug 2014 15:30:38 +0530
X-Google-Sender-Auth: _ZZIzR7JbgcvH0m0EruKXzjW9WI
Message-ID: <CAFp+6iF=Q5twhXwRVdwUYi7mOPvqQoRBu7=RG9tS7ORxOwvS+Q@mail.gmail.com>
Subject: Re: [PATCHv2 5/6] base: platform: name the device already during allocation
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 8:25 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 14, 2014 at 11:49:38AM +0530, Kishon Vijay Abraham I wrote:
>> Greg,
>>
>> On Thursday 05 June 2014 06:22 PM, Heikki Krogerus wrote:
>> > This allows resources such as GPIOs and clocks, which can be
>> > matched based on the device name when requested, to be
>> > assigned even when PLATFORM_DEVID_AUTO is used.
>>
>> Any comments on this patch?
>
> I thought I rejected it in the past, don't have my email archives
> around at the moment, sorry.
>
>
>> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Are we planning a different approach for this ?
Since we are basing the phy-calibration patches for phy-exynos5-usbdrd
on this series
and we need to register the phy lookup table in DWC3, and get the PHYs
in xhci-plat.

The following patch in this series (which is based on this change)
help us achieve that :
[PATCHv2 6/6] usb: dwc3: host: convey the PHYs to xhci
(https://lkml.org/lkml/2014/6/5/585)

>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > ---
>> >  drivers/base/platform.c | 77 ++++++++++++++++++++++++++++++-------------------
>> >  1 file changed, 47 insertions(+), 30 deletions(-)
>> >
>> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> > index 9e9227e..e856bc4 100644
>> > --- a/drivers/base/platform.c
>> > +++ b/drivers/base/platform.c
>> > @@ -177,11 +177,45 @@ struct platform_object {
>> >   */
>> >  void platform_device_put(struct platform_device *pdev)
>> >  {
>> > -   if (pdev)
>> > -           put_device(&pdev->dev);
>> > +   if (!pdev)
>> > +           return;
>> > +
>> > +   if (pdev->id_auto) {
>> > +           ida_simple_remove(&platform_devid_ida, pdev->id);
>> > +           pdev->id = PLATFORM_DEVID_AUTO;
>> > +   }
>> > +
>> > +   put_device(&pdev->dev);
>> >  }
>> >  EXPORT_SYMBOL_GPL(platform_device_put);
>
> Why would a single call to this function remove an id?  That seems
> really wrong, you should be able to call get and put on a device
> numerous times, only the "last" reference should cause the device to be
> cleaned up.
>
> Shouldn't this be in the release function instead?
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
