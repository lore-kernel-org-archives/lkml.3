Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaGIVB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:01:57 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38553 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaGIVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <53BD8398.6020507@codeaurora.org>
References: <1404665232-14311-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<53BD8398.6020507@codeaurora.org>
Date: Wed, 9 Jul 2014 23:01:54 +0200
Message-ID: <CAFo99gaqS747k9kVRh0uyt+TTmdi5RrXOxBb=pgEBca3eSpKTw@mail.gmail.com>
Subject: Re: [PATCH v2] tty: serial: msm_serial.c: Cleaning up uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-09 20:02 GMT+02:00 Stephen Boyd <sboyd@codeaurora.org>:
> On 07/06/14 09:47, Rickard Strandqvist wrote:
>> Set reasonable initial value of some variables, in case
>> they do not get set to something otherwise.
>> And I've also added a plausibility control of the values.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>
> This patch doesn't look right...
>
>> @@ -930,17 +930,21 @@ static int __init msm_console_setup(struct console *co, char *options)
>>
>>       msm_init_clock(port);
>>
>> -     if (options)
>> +     if (options) {
>>               uart_parse_options(options, &baud, &parity, &bits, &flow);
>> +             if (baud < 300 || baud > 115200)
>> +                     baud = 115200;
>> +             if (NULL == strchr("noeNOE", parity))
>> +                     parity = 'n';
>> +             if (bits != 7)
>> +                     bits = 8;
>> +             if (flow != 'r')
>> +                     flow = 'n';
>> +     }
>>
>> -     bits = 8;
>> -     parity = 'n';
>> -     flow = 'n';
>>       msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
>>                 UART_MR2);    /* 8N1 */
>>
>
> because this code is overriding whatever is parsed from
> uart_parse_options() on purpose. The hardware is configured for 8 bits,
> no parity, no flow control with this msm_write() statement. Maybe we
> should extend the code to configure the parity and flow control bits
> instead.



Hi

Okay, well that explains the strange code.
Maybe there should be a comment about this?

You mean that UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE is
set correctly for the msm_write function?
I can do that...

Regardless, the original error whas that baud could be used uninitialized.


Kind regards
Rickard Strandqvist
