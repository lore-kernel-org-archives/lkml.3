Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3IWVf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:35:56 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:51194 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IWVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:35:55 -0400
Message-ID: <5240B437.9090201@gmail.com>
Date: Mon, 23 Sep 2013 16:35:51 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Pisati <paolo.pisati@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] TTY: hvc_dcc: probe for a JTAG connection before registering
References: <1379968234-23373-1-git-send-email-robherring2@gmail.com> <5240AE43.6070708@canonical.com>
In-Reply-To: <5240AE43.6070708@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 04:10 PM, Tim Gardner wrote:
> On 09/23/2013 01:30 PM, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Enabling the ARM DCC console and using without a JTAG connection will
>> simply hang the system. Since distros like to turn on all options, this
>> is a reoccurring problem to debug. We can do better by checking if
>> anything is attached and handling characters. There is no way to probe
>> this, so send a newline and check that it is handled.
>>
>> Cc: Paolo Pisati <paolo.pisati@canonical.com>
>> Cc: Tim Gardner <tim.gardner@canonical.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  drivers/tty/hvc/hvc_dcc.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
>> index 44fbeba..44c8aff 100644
>> --- a/drivers/tty/hvc/hvc_dcc.c
>> +++ b/drivers/tty/hvc/hvc_dcc.c
>> @@ -86,6 +86,21 @@ static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
>>  	return i;
>>  }
>>  
>> +static bool hvc_dcc_check(void)
>> +{
>> +	unsigned long time = jiffies;
>> +
>> +	/* Write a test character to check if it is handled */
>> +	__dcc_putchar('\n');
>> +
>> +	while (jiffies < time + (HZ / 10)) {
>> +		if (!(__dcc_getstatus() & DCC_STATUS_TX))
>> +			return true;
>> +	}
> 
> I think you should use one of the jiffies time comparison functions, e.g.,
> 
> 	time = jiffies + (HZ / 10);
> 	while (time_before(jiffies,time) {
> 		...
> 	}

Yes.

> 
> What is the possibility that __dcc_getstatus() will return garbage if no
> JTAG is connected ? In that event you're likely to get a false positive
> on DCC_STATUS_TX.

That probably would not be architecturally compliant. The status bits
are cleared by JTAG reading the read side of the register. If the bit
stays set, we'll return false. If the bit is always clear, then we
wouldn't hang in the first place and should be fine. If you get random
values, then I'm sorry and good luck. You are still no worse off than
before this patch.

Rob

