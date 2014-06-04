Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaFDOIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:08:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35399 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaFDOH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:07:59 -0400
Message-ID: <538F2837.3080800@hitachi.com>
Date: Wed, 04 Jun 2014 23:07:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Moody <pmoody@google.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>
Subject: Re: splat in kretprobe in get_task_mm(current)
References: <r3noay9dhad.fsf@perdido.sfo.corp.google.com> <r3nfvjld5il.fsf@perdido.sfo.corp.google.com> <538ED2E3.1000707@hitachi.com>
In-Reply-To: <538ED2E3.1000707@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/04 17:03), Masami Hiramatsu wrote:
> Hi Peter,
> 
> (2014/06/04 6:53), Peter Moody wrote:
>>
>> As a follow up, I can reliably reproduce this bug with the following code
>>
>> #include <unistd.h>
>> #include <sys/types.h>
>>
>> int main(int argc, char *argv[]) {
>>   char *envp_[] = {NULL};
>>   char *argv_[] = {argv[0]};
>>   execve(argv[0], argv_, envp_);
>>   return 0;
>> }
>>
>> run in parallel like so:
>>
>> $ for x in $(seq 0 32) ; do ./a.out & done
>>
>> giving me the following splat:.
> 
> Thank you for reporting that. I've tried to reproduce it with your code, but
> not succeeded yet. Could you share us your kernel config too?

Hmm, it seems that on my environment (Fedora20, gcc version 4.8.2 20131212),
do_execve() in sys_execve has been optimized out (and do_execve_common() is
also renamed). I'll try to rebuild it. However, since such optimization sometimes
depends on kernel config, I'd like to do it with your config.

Thank you,

> 
> Thank you again,
> 
>>
>> [ 133.627336] BUG: spinlock cpu recursion on CPU#4, a.out/4643
>> [ 133.627346]  lock: kretprobe_table_locks+0x1b80/0x2000, .magic: dead4ead, .owner: a.out/4630, .owner_cpu: 4
>> [ 133.627350] CPU: 4 PID: 4643 Comm: a.out Tainted: G          IOE 3.15.0-rc8-splat+ #14
>> [ 133.627351] Hardware name: Dell Inc. Precision WorkStation T3500  /09KPNV, BIOS A10 01/21/2011
>> [ 133.627353]  ffff8804d5ae0000 ffff8804a7b4fd48 ffffffff81773413 0000000000000007
>> [ 133.627358]  ffffffff82843600 ffff8804a7b4fd68 ffffffff8176ec74 ffffffff82843600
>> [ 133.627362]  ffffffff81a8b6a6 ffff8804a7b4fd88 ffffffff8176ec9f ffffffff82843600
>> [ 133.627366] Call Trace:
>> [ 133.627372]  [<ffffffff81773413>] dump_stack+0x46/0x58
>> [ 133.627376]  [<ffffffff8176ec74>] spin_dump+0x8f/0x94
>> [ 133.627379]  [<ffffffff8176ec9f>] spin_bug+0x26/0x2b
>> [ 133.627384]  [<ffffffff810c4195>] do_raw_spin_lock+0x105/0x190
>> [ 133.627389]  [<ffffffff8177c7c0>] _raw_spin_lock_irqsave+0x70/0x90
>> [ 133.627394]  [<ffffffff817839dc>] ? kretprobe_hash_lock+0x6c/0x80
>> [ 133.627398]  [<ffffffff8177a86e>] ? mutex_unlock+0xe/0x10
>> [ 133.627401]  [<ffffffff817839dc>] kretprobe_hash_lock+0x6c/0x80
>> [ 133.627404]  [<ffffffff8177f16d>] trampoline_handler+0x3d/0x220
>> [ 133.627407]  [<ffffffff8177f0fe>] kretprobe_trampoline+0x25/0x57
>> [ 133.627412]  [<ffffffff811e28e8>] ? do_execve+0x18/0x20
>> [ 133.627415]  [<ffffffff817862a9>] stub_execve+0x69/0xa0
>>
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


