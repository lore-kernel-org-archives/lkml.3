Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3HWOlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:41:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48368 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3HWOld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:41:33 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-14-5217749b9ffc
Message-id: <52177499.4020703@samsung.com>
Date: Fri, 23 Aug 2013 16:41:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, robherring2@gmail.com, grant.likely@linaro.org,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 1/4] clk: add common __clk_get(),
 __clk_put()	implementations
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com>
 <1377020063-30213-2-git-send-email-s.nawrocki@samsung.com>
 <20130820203034.GC17845@n2100.arm.linux.org.uk>
In-reply-to: <20130820203034.GC17845@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xy7qzS8SDDNbPFLKY+vAJm8X7jfOY
	LA782cFo0fOn0uJs0xt2i86JS9gtNj2+xmpxedccNosJUyexW8z5M4XZ4vZlXosDT5azWTyd
	cJHN4tIeFYvv374BjfjpaPF03RJmi/UzXrNYLGz4wm5xc8IPZgcRj5bmHjaPldO9PS5/f8Ps
	sXPWXXaPDx/jPGZ3zGT1mD/9EbPHplWdbB53ru1h8zi6ci2Tx+Yl9R67vzYxevRtWcXo8XmT
	XABfFJdNSmpOZllqkb5dAlfG3M+XWQtOcVW0nbdqYJzA0cXIySEhYCJxYsoORghbTOLCvfVs
	XYxcHEICSxkldtx8C+V8YpR4OmkVWBWvgJbE2XUf2UBsFgFVid/T/jGD2GwChhK9R/vAakQF
	AiQWLznHDlEvKPFj8j0WEFtEwFTi2qNnzCBDmQVaWCTWPD0CNkhYIEziyPVmRohtWxkl1ra8
	AktwCthIHJjSD2YzC+hI7G+dBmXLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILipPRc
	I73ixNzi0rx0veT83E2MkLj9uoNx6TGrQ4wCHIxKPLwTnMWChFgTy4orcw8xSnAwK4nw7swT
	DxLiTUmsrEotyo8vKs1JLT7EyMTBKdXAaOfw+Hn9U9uD/7d+2+GRxrfu3nQ1F/PaqMlOUbk8
	016G1kvX5X/ULP13ceepbVEsiQHN732qv52rNmx7dUPFMY0/ntHASS0xKOPFcrtPBc9POAYv
	aVuYyJPYvqc9ufXvwhw3i/eOGZanS6buSauX7F+Y0TDnMIPq53MPgy37dZUPp7O3LtmixFKc
	kWioxVxUnAgAY+whsrkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:30 PM, Russell King - ARM Linux wrote:
> On Tue, Aug 20, 2013 at 07:34:20PM +0200, Sylwester Nawrocki wrote:
>> +int __clk_get(struct clk *clk)
>> +{
>> +	if (WARN_ON((!clk)))
>> +		return 0;
> 
> This changes the behaviour of clk_get()

My bad, will remove that.

>> +
>> +	if (!try_module_get(clk->owner))
>> +		return 0;
> 
> If you want this to be safe against NULL pointers, just do this:
> 
> 	if (clk && !try_module_get(clk->owner))
> 		return 0;

Ok, that should work too.

>> +
>> +	return 1;
>> +}
>> +EXPORT_SYMBOL(__clk_get);
>> +
>> +void __clk_put(struct clk *clk)
>> +{
>> +	if (!clk || IS_ERR(clk))
>> +		return;
>> +
>> +	module_put(clk->owner);
> 
> Calling clk_put() with an error-pointer should be a Bad Thing and something
> that shouldn't be encouraged, so trapping it is probably unwise.  So, just
> do here:
> 
> 	if (clk)
> 		module_put(clk->owner);
> 
> If we do have some callers of this with ERR pointers, then we could add:
> 
> 	if (WARN_ON_ONCE(IS_ERR(clk)))
> 		return;
> 
> and remove it after a full kernel cycle or so.

I wouldn't be surprised to see some callers with ERR pointers, since
clk_put() has been mostly a no op. I'm inclined to leave such a check
temporarily, let's see if it catches any issues.

Thanks for review of the other patches.
