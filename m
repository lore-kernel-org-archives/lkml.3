Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaGHRzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:55:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56919 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbaGHRzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:55:43 -0400
Message-ID: <53BC3081.9010402@ti.com>
Date: Tue, 8 Jul 2014 12:55:13 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@ucw.cz>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
References: <1403660878-56350-1-git-send-email-s-anna@ti.com> <1403660878-56350-3-git-send-email-s-anna@ti.com> <20140628170709.GB23634@xo-6d-61-c0.localdomain> <53B18999.2020506@ti.com> <20140630185942.GA5410@amd.pavel.ucw.cz> <53B1BBA8.5090507@ti.com> <20140630203225.GA3893@amd.pavel.ucw.cz> <20140704064547.GZ28884@atomide.com> <20140704080556.GA16274@amd.pavel.ucw.cz> <20140704082354.GD28884@atomide.com>
In-Reply-To: <20140704082354.GD28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Pavel,

On 07/04/2014 03:23 AM, Tony Lindgren wrote:
> * Pavel Machek <pavel@ucw.cz> [140704 01:07]:
>> Hi!
>>
>>>>>>>>> The non-DT support has to be maintained for now to not break
>>>>>>>>> OMAP3 legacy boot, and the legacy-style code will be cleaned
>>>>>>>>> up once OMAP3 is also converted to DT-boot only.
>>>>>>>>
>>>>>>>>> @@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
>>>>>>>>>  	return 0;
>>>>>>>>>  }
>>>>>>>>>  
>>>>>>>>> +static const struct omap_mbox_device_data omap2_data = {
>>>>>>>>> +	.num_users	= 4,
>>>>>>>>> +	.num_fifos	= 6,
>>>>>>>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +static const struct omap_mbox_device_data omap3_data = {
>>>>>>>>> +	.num_users	= 2,
>>>>>>>>> +	.num_fifos	= 2,
>>>>>>>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +static const struct omap_mbox_device_data am335x_data = {
>>>>>>>>> +	.num_users	= 4,
>>>>>>>>> +	.num_fifos	= 8,
>>>>>>>>> +	.intr_type	= MBOX_INTR_CFG_TYPE2,
>>>>>>>>> +};
>>>>>>>>
>>
>>>> Aha, ok, then the intr_type should be derived from
>>>> compatible-string. Or rather... you should have three
>>>> compatible-strings for the three possibilities? (And then subtype,
>>>> currently unused, in case there are more hw differences).
>>>
>>> The compatible string can and should be separate for each revision
>>> unless they are the same exacat hardware revision.
>>
>> ACK.

I checked the revision register from all SoCs. OMAP2 and OMAP3 have
different revisions compared to OMAP4+. All of OMAP4, OMAP5, DRA7,
AM335x and AM437x have the same version, but with different num-fifos
and num-users.  So, I can switch back to using omap4-mailbox for all of
these SoCs only if we encode the num-fifos and num-users in DT.

>>
>>>>> two are HW IP design parameters, so in general putting them in DT isn't
>>>>> completely a bad idea, but I will wait to see if there are any further
>>>>> comments on this from Tony or DT maintainers before I make changes.
>>>>
>>>> Ok, right... I'd vote for putting them into DT.
>>>
>>> I would avoid adding custom DT properties where possible and let the
>>> driver just initialize the right data based on the compatible flag.
>>
>> If these are HW IP design parameters, we can expect to see many
>> different combinations. Yet we know ahead of time how to handle
>> different parameters HW people select.

That's right, the above OMAP4+ SoCs already demonstrate this behavior.

>>
>> Thus IMO we should do it in the device tree.
> 
> Oh you mean from supporting new hardware with just .dts changes?
> From that point of view it makes sense to have them as DT properties,
> so I'm fine with that.
> 
> Let's just try to use something that's generic like fifosize. No idea
> how the property for num_fifos should be handled though as that
> implies some knowledge in the driver which num_users have fifos?

The fifos are not per num_users, but rather the total number of fifos
within the IP block. The num_users will be the number of targets the IP
block can interrupt. I tried looking for generic properties, but there
weren't any that seem to fit the description. If you want generic names,
I can use num-fifos and num-users, otherwise will stick to the
names defined in the previous series.

> 
> So unless that can be described clearly in a DT property as well,
> the binding might be still unusable for new hardware :)
> 

I don't expect the OMAP mailbox IP to change much in the future. There
is a FIFO depth parameter as well, but that's constant in all the
current versions, and even if they change it, I can already use the
generic property for that.

Tony,
Depending on the agreement here, I may have to respin the OMAP
mailbox DT/hwmod cleanup series [1]

regards
Suman

[1] http://marc.info/?l=linux-omap&m=140365833121612&w=2

