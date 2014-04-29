Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbaD2PQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:16:29 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54391 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaD2PQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVdwumX7Dsmt8NJhw4uWsj2sjUKaKS1wJQujW1fn1szLw@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVp5u-jF_xjCu68BgbZ=e0D508tn_-auoiT6cbkYtX8Og@mail.gmail.com>
	<CAL_JsqKiYmCNGrkiwS7m-OAt3rHZBq_yNGycen-AojbV-7famg@mail.gmail.com>
	<CAE9FiQVdwumX7Dsmt8NJhw4uWsj2sjUKaKS1wJQujW1fn1szLw@mail.gmail.com>
Date: Tue, 29 Apr 2014 10:16:27 -0500
Message-ID: <CAL_Jsq+uNunqfsvPNxZLQQ3y1ay_XMZKb4c=HNWvKtwuiZGQ0g@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Rob Herring <robherring2@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 9:56 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Apr 28, 2014 at 4:24 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On Sat, Apr 26, 2014 at 1:29 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> Thanks for finding these. I missed them in my build tests. This should fix them:
>>
>> diff --git a/drivers/tty/serial/8250/8250_early.c
>> b/drivers/tty/serial/8250/8250_early.c
>> index e83c9db..2094c3b 100644
>> --- a/drivers/tty/serial/8250/8250_early.c
>> +++ b/drivers/tty/serial/8250/8250_early.c
>> @@ -156,6 +156,11 @@ static int __init early_serial8250_setup(struct
>> earlycon_device *device,
>>  EARLYCON_DECLARE(uart8250, early_serial8250_setup);
>>  EARLYCON_DECLARE(uart, early_serial8250_setup);
>>
>> +int __init setup_early_serial8250_console(char *cmdline)
>> +{
>> +       return setup_earlycon(cmdline, "uart8250", early_serial8250_setup);
>> +}
>> +
>>  int serial8250_find_port_for_earlycon(void)
>>  {
>>         struct earlycon_device *device = early_device;
>
> that only handle "uart8250,", may need to add more lines to handle "uart,"


That is on purpose because the only 2 users use uart8250. I consider
this a legacy interface and use of "uart" is horrible because there
are lots of uarts which are not 8250.

Rob

>
> +int __init setup_early_serial8250_console(char *cmdline)
> +{
> +       char *options;
> +       options = strstr(cmdline, "uart8250,");
> +       if (options)
> +               return setup_earlycon(cmdline, "uart8250",
> early_serial8250_setup);
> +
> +       options = strstr(cmdline, "uart,");
> +       if (options)
> +              return setup_earlycon(cmdline, "uart", early_serial8250_setup);
> +
> +      return 0;
> +}
> +
>
> Thanks
>
> Yinghai
