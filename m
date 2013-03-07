Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3CGFUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 00:20:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12782 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CGFUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 00:20:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="28001017"
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] platform-drivers: msm: add single-wire serial bus interface (SSBI) driver
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
	<1362616187-21089-2-git-send-email-davidb@codeaurora.org>
	<20130307013008.GA2910@kroah.com>
Date: Wed, 06 Mar 2013 21:20:45 -0800
In-Reply-To: <20130307013008.GA2910@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 7 Mar 2013 09:30:08 +0800")
Message-ID: <8yawqtjvl8y.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Mar 06, 2013 at 04:29:42PM -0800, David Brown wrote:
>> +menu "Qualcomm MSM SSBI bus support"
>> +	depends on ARCH_MSM
>
> Why?

In the sense that ARCH_MSM are the only devices that ever were, or ever
will be made with this device.  It doesn't strictly depend on it, but do
we want to clutter the config for everything else.

>> +config MSM_SSBI
>> +	bool "Qualcomm Single-wire Serial Bus Interface (SSBI)"
>
> Why can't this be a module?

Without this device, the PMIC drivers won't work, regulators can't be
turned on, and most of the other devices won't work.  I can try if it
can still be made a module, and it might be good at exercising the
deferred probe mechanism.

So, a deeper question.  I've resent this driver with minimal change.
I've also made some other changes as patches afterwards.  Do we want
these squashed into a single patch, or the initial one (not authored by
me) followed by updates?

>> +#
>> +# Makefile for the MSM specific device drivers.
>
> MSM?
>
> No comment needed at all in this file :)

Thanks, missed this.  I think the original patch was using platform/msm,
and the minimalist comment almost made sense in that context.

>> +struct msm_ssbi {
>> +	struct device		*dev;
>> +	struct device		*slave;
>
> Really?  Two pointers to devices?  Why?  Shouldn't this have a struct
> device embedded in it instead of the dev member being a pointer?

I'll go through this more thoroughly and organize things better.

>> +static int ssbi_wait_mask(struct msm_ssbi *ssbi, u32 set_mask, u32 clr_mask)
>> +{
>> +	u32 timeout = SSBI_TIMEOUT_US;
>> +	u32 val;
>> +
>> +	while (timeout--) {
>> +		val = ssbi_readl(ssbi, SSBI2_STATUS);
>> +		if (((val & set_mask) == set_mask) && ((val & clr_mask) == 0))
>> +			return 0;
>> +		udelay(1);
>
> Busy loop?  Really?

I'm not sure what else to do here.  The controller is only slightly more
than a bit-banged bus.  I think the reason for the longer possibly delay
is because there is an arbiter (the PMIC is shared with the radio CPU).
I'll investigate further.

>> +	}
>> +
>> +	dev_err(ssbi->dev, "%s: timeout (status %x set_mask %x clr_mask %x)\n",
>> +		__func__, ssbi_readl(ssbi, SSBI2_STATUS), set_mask, clr_mask);
>
> Why polute the log with this?  What can a user do with it?

Nothing in fact, other than possibly learn that things, indeed aren't
working.  I'll take it and the others out.

>> +static int
>> +msm_ssbi_write_bytes(struct msm_ssbi *ssbi, u16 addr, u8 *buf, int len)
>> +{
>> +	int ret = 0;
>> +
>> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
>> +		u32 mode2 = ssbi_readl(ssbi, SSBI2_MODE2);
>> +		mode2 = SET_SSBI_MODE2_REG_ADDR_15_8(mode2, addr);
>> +		ssbi_writel(ssbi, mode2, SSBI2_MODE2);
>> +	}
>
> Perhaps have a controller type write function that can handle this type
> of stuff instead of putting it in the "generic" write path?

Yes, that's a better approach.

>> +EXPORT_SYMBOL(msm_ssbi_read);
>
> msm_*?  Why not just ssbi_*?

I'm fine with ssbi.  It is very MSM specific, though.

> EXPORT_SYMBOL_GPL()?

Yes, it's definitely a kernel internal API.

>> +static struct platform_driver msm_ssbi_driver = {
>> +	.probe		= msm_ssbi_probe,
>> +	.remove		= __exit_p(msm_ssbi_remove),
>
> You just oopsed if someone unbound your device from the driver from
> userspace.  Not good.

I did catch this one in a later patch :-)  I can clean it up in the
driver, though, since it looks like some more work needs to go into
this.

Thanks,
David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
