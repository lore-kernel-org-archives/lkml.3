Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaLBQnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:43:25 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39341 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLBQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:43:23 -0500
Message-ID: <547dec29.c71f8c0a.33d1.11d9@mx.google.com>
Date: Tue, 2 Dec 2014 14:43:17 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141201230813.GE25340@linux.vnet.ibm.com>
References: <20141126225745.GA30346@redhat.com>
	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 15:08:13 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Well, this turned out to be way simpler than I expected.  Passes
> light rcutorture testing.  Sometimes you get lucky...

	Linus, Paul and others, I finally got a call trace with
only CONFIG_TREE_PREEMPT_RCU *disabled* using Paul's patch (to trigger 
it I compiled PHP with make -j8).

Dec  2 14:24:39 tux kernel: [ 8475.941616] conftest[9730]: segfault at 0 ip 0000000000400640 sp 00007fffa67ab300 error 4 in conftest[400000+1000]
Dec  2 14:24:40 tux kernel: [ 8476.104725] conftest[9753]: segfault at 0 ip 00007f6863024906 sp 00007fff0e31cc48 error 4 in libc-2.19.so[7f6862efe000+1a1000]
Dec  2 14:25:54 tux kernel: [ 8550.791697] INFO: rcu_sched detected stalls on CPUs/tasks: { 4} (detected by 0, t=60002 jiffies, g=112854, c=112853, q=0)
Dec  2 14:25:54 tux kernel: [ 8550.791702] Task dump for CPU 4:
Dec  2 14:25:54 tux kernel: [ 8550.791703] cc1             R  running task        0 14344  14340 0x00080008
Dec  2 14:25:54 tux kernel: [ 8550.791706]  000000001bcebcd8 ffff880100000003 ffffffff810cb7f1 ffff88021f5f5c00
Dec  2 14:25:54 tux kernel: [ 8550.791708]  ffff88011bcebfd8 ffff88011bcebce8 ffffffff811fb970 ffff8802149a2a00
Dec  2 14:25:54 tux kernel: [ 8550.791710]  ffff8802149a2cc8 ffff88011bcebd28 ffffffff8103e979 ffff88020ed01398
Dec  2 14:25:54 tux kernel: [ 8550.791712] Call Trace:
Dec  2 14:25:54 tux kernel: [ 8550.791718]  [<ffffffff810cb7f1>] ? release_pages+0xa1/0x1e0
Dec  2 14:25:54 tux kernel: [ 8550.791722]  [<ffffffff811fb970>] ? cpumask_any_but+0x30/0x40
Dec  2 14:25:54 tux kernel: [ 8550.791725]  [<ffffffff8103e979>] ? flush_tlb_page+0x49/0xf0
Dec  2 14:25:54 tux kernel: [ 8550.791727]  [<ffffffff810cbe72>] ? lru_cache_add_active_or_unevictable+0x22/0x90
Dec  2 14:25:54 tux kernel: [ 8550.791731]  [<ffffffff810fc4c2>] ? alloc_pages_vma+0x72/0x130
Dec  2 14:25:54 tux kernel: [ 8550.791733]  [<ffffffff810cbe72>] ? lru_cache_add_active_or_unevictable+0x22/0x90
Dec  2 14:25:54 tux kernel: [ 8550.791735]  [<ffffffff810e5220>] ? handle_mm_fault+0x3a0/0xaf0
Dec  2 14:25:54 tux kernel: [ 8550.791737]  [<ffffffff81039074>] ? __do_page_fault+0x224/0x4c0
Dec  2 14:25:54 tux kernel: [ 8550.791740]  [<ffffffff8110d54c>] ? new_sync_write+0x7c/0xb0
Dec  2 14:25:55 tux kernel: [ 8550.791743]  [<ffffffff8114765c>] ? fsnotify+0x27c/0x350
Dec  2 14:25:55 tux kernel: [ 8550.791746]  [<ffffffff81087233>] ? rcu_eqs_enter+0x93/0xa0
Dec  2 14:25:55 tux kernel: [ 8550.791748]  [<ffffffff81087a5e>] ? rcu_user_enter+0xe/0x10
Dec  2 14:25:55 tux kernel: [ 8550.791749]  [<ffffffff8103938a>] ? do_page_fault+0x5a/0x70
Dec  2 14:25:55 tux kernel: [ 8550.791752]  [<ffffffff8139d9d2>] ? page_fault+0x22/0x30

	If you need more info/testing, just ask.

-- 
Linux 3.17.0-dirty: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
