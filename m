Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3KZTxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:53:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34375 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab3KZTxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:53:06 -0500
Message-ID: <5294FC09.2080604@ti.com>
Date: Tue, 26 Nov 2013 13:52:41 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH 1/8] ARM: OMAP: Move public portion of dmtimer.h to include/linux/omap-timer.h
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-2-git-send-email-joelf@ti.com> <20131122153334.GE10023@atomide.com> <52940F32.3000006@ti.com> <20131126182908.GK26766@atomide.com>
In-Reply-To: <20131126182908.GK26766@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 12:29 PM, Tony Lindgren wrote:
[..]
>>> We can implement an irqchip and a clocksource in the dmtimer code for the
>>> client drivers to use, and after that we only have a couple of dmtimer
>>> specific functions left to export.
>>>
>>> I'm thinkging some thing like this for the public API:
>>>
>>> omap_dm_timer_request			request_irq
>>> omap_dm_timer_request_specific		request_irq
>>> omap_dm_timer_get_irq			request_irq
>>> omap_dm_timer_set_source		clk_set_rate
>>
>> For clk_set_rate, how would one directly access the timer node if we've hidden
>> it behind an irq chip abstraction?
>>
>> per your suggestion, one would have something like:
>>
>> dsp {
>>     interrupt-parent = <&timer1>;
>> }
>>
>> so how do you clk_set_rate rate something like this given the dsp node?
> 
> All you have to do is implement a clocksource driver in dmtimer.c code.
>  
>> If the suggestion is to get the timer1 node from the interrupt-parent property,
>> if I may say- that's a bit ugly because now you're breaking the irq chip
>> abstraction just to access the timer node..
> 
> Hmm sorry I don't follow you here.

I assumed above that you were suggesting implementing interrupt chaining like
gpio-omap driver.

Can you give an example workflow to explain your suggestion?

I'll tell you how I understand what you were suggesting and then you can correct
me, and maybe we can meet somewhere:

Typically *without* irqchip or chaining what you suggested, we would  have
something like (purely an example):
dsp {
    timer = <&timer1>;
}

There is an API:
omap_dm_timer *omap_dm_timer_request_by_node(struct device_node *np); that one
would use.

Now moving to your suggestion, the dts would look like:
dsp {
    interrupt-parrent = <&timer1>;
    interrupts = <1>;
}

Naturally some APIs will not fit into the IRQ framework, so these subset of
dmtimer API may need to be exposed as you pointed. To use the API, the timer has
to first be retrieved from interrupt-parent property of "dsp" here to get a
device_node, and then the timer has to be requested and subset API used on it.
This is "hack" that's not acceptable according to me...

thanks,

-Joel

