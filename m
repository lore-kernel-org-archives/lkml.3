Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaGNJYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:24:31 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54945 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGNJYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:24:24 -0400
Message-ID: <53C3A1B5.3070801@linaro.org>
Date: Mon, 14 Jul 2014 10:24:05 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: kgdb_nmi: Convert kgdb_nmi_tty_enabled into a module
 parameter
References: <1405081811-15254-1-git-send-email-daniel.thompson@linaro.org> <20140712004739.GA13893@kroah.com>
In-Reply-To: <20140712004739.GA13893@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/14 01:47, Greg Kroah-Hartman wrote:
> On Fri, Jul 11, 2014 at 01:30:11PM +0100, Daniel Thompson wrote:
>> At present it is not possible to boot with the ttyNMI0 console treating
>> character input normally. To use the console requires that kdb be
>> entered and the nmi_console command be used to enable the console (or if
>> only kgdb is present then gdb must directly manipulate the value of
>> kgdb_nmi_tty_enabled).
>>
>> Introducing a module parameter makes the console much more usable.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Cc: linux-serial@vger.kernel.org
>> ---
>>  drivers/tty/serial/kgdb_nmi.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
>> index cfadf29..9361d69 100644
>> --- a/drivers/tty/serial/kgdb_nmi.c
>> +++ b/drivers/tty/serial/kgdb_nmi.c
>> @@ -43,6 +43,11 @@ module_param_named(magic, kgdb_nmi_magic, charp, 0600);
>>  MODULE_PARM_DESC(magic, "magic sequence to enter NMI debugger (default $3#33)");
>>  
>>  static bool kgdb_nmi_tty_enabled;
>> +module_param_named(tty, kgdb_nmi_tty_enabled, bool, 0600);
>> +MODULE_PARM_DESC(tty, "if set to false (default), characters received from "
>> +		      "the UART will be passed exclusively to the knock "
>> +		      "detector; when set to true characters will be passed "
>> +		      "both to the knock detector and to the TTY layer");
> 
> Module options suck rocks through straws.
> 
> Isn't there _any_ other way to determine this "dynamically"?  How will
> someone know to set this option?
> 
> Yeah, there are other options in this module, but please, why add more?

Thanks for the comment.

Yes. I think we can do this dynamically.

The two modes currently offered are:

1. characters bypass TTY layer and knock detector interactively prompts
   for the knock ('Press $3#33 to enter debugger>')

2. characters are routed to TTY layer and to a (silenced) knock
   detector

I think we might be able to select modes based on whether there is a
userspace process reading from the tty (i.e. if there is a getty then
act like a proper tty, if there is no getty allow prompting).


