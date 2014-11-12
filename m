Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaKLTur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:50:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57938 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLTup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:50:45 -0500
Message-ID: <5463B9F7.8040105@ti.com>
Date: Wed, 12 Nov 2014 13:50:15 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv6 5/5] hwspinlock/omap: add support for dt nodes
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-6-git-send-email-s-anna@ti.com> <CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
In-Reply-To: <CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 11/12/2014 01:14 PM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Fri, Sep 12, 2014 at 11:24 PM, Suman Anna <s-anna@ti.com> wrote:
>>  static int omap_hwspinlock_probe(struct platform_device *pdev)
>>  {
>> -       struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
>> +       struct device_node *node = pdev->dev.of_node;
>>         struct hwspinlock_device *bank;
>>         struct hwspinlock *hwlock;
>>         struct resource *res;
>>         void __iomem *io_base;
>> -       int num_locks, i, ret;
>> +       int num_locks, i, ret, base_id;
>>
>> -       if (!pdata)
>> +       if (!node)
>>                 return -ENODEV;
>>
>> +       ret = of_hwspin_lock_get_base_id(node);
>> +       if (ret < 0 && ret != -EINVAL)
>> +               return -ENODEV;
>> +       base_id = (ret > 0 ? ret : 0);
> 
> Does this mean you allow nodes not to have the base_id property? How
> do we protect against multiple nodes not having a base_id property
> then?
> 
> Implicitly assuming a base_id value (zero in this case) may not be always safe.

None of the OMAPs have multiple IP instances, and as such the base-id is
an optional property. I have made this change to make sure we atleast
attempt to use the value if mentioned in DT and not hard-coding the
value to begin with (going by the optional property semantics). If and
when multiple instances get added and a secondary node doesn't add the
property, the node will not be registered with the core due to an
overlap failure. Here is the previous version [1] for reference.

regards
Suman

[1] https://patchwork.kernel.org/patch/4096881/
