Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaLVPed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:34:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58539 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaLVPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:34:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "davej \@mail.xmission.com\>\> Dave Jones" <davej@redhat.com>
References: <54982C98.9070806@oracle.com>
Date: Mon, 22 Dec 2014 09:32:01 -0600
In-Reply-To: <54982C98.9070806@oracle.com> (Sasha Levin's message of "Mon, 22
	Dec 2014 09:37:12 -0500")
Message-ID: <87tx0nd7ke.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ouGsl6MSKvZkFCpTVh+mhXtgY9zKwC7Q=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Sasha Levin <sasha.levin@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 541 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.6 (0.5%), b_tie_ro: 1.95 (0.4%), parse: 0.66 (0.1%),
	extract_message_metadata: 11 (2.1%), get_uri_detail_list: 2.9 (0.5%),
	tests_pri_-1000: 4.8 (0.9%), tests_pri_-950: 1.02 (0.2%), tests_pri_-900:
	0.85 (0.2%), tests_pri_-400: 30 (5.5%), check_bayes: 29 (5.3%), b_tokenize: 9
	(1.6%), b_tok_get_all: 12 (2.2%), b_comp_prob: 2.6 (0.5%), b_tok_touch_all:
	3.3 (0.6%), b_finish: 0.54 (0.1%), tests_pri_0: 484 (89.5%), tests_pri_500:
	3.0 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: fs: proc: gpf in find_entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:

Weird.

>   2b:*	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)		<-- trapping instruction

%rax == 0
%r13 == dfffe90000000000
%r15 == 0 (%rax is derived from this)

That value of %r13 looks like an stomped pointer.

According to the disassembly %r15 is tested for 0 shortly
before we get to the faulting instruction.  So we should never have
reached the faulting instruction in the first place.

The byte instructions from the disassembly are weird, but may make sense
if strlen or and memcmp from namecmp were inlined.  Although if that is
what I am reading your line numbers are wrong stack backtrace.

I suspect the data structure got stomped somewhere.

If the stack trace didn't look sensible I would suspect someone jumped
into the middle of find_entry from somewhere else.

In there any chance you could take your vmlinux and use objdump to dump
the entire assembly of find_entry (that proc_sys_lookup calls?).  I am
suspecting the code you have and the code that is supposed to be there
don't match.

Short of seeing something when comparing the disassembly of find_entry
with the crash time text of find_entry I don't see any path to pursue.
None of the pieces seem to add up.

Eric

> [ 2015.960381] general protection fault: 0000 [#1] PREEMPT SMP KASAN
> [ 2015.961912] Dumping ftrace buffer:
> [ 2015.962803]    (ftrace buffer empty)
> [ 2015.963370] Modules linked in:
> [ 2015.963895] CPU: 1 PID: 16983 Comm: trinity-c126 Not tainted 3.18.0-next-20141219-sasha-00047-gaab33f6-dirty #1627
> [ 2015.965991] task: ffff88080e478000 ti: ffff88080e474000 task.ti: ffff88080e474000
> [ 2015.968196] RIP: find_entry (fs/proc/proc_sysctl.c:95)
> [ 2015.970534] RSP: 0018:ffff88080e4779d8  EFLAGS: 00010246
> [ 2015.970534] RAX: 0000000000000000 RBX: ffff88000003a960 RCX: 0000000000000073
> [ 2015.970534] RDX: 1ffff10101c8f3c4 RSI: 0000000000000000 RDI: ffff88080e479e20
> [ 2015.970534] RBP: ffff88080e477a28 R08: 0000000000000066 R09: 0000000000000073
> [ 2015.970534] R10: ffffda0017d55630 R11: dfffe90000000000 R12: ffff88005fc644b8
> [ 2015.970534] R13: dfffe90000000000 R14: ffffffff92464884 R15: 0000000000000000
> [ 2015.970534] FS:  00007f9cd6c6f700(0000) GS:ffff8800c2200000(0000) knlGS:0000000000000000
> [ 2015.970534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2015.970534] CR2: 00007f9cd0b9c000 CR3: 00000008193fb000 CR4: 00000000000006a0
> [ 2015.970534] DR0: ffffffffff000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2015.970534] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 2015.970534] Stack:
> [ 2015.970534]  ffff88080e477a28 ffff88080e477a50 00000003beaab0c0 ffff8800beaab0f8
> [ 2015.970534]  0000000000000001 ffff8800beaab0f8 ffff8800beaab0c0 ffff8806079af638
> [ 2015.970534]  0000000000000003 ffff88045f3cc000 ffff88080e477a88 ffffffff81c4e0ef
> [ 2015.970534] Call Trace:
> [ 2015.970534] proc_sys_lookup (fs/proc/proc_sysctl.c:303 fs/proc/proc_sysctl.c:452)
> [ 2015.970534] ? d_alloc (fs/dcache.c:1499)
> [ 2015.970534] lookup_real (fs/namei.c:1371)
> [ 2015.970534] __lookup_hash (fs/namei.c:1390)
> [ 2015.970534] link_path_walk (fs/namei.c:1496 fs/namei.c:1576 fs/namei.c:1830)
> [ 2015.970534] ? preempt_count_sub (kernel/sched/core.c:2620)
> [ 2015.970534] ? get_parent_ip (kernel/sched/core.c:2564)
> [ 2015.970534] ? get_parent_ip (kernel/sched/core.c:2564)
> [ 2015.970534] ? __cmpxchg_double_slab.isra.4 (./arch/x86/include/asm/preempt.h:95 include/linux/bit_spinlock.h:81 mm/slub.c:346 mm/slub.c:386)
> [ 2015.970534] path_init (fs/namei.c:1947)
> [ 2015.970534] ? deactivate_slab (include/linux/spinlock.h:349 mm/slub.c:1945)
> [ 2015.970534] path_lookupat (fs/namei.c:1989)
> [ 2015.970534] ? alloc_debug_processing (mm/slub.c:1044)
> [ 2015.970534] filename_lookup (fs/namei.c:2025)
> [ 2015.970534] kern_path_create (fs/namei.c:3309)
> [ 2015.970534] ? getname_flags (fs/namei.c:159)
> [ 2015.970534] ? vtime_account_user (kernel/sched/cputime.c:701)
> [ 2015.970534] user_path_create (fs/namei.c:3381)
> [ 2015.970534] SyS_mknod (fs/namei.c:3443 fs/namei.c:3431 fs/namei.c:3475 fs/namei.c:3473)
> [ 2015.970534] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
> [ 2015.970534] Code: e8 03 42 80 3c 28 00 0f 85 ff 01 00 00 4c 8b 7b 18 4d 85 ff 0f 84 de 01 00 00 41 f6 c7 07 0f 85 d4 01 00 00 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 b5 01 00 00 4d 8b 37 4d 85 ff 0f 84 55 02
> All code
> ========
>    0:	e8 03 42 80 3c       	callq  0x3c804208
>    5:	28 00                	sub    %al,(%rax)
>    7:	0f 85 ff 01 00 00    	jne    0x20c
>    d:	4c 8b 7b 18          	mov    0x18(%rbx),%r15
>   11:	4d 85 ff             	test   %r15,%r15
>   14:	0f 84 de 01 00 00    	je     0x1f8
>   1a:	41 f6 c7 07          	test   $0x7,%r15b
>   1e:	0f 85 d4 01 00 00    	jne    0x1f8
>   24:	4c 89 f8             	mov    %r15,%rax
>   27:	48 c1 e8 03          	shr    $0x3,%rax
>   2b:*	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)		<-- trapping instruction
>   30:	0f 85 b5 01 00 00    	jne    0x1eb
>   36:	4d 8b 37             	mov    (%r15),%r14
>   39:	4d 85 ff             	test   %r15,%r15
>   3c:	0f                   	.byte 0xf
>   3d:	84 55 02             	test   %dl,0x2(%rbp)
> 	...
>
> Code starting with the faulting instruction
> ===========================================
>    0:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
>    5:	0f 85 b5 01 00 00    	jne    0x1c0
>    b:	4d 8b 37             	mov    (%r15),%r14
>    e:	4d 85 ff             	test   %r15,%r15
>   11:	0f                   	.byte 0xf
>   12:	84 55 02             	test   %dl,0x2(%rbp)
> 	...
> [ 2015.970534] RIP find_entry (fs/proc/proc_sysctl.c:95)
> [ 2015.970534]  RSP <ffff88080e4779d8>
> [ 2016.028073] ---[ end trace 142d37d0fb80aa87 ]---
> [ 2016.028925] Kernel panic - not syncing: Fatal exception
> [ 2016.030263] Dumping ftrace buffer:
> [ 2016.030847]    (ftrace buffer empty)
> [ 2016.031399] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [ 2016.032890] Rebooting in 1 seconds..
>
>
> Thanks,
> Sasha
