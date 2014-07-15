Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaGOPpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:45:04 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:52116 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaGOPpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140715153801.GX3403@laptop.dumpdata.com>
References: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net>
 <20140715153801.GX3403@laptop.dumpdata.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Jul 2014 08:44:39 -0700
Message-ID: <CALCETrUsjMkQfwhwAvsJz0gNXaH-OOz0qCUJ5q1me3=4zpP7Ew@mail.gmail.com>
Subject: Re: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 8:38 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Jul 15, 2014 at 08:26:41AM -0700, Andy Lutomirski wrote:
>> Xen doesn't call start_secondary.
>
> Duh!
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>
>> espfix still doesn't seem to work on Xen (it goes boom in some way that
>> I don't understand right now), but initializing all CPUs instead of just
>> one of them seems like a good start.
>>
>> ISTM the right fix is probably to shove the espfix logic into
>> native_iret and to tweak the paravirt logic so that native_iret always
>> gets invoked.  I suspect that Xen will need its own implementation of
>> espfix64 in the hypervisor and that, ultimately, someone may want to
>> stop initializing espfix64 at all on Xen guests.
>
> I think just disallowing would be preferrable.

Disabling what?

Sorry, my flu-addled brain needs more clarity.  I'm currently working
on a patch on top of this one to move all of the espfix64 invocation
logic into native_iret, which will have the effect of preventing it
from being used on Xen.

Is that what you mean?

--Andy

>
> Thanks for posting this patch!
>>
>>  arch/x86/xen/smp.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index 7005974..eea9bcc 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -23,6 +23,7 @@
>>  #include <asm/desc.h>
>>  #include <asm/pgtable.h>
>>  #include <asm/cpu.h>
>> +#include <asm/espfix.h>
>>
>>  #include <xen/interface/xen.h>
>>  #include <xen/interface/vcpu.h>
>> @@ -85,6 +86,13 @@ static void cpu_bringup(void)
>>
>>       xen_setup_cpu_clockevents();
>>
>> +     /*
>> +      * Enable the espfix hack for this CPU
>> +      */
>> +#ifdef CONFIG_X86_ESPFIX64
>> +     init_espfix_ap();
>> +#endif
>> +
>>       notify_cpu_starting(cpu);
>>
>>       set_cpu_online(cpu, true);
>> --
>> 1.9.3
>>



-- 
Andy Lutomirski
AMA Capital Management, LLC
