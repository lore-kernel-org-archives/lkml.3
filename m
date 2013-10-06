Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3JFUZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:25:00 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33558 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab3JFUY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:24:59 -0400
Message-ID: <5251E334.2070008@gmail.com>
Date: Mon, 07 Oct 2013 00:24:52 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Mike Turquette <mturquette@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: provide public clk_is_enabled function
References: <1380881310-24345-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131005202430.GI10079@pengutronix.de> <20131005204208.GB28106@lunn.ch> <20131006090609.GK14747@book.gsilab.sittig.org> <20131006163011.GA30818@lunn.ch> <5251BD09.3050900@gmail.com> <20131006200223.32214.4440@quantum>
In-Reply-To: <20131006200223.32214.4440@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 10:02 PM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2013-10-06 12:42:01)
>> On 10/06/2013 06:30 PM, Andrew Lunn wrote:
>>> On Sun, Oct 06, 2013 at 11:06:09AM +0200, Gerhard Sittig wrote:
>>>> What's wrong with an explicit enable/disable around the data
>>>> acquisition?
>>>
>>> It avoids the CPU locking hard, but will not get us a valid MAC
>>> address, which is the point of the exercise.
>>
>> While I agree to all Andew explained above, I somehow have the strong
>> feeling that an clk_is_enabled will just be abused where possible. We
>> already have two ppl complaining about it - even though a quick look at
>> clk/core.c should have cleared out most of it.
>>
>> Maybe we should just enable the clock, get the (possibly bogus) MAC
>> and disable it again. We loose one possible FW_BUG report and overwrite
>> an invalid local-mac-address property with another invalid one.
>
> Firstly, I'm OK with adding a new clk_is_enabled API for The Right
> Reasons, if we can figure out what those reasons are. A major concern is
> the lack of locks/barriers around that call that create a critical
> section where the enabled state is guaranteed not to change. Those locks
> are not exported to drivers nor do I want them to be.
>
> Secondly, this specific Ethernet/MAC address issue seems like another
> case of "the driver should be calling clk_get and clk_prepare_enable but
> for some reason it doesn't". This seems to be a common pattern and I'm
> not sure why. Does calling clk_enable on your clock which has been

Ok, the driver is doing clk_prepare_enable/disable_unprepare just fine.
It has nothing to do with the driver but the workaround for broken HW
explained below.

> already enabled by the bootloader cause issues for you? If not then it
> is better to just call clk_enable and have the clock framework book
> keeping in-sync with the hardware state.
>
> Is it possible in your case to only detect the invalid MAC address
> without sniffing the state of the clock hardware? Isn't it valid to
> report a bootloader bug after only looking at the MAC address and not
> the clock enabled state?

The ethernet IP used on Kirkwood (mv643xx_eth) is loosing the MAC
address register contents on gated clocks. Everything was fine without
DT and CCF, because clocks had to be enabled by bootloader. With DT and
CCF, we gained clock gating but realized that IP has this flaw. For
built-in ethernet driver usually everything is just fine, because driver
picks up clock early and it never gets gated.

As people were complaining about modular ethernet driver, we thought
about how to (a) work around non-DT aware boot loaders, which we have
a lot of and its not likely to change soon nor quick and (b) gate those
clocks if possible.

The workaround until now was to always enable the clocks in board init
code, leaving clocks running. Now we want to switch to update the DT
with the MAC address possibly found in those registers. It is also done
on some other machs and archs, so I guess it is not uncommon do
workaround broken/unaware bootloaders this way.

The idea is to check nodes status and skip already disabled nodes. For
enabled nodes, check the MAC address properties and skip those with
valid MAC. Now, my initial workaround was to read registers for those
left and copy the MAC address to local-mac-address property.

Andrew has mentioned, that some bootloaders might disable clocks but
leave the nodes enabled. Reading those registers would lock up
the HW, of course. So we thought about to check clk gate status first,
which this patch is about.

Of course, we can do clk_enable, read, clk_disable as said before - and
given the amount of questions and misinterpretation, I think it is the
saner way.

Sebastian
