Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaKGQu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:50:27 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58492 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaKGQuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:50:25 -0500
Message-ID: <545CF847.3020409@linaro.org>
Date: Fri, 07 Nov 2014 16:50:15 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
References: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>	 <1415361686-3797-1-git-send-email-daniel.thompson@linaro.org> <1415376272.23530.10.camel@perches.com>
In-Reply-To: <1415376272.23530.10.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 16:04, Joe Perches wrote:
> On Fri, 2014-11-07 at 12:01 +0000, Daniel Thompson wrote:
>> Currently when kdb traps printk messages then the raw log level prefix
>> (consisting of '\001' followed by a numeral) does not get stripped off
>> before the message is issued to the various I/O handlers supported by
>> kdb. This causes annoying visual noise as well as causing problems
>> grepping for ^. It is also a change of behaviour compared to normal usage
>> of printk() usage. For example <SysRq>-h ends up with different output to
>> that of kdb's "sr h".
>>
>> This patch addresses the problem by stripping log levels from messages
>> before they are issued to the I/O handlers. printk() which can also
>> act as an i/o handler in some cases is special cased; if the caller
>> provided a log level then this will be preserved when sent to printk().
>>
>> The addition of non-printable characters to the output of kdb commands is a
>> regression, albeit and extremely elderly one, introduced by commit
>> 04d2c8c83d0e ("printk: convert the format for KERN_<LEVEL> to a 2 byte
>> pattern"). Note also that this patch does *not* restore the original
>> behaviour from v3.5. Instead it makes printk() from within a kdb command
>> display the message without any prefix (i.e. like printk() normally does).
> []
>> diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
> []
>> @@ -711,7 +712,10 @@ kdb_printit:
>>  	if (logging) {
>>  		saved_loglevel = console_loglevel;
>>  		console_loglevel = CONSOLE_LOGLEVEL_SILENT;
>> -		printk(KERN_INFO "%s", kdb_buffer);
>> +		if (cp == kdb_buffer)
>> +			printk(KERN_INFO "%s", kdb_buffer);
>> +		else
>> +			printk("%s", kdb_buffer);
> 
> The first part of the patch seem fine, but I'm
> confused about this bit above.
> 
> Here, isn't the "if (cp == kdb_buffer)" unnecessary?
> 
> if "(cp != kdb_buffer)", the buffer does have
> a prefix and it's emitted.
> 
> If (cp == kdb_buffer), the buffer does _not_ have
> a prefix (meaning it's either a naked printk or
> a continuation line. (KERN_CONT is "")
> 
> So why insert KERN_INFO?

vkdb_printf() and  printk() can appear either way round in a stack
trace. Each is capable of calling the other and a flag (kdb_trap_printk)
is used to prevent mutual recursion.

Messages that originate from with kdb itself start life as direct call
to (v)kdb_printf() and are not prefixed. If these messages are logged
then they are supposed to be tagged KERN_INFO hence the little dance here.

Before my patch then printk() messages would receive a double log header
if they were copied to the log (they would unconditionally have
KERN_INFO tacked in front of them). My patch does better and preserves
log levels where this is possible. However there are cases when logging
printk() continuations that data could be tagged with an unexpected log
level.

A complete solution would require a means to know whether vkdb_printf()
were entered directly or from printk(). A flag passed to vkdb_printf()
would achieve this. I'll take a look.


Daniel.
