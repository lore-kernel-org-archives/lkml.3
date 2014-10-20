Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaJTLDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:03:40 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51658 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaJTLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:03:37 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-04-5444ec06b15d
Message-id: <5444EBFA.5030103@samsung.com>
Date: Mon, 20 Oct 2014 15:03:22 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.1
MIME-version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
In-reply-to: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e/4NV22Ny4hBkt+W1t8/dLBYjFn/Ro2
	iwkP29gtpm0Ut1jZ+YDV4s+uHUwWl3fNYbO4dGABk0XLvgtMFsd7DzBZLD5ym9li86apzBat
	PT/ZLX5seMzqwOfRsrncY+esu+weCzaVemxeoeWxaVUnm8e7c+fYPU7M+M3i0XTmKLPHx6e3
	WDze77vK5nFmwRF2j8+b5DxOtHxhDeCN4rJJSc3JLEst0rdL4MqYumArS8F1iYql17eyNzCu
	FO1i5OSQEDCR+PzjAROELSZx4d56ti5GLg4hgaWMEis6nzJCOM1MEr8uHWEEqeIV0JI4cusi
	cxcjBweLgKrE0/5ikDCbgJ7Ev1nb2UBsUYEIiY3rd0CVC0r8mHyPBcQWEVCUuNXyhRlkJrPA
	JWaJS7NPgiWEBRwk5jW9BWsWEnCT6L50COwiTgF3iQvz9jKD2MwC6hKT5i2CsuUlNq95yzyB
	UWAWkh2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI1H3Zwbj4mNUhRgEO
	RiUeXgFLlxAh1sSy4srcQ4wSHMxKIrzdt4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGDNXvhb9
	ZcZkXHcmV5OHV/OqzEqJtXu5jzm/fiWpeXvN2pttl20sbhkpdij/8DGeMFui5EpY7k3fT9q3
	+ev2vmizOFlZ077povT/lcyHREU1TF/t+Kb14abxNba1czu3qmf6hitaJs7LWj9ve7RSeesf
	pSPn1y9Y9nDeyy8Xmv4dO+CQNOnpET0lluKMREMt5qLiRADiPOcRmAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Theodore.

I've got this while booting kernel with ubsan:

    [    0.000000] ================================================================================
    [    0.000000] UBSan: Undefined behaviour in ../include/linux/bitops.h:107:33
    [    0.000000] shift exponent 32 is to large for 32-bit type 'unsigned int'
    [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc1+ #64
    [    0.000000]  0000000000000020 0000000000000000 0000000000000000 ffffffff83003c68
    [    0.000000]  ffffffff82add58a 000000000000009f 0000000000000020 ffffffff83003c78
    [    0.000000]  ffffffff819a4519 ffffffff83003d28 ffffffff819a4a05 ffffffff82df889d
    [    0.000000] Call Trace:
    [    0.000000] dump_stack (/home/andrew/linux/ubsan_x86//lib/dump_stackc:52)
    [    0.000000] ubsan_epilogue (/home/andrew/linux/ubsan_x86//lib/ubsanc:159)
    [    0.000000] __ubsan_handle_shift_out_of_bounds (/home/andrew/linux/ubsan_x86//lib/ubsanc:458)
    [    0.000000] ? dmi_string_nosave (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:51)
    [    0.000000] ? dmi_string (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:72)
    [    0.000000] ? dmi_save_ident (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:159)
    [    0.000000] _mix_pool_bytes (/home/andrew/linux/ubsan_x86//include/linux/bitopsh:107 /home/andrew/linux/ubsan_x86//drivers/char/randomc:509)
    [    0.000000] ? dmi_decode (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:376)
    [    0.000000] ? dmi_walk_early (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:127)
    [    0.000000] add_device_randomness (/home/andrew/linux/ubsan_x86//drivers/char/randomc:747)
    [    0.000000] ? dmi_save_one_device (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:375)
    [    0.000000] ? dmi_save_one_device (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:375)
    [    0.000000] dmi_walk_early (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:127)
    [    0.000000] dmi_present (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:497)
    [    0.000000] dmi_scan_machine (/home/andrew/linux/ubsan_x86//drivers/firmware/dmi_scanc:555)
    [    0.000000] setup_arch (/home/andrew/linux/ubsan_x86//arch/x86/kernel/setupc:1022)
    [    0.000000] ? printk (/home/andrew/linux/ubsan_x86//kernel/printk/printkc:1849)
    [    0.000000] ? early_idt_handlers (/home/andrew/linux/ubsan_x86//arch/x86/kernel/head_64S:344)
    [    0.000000] start_kernel (/home/andrew/linux/ubsan_x86//include/linux/bitmaph:162 /home/andrew/linux/ubsan_x86//include/linux/cpumaskh:333
/home/andrew/linux/ubsan_x86//include/linux/mm_typesh:464 /home/andrew/linux/ubsan_x86//init/mainc:532)
    [    0.000000] ? early_idt_handlers (/home/andrew/linux/ubsan_x86//arch/x86/kernel/head_64S:344)
    [    0.000000] x86_64_start_reservations (/home/andrew/linux/ubsan_x86//arch/x86/kernel/head64c:194)
    [    0.000000] x86_64_start_kernel (/home/andrew/linux/ubsan_x86//arch/x86/kernel/head64c:183)
    [    0.000000] ================================================================================
