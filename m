Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaDNGNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:13:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56174 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaDNGNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:13:36 -0400
Message-ID: <534B7C89.5020602@hitachi.com>
Date: Mon, 14 Apr 2014 15:13:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Takenori Nagano <t-nagano@ah.jp.nec.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in unstable
 condition
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp> <87d2gkxzkl.fsf@x220.int.ebiederm.org>
In-Reply-To: <87d2gkxzkl.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/14 14:14), Eric W. Biederman wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> 
>> Add a "late_kdump" option to run kdump after running panic
>> notifiers and dump kmsg. This can help rare situations which
>> kdump drops in failure because of unstable crashed kernel
>> or hardware failure (memory corruption on critical data/code),
>> or the 2nd kernel is broken by the 1st kernel (it's a broken
>> behavior, but who can guarantee that the "crashed" kernel
>> works correctly?).
>>
>> Usage: add "late_kdump" to kernel boot option. That's all.
>>
>> Note that this actually increases risks of the failure of
>> kdump. This option should be set only if you worry about
>> the rare case of kdump failure rather than increasing the
>> chance of success.
> 
> This is better than some others, but every time I have seen a request
> to do this it is because someone wants to do something horrible that
> makes kdump more brittle and generally unsupportable.

I see, with such horrible handlers, kdump should be unreliable. However,
that is not introduced by this option.

> You seem to in general understand that.
> 
> But how can we support an option to make the kernel flakier?

I think it's user's own risk. We do not need to (individual) support it
but just give them a chance. And distros decide to provide support on such
option or not.

For example, some users may choose enabling this without any kdump guarantee
from distro, or will pay more for them to extra support. OTOH, other users who
don't enable this, will not pay much for extra support :)

> I suspect it would be more productive to work on the lkcd (spelling?)
> test module and show that crash dump actually works in the situation
> people are worried about.

No, I think there are some situation which the kdump/lkcd actually doesn't
work (e.g. software/hardware memory corruptions involving 2nd kernel image).
And in those cases, to leave the minimum information on serial console,
NVM or somewhere safe, this option may give a chance.

Note that those output action can make the situation worse, because some of
such actions are not well tested and may be immature. Thus I added a warning
message on the path of "late_kdump" :)


> Just thinking about this send shivers up my spine. Ick.

I hope everyone correctly understand the risk of this option, and not sending
bug reports to you.

Thank you,

> 
> Eric
> 
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: Vivek Goyal <vgoyal@redhat.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> Cc: Satoru MORIYA <satoru.moriya.br@hitachi.com>
>> Cc: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
>> Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>
>> ---
>>  Documentation/kernel-parameters.txt |    7 +++++++
>>  kernel/panic.c                      |   24 ++++++++++++++++++++++--
>>  2 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 03e50b4..1ba58da 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2339,6 +2339,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  			timeout < 0: reboot immediately
>>  			Format: <timeout>
>>  
>> +	late_kdump	Run kdump after running panic-notifiers and dumping
>> +			kmsg. This only for the users who doubt kdump always
>> +			succeeds in any situation.
>> +			Note that this also increases risks of kdump failure,
>> +			because some panic notifiers can make the crashed
>> +			kernel more unstable.
>> +
>>  	parkbd.port=	[HW] Parallel port number the keyboard adapter is
>>  			connected to, default is 0.
>>  			Format: <parport#>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index d02fa9f..bba42b5 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -32,6 +32,7 @@ static unsigned long tainted_mask;
>>  static int pause_on_oops;
>>  static int pause_on_oops_flag;
>>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>> +static bool late_kdump;
>>  
>>  int panic_timeout = CONFIG_PANIC_TIMEOUT;
>>  EXPORT_SYMBOL_GPL(panic_timeout);
>> @@ -112,9 +113,14 @@ void panic(const char *fmt, ...)
>>  	/*
>>  	 * If we have crashed and we have a crash kernel loaded let it handle
>>  	 * everything else.
>> -	 * Do we want to call this before we try to display a message?
>> +	 * If we want to call this after we try to display a message, pass
>> +	 * the "late_kdump" option to the kernel.
>>  	 */
>> -	crash_kexec(NULL);
>> +	if (!late_kdump)
>> +		crash_kexec(NULL);
>> +	else
>> +		pr_emerg("Warning: late_kdump option is set. Please DO NOT "
>> +			"report bugs about kdump failure with this option.\n");
>>  
>>  	/*
>>  	 * Note smp_send_stop is the usual smp shutdown function, which
>> @@ -131,6 +137,13 @@ void panic(const char *fmt, ...)
>>  
>>  	kmsg_dump(KMSG_DUMP_PANIC);
>>  
>> +	/*
>> +	 * If you doubt kdump always works perfectly in any situation,
>> +	 * "late_kdump" offers you to try kdump after running panic_notifier
>> +	 * and dumping kmsg.
>> +	 */
>> +	crash_kexec(NULL);
>> +
>>  	bust_spinlocks(0);
>>  
>>  	if (!panic_blink)
>> @@ -472,6 +485,13 @@ EXPORT_SYMBOL(__stack_chk_fail);
>>  core_param(panic, panic_timeout, int, 0644);
>>  core_param(pause_on_oops, pause_on_oops, int, 0644);
>>  
>> +static int __init setup_late_kdump(char *s)
>> +{
>> +	late_kdump = true;
>> +	return 0;
>> +}
>> +early_param("late_kdump", setup_late_kdump);
>> +
>>  static int __init oops_setup(char *s)
>>  {
>>  	if (!s)
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


