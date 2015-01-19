Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbbASVba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:31:30 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:36967 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbASVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:31:29 -0500
X-IronPort-AV: E=Sophos;i="5.09,429,1418112000"; 
   d="scan'208";a="55125345"
Message-ID: <54BD77AD.3080209@broadcom.com>
Date: Mon, 19 Jan 2015 13:31:25 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Wolfram Sang <wsa@the-dreams.de>,
        =?windows-1252?Q?Uwe_Kleine-K=F6n?= =?windows-1252?Q?ig?= 
	<u.kleine-koenig@pengutronix.de>,
        Arend van Spriel <arend@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <rjui@broadcom.com> <1421695428-19102-1-git-send-email-rjui@broadcom.com> <1421695428-19102-3-git-send-email-rjui@broadcom.com> <20150119194420.GG26493@n2100.arm.linux.org.uk>
In-Reply-To: <20150119194420.GG26493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/19/2015 11:44 AM, Russell King - ARM Linux wrote:
> To see why atomic_t is pure obfuscation:
> 
> typedef struct {
>         int counter;
> } atomic_t;
> 
> So, counter is a plain int.
> 
> On Mon, Jan 19, 2015 at 11:23:47AM -0800, Ray Jui wrote:
>> +static irqreturn_t bcm_iproc_i2c_isr(int irq, void *data)
>> +{
>> +	struct bcm_iproc_i2c_dev *iproc_i2c = data;
>> +	u32 status = readl(iproc_i2c->base + IS_OFFSET);
>> +
>> +	status &= ISR_MASK;
>> +
>> +	if (!status)
>> +		return IRQ_NONE;
>> +
>> +	writel(status, iproc_i2c->base + IS_OFFSET);
>> +	atomic_set(&iproc_i2c->xfer_is_done, 1);
> 
> #define atomic_set(v,i) (((v)->counter) = (i))
> 
> So, this is the same as doing:
> 
> 	iproc_i2c->xfer_is_done.counter = 1;
> 
> which is merely setting the 'int' to 1.
> 
>> +	time_left = wait_for_completion_timeout(&iproc_i2c->done, time_left);
>> +
>> +	/* disable all interrupts */
>> +	writel(0, iproc_i2c->base + IE_OFFSET);
>> +
>> +	if (!time_left && !atomic_read(&iproc_i2c->xfer_is_done)) {
> 
> #define atomic_read(v)  ACCESS_ONCE((v)->counter)
> 
> This is practically the same as:
> 
> 	if (!time_left && !iproc_i2c->xfer_is_done.counter) {
> 
> except that this access will be guaranteed to happen just once at this
> location (see ACCESS_ONCE() in include/linux/compiler.h).
> 
> However, complete()..wait_for_completion() ensures that there are
> barriers in the way: complete takes a spinlock on the waiter, so the
> write to iproc_i2c->xfer_is_done.counter will be visible by the time
> wait_for_completion() returns, and wait_for_completion() also does.
> The same spinlock is also manipulated by wait_for_completion(), which
> means there's barriers there as well, so it can't cache the value of
> "counter" across that call.
> 
> So, the "volatile" access guaranteed by ACCESS_ONCE() isn't even
> needed here.
> 
> (It would be needed if you were spinning in a loop, calling no other
> functions - but then you're supposed to use cpu_relax() in that
> circumstance, which has a compiler barrier in it, which ensures that
> it will re-read such a variable each time.)
> 
I really learned a good lesson here. Thanks for the thorough explanation!
