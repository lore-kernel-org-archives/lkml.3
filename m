Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaK0JuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:50:11 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46896 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaK0JuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:50:07 -0500
Message-ID: <5476F3C5.8020709@linaro.org>
Date: Thu, 27 Nov 2014 09:49:57 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>, Kiran Raparthy <kiran.kumar@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v3] debug: prevent entering debug mode on errors
References: <1416993266-16514-1-git-send-email-kiran.kumar@linaro.org> <CAMbhsRR0XzJ9ouYuoE2z+oCR9jRt8XBEfuVgd7sLJMg24bMKyQ@mail.gmail.com>
In-Reply-To: <CAMbhsRR0XzJ9ouYuoE2z+oCR9jRt8XBEfuVgd7sLJMg24bMKyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 17:45, Colin Cross wrote:
> On Wed, Nov 26, 2014 at 1:14 AM, Kiran Raparthy <kiran.kumar@linaro.org> wrote:
>> From: Colin Cross <ccross@android.com>
>>
>> debug: prevent entering debug mode on errors
>>
>> On non-developer devices kgdb prevents CONFIG_PANIC_TIMEOUT from rebooting the
>> device after a panic.
>>
>> In case of panics and exceptions, to honor CONFIG_PANIC_TIMEOUT, prevent
>> entering debug mode to avoid getting stuck waiting for the user to interact
>> with debugger.
>>
>> Cc: Jason Wessel <jason.wessel@windriver.com>
>> Cc: kgdb-bugreport@lists.sourceforge.net
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> [Kiran: Added context to commit message.
>> panic_timeout is used instead of break_on_panic and
>> break_on_exception to honor CONFIG_PANIC_TIMEOUT]
>> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>> ---
>>  kernel/debug/debug_core.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
>> index 1adf62b..0012a1f 100644
>> --- a/kernel/debug/debug_core.c
>> +++ b/kernel/debug/debug_core.c
>> @@ -689,6 +689,14 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
>>
>>         if (arch_kgdb_ops.enable_nmi)
>>                 arch_kgdb_ops.enable_nmi(0);
>> +       /*
>> +        * Avoid entering the debugger if we were triggered due to an oops
>> +        * but panic_timeout indicates the system should automatically
>> +        * reboot on panic. We don't want to get stuck waiting for input
>> +        * on such systems, especially if its "just" an oops.
>> +        */
>> +       if (signo != SIGTRAP && panic_timeout)
>> +               return 1;
>>
>>         memset(ks, 0, sizeof(struct kgdb_state));
>>         ks->cpu                 = raw_smp_processor_id();
>> @@ -821,6 +829,15 @@ static int kgdb_panic_event(struct notifier_block *self,
>>                             unsigned long val,
>>                             void *data)
>>  {
>> +       /*
>> +        * Avoid entering the debugger if we were triggered due to a panic
>> +        * We don't want to get stuck waiting for input from user in such case.
>> +        * panic_timeout indicates the system should automatically
>> +        * reboot on panic.
>> +        */
>> +       if (panic_timeout)
>> +               return NOTIFY_DONE;
>> +
>>         if (dbg_kdb_mode)
>>                 kdb_printf("PANIC: %s\n", (char *)data);
>>         kgdb_breakpoint();
> 
> The original patch was more useful as it allowed re-enabling break on
> panic on specific devices where you were trying to debug a
> reproducible issue.  What about using a module_param similar to
> kgdbreboot, but setting the default based on CONFIG_PANIC_TIMEOUT to
> avoid extra configuration?

This change was due to my review so perhaps I'd better answer this...

panic_timeout is the value of the panic sysctl. In addition to the
normal sysctl tooling (which I don't think is available on most android
systems), its value can be set using panic=0 on the kernel command line
or via /proc/sys/kernel/panic at runtime.

CONFIG_PANIC_TIMEOUT merely sets the default value of the sysctl. I
guess perhaps the patch description could be improved to make this clearer.

Therefore, the only loss of function I expected versus the original is
that it would be hard to get as far as a reproducible panic if the
system also has a ton of reproducible oopses that we don't want to fix.
Is such a use-case important?
