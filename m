Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbaKMTcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:32:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaKMTcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:32:02 -0500
Message-ID: <5465072F.6040509@codeaurora.org>
Date: Thu, 13 Nov 2014 11:31:59 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Kevin Hilman <khilman@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com> <5461150B.2010907@codeaurora.org> <54616CB3.5000405@gmail.com> <54616F74.5010408@codeaurora.org> <54618077.9000108@gmail.com> <5463A381.9060305@gmail.com>
In-Reply-To: <5463A381.9060305@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 10:14 AM, Frank Rowand wrote:
> On 11/10/2014 7:20 PM, Frank Rowand wrote:
>> On 11/10/2014 6:07 PM, Stephen Boyd wrote:
>>> On 11/10/2014 05:56 PM, Frank Rowand wrote:
>>>> On 11/10/2014 11:42 AM, Stephen Boyd wrote:
>>>>> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
>>>>> index 09364dd8cf3a..d1bc6b6cbc70 100644
>>>>> --- a/drivers/tty/serial/msm_serial.c
>>>>> +++ b/drivers/tty/serial/msm_serial.c
>>>>> @@ -1046,14 +1046,14 @@ static int msm_serial_probe(struct platform_device *pdev)
>>>>>  	const struct of_device_id *id;
>>>>>  	int irq, line;
>>>>>  
>>>>> -	if (pdev->id == -1)
>>>>> -		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
>>>>> -
>>>>>  	if (pdev->dev.of_node)
>>>>>  		line = of_alias_get_id(pdev->dev.of_node, "serial");
>>>>>  	else
>>>>>  		line = pdev->id;
>>>>>  
>>>>> +	if (line < 0)
>>>>> +		line = atomic_inc_return(&msm_uart_next_id) - 1;
>>>>> +
>>>>>  	if (unlikely(line < 0 || line >= UART_NR))
>>>> Then this original check for "line < 0" can also be removed.
>>>>
>>>>
>>> Well this matches what was there before. It would do atomic_inc_return
>>> if the line was negative and then still check for a negative value. I
>>> don't mind removing it though. Perhaps we should use an ida?:
>>>
>> OK, you are right.  If (pdev->id < -1) and (!pdev->dev.of_node) then
>> the check is still needed.
>>
>> You could use an ida.  Some drivers use a bit map.  I really don't think
>> this should become a complicated algorithm though.  If the rule is that
>> either all UARTS have an alias, or no UART has an alias, then I think
>> the patch could be something like the following.
>>
>> This combines your original patch, plus your fix patch, plus making
>> the aliases all or nothing.  Not tested, not even compiled.
>>
>> What do you think?
> < snip - previous version of patch >
>
> Previous version of the patch did not protect against no alias, followed
> by alias.
>
>
>
> From: Frank Rowand <frank.rowand@sonymobile.com>
>
> This patch is intended to show roughly what an implementation of an all or
> nothing policy for using serialN aliases would look like.  It is intended
> simply to help determine whether this policy should be used.
>
> Combines Stephen's first patch, Stephen's fix patch (to make the serialN
> alias optional), plus makes use of the serialN alias all or nothing (either
> all ports have an alias or none do).
>
> This is not a correct implementation because the atomic_read(&msm_uart_next_id)
> does not protect against concurrency; instead a lock should be used.
>
> Not tested, not even compiled.

Sorry, I'm sort of lost. If there are serial aliases in the dts file,
then we should alias all of the serial ports. If there aren't aliases
then we're backwards compatible with the dts we have now and we'll do
dynamic generation. Putting code into the driver to validate that this
is true is not the job of the driver. If anything, it should validated
when the dts file is created. If one day we screw up and have a dts file
with such a bad configuration we'll have to work around it, but until
that day comes I'd rather not think about it.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

