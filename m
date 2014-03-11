Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaCKG6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:58:25 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53477 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaCKG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:58:20 -0400
Message-ID: <531EB408.2070707@converseincode.com>
Date: Mon, 10 Mar 2014 23:58:16 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH 1/5] kbuild: LLVMLinux: Add Kbuild support for building
 kernel with Clang
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com> <1393376923-21892-2-git-send-email-behanw@converseincode.com> <20140309215834.GA29655@ravnborg.org>
In-Reply-To: <20140309215834.GA29655@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 14:58, Sam Ravnborg wrote:
> On Tue, Feb 25, 2014 at 05:08:39PM -0800, behanw@converseincode.com wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Add support to toplevel Makefile for compiling with clang, both for
>> HOSTCC and CC. Use cc-option to prevent gcc option from breaking clang, and
>> from clang options from breaking gcc.
>>
>> Clang 3.4 semantics are the same as gcc semantics for unsupported flags. For
>> unsupported warnings clang 3.4 returns true but shows a warning and gcc shows
>> a warning and returns false.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> Cc: PaX Team <pageexec@freemail.hu>
>> ---
>>   Makefile | 32 +++++++++++++++++++++++++++++++-
>>   1 file changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 831b36a..c4ab30d 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -247,6 +247,15 @@ HOSTCXX      = g++
>>   HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
>>   HOSTCXXFLAGS = -O2
>>   
>> +ifeq ($(shell $(HOSTCC) -v 2>&1 | grep -c "clang version"), 1)
>> +HOSTCOMPILER := clang
>> +HOSTCFLAGS  += -Wno-unused-value -Wno-unused-parameter \
>> +		-Wno-missing-field-initializers -fno-delete-null-pointer-checks
>> +else
>> +HOSTCOMPILER := gcc
>> +endif
>> +export HOSTCOMPILER
> I see no use of HOSTCOMPLIER anywhere in this patchset not in the kernel. Can we drop this?
Actually, we're not using it anymore, though we were at one point. We'll 
drop it.

>> +
>>   # Decide whether to build built-in, modular, or both.
>>   # Normally, just do built-in.
>>   
>> @@ -323,6 +332,12 @@ endif
>>   
>>   export quiet Q KBUILD_VERBOSE
>>   
>> +ifeq ($(shell $(CC) -v 2>&1 | grep -c "clang version"), 1)
>> +COMPILER := clang
>> +else
>> +COMPILER := gcc
>> +endif
>> +export COMPILER
> Likewise - COMPILER seems unsued- can it be dropped?
We use COMPILER a lot in upcoming patches. :(

It's here in order to be available early so that the other patches can 
use it. I hope that's okay.

>> # Look for make include files relative to root of kernel src
>>   MAKEFLAGS += --include-dir=$(srctree)
>> @@ -382,7 +397,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>>   		   -fno-strict-aliasing -fno-common \
>>   		   -Werror-implicit-function-declaration \
>>   		   -Wno-format-security \
>> -		   -fno-delete-null-pointer-checks
>> +		   $(call cc-option,-fno-delete-null-pointer-checks,)
>>   KBUILD_AFLAGS_KERNEL :=
>>   KBUILD_CFLAGS_KERNEL :=
>>   KBUILD_AFLAGS   := -D__ASSEMBLY__
>> @@ -620,9 +635,24 @@ else
>>   endif
>>   KBUILD_CFLAGS += $(stackp-flag)
>>   
>> +ifeq ($(COMPILER),clang)
> Except that COMPILER is used here. But this does not warrant the export.
Like I said. It is used in at least 4 other patches which are unrelated 
to kbuild... Well, okay, one in the arm portion of kbuild.

I don't actually like using it, and would prefer not to, but we needed 
the equivalent of an "#ifdef __clang__" in the Makefiles for various 
reasons. :(

>> +KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
> Is this really needed today?
> https://bugzilla.mozilla.org/show_bug.cgi?id=717713 suggest that this is default.
>
>> +KBUILD_CPPFLAGS += $(call cc-option,-Wno-unknown-warning-option,)
> https://bugzilla.mozilla.org/show_bug.cgi?id=731316 seems to suggest this is default
These haven't always been the defaults. I will check on when they became 
defaults, retest, and reply back.

Though thanks for pointing this out! Very thorough. :)

>> +KBUILD_CFLAGS += $(call cc-disable-warning, unused-variable)
>> +KBUILD_CFLAGS += $(call cc-disable-warning, format-invalid-specifier)
>> +KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
> Is it really justified to disable these warnings?
> # of warnign for a defconfig build would be a nice figure to judge from.
To be honest, the number one complaint we get from kernel devs who've 
tried clang is that there are too many warnings. We don't want to turn 
them off, but merely to stem the tide for now so as not to put people 
off. The idea is to turn them on once we've had time to address the 
warnings more fully. I'd quite like to see all (most) of the clang 
warnings on by default eventually. Does that make sense?

However, the unused-variable warning will likely need to stay on IMHO. 
There are quite a few things in the kernel which create variables which 
are intended to be optimized away (last I checked). gcc doesn't complain 
about this, but clang get's very noisy about it.

Though if the consensus is to have more warnings on by default, I'm 
happy to oblige.

>> +# Quiet clang warning: comparison of unsigned expression < 0 is always false
>> +KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
> Same with this.
Actually, if is my understanding that comparing signed and unsigned 
values are considered valid in the kernel code. Certainly I've seen many 
patches rejected which were trying to fix "tautological compare errors".

>> +# CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the
>> +# source of a reference will be _MergedGlobals and not on of the whitelisted names.
>> +# See modpost pattern 2
>> +KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
> Should we fix modpost?
We looked at doing this, but the symbol name compares in modpost seem 
like a Good Idea (tm). By using _MergedGlobals you lose information 
which modpost relies on. I think modpost can catch more potential 
problems by not using clang merged globals. But I'll easily be swayed by 
someone who knows better. :)

Thanks for the feedback,

Behan

-- 
Behan Webster
behanw@converseincode.com

