Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaAHNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:09:58 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48118 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaAHNJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:54 -0500
MIME-Version: 1.0
In-Reply-To: <2078358.4WniMksEuS@amdc1032>
References: <1388408823-4963-1-git-send-email-yuvaraj.cd@samsung.com>
	<11600750.UKZ7EpemHS@amdc1032>
	<CAKuRcOJVQ9U_4rpUf-6+=nbO=UoNkkTU5ttmRqfWxi4_nh7fag@mail.gmail.com>
	<2078358.4WniMksEuS@amdc1032>
Date: Wed, 8 Jan 2014 18:39:52 +0530
Message-ID: <CAKuRcOK73rpH_qJu-tNRjsBNA20B0_w7EiA-Xw6vVTc-arygkA@mail.gmail.com>
Subject: Re: [PATCH V4 1/2] Phy: Exynos: Add Exynos5250 sata phy driver
From: Yuvaraj Kumar <yuvaraj.cd@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Jingoo Han <jg1.han@samsung.com>, sunil joshi <joshi@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 7:52 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> On Thursday, January 02, 2014 07:03:23 PM Yuvaraj Kumar wrote:
>> On Tue, Dec 31, 2013 at 9:00 PM, Bartlomiej Zolnierkiewicz
>> <b.zolnierkie@samsung.com> wrote:
>
>> >> @@ -8,3 +8,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)   += phy-exynos-mipi-video.o
>> >>  obj-$(CONFIG_PHY_MVEBU_SATA)         += phy-mvebu-sata.o
>> >>  obj-$(CONFIG_OMAP_USB2)                      += phy-omap-usb2.o
>> >>  obj-$(CONFIG_TWL4030_USB)            += phy-twl4030-usb.o
>> >> +obj-$(CONFIG_EXYNOS5250_SATA_PHY)    += sata_phy_exynos5250.o exynos5250_phy_i2c.o
>> >
>> > Will this compile/work without I2C support?
>> No.I missed this.It will not compile without I2C support.
>> How about  below change in drivers/phy/Kconfig ?
>> config EXYNOS5250_SATA_PHY
>> select I2C
>> select I2C_S3C2410
>
> Fine with me.
>
>> > CONFIG_EXYNOS5250_SATA_PHY doesn't require it currently.
>> I didnt get this. what it doesn't require?
>
> It doesn't require I2C.  If you add above I2C selects it will be OK.
>
>> >> +struct i2c_driver sataphy_i2c_driver = {
>> >
>> > Keeping it global together with sataphy_attach_i2c_client() is not very
>> > nice.  I've talked with our local device tree guru (a.k.a. Tomasz Figa)
>> > about this and it may be that this i2c driver is not even necessary.
>> Can you elaborate more on this?
>
> The usage of the global i2c driver is not a proper solution.
>
> i2c driver should register itself in the driver init function
do you mean i2c-s3c2410.c driver?
> (which is not present currently) instead of being registered by
> the SATA PHY driver.
>
> The SATA PHY driver should find i2c client device using DT.
>
> sataphy_attach_i2c_client() should then be removed.
>
>> > If you manage to extract i2c adapter and address data from the device
>> > tree (using proper of_* methods) they can be used instead of i2c client
>> > data in the SATA PHY driver.
>> I think the above is true, if the complete SATA PHY controller sits on
>> the i2c adapter.
>> But in Exynos5250 case,only the few configurations ( CMU and TRSV
>> blocks ) SATA PHY
>> are done through I2C(channel 9). Correct me if i am wrong.
>
> Well, it shouldn't matter if all or only some of the configuration of
> the SATA PHY controller is done through i2c.
>
> Anyway, how about another idea -> adding a new phandle of i2c client
> device to SATA PHY DT entry and using DT in the SATA PHY driver to
> find i2c client device?
>
> i.e. "samsung,exynos-sataphy-i2c-phandle" property in SATA PHY
> controller DT entry can point at existing "sata-phy@38" sataphy i2c
> client DT entry (by adding new label to it, i.e. "sata_phy_i2c").
>
> Such new phandle can be used first to find the DT device node of i2c
> device (by using of_parse_phandle(), if it returns NULL the error
> should be returned) and then later to find proper i2c client device
> (by using of_find_i2c_device_by_node(), if it returns NULL deferred
> probing should be requested by returning -EPROBE_DEFER).
I can get the i2c_client structure,but how the client driver binding
happens to registered device?
Currently with this approach i2c client device is being registered but
cleint driver could not able to bind with the device.
[    0.082680] i2c i2c-9: adapter [s3c2410-i2c] registered
[    0.082691] i2c i2c-9: of_i2c: walking child nodes
[    0.082696] i2c i2c-9: of_i2c: register /i2c@121D0000/sata-phy@38
[    0.082794] i2c 9-0038: uevent
[    0.082845] i2c i2c-9: client [exynos-sataphy-i2c] registered with
bus id 9-0038
[    0.082851] s3c-i2c 121d0000.i2c: i2c-9: S3C I2C adapter
>
> i2c@121D0000 {
>         ...
>         sata_phy_i2c: sata-phy@38 {
>                 ...
>         };
>         ...
> };
>
> sata_phy: sata-phy@12170000 {
>         ...
>         samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
>         ...
> };
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
