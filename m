Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaJVJ7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:59:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50324 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaJVJ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:58:58 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
Organization: D03
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
	<1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
X-Hashcash: 1:20:141022:dvyukov@google.com::qXOAEkEwRYcYCMow:00000000000000000000000000000000000000000000+B2
X-Hashcash: 1:20:141022:linux-kbuild@vger.kernel.org::AN40SEzYbm4iCutG:0000000000000000000000000000000000d7H
X-Hashcash: 1:20:141022:x86@kernel.org::MIZxc23+0V9W1Feq:0001N2+
X-Hashcash: 1:20:141022:sasha.levin@oracle.com::Dy3IdPc0bQbLEV9q:0000000000000000000000000000000000000000ibs
X-Hashcash: 1:20:141022:mingo@redhat.com::EB+GrdGxRjQuU3GY:00Ah0
X-Hashcash: 1:20:141022:a.ryabinin@samsung.com::ax3TlmHGVud3RQON:0000000000000000000000000000000000000001R0+
X-Hashcash: 1:20:141022:mmarek@suse.cz::gcSRJ8MeyKHLRCg3:0001ouT
X-Hashcash: 1:20:141022:peterz@infradead.org::L2y9Im4CnbbDrJ1R:000000000000000000000000000000000000000002E/j
X-Hashcash: 1:20:141022:adilger.kernel@dilger.ca::5zDKwi+0nbu+lYbG:00000000000000000000000000000000000002oPv
X-Hashcash: 1:20:141022:koct9i@gmail.com::vtGDWiI7pOmklfng:05jO+
X-Hashcash: 1:20:141022:linux-kernel@vger.kernel.org::NBOSGaNqBp75m9OM:0000000000000000000000000000000007BIx
X-Hashcash: 1:20:141022:hpa@zytor.com::E4ePn9Mrtcp6J6Un:00008Txw
X-Hashcash: 1:20:141022:tglx@linutronix.de::3yyMHD7sqcwA63v1:00000000000000000000000000000000000000000009JhD
X-Hashcash: 1:20:141022:akpm@linux-foundation.org::eamUgOPAu96x4mi/:0000000000000000000000000000000000009h58
X-Hashcash: 1:20:141022:tytso@mit.edu::3+kRNb5WpyssWC48:0000FUEo
Date: Wed, 22 Oct 2014 11:58:54 +0200
In-Reply-To: <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
	(Andrey Ryabinin's message of "Mon, 20 Oct 2014 14:54:59 +0400")
Message-ID: <871tq077dt.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20 2014, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:

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

[...]

> +
> +#define REPORTED_BIT 31
> +#define COLUMN_MASK (~(1U << REPORTED_BIT))
> +
> +static bool is_disabled(struct source_location *location)
> +{
> +	return test_and_set_bit(REPORTED_BIT,
> +				(unsigned long *)&location->column);
> +}

[...]

> +struct source_location {
> +	const char *file_name;
> +	u32 line;
> +	u32 column;
> +};


AFAICT, this introduces UB and/or memory corruption on big-endian
systems with BITS_PER_LONG==64. (Also, on both LE and BE 64 bit systems,
there's the issue of the alignment of location->column, which is likely
to be 4-but-not-8 byte aligned).

Is the layout of struct source_location dictated by gcc? 

Rasmus
