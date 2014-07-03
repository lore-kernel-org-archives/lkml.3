Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbaGCKHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:07:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48376 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaGCKHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:07:39 -0400
Message-ID: <53B52B3B.4010507@ti.com>
Date: Thu, 3 Jul 2014 15:36:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH 3/5] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org> <1404133317-25953-4-git-send-email-lee.jones@linaro.org> <53B3DCBC.8000105@ti.com> <20140703080758.GI30534@lee--X1>
In-Reply-To: <20140703080758.GI30534@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 03 July 2014 01:37 PM, Lee Jones wrote:
> On Wed, 02 Jul 2014, Kishon Vijay Abraham I wrote:
>> On Monday 30 June 2014 06:31 PM, Lee Jones wrote:
>>> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
>>> devices. It has 2 ports which it can use for either; both SATA, both
>>> PCIe or one of each in any configuration.
>>>
>>> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> Removed.
> 
>>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>>> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>  drivers/phy/Kconfig         |  10 +
>>>  drivers/phy/Makefile        |   1 +
>>>  drivers/phy/phy-miphy365x.c | 630 ++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 641 insertions(+)
>>>  create mode 100644 drivers/phy/phy-miphy365x.c
> 
> [...]
> 
>>> +struct miphy365x_dev {
>>> +	struct device *dev;
>>> +	struct mutex miphy_mutex;
>>> +	struct miphy365x phys[ARRAY_SIZE(ports)];
>>
>> Avoid using fixed array sizes for ports or channels. Refer [1].
> 
> Just addressing this point in this mail.  Any other subsequent points
> will either be fixed up or addressed in other correspondence.
> 
> I don't agree with this point.  I don't believe the number of channels
> should be dictated by the number of DT sub-nodes supplied.  Instead,

But that's the way it is. The DT describes your hw and not the driver. However
the driver may not support everything that is in the hw.
> the driver should contain knowledge about what is supported and
> validate the DT data accordingly.  If it's omitted we lose the ability

IMO the driver cannot validate DT data, it can just return error if there is
something the _driver_ cannot support.
> to conduct any kind of bounds checking, such like the following: 
> 
>         if (WARN_ON(port >= ARRAY_SIZE(ports)))
>                 return ERR_PTR(-EINVAL);

Just as I mentioned in the other patch, 'ports' shouldn't be needed at all. If
we directly give phandle to the sub-node, it won't be needed.
> And
>         if (child_count != ARRAY_SIZE(ports)) {
>                 dev_err(&pdev->dev, "%d ports supported, %d supplied\n",
>                         ARRAY_SIZE(ports), child_count);
>                 return -EINVAL;
>         }
> 
> If at a later point, we need to expand the driver to support a new
> chip which supports more channels/ports then we need to expand the
> bounds checking based on match data extracted from the supplied
> compatible string.  For instance, if a 4 port controller is being used
> and only 2 channels have been supplied, or vice versa then probe()
> should fail.

I don't think error checking of this sort should be done in driver. The dt
_should_ know what is the controller that is being used.

Cheers
Kishon
