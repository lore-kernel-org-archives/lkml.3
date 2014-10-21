Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaJUIEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:04:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54009 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaJUIDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:03:47 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-36-5446135f9a8a
Message-id: <5446135E.9020101@samsung.com>
Date: Tue, 21 Oct 2014 12:03:42 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
 <5445640F.10000@oracle.com>
In-reply-to: <5445640F.10000@oracle.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4Zd14YbcQg4990hZfv3SwWMxZv4bN
	YsLDNnaLaRvFLVZ2PmC1+LNrB5PF5V1z2CwuHVjAZNGy7wKTxfHeA0wWi4/cZrbYvGkqs0Vr
	z092ix8bHrM68Hm0bC732DnrLrvHgk2lHptXaHlsWtXJ5vHu3Dl2jxMzfrN4NJ05yuzx8ekt
	Fo/3+66yeZxZcITd4/MmOY8TLV9YA3ijuGxSUnMyy1KL9O0SuDJm9sxiK9jiXPHqyW22Bsad
	Jl2MnBwSAiYSBzruMkLYYhIX7q1n62Lk4hASWMoo8ebaFxYIp5lJ4sGsXywgVbwCWhIHv79m
	72Lk4GARUJU4f1sVJMwmoCfxb9Z2NhBbVCBC4sqaOYwQ5YISPybfA5sjInCdSWJdywRWEIdZ
	YA6jxKk3O5hBqoQFvCRe/2hlhNi2kFFixetHTCAJTgENiU2bZ7CCbGMWUJeYMiUXJMwsIC+x
	ec1b5gmMArOQLJmFUDULSdUCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFR93UH49Jj
	VocYBTgYlXh4I5a4hgixJpYVV+YeYpTgYFYS4f0bAxTiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	qMmVfrTFSP5aj2DZ3ENn4gRVjRQPzdIJuaQjcFT8kcf2q+p33lhVJpUvvSI1Q++At2TOGQfx
	4MX//tadCX588r1Pzu3UWqXU+IB/qqfSjgtGh9xg22ExTctS4pT4ctnzbZsvv75zRlQjI0rp
	cN6UhC1FPq/CJu7v6Py5WXCP4U6t9TtTLb7vUGIpzkg01GIuKk4EAB4eXxaYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 11:35 PM, Sasha Levin wrote:
> On 10/20/2014 06:54 AM, Andrey Ryabinin wrote:
>>
>> UBSan uses compile-time instrumentation to catch undefined behavior (UB).
>> Compiler inserts code that perform certain kinds of
>> checks before operations that could cause UB.
>> If check fails (i.e. UB detected) __ubsan_handle_* function called.
>> to print error message.
>>
>> So the most of the work is done by compiler.
>> This patch just implements ubsan handlers printing errors.
>>
>> GCC supports this since 4.9, however upcoming GCC 5.0 has
>> more checkers implemented.
>>
>> Different kinds of checks could be enabled via boot parameter:
>> ubsan_handle=OEAINVBSLF.
>> If ubsan_handle not present in cmdline default options are used: ELNVBSLF
>>
>> 	O - different kinds of overflows
>> 	E - negation overflow, division overflow, division by zero.
>> 	A - misaligned memory access.
>> 	I - load from/store to an object with insufficient space.
>> 	N - null argument declared with nonnull attribute,
>> 	  returned null from function which never returns null, null ptr dereference.
>> 	V - variable size array with non-positive length
>> 	B - out-of-bounds accesses.
>> 	S - shifting out-of-bounds.
>> 	L - load of invalid value (value out of range for the enum type, loading other then 0/1 to bool type)
>> 	F - call to function through pointer with incorrect function type
>> 	    (AFAIK this is not implemented in gcc yet, probably works with clang, though
>> 	    	   I didn't check ubsan with clang at all).
>>
>> Instrumentation in kernel/printk/printk.c is disabled because struct printk_log is not properly aligned,
>> therefore we are recursively taking logbuf_lock while trying to print error in __ubsan_handle*().
>>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>  Makefile                              |  12 +-
>>  arch/x86/Kconfig                      |   1 +
>>  arch/x86/boot/Makefile                |   1 +
>>  arch/x86/boot/compressed/Makefile     |   1 +
>>  arch/x86/realmode/rm/Makefile         |   1 +
>>  arch/x86/vdso/Makefile                |   2 +
>>  drivers/firmware/efi/libstub/Makefile |   1 +
>>  include/linux/sched.h                 |   4 +
>>  kernel/printk/Makefile                |   1 +
>>  lib/Kconfig.debug                     |  23 ++
>>  lib/Makefile                          |   3 +
>>  lib/ubsan.c                           | 559 ++++++++++++++++++++++++++++++++++
>>  lib/ubsan.h                           |  84 +++++
>>  scripts/Makefile.lib                  |   6 +
>>  14 files changed, 698 insertions(+), 1 deletion(-)
>>  create mode 100644 lib/ubsan.c
>>  create mode 100644 lib/ubsan.h
>>
>> diff --git a/Makefile b/Makefile
>> index 05d67af..d3e23f9 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -377,6 +377,9 @@ LDFLAGS_MODULE  =
>>  CFLAGS_KERNEL	=
>>  AFLAGS_KERNEL	=
>>  CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
>> +CFLAGS_UBSAN	= $(call cc-option, -fsanitize=undefined) \
>> +			$(call cc-option, -fno-sanitize=unreachable) \
>> +			$(call cc-option, -fno-sanitize=float-cast-overflow)
> 
> What's the reason behind those two -fno-sanitize?

Both not implemented.

float-cast-overflow is for floating point arithmetic which we don't have in kernel.
This could be removed safely without needing to implement __ubsan_handle_float_cast_overflow().

fsanitize=unreachable is for catching calls to __builtin_unreachable().




>> +config HAVE_ARCH_UBSAN_SANTIZE_ALL
>> +	bool
>> +
>> +config UBSAN
>> +	bool "Undefined behaviour sanity checker"
>> +	help
>> +	  This option enables undefined behaviour sanity checker
>> +	  Compile-time instrumentataion used to detect various undefined
> 		       instrumentation
>> +	  behaviours in runtime. Different kinds of checks could be enabled
>> +	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
>> +	  (TODO: write docs).
>> +
>> +config UBSAN_SANITIZE_ALL
>> +	bool "Enable instrumentation for the entire kernel"
>> +	depends on UBSAN
>> +	depends on HAVE_ARCH_UBSAN_SANTIZE_ALL
>> +	default y
>> +	help
>> +	  This option acitivates instrumentation for the entire kernel.
>                       activates
>> +	  If you don't enable this option, you have to explicitly specify
>> +	  UBSAN_SANITIZE := y for the files/directories you want to check for UB.
>> +
>> +
> [snip
> 
>> +/* By default enable everything except signed overflows and
>> + * misaligned accesses
>> + */
> 
> Why those two are disabled? Maybe we should be fixing them rather
> than ignoring?
> 

Signed overflows are disabled because they are allowed in linux kernel. Using -fno-strict-alliasing
disables compiler's optimization based on assumption that signed overflow never happens. Though this
option doesn't make signed overflows defined, it was proven by years that it just works.
There is -fwrapv option which make signed overflows defined, but it's not used because it bogus on
some versions of compilers.


Unaligned accesses disabled because they are allowed on some arches (see HAVE_EFFICIENT_UNALIGNED_ACCESS).
Another reason is that there are to many reports. Not because there are lot of bugs, but because
there are many reports for one bug.
For example take a look at struct irqaction. It declared with ____cacheline_internodealigned_in_smp.

And look at the request_threaded_irq():

        action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
        if (!action)
                return -ENOMEM;

        action->handler = handler;
        action->thread_fn = thread_fn;
        action->flags = irqflags;
        action->name = devname;
        action->dev_id = dev_id;

This struct allocated via kmalloc which is wrong because in general kmalloc guaranties only sizeof(void *) alignment.
UBSan print report only once per source location, but there are many places where 'action' from above referenced.
Just after allocation where we fill struct's fields there will be 5 reports.


>> +static unsigned long ubsan_handle = GENMASK(HANDLERS_END, 0) &
>> +	~(BIT_MASK(SUM_OVERFLOW) | BIT_MASK(SUB_OVERFLOW) |
>> +		BIT_MASK(NEG_OVERFLOW) | BIT_MASK(ALIGNMENT));
Oops, s/NEG_OVERFLOW/MULL_OVERFLOW

>> +
>> +static void enable_handler(unsigned int handler)
>> +{
>> +	set_bit(handler, &ubsan_handle);
>> +}
>> +
>> +static bool handler_enabled(unsigned int handler)
>> +{
>> +	return test_bit(handler, &ubsan_handle);
>> +}
>> +
>> +#define REPORTED_BIT 31
>> +#define COLUMN_MASK (~(1U << REPORTED_BIT))
>> +
>> +static bool is_disabled(struct source_location *location)
>> +{
>> +	return test_and_set_bit(REPORTED_BIT,
>> +				(unsigned long *)&location->column);
>> +}
>> +
>> +static void print_source_location(const char *prefix, struct source_location *loc)
>> +{
>> +	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
>> +		loc->line, loc->column & COLUMN_MASK);
>> +}
>> +
>> +static bool type_is_int(struct type_descriptor *type)
>> +{
>> +	return type->type_kind == type_kind_int;
>> +}
>> +
>> +static bool type_is_signed(struct type_descriptor *type)
>> +{
>> +	return type_is_int(type) && (type->type_info & 1);
>> +}
>> +
>> +static unsigned type_bit_width(struct type_descriptor *type)
>> +{
>> +	return 1 << (type->type_info >> 1);
>> +}
>> +
>> +static bool is_inline_int(struct type_descriptor *type)
>> +{
>> +	unsigned inline_bits = sizeof(unsigned long)*8;
>> +	unsigned bits = type_bit_width(type);
>> +
> 
> Shouldn't we check type_is_int() here as well?
> 

It won't hurt.
This actually shouldn't be called for any other type than integer types,
so it deserves WARN_ON(!type_is_int());


>> +	return bits <= inline_bits;
>> +}
> 
> [snip]
> 
>> +void __ubsan_handle_negate_overflow(struct overflow_data *data,
>> +				unsigned long old_val)
>> +{
>> +
>> +	char old_val_str[60];
>> +
>> +	if (!handler_enabled(NEG_OVERFLOW))
>> +		return;
>> +
>> +	if (current->in_ubsan)
>> +		return;
>> +
>> +	if (is_disabled(&data->location))
>> +		return;
> 
> This pattern of 3 if()s is repeating itself couple of times, maybe
> it deserves a function of it's own?
> 
Definitely.

>> +	ubsan_prologue(&data->location);
>> +
>> +	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
>> +
>> +	pr_err("negation of %s cannot be represented in type %s:\n",
>> +		old_val_str, data->type->type_name);
>> +
>> +	ubsan_epilogue();
>> +}
>> +EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
> 
> 
> Thanks,
> Sasha
> 
> 

