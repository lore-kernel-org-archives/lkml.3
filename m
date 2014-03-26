Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaCZSXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:23:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47794 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaCZSX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <5333129E.1050108@redhat.com>
References: <1395842441-17923-1-git-send-email-prarit@redhat.com>
	<CA+5PVA7vt6nBWfuU9V4UahHigy7=3d40rmPhSJvPv9F5J_n0ug@mail.gmail.com>
	<5333129E.1050108@redhat.com>
Date: Wed, 26 Mar 2014 14:23:27 -0400
X-Google-Sender-Auth: 8lAHY5dtvZs-ybsIVgwW9p3FKIA
Message-ID: <CA+5PVA7wbvZ8zPx75kJ522OvY=asuE+OXSU+gdV4r8X3Af0UMQ@mail.gmail.com>
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 1:47 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 03/26/2014 12:34 PM, Josh Boyer wrote:
>> On Wed, Mar 26, 2014 at 10:00 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>>> When a module is built into the kernel, the modules's module_init()
>>> function becomes an initcall.  Debugging built in kernel modules is
>>> typically done by changing the .config, recompiling, and booting the new
>>> kernel in an effort to determine exactly which module caused a problem.
>>> This is a wasteful time consuming process as it may be repeated several times
>>> before determining precisely what caused the problem.
>>>
>>> This patch has been useful in identifying problems with built-in modules and
>>> initcalls.  It allows a user to skip an initcall to see if the kernel
>>> would continue to boot properly without requiring recompiles.
>>>
>>> Usage: initcall_blacklist=<initcall function>
>>>
>>> ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
>>> the log contains:
>>>
>>>         blacklisted initcall sgi_uv_sysfs_init
>>>         ...
>>>         ...
>>>         function sgi_uv_sysfs_init returning without executing
>>>
>>
>> Could you elaborate on cases where this would be more useful than
>> initcall_debug?  It seems odd to have one option to debug initicalls
>> already saying it's useful for working out where the kernel is dying
>> during startup, and then adding another option with the same goal.
>
> Sure, here's an example of where this would have been useful.  The last thing
> seen on the console was:

Thanks for the quick reply!

<snip very well detailed example>

OK, so maybe elude to the reasons you are introducing this in both the
commit log and the kernel-parameters description.  Something along the
lines of:

"This can be useful stand-alone or combined with initcall_debug.
There are cases where some initcalls can hang the machine before the
console can be flushed, which can make initcall_debug output
inaccurate.  Having the ability to skip initcalls can help further
debugging of these scenarios."

> There is admittedly another use for this code and that would be to allow someone
> with a broken system to skip over a built-in module's init call.  The end user
> could have continued with "initcall_blacklist=init_tis" while we continued to
> debug.  While I wouldn't recommend running this way in production with something
> like TPM disabled, I could see myself saying this is okay to do with a driver
> that wasn't critical for a system (floppy on a modern server).

Yeah, I don't think that's unreasonable for a per-instance debugging
situation, but I wouldn't really recommend it in the help text or
anything ;).

>>>         inport.irq=     [HW] Inport (ATI XL and Microsoft) busmouse driver
>>> diff --git a/init/main.c b/init/main.c
>>> index 9c7fd4c..a34677c 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -666,6 +666,15 @@ static void __init do_ctors(void)
>>>  bool initcall_debug;
>>>  core_param(initcall_debug, initcall_debug, bool, 0644);
>>>
>>> +static char blacklist_buf[128] = "\0";
>>> +static int initcall_blacklist(char *str)
>>> +{
>>> +       snprintf(blacklist_buf, 127, "%s", str);
>>> +       pr_debug("blacklisted initcall %s\n", blacklist_buf);
>>> +       return 0;
>>> +}
>>> +__setup("initcall_blacklist=", initcall_blacklist);
>>> +
>>
>> I'm not trying to bikeshed, but this isn't so much a list as it is a
>> single initcall to skip.  Maybe call it initcall_skip ?  I can see
>> people doing something like
>> initcall_blacklist=sgi_uv_sysfs_init,foo_bar_init,baz_debug_init and
>> being confused when nothing is skipped because no single initcall
>> matches that literal string.
>
> Or maybe that implies that I should allow for a list of blacklist'd calls?  It
> was something that a fellow engineer at Red Hat suggested as well, along with
> some cleanups of the 128/127 char writing.  He pointed out that removing one
> initcall could have an impact on another.  For example, removing the init for
> netdev would have an impact on loading the igb driver, and then you're booting
> into another panic/oops situation.

Sure, fixing it to be a list would work too.

> Is dynamically allocating memory in __setup() calls acceptable?  I'm not sure if
> there are any restrictions on doing so.  Ingo or Peter?  Do you know?

That I'm unsure of myself.

josh
