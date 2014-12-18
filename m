Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaLRTDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:03:36 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:47861 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLRTDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <549307F0.7090009@zytor.com>
References: <d7875b60e28c512f6a6fc0baf5714d58e7eaadbb.1418856405.git.luto@amacapital.net>
	<tip-3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0@git.kernel.org>
	<549307F0.7090009@zytor.com>
Date: Thu, 18 Dec 2014 11:03:33 -0800
X-Google-Sender-Auth: VU0NYQ5pw0WR0eBHv8e320j0Y9U
Message-ID: <CA+55aFwULSs-xiyQbpUezx3ebJOfRHz4uBE3Vw7S0dXVWbfEhQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/tls: Don't validate lm in set_thread_area()
 after all
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 8:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> will leave .lm uninitialized.  This means that anything in the
>> kernel that reads user_desc.lm for 32-bit tasks is unreliable.
>
> No, it won't.  However, if you initialize this dynamically field by
> field rather than as an initializer, then you are correct.

Actually, even with a full initializer, unnamed parts of a structure
(so padding bytes between things, but for bitfields also unnamed
alignment fields etc) are basically "all bets are off". They are *not*
guaranteed to be initialized to zero.

So if you have a structure like

   struct {
       unsigned int a:5;
       unsigned int b;
   } x = { .a = 0, .b = 0 };

afaik the compiler is not guaranteed to initialize the left-over bits
in the first word. Because they simply don't "exist" as far as the C
language is concerned.

On the other hand, if you do

   struct {
        unsigned int a:5, unused:27;
        unsigned int b;
   } x = { .a = 0, .b = 0 };

then the 'unused' bits are guaranteed to be initialized to zero.

(Static allocations in the BSS are obviously zeroed for other reasons,
so there are no "left-over" bits there to worry about,. So in practice
the above is only about dynamic initializers).

                         Linus
