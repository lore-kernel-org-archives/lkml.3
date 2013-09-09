Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab3IIANF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:13:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57391 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3IIAND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:13:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com>
	<20130830144232.GA18281@mail.hallyn.com>
	<87hae6vh0w.fsf_-_@xmission.com>
	<CALkWK0kSBrN-ZHG0CEWwvjYQ86ArJtDmbKqJR_6f3_ZTN6xJQQ@mail.gmail.com>
Date: Sun, 08 Sep 2013 17:12:57 -0700
In-Reply-To: <CALkWK0kSBrN-ZHG0CEWwvjYQ86ArJtDmbKqJR_6f3_ZTN6xJQQ@mail.gmail.com>
	(Ramkumar Ramachandra's message of "Mon, 9 Sep 2013 01:02:21 +0530")
Message-ID: <87bo42g8dy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+Q4hu7cYZmPV2NwNBAKDZku9OSUYtPuXU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1612]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Ramkumar Ramachandra <artagnon@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH] pidns: Fix hang in zap_pid_ns_processes by sending a potentially extra wakeup
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra <artagnon@gmail.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>     Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>     > Since commit af4b8a83add95ef40716401395b44a1b579965f4 it's been
>     > possible to get into a situation where a pidns reaper is
>     > <defunct>, reparented to host pid 1, but never reaped.  How to
>     > reproduce this is documented at
>     >
>     > https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526
>     > (and see
>     >
>     https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526/comments/13)
>     > In short, run repeated starts of a container whose init is
>     >
>     > Process.exit(0);
>     >
>     > sysrq-t when such a task is playing zombie shows:
>     >
>     > [  131.132978] init            x ffff88011fc14580     0  2084  
>     2039 0x00000000
>     > [  131.132978]  ffff880116e89ea8 0000000000000002
>     ffff880116e89fd8 0000000000014580
>     > [  131.132978]  ffff880116e89fd8 0000000000014580
>     ffff8801172a0000 ffff8801172a0000
>     > [  131.132978]  ffff8801172a0630 ffff88011729fff0
>     ffff880116e14650 ffff88011729fff0
>     > [  131.132978] Call Trace:
>     > [  131.132978]  [<ffffffff816f6159>] schedule+0x29/0x70
>     > [  131.132978]  [<ffffffff81064591>] do_exit+0x6e1/0xa40
>     > [  131.132978]  [<ffffffff81071eae>] ?
>     signal_wake_up_state+0x1e/0x30
>     > [  131.132978]  [<ffffffff8106496f>] do_group_exit+0x3f/0xa0
>     > [  131.132978]  [<ffffffff810649e4>] SyS_exit_group+0x14/0x20
>     > [  131.132978]  [<ffffffff8170102f>] tracesys+0xe1/0xe6
>     
>     
> Interestingly, notice how the memory addresses begin with ffff88011,
> and then ffffffff81 in the call trace.

The cause is known and this patch fixes the problem.  So I don't know
why you would be looking at the addresses, there is no mystery to be solved.

That said roughly ffff880000000000 is where the kernel has it's identity
mapping of all physical memory in the system.

Meanwhile roughly ffffffff80000000 is the high 2GB of memory where the
kernel text pages reside.

So what is seen is exactly what is expected that the data pointers point
into the kernels identity mapping and the code address use the mapping
for kernel code.

Eric
