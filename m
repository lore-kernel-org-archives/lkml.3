Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaE1Pzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:55:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33425 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaE1Pzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:55:42 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: larry.bassel@linaro.org, Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel\@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman\@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v5 2/2] arm64: enable context tracking
References: <1401130573-7443-1-git-send-email-larry.bassel@linaro.org>
	<1401130573-7443-3-git-send-email-larry.bassel@linaro.org>
	<20140528114438.GF15222@arm.com>
Date: Wed, 28 May 2014 08:55:39 -0700
In-Reply-To: <20140528114438.GF15222@arm.com> (Will Deacon's message of "Wed,
	28 May 2014 12:44:38 +0100")
Message-ID: <7hegzd99tw.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Will Deacon <will.deacon@arm.com> writes:

> On Mon, May 26, 2014 at 07:56:13PM +0100, Larry Bassel wrote:
>> Make calls to ct_user_enter when the kernel is exited
>> and ct_user_exit when the kernel is entered (in el0_da,
>> el0_ia, el0_svc, el0_irq and all of the "error" paths).
>> 
>> These macros expand to function calls which will only work
>> properly if el0_sync and related code has been rearranged
>> (in a previous patch of this series).
>> 
>> The calls to ct_user_exit are made after hw debugging has been
>> enabled (enable_dbg_and_irq).
>> 
>> The call to ct_user_enter is made at the beginning of the
>> kernel_exit macro.
>> 
>> This patch is based on earlier work by Kevin Hilman.
>> Save/restore optimizations were also done by Kevin.
>
> Apologies if we've discussed this before (it rings a bell), but why are we
> penalising the fast syscall path with this? Shouldn't TIF_NOHZ contribute to
> out _TIF_WORK_MASK, then we could do the tracking on the syscall slow path?

I'll answer here since Larry inherited this design decision from me.

I considered (and even implemented) forcing the slow syscall path
based on TIF_NOHZ but decided (perhaps wrongly) not to.  I guess the
choice is between:

- forcing the overhead of syscall tracing path on all
  TIF_NOHZ processes

- forcing the (much smaller) ct_user_exit overhead on all syscalls,
  (including the fast syscall path)

I had decided that the former was better, but as I write this, I'm
thinking that the NOHZ tasks should probably eat the extra overhead
since we expect their interactions with the kernel to be minimal anyways
(part of the goal of full NOHZ.)

Ultimately, I'm OK with either way and have the other version ready.

> I think that would tidy up your mov into x19 too.

That's correct.  If we force the syscall_trace path, the ct_user_enter
wouldn't have to do any context save/restore.

> Also -- how do you track ret_from_fork in the child with these patches?

Not sure I follow the question, but ret_from_fork calls
ret_to_user, which calls kernel_exit, which calls ct_user_enter.

Kevin
