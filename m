Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaAPBNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:13:09 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47573 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaAPBNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:13:06 -0500
X-Sasl-enc: xUBxUika8pZUTTLePCOJa+i/iAEdKipAw9JEiHsRjG90 1389834782
Message-ID: <52D73220.3030108@signal11.us>
Date: Wed, 15 Jan 2014 20:13:04 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Deadlock in do_page_fault() on ARM (old kernel)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a deadlock that I'm trying to understand. The symptom is multiple 
tasks trying to acquire a read lock (down_read()) on mm->mmap_sem in 
do_page_fault(). I'll be right up front and say that this is a fairly 
old kernel (2.6.37 TI PSP kernel) on a fairly old processor DaVinci 6446.

At the time of the deadlock, sysrq's show-all-tasks shows the following 
for three of the tasks which are deadlocked (there are more, but I just 
picked the interesting ones; the full output is at [1]):

ui            D c0ea8208     0  1405   1293 0x00000000
[<c0ea8208>] (schedule+0x33c/0x3c4) from [<c0eaa3b4>] 
(__down_read+0xbc/0xd4)
[<c0eaa3b4>] (__down_read+0xbc/0xd4) from [<c0c0b378>] 
(do_page_fault+0x94/0x248)
[<c0c0b378>] (do_page_fault+0x94/0x248) from [<c0c052e0>] 
(do_DataAbort+0x34/0x94)
[<c0c052e0>] (do_DataAbort+0x34/0x94) from [<c0c05b0c>] 
(__dabt_svc+0x4c/0x60)
Exception stack(0xc048dce8 to 0xc048dd30)
dce0:                   400e9a94 c048ddb0 ffffffec 00000000 c048c000 
c048dda4
dd00: 400e9a94 00000000 ffffff92 c048c000 00000000 00000001 00000014 
c048dd34
dd20: 00000000 c0d1f68c 00000013 ffffffff
[<c0c05b0c>] (__dabt_svc+0x4c/0x60) from [<c0d1f68c>] 
(__copy_to_user_std+0xcc/0x3a8)

ui            D c0ea8208     0  1406   1293 0x00000000
[<c0ea8208>] (schedule+0x33c/0x3c4) from [<c0eaa3b4>] 
(__down_read+0xbc/0xd4)
[<c0eaa3b4>] (__down_read+0xbc/0xd4) from [<c0c0b378>] 
(do_page_fault+0x94/0x248)
[<c0c0b378>] (do_page_fault+0x94/0x248) from [<c0c052e0>] 
(do_DataAbort+0x34/0x94)
[<c0c052e0>] (do_DataAbort+0x34/0x94) from [<c0c05f0c>] 
(ret_from_exception+0x0/0x10)
Exception stack(0xc048ffb0 to 0xc048fff8)
ffa0:                                     00000060 0000000a 000000a8 
0010d000
ffc0: 00c23d80 00c23de8 405af06c 00000000 405af03c 405af074 00000050 
000001ff
ffe0: 405ae000 40185748 404f5c4c 404f393c 80000010 ffffffff

ui            D c0ea8208     0  1411   1293 0x00000000
[<c0ea8208>] (schedule+0x33c/0x3c4) from [<c0eaa3b4>] 
(__down_read+0xbc/0xd4)
[<c0eaa3b4>] (__down_read+0xbc/0xd4) from [<c0c0b378>] 
(do_page_fault+0x94/0x248)
[<c0c0b378>] (do_page_fault+0x94/0x248) from [<c0c052e0>] 
(do_DataAbort+0x34/0x94)
[<c0c052e0>] (do_DataAbort+0x34/0x94) from [<c0c05f0c>] 
(ret_from_exception+0x0/0x10)
Exception stack(0xc053bfb0 to 0xc053bff8)
bfa0:                                     00000000 00000001 00ba3610 
00000000
bfc0: 00000000 00ba3610 00bb6020 00ba3610 40074000 00b91024 415e4930 
00000583
bfe0: 00b611a0 415e38e0 4005f3e4 ffff0fc0 60000010 ffffffff

---- [snip] ----

Showing all locks held in the system:
1 lock held by getty/1294:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<c0d45bf0>] 
n_tty_read+0x21c/0x670
1 lock held by ui/1405:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c0b378>] do_page_fault+0x94/0x248
1 lock held by ui/1406:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c0b378>] do_page_fault+0x94/0x248
1 lock held by ui/1408:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c0b378>] do_page_fault+0x94/0x248
1 lock held by ui/1409:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c0b378>] do_page_fault+0x94/0x248
1 lock held by ui/1411:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c0b378>] do_page_fault+0x94/0x248
1 lock held by ui/1416:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c6e604>] sys_mmap_pgoff+0x70/0xc0
1 lock held by ui/1418:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c0b378>] do_page_fault+0x94/0x248
1 lock held by ui/1420:
  #0:  (&mm->mmap_sem){++++++}, at: [<c0c6e604>] sys_mmap_pgoff+0x70/0xc0
1 lock held by ui/1434:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<c0d45bf0>] 
n_tty_read+0x21c/0x670


Note that above, do_page_fault() takes out a read lock (down_read()) and 
sys_mmap_pgoff() takes out a write lock (down_write()).

I've searched for this kind of problem and found two patches which seem 
to be related to this issue[2]. I have applied both with no better results.

So my questions are:
1. Why don't I see a full backtrace beyond the exception stack? It's the 
same when dump_stack() is called manually.
2. __copy_to_user_memcpy() takes a read lock (down_read()) on 
mm->mmap_sem. While that lock is held, __copy_to_user_memcpy() can 
generate a page fault, causing do_page_fault() to get called, which will 
also try to get a read lock (down_read()) on mm->mmap_sem. Multiple read 
locks can be taken on an rw_semaphore, but deadlock will occur if 
another thread tries to get a write lock (down_write()) in between. For 
example:
     Task 1:         Task 2:
     down_read(sem)
                     down_write(sem)    <-- Goes to sleep
     down_read(sem)                     <-- Goes to sleep

There is a thread from 2005[3] which seems to discuss the same concept 
of recursive rw_semaphores, but for futexes.

Other comments:
1. My analysis of this probably wrong. Otherwise it seems many others 
would have the same problem, and they don't seem to. I'm hoping this 
email will help to correct my understanding.
2. I looked through the git logs for recent (since 2.6.37 time frame) 
and nothing else jumped out at me as being an obvious fix for this 
situation.

Thanks for any insight you can give,

Alan.

[1] http://www.signal11.us/~alan/show-all-tasks-deadlock.txt

[2] Some websites/bugtrackers mention this commit with a similar issue, 
but I'm not entirely sure how it's related:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8878a539ff19a43cf3729e7562cd528f490246ae

This one seems obviously related, but has no effect on my system:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=435a7ef52db7d86e67a009b36cac1457f8972391

[3] http://thread.gmane.org/gmane.linux.kernel/280900
