Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3KMCKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:10:23 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:52552 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757879Ab3KMCKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:10:17 -0500
Message-ID: <5282DF83.7020809@akamai.com>
Date: Tue, 12 Nov 2013 21:10:11 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic: Make panic_timeout configurable
References: <20131108204307.49C6AFE076@prod-mail-relay02.akamai.com> <20131111093213.GA13550@gmail.com>
In-Reply-To: <20131111093213.GA13550@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 04:32 AM, Ingo Molnar wrote:
> * Jason Baron <jbaron@akamai.com> wrote:
>
>> The panic_timeout can be set via the command line option 'panic=x', or via
>> /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
>> before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
>> so that we can set the desired value from the .config, instead of carrying a
>> patch for it.
>>
>> The default panic_timeout value continues to be 0 - wait forever, except for
>> powerpc and mips, which have been defaulted to 180 and 5 respectively. This
>> is in keeping with the fact that these arches already set panic_timeout in
>> their arch init code. However, I found two exceptions- one in mips and one in
>> powerpc where settings didn't match these default values. In those two cases,
>> I left the arch code so it continues to override. Perhaps, these cases can
>> be converted to the default?
>>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>  arch/mips/netlogic/xlp/setup.c |  1 -
>>  arch/mips/netlogic/xlr/setup.c |  1 -
>>  arch/mips/sibyte/swarm/setup.c |  2 --
>>  arch/powerpc/kernel/setup_32.c |  3 ---
>>  arch/powerpc/kernel/setup_64.c |  3 ---
>>  kernel/panic.c                 |  2 +-
>>  lib/Kconfig.debug              | 12 ++++++++++++
>>  7 files changed, 13 insertions(+), 11 deletions(-)
>>
>> @@ -33,7 +33,7 @@ static int pause_on_oops;
>>  static int pause_on_oops_flag;
>>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>>  
>> -int panic_timeout;
>> +int panic_timeout = CONFIG_PANIC_TIMEOUT;
>>  EXPORT_SYMBOL_GPL(panic_timeout);
>>  
>>  ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index ebef88f..22b746e 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -761,6 +761,18 @@ config PANIC_ON_OOPS_VALUE
>>  	default 0 if !PANIC_ON_OOPS
>>  	default 1 if PANIC_ON_OOPS
>>  
>> +config PANIC_TIMEOUT
>> +	int "panic timeout"
>> +	default 0 if (!PPC && !MIPS)
>> +	default 180 if PPC
>> +	default 5 if MIPS
> I don't think there should be such arch conditionals in the core config. 
> If we introduce such a config, and if it's set by the user to anything but 
> 0 then it should always override whatever arch boot time hackery ...
>
> We might also want to add a second Kconfig value, set by architectures to 
> their desired default panic timeout value - instead of the runtime setting 
> during arch init (which, btw., might be too late if a panic happens 
> early).

yes - that's why i'm proposing this thing.

hmmm...sticking something such as:

config PANIC_TIMEOUT
        int
        default 5

in the arch/*/Kconfig files, seems to work fine to override the default
value in the common Kconfig file. Quoting from 'kconfig-language.txt':

"
  A config option can have any number of default values. If multiple
  default values are visible, only the first defined one is active.
  Default values are not limited to the menu entry where they are
  defined. This means the default can be defined somewhere else or be
  overridden by an earlier definition.
"

So this seems to do what we want - the only thing I noticed was that
the CONFIG_PANIC_TIMEOUT= ends up in the arch specific parts of the
.config, when I do a 'make defconfig', but I think that is ok - this is an
arch specific setting in this case...

> This means that 'panic_timeout' should be unexported (i.e. no naked 
> setting of the variable) and all arch use should go through that new 
> Kconfig plus perhaps a core panic_timeout_set() function for the 
> remaining, justified 'dynamic' settings of panic_timeout_set().

Ok - we could have a set function, to unexport the var from the
arch init as:

void set_panic_timeout_early(int timeout, int arch_default_timeout)
{
    if (panic_timeout == arch_default_timeout)
         panic_timeout = timeout;
}

That would work for the arch initialization, although we
have a small window b/w initial boot and arch_init() where we have the
wrong value in 2 cases (b/c its changing) - but that can be fixed now
by manually overriding the .config setting now, if we can't consolidate to
1 setting per-arch. Maybe the arch maintainers can comment?
But i think its still an improvement...

We'll also need an accessor functions for usages in:
arch/x86/kernel/cpu/mcheck/mce.c and ./drivers/acpi/apei/ghes.c.

Finally, kernel/sysctl.c, directly accesses panic timeout. I think the
command line "panic_timeout=" and sysctl settings continue
to be complete overwrites? So we can add a set function that
just does an overwrite for these cases.

Thanks,

-Jason





