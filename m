Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3JGIzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:55:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57381 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3JGIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:55:46 -0400
Date: Mon, 7 Oct 2013 10:55:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131007085533.GZ3081@twins.programming.kicks-ass.net>
References: <20131005234430.GA22485@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005234430.GA22485@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 07:44:30AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 0c44c2d0f459cd7e275242b72f500137c4fa834d
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Sep 11 15:19:24 2013 +0200
> 
>     x86: Use asm goto to implement better modify_and_test() functions
>     
>     Linus suggested using asm goto to get rid of the typical SETcc + TEST
>     instruction pair -- which also clobbers an extra register -- for our
>     typical modify_and_test() functions.
>     
>     Because asm goto doesn't allow output fields it has to include an
>     unconditinal memory clobber when it changes a memory variable to force
>     a reload.
>     
>     Luckily all atomic ops already imply a compiler barrier to go along
>     with their memory barrier semantics.
>     
>     Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Link: http://lkml.kernel.org/n/tip-0mtn9siwbeo1d33bap1422se@git.kernel.org
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>


Well that blows,.. Anybody got any clue as to where to start looking?
I've not actually seen anything like this on my own machines.

Wu, do you use the same compiler version for all the builds that crash
like this (I'm assuming the other email was this same commit)? Does a
different compiler make things work again?


> [    3.336040] Write protecting the kernel read-only data: 2644k
> [    3.336982] NX-protecting the kernel data: 6152k
> [    3.375173] BUG: unable to handle kernel paging request at 00740060
> [    3.376162] IP: [<81053fc4>] task_work_run+0x54/0xa0
> [    3.376837] *pdpt = 00000000072e1001 *pde = 0000000000000000 
> [    3.377579] Oops: 0000 [#1] DEBUG_PAGEALLOC
> [    3.378158] CPU: 0 PID: 85 Comm: hostname Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #5
> [    3.378206] task: 8730c000 ti: 8730e000 task.ti: 8730e000
> [    3.378206] EIP: 0060:[<81053fc4>] EFLAGS: 00010206 CPU: 0
> [    3.378206] EIP is at task_work_run+0x54/0xa0
> [    3.378206] EAX: 00740060 EBX: 87309000 ECX: 00000000 EDX: 00740060
> [    3.378206] ESI: 8730c388 EDI: 8730c000 EBP: 8730ff40 ESP: 8730ff34
> [    3.378206]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    3.378206] CR0: 8005003b CR2: 00740060 CR3: 072d7000 CR4: 000006b0
> [    3.378206] Stack:
> [    3.378206]  ffffffff 87308058 8730c000 8730ff8c 81039315 77675fb8 8105af7b 00000000
> [    3.378206]  8730ffac 00000001 6c0e41a5 61636f6c 736f686c 6f6c2e74 646c6163 8730c398
> [    3.378206]  815fc8fe 81022f40 00000000 00000000 872f1880 8730c000 8730ffa4 81039a0a
> [    3.378206] Call Trace:
> [    3.378206]  [<81039315>] do_exit+0x2a5/0x910
> [    3.378206]  [<8105af7b>] ? up_write+0x1b/0x30
> [    3.378206]  [<815fc8fe>] ? restore_all+0xf/0xf
> [    3.378206]  [<81022f40>] ? kvm_read_and_reset_pf_reason+0x40/0x40
> [    3.378206]  [<81039a0a>] do_group_exit+0x4a/0xa0
> [    3.378206]  [<81039a78>] SyS_exit_group+0x18/0x20
> [    3.378206]  [<815fcf50>] sysenter_do_call+0x12/0x3c
> [    3.378206] Code: 36 31 c9 89 d0 0f b1 0e 39 c2 75 eb 85 d2 74 5c 8d b4 26 00 00 00 00 f3 90 8b 87 c0 03 00 00 85 c0 74 f4 31 db eb 04 89 d3 89 c2 <8b> 02 89 1a 85 c0 75 f4 eb 16 66 90 f6 47 0c 04 74 c4 b9 f0 af
> [    3.378206] EIP: [<81053fc4>] task_work_run+0x54/0xa0 SS:ESP 0068:8730ff34
> [    3.378206] CR2: 0000000000740060
> [    3.394549] ---[ end trace a6f697254c888db0 ]---
> 
