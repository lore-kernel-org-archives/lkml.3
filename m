Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaJXTmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:42:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34271 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJXTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:42:50 -0400
Message-ID: <544AABB8.10302@codeaurora.org>
Date: Fri, 24 Oct 2014 12:42:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Andersson <bjorn@kryo.se>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com> <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com> <alpine.DEB.2.11.1410211120430.5308@nanos>	<544628BF.8010809@arm.com> <CAJAp7OjpN-+S=OH1BW6Fcme9mp4qj8AsSNC3_41fhfpYzX-Shg@mail.gmail.com> <544A936D.5040409@arm.com>
In-Reply-To: <544A936D.5040409@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 10:59 AM, Marc Zyngier wrote:
> Hi Bjorn,
>
> On 24/10/14 18:31, Bjorn Andersson wrote:
>>
>> Stephen Boyd talked about the need to be able to mask/unmask interrupts from
>> client code in the Qualcomm platform as well - most likely to block wakeup
>> sources(?)
> What's wrong with irq_disable?

The problem is irq_disable() is lazy and doesn't actually disable the
interrupt.

This is the scenario. During idle we want to communicate with another
processor in the SoC and tell it to turn off something after we go to
idle. The communication mechanism uses some shared memory and an
interrupt to trigger the other processor to go look at what we told it
to do. When the other processor is done handling the message it will
send us an ack interrupt. We want to temporarily ignore that ack
interrupt because 1) we're going to execute a wfi to trigger a deep idle
and any pending interrupt will abort that instruction and 2) if the
interrupt comes after we execute the wfi it will wake us up out of deep
idle unnecessarily and waste power. There isn't anything in the
communication protocol that says we don't want the interrupt to be sent
and it would probably make things more complicated anyway. The solution
is to mask the interrupt before we send the message, and then execute
the wfi. Once we wake up, we unmask the interrupt and then handle the ack.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

