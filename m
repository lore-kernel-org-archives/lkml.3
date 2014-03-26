Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaCZRrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbaCZRro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:47:44 -0400
Message-ID: <5333129E.1050108@redhat.com>
Date: Wed, 26 Mar 2014 13:47:10 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Add initcall_blacklist kernel parameter
References: <1395842441-17923-1-git-send-email-prarit@redhat.com> <CA+5PVA7vt6nBWfuU9V4UahHigy7=3d40rmPhSJvPv9F5J_n0ug@mail.gmail.com>
In-Reply-To: <CA+5PVA7vt6nBWfuU9V4UahHigy7=3d40rmPhSJvPv9F5J_n0ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/26/2014 12:34 PM, Josh Boyer wrote:
> On Wed, Mar 26, 2014 at 10:00 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>> When a module is built into the kernel, the modules's module_init()
>> function becomes an initcall.  Debugging built in kernel modules is
>> typically done by changing the .config, recompiling, and booting the new
>> kernel in an effort to determine exactly which module caused a problem.
>> This is a wasteful time consuming process as it may be repeated several times
>> before determining precisely what caused the problem.
>>
>> This patch has been useful in identifying problems with built-in modules and
>> initcalls.  It allows a user to skip an initcall to see if the kernel
>> would continue to boot properly without requiring recompiles.
>>
>> Usage: initcall_blacklist=<initcall function>
>>
>> ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
>> the log contains:
>>
>>         blacklisted initcall sgi_uv_sysfs_init
>>         ...
>>         ...
>>         function sgi_uv_sysfs_init returning without executing
>>
> 
> Could you elaborate on cases where this would be more useful than
> initcall_debug?  It seems odd to have one option to debug initicalls
> already saying it's useful for working out where the kernel is dying
> during startup, and then adding another option with the same goal.

Sure, here's an example of where this would have been useful.  The last thing
seen on the console was:

Non-volatile memory driver v1.2
Linux agpgart interface v0.103

Seems easy enough to debug, right?  Must be the agp driver.  So I added
"initcall_debug" and got ...

Non-volatile memory driver v1.2
initcall nvram_init+0x0/0x6f
calling  agp_init+0x0/0x28
Linux agpgart interface v0.103

So it is obvious that the agp code is to blame.  I removed the agp_intel_init()
(I was on an Intel based system) & driver from the kernel config and then ended
up with the same failure:

Non-volatile memory driver v1.2
Linux agpgart interface v0.103

I was then scratching my head and started pulling config options to get deeper
into the boot.  I eventually removed the TPM's init and the system booted -- the
issue was a peculiar HW problem with TPM which hung the system so bad that the
console didn't have time to flush.  The issue was resolved in the BIOS FWIW, but
that's not really the point; the problem is that I wasted effort debugging this
when 20-30 lines of code would have made it so much easier to do so.

I no longer have the original call sequence but here's one from current
top-of-tree so you can see the number of builds that were required to figure out
exactly what was broken:

[   13.804729] initcall agp_init+0x0/0x29 returned 0 after 4466 usecs
[   13.811628] calling  agp_amd64_mod_init+0x0/0x21 @ 1
[   13.817794] initcall agp_amd64_mod_init+0x0/0x21 returned -19 after 607 usecs
[   13.825762] calling  agp_intel_init+0x0/0x2a @ 1
[   13.831093] initcall agp_intel_init+0x0/0x2a returned 0 after 172 usecs
[   13.838479] calling  agp_sis_init+0x0/0x2a @ 1
[   13.843600] initcall agp_sis_init+0x0/0x2a returned 0 after 155 usecs
[   13.850792] calling  agp_via_init+0x0/0x2a @ 1
[   13.855909] initcall agp_via_init+0x0/0x2a returned 0 after 152 usecs
[   13.863102] calling  init_tis+0x0/0xa6 @ 1
[   13.868269] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[   13.910570] initcall init_tis+0x0/0xa6 returned 0 after 41906 usecs

and I had to annoyingly bisect through to figure out exactly which built in
module caused the problem.  It really was a waste of time IMO when it would have
been so much easier to do have just bisected init calls and ended up with
"initcall_blacklist=init_tis".

Even with the above output as straight forward as it is I feel I got lucky with
the debug.  I know I've debugged situations (plural emphasized) where a function
seconds earlier in the initcalls that caused a problem later on (due to an
expired timer or some such thing).  That's not to say the case above also could
have been something much later on ... then I would really have been burning time
doing compiles trying to see what went wrong.

There is admittedly another use for this code and that would be to allow someone
with a broken system to skip over a built-in module's init call.  The end user
could have continued with "initcall_blacklist=init_tis" while we continued to
debug.  While I wouldn't recommend running this way in production with something
like TPM disabled, I could see myself saying this is okay to do with a driver
that wasn't critical for a system (floppy on a modern server).


> 
>>         inport.irq=     [HW] Inport (ATI XL and Microsoft) busmouse driver
>> diff --git a/init/main.c b/init/main.c
>> index 9c7fd4c..a34677c 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -666,6 +666,15 @@ static void __init do_ctors(void)
>>  bool initcall_debug;
>>  core_param(initcall_debug, initcall_debug, bool, 0644);
>>
>> +static char blacklist_buf[128] = "\0";
>> +static int initcall_blacklist(char *str)
>> +{
>> +       snprintf(blacklist_buf, 127, "%s", str);
>> +       pr_debug("blacklisted initcall %s\n", blacklist_buf);
>> +       return 0;
>> +}
>> +__setup("initcall_blacklist=", initcall_blacklist);
>> +
> 
> I'm not trying to bikeshed, but this isn't so much a list as it is a
> single initcall to skip.  Maybe call it initcall_skip ?  I can see
> people doing something like
> initcall_blacklist=sgi_uv_sysfs_init,foo_bar_init,baz_debug_init and
> being confused when nothing is skipped because no single initcall
> matches that literal string.

Or maybe that implies that I should allow for a list of blacklist'd calls?  It
was something that a fellow engineer at Red Hat suggested as well, along with
some cleanups of the 128/127 char writing.  He pointed out that removing one
initcall could have an impact on another.  For example, removing the init for
netdev would have an impact on loading the igb driver, and then you're booting
into another panic/oops situation.

Is dynamically allocating memory in __setup() calls acceptable?  I'm not sure if
there are any restrictions on doing so.  Ingo or Peter?  Do you know?

P.

> 
> josh
> 
