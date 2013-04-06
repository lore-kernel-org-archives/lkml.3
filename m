Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3DFTze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 15:55:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35692 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab3DFTzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 15:55:32 -0400
From: "Jacquiot, Aurelien" <a-jacquiot@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mark Salter <msalter@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>
Subject: RE: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
Thread-Topic: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for
 !PREEMPT_COUNT
Thread-Index: AQHOMvDCgnE7wUdM3EW76eI+KEq3z5jJmscg
Date: Sat, 6 Apr 2013 19:54:53 +0000
Message-ID: <553CFBBAF1315044BC4CD328C97B0B1C1804500D@DNCE05.ent.ti.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	<20130404152808.GB15261@ab42.lan>	<515E54BD.2090300@synopsys.com>
	<51602459.3040105@synopsys.com>
	<CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
 <CA+55aFyvD2NtQatdaFZt+Q6ZPD0USofhgZHEock8rOx0ihSLhQ@mail.gmail.com>
In-Reply-To: <CA+55aFyvD2NtQatdaFZt+Q6ZPD0USofhgZHEock8rOx0ihSLhQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.131.83]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r36JtujV016543

Agreed. We will fix it.

Aurelien


Texas Instruments France SA, 821 Avenue Jack Kilby, 06270 Villeneuve Loubet. 036 420 040 R.C.S Antibes. Capital de EUR 12.654.784

-----Original Message-----
From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus Torvalds
Sent: Saturday, April 06, 2013 8:01 PM
To: Vineet Gupta; Mark Salter; Jacquiot, Aurelien
Cc: Thomas Gleixner; Christian Ruppert; Pierrick Hascoet; Frederic Weisbecker; Steven Rostedt; Peter Zijlstra; Ingo Molnar; Linux Kernel Mailing List; linux-arch@vger.kernel.org; linux-c6x-dev@linux-c6x.org
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT

Looking around, it looks like c6x has the same bug.

Some other architectures (tile) have such subtle implementations (where is __insn_mtspr() defined?) that I have a hard time judging.
And maybe I missed something, but the rest seem ok.

                Linus

On Sat, Apr 6, 2013 at 9:13 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> This is all *COMPLETELY* wrong.
>
> Neither the normal preempt macros, nor the plain spinlocks, should
> protect anything at all against interrupts.
>
> The real protection should come from the  spin_lock_irqsave() in
> lock_timer_base(), not from spinlocks, and not from preemption.
>
> It sounds like ARC is completely buggered, and hasn't made the irq
> disable be a compiler barrier. That's an ARC bug, and it's a big one,
> and can affect a lot more than just the timers.
>
> So the real fix is to add a "memory" clobber to
> arch_local_irq_save/restore() and friends, so that the compiler
> doesn't get to cache memory state from the irq-enabled region into the
> irq-disabled one.
>
> Fix ARC, don't try to blame generic code. You should have asked
> yourself why only ARC saw this bug, when the code apparently works
> fine for everybody else!
>
>                    Linus
>
> On Sat, Apr 6, 2013 at 6:34 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>> On 04/05/2013 10:06 AM, Vineet Gupta wrote:
>>> Hi Thomas,
>>>
>>> Given that we are closing on 3.9 release, and that one/more of these
>>> patches fix a real issue for us - can you please consider my earlier
>>> patch to fix
>>> timer_pending() only for 3.9
>>> [http://www.spinics.net/lists/kernel/msg1508224.html]
>>> This will be a localized / low risk change for this late in cycle.
>>>
>>> For 3.10 - assuming preempt_* change is blessed, we can revert this
>>> one and add that fuller/better fix.
>>>
>>> What do you think ?
>>>
>>> Thx,
>>> -Vineet
>>>
>>
>> Ping ! Sorry for pestering, but one of the fixes is needed before 3.9 goes out.
>>
>> Simple localized fix:
>> http://www.spinics.net/lists/kernel/msg1508224.html
>> Better but risky: http://www.spinics.net/lists/kernel/msg1510885.html
>>
>> Thx,
>> -Vineet

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
