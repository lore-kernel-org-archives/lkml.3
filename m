Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaKDRFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:05:37 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47644 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKDRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:05:35 -0500
Message-ID: <54590755.1070204@linaro.org>
Date: Tue, 04 Nov 2014 17:05:25 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Drake <drake@endlessm.com>
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Medhurst <tixy@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement arch_trigger_all_cpu_backtrace
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org> <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com> <20141014233126.GF27405@n2100.arm.linux.org.uk> <543F90ED.5030005@linaro.org>
In-Reply-To: <543F90ED.5030005@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/14 10:33, Daniel Thompson wrote:
>> The blocker on this work right now is the annoying Versatile Express
>> platform, which pretty much means that we currently can't push the
>> code into the GIC to support FIQs.  As long as adding FIQ support to
>> the GIC results in the Versatile Express becoming non-bootable, the
>> idea of using FIQs is a total non-starter.
>>
>> Or we decide that we dump the platform completely (which will upset
>> a number of developers.)
>>
>> I have patches I'm using for trigger_all_cpu_backtrace() which I'm
>> maintaining privately in my tree until we can get the FIQ situation
>> sorted.
> 
> I do hope to gain (remote) access to a vexpress at some point just to
> pick at this issue a little.

This week with the help of one of my colleagues (thanks Tixy) I have
been able to run some tests and figure out what it going on on vexpress-a9.

The summary is that on some GICv1 implementations the bit to enable
group 1 interrupts cannot be accessed using secure memory accesses. More
specifically the presence/absence of the EnableGrp1 bit in the secure
version GICD_CTRL register is implementation defined.

My original patches overlooked this and as a result the existing code
will migrate all interrupts to group but then cannot enable delivery of
group 1 interrupts.

I'm planning to respin the code so it will automatically disable FIQ
support when the EnableGrp1 bit is not implemented. This means
vexpress-a9 will not benefit from FIQ support but will also not be
harmed by it.
