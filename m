Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3IBLmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:42:00 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:37276 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3IBLl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:41:58 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for ARC
Thread-Topic: [PATCH] Kconfig.debug: Add FRAME_POINTER anti-dependency for
 ARC
Thread-Index: AQHOov/erDeR0JeI70CghkAjOCB3Tg==
Date: Mon, 2 Sep 2013 11:41:53 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751414AB@IN01WEMBXA.internal.synopsys.com>
References: <1377592285-21148-1-git-send-email-vgupta@synopsys.com>
 <CAOtvUMcKprmyKdi-+TJNvCNqaDv=6WLxeATkJtFe+b1c1bSSGA@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gilad,

On 09/02/2013 02:33 PM, Gilad Ben-Yossef wrote:
> Hi,
>
> On Tue, Aug 27, 2013 at 11:31 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> Frame pointer on ARC doesn't serve the conventional purpose of stack
>> unwinding due to the typical way ABI designates it's usage.
> More out of curiosity to understand the platform better than actual
> review - can you explain a little what
> you meant by this statement?
>
> Is this statement because of the use of write back mode with ld/st to
> or not related?

No - this is not related to to any LD/ST addressing/wb modes.

ARCompact ISA has 2 stack related registers, SP (top) and FP (Base)

A typical frame pointer-ish ABI would do sometime like this
1. push BLINK (return address)
2. push FP
3. FP = SP
4. push callee-regs
5. allocate stack for local vars etc
...

Note that beyond #3, FP remains constant while this function is in scope. Thus
from anywhere inside the function, [FP, 4] always has caller's PC and [FP, 0]
always has caller's FP. This makes it possible to retract back to caller and from
there to it's caller and so on.

However the ARC gcc ABI - set in stone many years ago doesn't do this. It does 1,
4, 2, 3...

With FP no longer having base address of current call, it can't be used to get
FP/BLINK of prev frame so from stack unwinding perspective, there's no point in
using FP for stack frames. More importantly, FP usage bloats function
prologue/epilogue - adds extra stack ops, .... hence it's usage in general is
discouraged. gcc though is free to summon it's usage for typical stack frames (var
sized arrays etc).

Hence the reason we don't ever build ARC with FP and need for this patch.

HTH,
-Vineet

