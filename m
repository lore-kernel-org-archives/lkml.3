Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaJTLH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:07:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55718 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaJTLHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:07:54 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-bf-5444ed07cc09
Message-id: <5444ED06.6030008@samsung.com>
Date: Mon, 20 Oct 2014 15:07:50 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.1
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: kernel: clockevents: shift out-of-bounds
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
In-reply-to: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4VV32ty4hBpdf6lt8/dLBYjFn/Ro2
	iwkP29gtpm0Ut1jZ+YDV4s+uHUwWl3fNYbO4dGABk0XLvgtMFsd7DzBZLD5ym9li86apzBat
	PT/ZLX5seMzqwOfRsrncY+esu+weCzaVemxeoeWxaVUnm8e7c+fYPU7M+M3i0XTmKLPHx6e3
	WDze77vK5nFmwRF2j8+b5DxOtHxhDeCN4rJJSc3JLEst0rdL4Mo4+vwMS8Ek/oqbxxoYGxj/
	8XQxcnJICJhIXD+ygQnCFpO4cG89G4gtJLCUUeLd4pIuRi4gu5lJYtvsLYwgCV4BLYmuc+tZ
	QGwWAVWJ87t2M4PYbAJ6Ev9mbQdrFhWIkNi4fgdUvaDEj8n3wOpFBDQkNl66xQwylFngJLPE
	kj172EESwgKGEtMvz2OB2Owm0X3pENhFnALuEhfm7QVbwCygLjFp3iIoW15i85q3zBMYBWYh
	2TELSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRE3dcdjEuPWR1iFOBgVOLh
	3WHmEiLEmlhWXJl7iFGCg1lJhLf7NlCINyWxsiq1KD++qDQntfgQIxMHp1QDY5+Z2v8ziYs3
	rH4w73J4x437Gp6Fh8Mj3jTU6b9+907zRcwWFycZp5pX16O2zV2seuJa1GyP7BDGd7OFFGrF
	0kvc1HYoqws8tMt8P23h0gO3v/0ptOf6sn6yqWkS5yqBiadE1i/mTe9dO1tiwlK++VnSm2/v
	qp/29vtm1tQW2Xv/Te6Wrj0v9ECJpTgj0VCLuag4EQBFQWjJmAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On kernel with UBSan enabled I've got following:

     UBSan: Undefined behaviour in ../kernel/time/clockevents.c:75:34
     shift exponent 32 is to large for 32-bit type 'unsigned int'
     CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc7+ #39
     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
      0000000000000000 0000000000000000 0000000000000001 ffffffff83003db0
      ffffffff82a30940 0000000000000020 ffffffff83003dc0 ffffffff819502e9
      ffffffff83003e40 ffffffff81950735 ffff88013f003233 0000000000000000
     Call Trace:
     dump_stack (/home/andrew/linux/lib/dump_stack.c:52)
     ubsan_epilogue (/home/andrew/linux/lib/ubsan.c:122)
     __ubsan_handle_shift_out_of_bounds (/home/andrew/linux/lib/ubsan.c:390)
     ? hpet_enable (/home/andrew/linux/arch/x86/kernel/hpet.c:862)
     cev_delta2ns (/home/andrew/linux/kernel/time/clockevents.c:75 (discriminator 1))
     clockevents_config.part.2 (/home/andrew/linux/kernel/time/clockevents.c:421)
     ? __clocksource_select (/home/andrew/linux/kernel/time/clocksource.c:607 /home/andrew/linux/kernel/time/clocksource.c:631)
     clockevents_config_and_register (/home/andrew/linux/kernel/time/clockevents.c:440)
     hpet_enable (/home/andrew/linux/arch/x86/kernel/hpet.c:305 /home/andrew/linux/arch/x86/kernel/hpet.c:891)
     hpet_time_init (/home/andrew/linux/arch/x86/kernel/time.c:79)
     x86_late_time_init (/home/andrew/linux/arch/x86/kernel/time.c:87)
     start_kernel (/home/andrew/linux/init/main.c:637)
     ? early_idt_handlers (/home/andrew/linux/arch/x86/kernel/head_64.S:344)
     x86_64_start_reservations (/home/andrew/linux/arch/x86/kernel/head64.c:194)
     x86_64_start_kernel (/home/andrew/linux/arch/x86/kernel/head64.c:183)

I guess it should be 1ULL here instead of 1U:
            (!ismax || evt->mult <= (1U << evt->shift)))

