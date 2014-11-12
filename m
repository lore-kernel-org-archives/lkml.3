Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaKLSOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:14:47 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56814 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaKLSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:14:32 -0500
Message-ID: <5463A381.9060305@gmail.com>
Date: Wed, 12 Nov 2014 10:14:25 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Kevin Hilman <khilman@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com> <5461150B.2010907@codeaurora.org> <54616CB3.5000405@gmail.com> <54616F74.5010408@codeaurora.org> <54618077.9000108@gmail.com>
In-Reply-To: <54618077.9000108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 7:20 PM, Frank Rowand wrote:
> On 11/10/2014 6:07 PM, Stephen Boyd wrote:
>> On 11/10/2014 05:56 PM, Frank Rowand wrote:
>>> On 11/10/2014 11:42 AM, Stephen Boyd wrote:
>>>> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
>>>> index 09364dd8cf3a..d1bc6b6cbc70 100644
>>>> --- a/drivers/tty/serial/msm_serial.c
>>>> +++ b/drivers/tty/serial/msm_serial.c
>>>> @@ -1046,14 +1046,14 @@ static int msm_serial_probe(struct platform_device *pdev)
>>>>  	const struct of_device_id *id;
>>>>  	int irq, line;
>>>>  
>>>> -	if (pdev->id == -1)
>>>> -		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
>>>> -
>>>>  	if (pdev->dev.of_node)
>>>>  		line = of_alias_get_id(pdev->dev.of_node, "serial");
>>>>  	else
>>>>  		line = pdev->id;
>>>>  
>>>> +	if (line < 0)
>>>> +		line = atomic_inc_return(&msm_uart_next_id) - 1;
>>>> +
>>>>  	if (unlikely(line < 0 || line >= UART_NR))
>>> Then this original check for "line < 0" can also be removed.
>>>
>>>
>>
>> Well this matches what was there before. It would do atomic_inc_return
>> if the line was negative and then still check for a negative value. I
>> don't mind removing it though. Perhaps we should use an ida?:
>>
> 
> OK, you are right.  If (pdev->id < -1) and (!pdev->dev.of_node) then
> the check is still needed.
> 
> You could use an ida.  Some drivers use a bit map.  I really don't think
> this should become a complicated algorithm though.  If the rule is that
> either all UARTS have an alias, or no UART has an alias, then I think
> the patch could be something like the following.
> 
> This combines your original patch, plus your fix patch, plus making
> the aliases all or nothing.  Not tested, not even compiled.
> 
> What do you think?

< snip - previous version of patch >

Previous version of the patch did not protect against no alias, followed
by alias.



From: Frank Rowand <frank.rowand@sonymobile.com>

This patch is intended to show roughly what an implementation of an all or
nothing policy for using serialN aliases would look like.  It is intended
simply to help determine whether this policy should be used.

Combines Stephen's first patch, Stephen's fix patch (to make the serialN
alias optional), plus makes use of the serialN alias all or nothing (either
all ports have an alias or none do).

This is not a correct implementation because the atomic_read(&msm_uart_next_id)
does not protect against concurrency; instead a lock should be used.

Not tested, not even compiled.

Not-Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---

Index: linux/drivers/tty/serial/msm_serial.c
===================================================================
--- linux.orig/drivers/tty/serial/msm_serial.c
+++ linux/drivers/tty/serial/msm_serial.c
@@ -1044,17 +1044,31 @@ static int msm_serial_probe(struct platf
 	struct resource *resource;
 	struct uart_port *port;
 	const struct of_device_id *id;
-	int irq;
+	int irq, line;
+	static int no_prev_alias = 1;
 
-	if (pdev->id == -1)
-		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
+	if (pdev->dev.of_node) {
+		line = of_alias_get_id(pdev->dev.of_node, "serial");
+		if (line < 0 && no_prev_alias) {
+			line = atomic_inc_return(&msm_uart_next_id) - 1;
+		} else {
+			no_prev_alias = 0;
+			if (atomic_read(&msm_uart_next_id))
+				line = -ENXIO;
+		}
+	} else {
+		if (pdev->id < 0 && no_prev_alias)
+			line = atomic_inc_return(&msm_uart_next_id) - 1;
+		else
+			line = pdev->id;
+	}
 
-	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
+	if (unlikely(line < 0 || line >= UART_NR))
 		return -ENXIO;
 
-	dev_info(&pdev->dev, "msm_serial: detected port #%d\n", pdev->id);
+	dev_info(&pdev->dev, "msm_serial: detected port #%d\n", line);
 
-	port = get_port_from_line(pdev->id);
+	port = get_port_from_line(line);
 	port->dev = &pdev->dev;
 	msm_port = UART_TO_MSM(port);
 
