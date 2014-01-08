Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaAHNOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:14:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbaAHNOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:14:34 -0500
Message-ID: <52CD4F2A.9080301@redhat.com>
Date: Wed, 08 Jan 2014 14:14:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>
CC: tj@kernel.org, sergei.shtylyov@cogentembedded.com,
        b.zolnierkie@samsung.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v3 2/3] ata: ahci_platform: Manage SATA PHY
References: <1389174428-31414-1-git-send-email-rogerq@ti.com> <1389174428-31414-3-git-send-email-rogerq@ti.com> <52CD2176.6050102@ti.com> <6214646.nAF6lzWV79@wuerfel> <52CD364F.4060104@ti.com>
In-Reply-To: <52CD364F.4060104@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/08/2014 12:28 PM, Roger Quadros wrote:
> On 01/08/2014 03:35 PM, Arnd Bergmann wrote:
>> On Wednesday 08 January 2014 15:29:18 Kishon Vijay Abraham I wrote:
>>>> +     hpriv->phy = devm_phy_get(dev, "sata-phy");
>>>> +     if (IS_ERR(hpriv->phy)) {
>>>> +             dev_dbg(dev, "can't get sata-phy\n");
>>>> +             /* return only if -EPROBE_DEFER */
>>>> +             if (PTR_ERR(hpriv->phy) == -EPROBE_DEFER) {
>>>> +                     rc = -EPROBE_DEFER;
>>>> +                     goto disable_unprepare_clk;
>>>> +             }
>>>> +     }
>>
>> This should probably check for all errors except "not present"
>> rather than checking for -EPROBE_DEFER. We want to abort the
>> probe function for deferred probe as well as the case where we
>> a PHY was listed but isn't working properly.
>
> OK.
>
>>
>>>> +     if (!IS_ERR(hpriv->phy)) {
>>>> +             phy_init(hpriv->phy);
>>>
>>> Don't we have to check the return values of phy_init and phy_power_on? Is it
>>> not needed because it is an optional phy?
>>
>> Right. I think we should set hpriv->phy to NULL if it's not there and
>> then call the functions only if it's actually present but bail out on
>> an error.
>
> OK. How does this look?
>
> hpriv->phy = devm_phy_get(dev, "sata-phy");
> if (IS_ERR(hpriv->phy)) {
> 	if (PTR_ERR(hpriv->phy) == -ENODEV)
> 		goto continue;

-ENODEV is not the right errno to check for,
if there is no phy specified in the dt then
you will get -EINVAL (no phy-names property) or
-ENODATA (phy-names property is there but name
not found).

Also you don't want to log an error on
PROBE_DEFERRAL.

Here is what I've for similar code I'm working on
for ehci-platform.c and ohci-platform.c :

                 priv->phy = devm_phy_get(&dev->dev, "phy0");
                 if (IS_ERR(priv->phy)) {
                         err = PTR_ERR(priv->phy);
                         if (err != -EINVAL && err != -ENODATA) {
                                 if (err != -EPROBE_DEFER)
                                         dev_err(&dev->dev,
                                                 "Error getting phy\n");
                                 goto err_put_hcd;
                         }
                         priv->phy = NULL;
                 }

And from then on I simply use "if (priv->phy)" checks, and of course
check phy_init and phy_power_on return values.

Regards,

Hans
