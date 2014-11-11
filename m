Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKKB4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:56:09 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53932 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKKB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:56:07 -0500
Message-ID: <54616CB3.5000405@gmail.com>
Date: Mon, 10 Nov 2014 17:56:03 -0800
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
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com> <5461150B.2010907@codeaurora.org>
In-Reply-To: <5461150B.2010907@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 11:42 AM, Stephen Boyd wrote:
> On 11/10/2014 10:54 AM, Kevin Hilman wrote:
>> On Wed, Oct 22, 2014 at 5:33 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> We rely on probe order of this driver to determine the line number for
>>> the uart port. This makes it impossible to know the line number
>>> when these devices are populated via DT. Use the DT alias
>>> mechanism to assign the line based on the aliases node.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> FYI... this patch hit linux-next and caused multiple boot failures on
>> qcom platforms[1] as of next-20141110.  I'm assuming this is because
>> the corresponding DTS changes have not hit linux-next yet.
>>
>> Kevin
>>
>> [1] http://status.armcloud.us/boot/?qcom
> 
> Hmm the intention was to make it optional so that dts changes aren't
> necessary unless you want deterministic numbering. I screwed that up
> badly :/ Thanks for finding this.
> 
> Greg, can you also apply this patch or squash it into the bad one?
> 
> ----8<-----
> 
> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: [PATCH] tty: serial: msm_serial: Don't required DT aliases
> 
> If there isn't a DT alias then of_alias_get_id() will return
> -ENODEV. This will cause the msm_serial driver to fail probe,
> when we want to keep the previous behavior where we generated a
> dynamic line number at probe time. Restore this behavior by
> generating a dynamic id if the line number is still negative
> after checking for an alias or (in the non-DT case) looking at the
> .id field of the platform device.
> 
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/tty/serial/msm_serial.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
> index 09364dd8cf3a..d1bc6b6cbc70 100644
> --- a/drivers/tty/serial/msm_serial.c
> +++ b/drivers/tty/serial/msm_serial.c
> @@ -1046,14 +1046,14 @@ static int msm_serial_probe(struct platform_device *pdev)
>  	const struct of_device_id *id;
>  	int irq, line;
>  
> -	if (pdev->id == -1)
> -		pdev->id = atomic_inc_return(&msm_uart_next_id) - 1;
> -
>  	if (pdev->dev.of_node)
>  		line = of_alias_get_id(pdev->dev.of_node, "serial");
>  	else
>  		line = pdev->id;
>  
> +	if (line < 0)
> +		line = atomic_inc_return(&msm_uart_next_id) - 1;
> +
>  	if (unlikely(line < 0 || line >= UART_NR))

Then this original check for "line < 0" can also be removed.


>  		return -ENXIO;
>  
> 

