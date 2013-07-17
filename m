Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3GQNQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:16:10 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54280 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3GQNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:16:05 -0400
Message-ID: <51E69911.3000804@twiddle.net>
Date: Wed, 17 Jul 2013 06:16:01 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
        linux-alpha@vger.kernel.org
Subject: Re: [RFC PATCH 05/10] alpha: Primitive support for CPU power down.
References: <1373996058-13399-1-git-send-email-rth@twiddle.net> <1373996058-13399-6-git-send-email-rth@twiddle.net> <CAEdQ38FF32t+Ca0EsEk=uArhU28HKGf91=F1DzA+NE88WDVKtw@mail.gmail.com>
In-Reply-To: <CAEdQ38FF32t+Ca0EsEk=uArhU28HKGf91=F1DzA+NE88WDVKtw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 10:17 PM, Matt Turner wrote:
> On Tue, Jul 16, 2013 at 10:34 AM, Richard Henderson <rth@twiddle.net> wrote:
>> Use WTINT to wait for the next interrupt.  Squash the WTINT call
>> if the PALcode doesn't support it (e.g. MILO).  No attempt is yet
>> made to skip clock ticks during normal scheduling in order to stay
>> in power down mode longer.
> 
> The architecture reference manual says
> 
>> The counter, PCC, may increment at a lower rate or may stop entirely
>> during wtint execution. This side effect is implementation dependent.
> 
> Is that anything to worry about?

Hmm, yes.  It means that we can't use both this and rpcc as a clocksource.
Which we can't do while SMP either, so perhaps that's not so bad.  So, right
now, with an SMP EV6 system we ought not worry.  Care to report whether that
hypothesis is true?

It may well be a tradeoff we want to CONFIG though, since nothing in the EV5
thru PCA56 can make use of the power down state, and were often uniprocessor
systems...

>> @@ -243,6 +243,18 @@ do_entIF(unsigned long type, struct pt_regs *regs)
>>                                (const char *)(data[1] | (long)data[2] << 32),
>>                                data[0]);
>>                 }
>> +               if (type == 4) {
>> +                       /* If CALL_PAL WTINT is not supported by the PALcode,
>> +                          "emulate" it by overwriting the insn.  */
> 
> The pseudo-code for WTINT contains an IF(implemented) check, where the
> ELSE case just does v0 <- 0. So is overwriting with nop just an
> optimization to avoid the (expensive) PAL call? If it is, could we
> clarify the comment?

No, notice where this code is: entIF, aka SIGILL.  Looking at MILO sources
I can tell you that WTINT isn't implemented at all.  Overwriting with the
mov insn is what I call "emulating" the unimplemented PALcall.


r~
