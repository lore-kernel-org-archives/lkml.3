Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaIZTaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:30:08 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61229 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaIZTaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:30:06 -0400
MIME-Version: 1.0
X-Originating-IP: [12.227.248.5]
In-Reply-To: <20140926142315.49215fc5@as>
References: <138a894f22366da4173c8a4f2bfb0e670c66dbec.1411758752.git.luto@amacapital.net>
	<20140926142315.49215fc5@as>
Date: Fri, 26 Sep 2014 14:30:04 -0500
Message-ID: <CAOS_Y6QMVePeSwsqPEcK0EBu6mP=wVc7DA22utrk8TGSY_O3QA@mail.gmail.com>
Subject: Re: [PATCH v3] init: Add strictinit to disable init= fallbacks
From: Rob Landley <rob@landley.net>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 2:23 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Fri, 26 Sep 2014 12:13:57 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> If a user puts init=/whatever on the command line and /whatever
>> can't be run, then the kernel will try a few default options before
>> giving up.  If init=/whatever came from a bootloader prompt, then
>> this probably makes sense.  On the other hand, if it comes from a
>> script (e.g. a tool like virtme or perhaps a future kselftest
>> script), then the fallbacks are likely to exist, but they'll do the
>> wrong thing.  For example, they might unexpectedly invoke systemd.
>>
>> This adds a new option called strictinit.  If init= and strictinit
>> are both set, and the init= binary is not executable, then the
>> kernel will panic immediately.  If strictinit is set but init= is
>> not set, then strictinit will have no effect, because the only real
>> alternative would be to panic regardless of the contents of the root
>> fs.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  Documentation/kernel-parameters.txt |  8 ++++++++
>>  init/main.c                         | 16 ++++++++++++++--
>>  2 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 10d51c2f10d7..1576273edce6 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -3236,6 +3236,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>       stifb=          [HW]
>>                       Format: bpp:<bpp1>[:<bpp2>[:<bpp3>...]]
>>
>> +     strictinit      [KNL,BOOT]
>> +                     Normally, if the kernel can't find the init binary
>> +                     specified by rdinit= and/or init=, then it will
>> +                     try several fallbacks.  If strictinit is set
>> +                     and the value specified by init= does not work,
>> +                     then the kernel will panic instead.
>> +                     This option makes no sense if init= is not specified.
>> +
>>       sunrpc.min_resvport=
>>       sunrpc.max_resvport=
>>                       [NFS,SUNRPC]
>> diff --git a/init/main.c b/init/main.c
>> index bb1aed928f21..2ae0f2776155 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -131,6 +131,7 @@ static char *initcall_command_line;
>>
>>  static char *execute_command;
>>  static char *ramdisk_execute_command;
>> +static bool strictinit;
>>
>>  /*
>>   * Used to generate warnings if static_key manipulation functions are used
>> @@ -347,6 +348,13 @@ static int __init rdinit_setup(char *str)
>>  }
>>  __setup("rdinit=", rdinit_setup);
>>
>> +static int __init strictinit_setup(char *str)
>> +{
>> +     strictinit = true;
>> +     return 1;
>> +}
>> +__setup("strictinit", strictinit_setup);
>> +
>>  #ifndef CONFIG_SMP
>>  static const unsigned int setup_max_cpus = NR_CPUS;
>>  #ifdef CONFIG_X86_LOCAL_APIC
>> @@ -960,8 +968,12 @@ static int __ref kernel_init(void *unused)
>>               ret = run_init_process(execute_command);
>>               if (!ret)
>>                       return 0;
>> -             pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
>> -                     execute_command, ret);
>> +             if (strictinit)
>> +                     panic("Requested init %s failed (error %d) and strictinit was set.",
>> +                           execute_command, ret);
>> +             else
>> +                     pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
>> +                            execute_command, ret);
>>       }
>>       if (!try_to_run_init_process("/sbin/init") ||
>>           !try_to_run_init_process("/etc/init") ||
>
> Can't you just make it use "init=foo,strict" instead?

Can't we just change the default behavior and add a
CONFIG_INIT_FALLBACK that defaults to "n" which you can switch on to
get the old behavior? (And then immediately deprecate it?)

If you're specifying an init, you probably want that init...

Rob
