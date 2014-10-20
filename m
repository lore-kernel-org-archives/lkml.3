Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaJTTgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:36:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30865 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaJTTgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:36:40 -0400
Message-ID: <5445640F.10000@oracle.com>
Date: Mon, 20 Oct 2014 15:35:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 06:54 AM, Andrey Ryabinin wrote:
> 
> UBSan uses compile-time instrumentation to catch undefined behavior (UB).
> Compiler inserts code that perform certain kinds of
> checks before operations that could cause UB.
> If check fails (i.e. UB detected) __ubsan_handle_* function called.
> to print error message.
> 
> So the most of the work is done by compiler.
> This patch just implements ubsan handlers printing errors.
> 
> GCC supports this since 4.9, however upcoming GCC 5.0 has
> more checkers implemented.
> 
> Different kinds of checks could be enabled via boot parameter:
> ubsan_handle=OEAINVBSLF.
> If ubsan_handle not present in cmdline default options are used: ELNVBSLF
> 
> 	O - different kinds of overflows
> 	E - negation overflow, division overflow, division by zero.
> 	A - misaligned memory access.
> 	I - load from/store to an object with insufficient space.
> 	N - null argument declared with nonnull attribute,
> 	  returned null from function which never returns null, null ptr dereference.
> 	V - variable size array with non-positive length
> 	B - out-of-bounds accesses.
> 	S - shifting out-of-bounds.
> 	L - load of invalid value (value out of range for the enum type, loading other then 0/1 to bool type)
> 	F - call to function through pointer with incorrect function type
> 	    (AFAIK this is not implemented in gcc yet, probably works with clang, though
> 	    	   I didn't check ubsan with clang at all).
> 
> Instrumentation in kernel/printk/printk.c is disabled because struct printk_log is not properly aligned,
> therefore we are recursively taking logbuf_lock while trying to print error in __ubsan_handle*().
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  Makefile                              |  12 +-
>  arch/x86/Kconfig                      |   1 +
>  arch/x86/boot/Makefile                |   1 +
>  arch/x86/boot/compressed/Makefile     |   1 +
>  arch/x86/realmode/rm/Makefile         |   1 +
>  arch/x86/vdso/Makefile                |   2 +
>  drivers/firmware/efi/libstub/Makefile |   1 +
>  include/linux/sched.h                 |   4 +
>  kernel/printk/Makefile                |   1 +
>  lib/Kconfig.debug                     |  23 ++
>  lib/Makefile                          |   3 +
>  lib/ubsan.c                           | 559 ++++++++++++++++++++++++++++++++++
>  lib/ubsan.h                           |  84 +++++
>  scripts/Makefile.lib                  |   6 +
>  14 files changed, 698 insertions(+), 1 deletion(-)
>  create mode 100644 lib/ubsan.c
>  create mode 100644 lib/ubsan.h
> 
> diff --git a/Makefile b/Makefile
> index 05d67af..d3e23f9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -377,6 +377,9 @@ LDFLAGS_MODULE  =
>  CFLAGS_KERNEL	=
>  AFLAGS_KERNEL	=
>  CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
> +CFLAGS_UBSAN	= $(call cc-option, -fsanitize=undefined) \
> +			$(call cc-option, -fno-sanitize=unreachable) \
> +			$(call cc-option, -fno-sanitize=float-cast-overflow)

What's the reason behind those two -fno-sanitize?

[snip]

> +config HAVE_ARCH_UBSAN_SANTIZE_ALL
> +	bool
> +
> +config UBSAN
> +	bool "Undefined behaviour sanity checker"
> +	help
> +	  This option enables undefined behaviour sanity checker
> +	  Compile-time instrumentataion used to detect various undefined
		       instrumentation
> +	  behaviours in runtime. Different kinds of checks could be enabled
> +	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
> +	  (TODO: write docs).
> +
> +config UBSAN_SANITIZE_ALL
> +	bool "Enable instrumentation for the entire kernel"
> +	depends on UBSAN
> +	depends on HAVE_ARCH_UBSAN_SANTIZE_ALL
> +	default y
> +	help
> +	  This option acitivates instrumentation for the entire kernel.
                      activates
> +	  If you don't enable this option, you have to explicitly specify
> +	  UBSAN_SANITIZE := y for the files/directories you want to check for UB.
> +
> +
[snip

> +/* By default enable everything except signed overflows and
> + * misaligned accesses
> + */

Why those two are disabled? Maybe we should be fixing them rather
than ignoring?

> +static unsigned long ubsan_handle = GENMASK(HANDLERS_END, 0) &
> +	~(BIT_MASK(SUM_OVERFLOW) | BIT_MASK(SUB_OVERFLOW) |
> +		BIT_MASK(NEG_OVERFLOW) | BIT_MASK(ALIGNMENT));
> +
> +static void enable_handler(unsigned int handler)
> +{
> +	set_bit(handler, &ubsan_handle);
> +}
> +
> +static bool handler_enabled(unsigned int handler)
> +{
> +	return test_bit(handler, &ubsan_handle);
> +}
> +
> +#define REPORTED_BIT 31
> +#define COLUMN_MASK (~(1U << REPORTED_BIT))
> +
> +static bool is_disabled(struct source_location *location)
> +{
> +	return test_and_set_bit(REPORTED_BIT,
> +				(unsigned long *)&location->column);
> +}
> +
> +static void print_source_location(const char *prefix, struct source_location *loc)
> +{
> +	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
> +		loc->line, loc->column & COLUMN_MASK);
> +}
> +
> +static bool type_is_int(struct type_descriptor *type)
> +{
> +	return type->type_kind == type_kind_int;
> +}
> +
> +static bool type_is_signed(struct type_descriptor *type)
> +{
> +	return type_is_int(type) && (type->type_info & 1);
> +}
> +
> +static unsigned type_bit_width(struct type_descriptor *type)
> +{
> +	return 1 << (type->type_info >> 1);
> +}
> +
> +static bool is_inline_int(struct type_descriptor *type)
> +{
> +	unsigned inline_bits = sizeof(unsigned long)*8;
> +	unsigned bits = type_bit_width(type);
> +

Shouldn't we check type_is_int() here as well?

> +	return bits <= inline_bits;
> +}

[snip]

> +void __ubsan_handle_negate_overflow(struct overflow_data *data,
> +				unsigned long old_val)
> +{
> +
> +	char old_val_str[60];
> +
> +	if (!handler_enabled(NEG_OVERFLOW))
> +		return;
> +
> +	if (current->in_ubsan)
> +		return;
> +
> +	if (is_disabled(&data->location))
> +		return;

This pattern of 3 if()s is repeating itself couple of times, maybe
it deserves a function of it's own?

> +	ubsan_prologue(&data->location);
> +
> +	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
> +
> +	pr_err("negation of %s cannot be represented in type %s:\n",
> +		old_val_str, data->type->type_name);
> +
> +	ubsan_epilogue();
> +}
> +EXPORT_SYMBOL(__ubsan_handle_negate_overflow);


Thanks,
Sasha

