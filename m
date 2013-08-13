Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3HMJXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:23:04 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51108 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3HMJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:23:01 -0400
Message-ID: <5209FAF0.5040807@gmail.com>
Date: Tue, 13 Aug 2013 11:22:56 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 1/9] PCI: mvebu: move clock enable before register access
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-2-git-send-email-sebastian.hesselbarth@gmail.com> <20130813091106.326c562a@skate>
In-Reply-To: <20130813091106.326c562a@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/13 09:11, Thomas Petazzoni wrote:
> On Mon, 12 Aug 2013 20:46:47 +0200, Sebastian Hesselbarth wrote:
>> +		port->clk = of_clk_get_by_name(child, NULL);
>> +		if (IS_ERR(port->clk)) {
>> +			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
>> +			       port->port, port->lane);
>> +			iounmap(port->base);
>
> You shouldn't iounmap() here in case of error, since the register
> mapping hasn't been done yet.

Dooh, it was in my testing branch, but I failed to transfer that when
separating the changes to single patches. Will update.

>> +			port->haslink = 0;
>> +			continue;
>> +		}
>> +		clk_prepare_enable(port->clk);
>
> Nitpick, an empty new line between the closing } and the
> clk_prepare_enable() line would be nice.

Ok, as Theirry mentioned to check for clk_prepare_enable's return value
that would give a new "if (..)" anyway. Although, it might be the first
driver ever checking for this return value ;)

>> +
>>   		port->base = mvebu_pcie_map_registers(pdev, child, port);
>>   		if (!port->base) {
>>   			dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
>> @@ -916,22 +926,9 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
>>   				 port->port, port->lane);
>
> and maybe here you could unprepare+release the clock if we haven't
> managed to remap registers?

Ack.

Sebastian
