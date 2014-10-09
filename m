Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaJINnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:43:05 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35556 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJINmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAJJ77WvDaM2MmC_r9Wop68++L0FfaRmq6oiXTp+GdqcaKKwSBw@mail.gmail.com>
References: <1411367422-2095-1-git-send-email-ssreedharan@mvista.com>
	<CAMAWPa9R5HtGKkV=Ya-ekynY5maespZ0Q6BjwJcX3LN3857ZjQ@mail.gmail.com>
	<CAJJ77WvDaM2MmC_r9Wop68++L0FfaRmq6oiXTp+GdqcaKKwSBw@mail.gmail.com>
Date: Thu, 9 Oct 2014 19:12:47 +0530
Message-ID: <CAJJ77WtZKtDqxRQv4+zH6DDnBKq9RmsKT7DYe7d+H-ztjKNQ7A@mail.gmail.com>
Subject: Re: [PATCH] serial/core: Initialize the console pm state
From: Sudhir Sreedharan <ssreedharan@mvista.com>
To: Kevin Hilman <khilman@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 6, 2014 at 2:57 PM, Sudhir Sreedharan
<ssreedharan@mvista.com> wrote:
>>
>> Multiple boot failures on ARM[1] were bisected down to this patch.
>>
>> How was this patch tested, and on which platforms?
>
>
>
> This patch was tested on x86-64(haswell) board, which uses ST16650V2
> uart(which has UART_CAP_SLEEP).
> While serial driver gets initialized, console port LCR register is
> getting reinitalized to 0.
> Then boot logs will be seen as garbage characters.
>
> I will re-check why this failed on the boards/archs you mentioned.


The issue is, in the boot logs, once the serial driver gets
initialized, it throws garbage in the console. The serial device being
used is ST16550V2 which is having SLEEP functionality. So when
uart_configure_port is called, it calls the serial8250_set_sleep and
set the LCR register to 0.

The previous patch got failed because those are not based on 8250 and
the do_pm functionality is different. Eg. for arndale board, in
s3c24xx_serial_pm it uses the clock enable and disable functionality.

I have created a new patch which will be confined only to 8250 based
serial devices. I have tested it on x86-64 based haswell board, ARM64
based, P5040 powerpc which all uses 8250 based serial device.

>
> Thanks,
> Sudhir
