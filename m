Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbaGYKcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:32:47 -0400
Received: from router.aksignal.cz ([188.175.113.102]:58191 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaGYKcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:32:46 -0400
Message-ID: <53D23246.1010300@aksignal.cz>
Date: Fri, 25 Jul 2014 12:32:38 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>	<53D10C50.50305@aksignal.cz>	<20140724162645.4e19c26c@bbrezillon>	<53D12103.3020103@aksignal.cz>	<20140724175848.44f5da10@bbrezillon>	<53D1F5D0.1080006@aksignal.cz>	<20140725095319.16a8465c@bbrezillon>	<53D214E1.4050105@aksignal.cz>	<20140725104553.403921b1@bbrezillon>	<53D21B3F.7060006@aksignal.cz>	<20140725110124.3f0dce6c@bbrezillon>	<53D21FCF.7010402@aksignal.cz>	<20140725113110.70c4aa41@bbrezillon>	<53D22C26.4030208@aksignal.cz> <20140725121804.18b05a5d@bbrezillon>
In-Reply-To: <20140725121804.18b05a5d@bbrezillon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dne 25.7.2014 v 12:18 Boris BREZILLON napsal(a):
>> / # devmem 0xfffff408
>> 0xF0E04018
>> / # devmem 0xfffff418
>> 0xE0C04000
>> / # devmem 0xfffff438
>> 0x00C04000
>> / # devmem 0xfffff43c
>> 0x13FFD7FB
>> / # devmem 0xfffff458
>> 0x00000000
>> / # devmem 0xfffff468
>> 0xFF223B4E
>> / # devmem 0xfffff470
>> 0x0F000000
>> / # devmem 0xfffff474
>> 0x00000000
>> / # devmem 0xfffff498
>> 0xFFFFFFFF
>>
>> I get thought if is possible that in time of probe fm25 (it's first) is not configured PA14 (it 's last)?
>
> Oh, nice catch!
> I think you've found the origin of this bug.
> Indeed each device is instantiated sequentially and thus when the first
> device is probed (CS0) the last one has not requested it's cs_gpio yet
> (and PA14 is still assigned to periph A).
>
> Declaring cs-pins and referencing them in pinctrl-0 solves the issue
> because in this case all CS pins are requested during controller probe.
>
So, what would be the right fix up? I my patch it's not good idea since some other driver can request pin for other 
peripheral earlier than spi. In board dts it could be new investigating for someone else who don't know this issue. I 
think the best way would be request all cs in early spi init since cs depends on each other and must be all of them in 
right state before any communication on bus. They are part of bus, like miso, mosi, clk, not part of chips. Also they 
are defined in parent spi node, not in child chip node.
Am I right?
