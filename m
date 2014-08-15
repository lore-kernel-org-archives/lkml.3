Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaHOVqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:46:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52934 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOVqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:46:33 -0400
Message-ID: <53EE7FC9.5010509@wwwdotorg.org>
Date: Fri, 15 Aug 2014 15:46:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
References: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com> <53EE32C7.6000500@wwwdotorg.org> <20140815180218.GH1626@tbergstrom-lnx.Nvidia.com> <53EE4C45.5080805@wwwdotorg.org> <20140815194546.GI1626@tbergstrom-lnx.Nvidia.com> <20140815213442.GJ1626@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140815213442.GJ1626@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 03:34 PM, Peter De Schrijver wrote:
> On Fri, Aug 15, 2014 at 09:45:46PM +0200, Peter De Schrijver wrote:
>> On Fri, Aug 15, 2014 at 08:07:01PM +0200, Stephen Warren wrote:
>>>>> However, the new code sets the clock rate after the clock is prepared. I
>>>>> think the rate should be set first, then the clock prepared. While this
>>>>> likely doesn't apply to the Tegra clock controller, prepare() is allowed
>>>>> to enable the clock if enable() can't be implemented in an atomic
>>>>> fashion (in which case enable/disable would be no-ops), and we should
>>>>> make sure that the driver correctly configures the clock before
>>>>> potentially enabling it.
>>>>>
>>>>> I'm not sure if a similar change to our SPI drivers is possible; after
>>>>> all, the SPI transfer rate can vary per message, so if clk_set_rate()
>>>>> acquires a lock, it seems there's no way to avoid the issue there.
>>>>
>>>> Even for i2c this could be the case I think if you use the highspeed (3.4Mhz)
>>>> mode? From what I remember, a highspeed i2c transaction starts with a lower
>>>> speed preamble to make sure non highspeed slaves don't get confused? Which
>>>> means you could change the bus speed depending on the slave you're addressing.
>>>
>>> Since there's no separate chip-select for I2C, I believe all I2C devices
>>> need to be able to understand the entire transaction, so the I2C bus
>>> speed is fixed.
>>>
>>
>> Does it? I would assume the slave only needs to check if the address matches
>> its own address after a START condition and if not can just wait until the
>> STOP condition appears on the bus?
>>
>
> http://www.nxp.com/documents/user_manual/UM10204.pdf says you can mix them by
> using an interconnect bridge between the highspeed and the non-highspeed
> capable slaves. The bridge uses the special preamble to disconnect the non-
> highspeed part of the bus when a highspeed transaction is ongoing. It's afaics
> transparent to the master.

I expect that works by echoing the slow-speed pre-amble to the 
slow-speed bus segment, then emitting a stop and turning off the echo. 
For actual slow-speed transactions, the whole thing would be echo'd. 
That way the slow-speed devices don't ever see any high-speed pulses.

That all said, that does indeed imply that a master supporting the 
high-speed transactions would need to emit a varying-speed signal. My 
assumption would be that this happens inside the I2C HW, rather than 
under SW control though, since the transition would need to happen 
mid-protocol. Still, perhaps the selection between low-speed and 
high-speed-with-a-slow-preamble might need SW clock programming 
depending on the HW though... Who knows.

