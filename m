Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3KKThL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:37:11 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39384 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3KKThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:37:05 -0500
MIME-Version: 1.0
In-Reply-To: <52812F92.1020006@zytor.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
	<tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
	<20131111182046.GA14961@gmail.com>
	<52812F92.1020006@zytor.com>
Date: Mon, 11 Nov 2013 11:37:04 -0800
X-Google-Sender-Auth: LO82R9_U5IJ2shEgJxExPxIx61w
Message-ID: <CAGXu5j+66dfv_048iDp+ZAv4_sS4si9cHG-8L_4zJ1OHHLxaUw@mail.gmail.com>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/11/2013 10:20 AM, Ingo Molnar wrote:
>>
>> Why aren't the 3 sources of entropy XOR-ed together?
>>
>
> Note we don't want to poke i8254 if we have any other sources, as the
> i8254 may not be present on newer systems and in some other cases not
> safe to touch.  We can XOR in the TSC with RDRAND although it seems a
> bit odd.

I await the final decision! :)

> HOWEVER...
>
> +               /* Only use the low bits of rdtsc. */
> +               random = raw & 0xffff;
>
> Why?!  All that can do is throw away randomness...

Due to the 2GiB addressing and 2MiB alignment, we can never use more
than 10 bits of entropy at maximum. The existing patches only use 9
bits (due to page table layouts) on 64-bit and 8 bits on 32-bit.

> +       /* Extend timer bits poorly... */
> +       random |= (random << 16);
> +#ifdef CONFIG_X86_64
> +       random |= (random << 32);
> +#endif

I did this so that any portion of the returned value could be used for
the 10 bit mask.

> For smearing out bits, a better way is usually to multiply with a large
> prime number (preferably a circular multiply.)

This shouldn't be needed since we're only using the low 10 bits.

How would you like to see this function updated to make that more
clear? More comments?

-Kees

-- 
Kees Cook
Chrome OS Security
