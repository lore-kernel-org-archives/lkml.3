Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaFJQOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:14:12 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:58810 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFJQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <5396A772.1060103@nod.at>
References: <5396A772.1060103@nod.at>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 10 Jun 2014 09:13:49 -0700
Message-ID: <CALCETrU9QFBhJeES61FiKbNsF=ZUnmF9H3cg-6Gup-ov3PrpyA@mail.gmail.com>
Subject: Re: Out-of-bounds access in vread_hpet()
To: Richard Weinberger <richard@nod.at>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 11:36 PM, Richard Weinberger <richard@nod.at> wrote:
> FYI:
> ________________________________________________________________________________________________________
> *** CID 1222081:  Out-of-bounds access  (ARRAY_VS_SINGLETON)
> /arch/x86/vdso/vclock_gettime.c: 38 in vread_hpet()
> 32     #ifdef CONFIG_HPET_TIMER
> 33     extern u8 hpet_page
> 34      __attribute__((visibility("hidden")));
> 35
> 36     static notrace cycle_t vread_hpet(void)
> 37     {
>>>>     CID 1222081:  Out-of-bounds access  (ARRAY_VS_SINGLETON)
>>>>     Using "&hpet_page" as an array.  This might corrupt or misinterpret adjacent memory locations.
> 38      return *(const volatile u32 *)(&hpet_page + HPET_COUNTER);

That's a false positive.  HPET_COUNTER is a compile-time constant
index of a register, and hpet_page is the base address where the thing
is mapped.

I can change the code if there's something non-ugly that makes it
clearer, but ISTM that this particular warning might not make so much
sense when the offset is a real constant like this.

Hmm.  Maybe hpet_page could be redefined as const char hpet_page[PAGE_SIZE].

--Andy
