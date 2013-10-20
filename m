Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab3JTEFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 00:05:08 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57603 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3JTEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 00:05:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
References: <20131020025026.GB6737@localhost>
Date: Sat, 19 Oct 2013 21:04:57 -0700
In-Reply-To: <20131020025026.GB6737@localhost> (Fengguang Wu's message of
	"Sun, 20 Oct 2013 10:50:26 +0800")
Message-ID: <87li1oa8pi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/tKWMoqP+mNDAFmwVb+v4EA8F3fDzQsGc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [userns-always-map-user-v136] BUG: unable to handle kernel NULL pointer dereference at (null)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Hi Eric,
>
> It's beyond me why this trivial patch will lead to kernel panic.  But
> the NULL pointer dereference bug is 100% reproducible since this
> commit.

My mistake apparently I failed to boot test that patch.

The problem crash is because
kthreadd_task == NULL.

kthreadd_task is NULL because this little sequence sets kthreadd_task to NULL

	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
	rcu_read_lock();
	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
	rcu_read_unlock();

The lookup for kthreadd_task fails because when spawning kthread_task
with kernel_thread the is_idle_task(p) test in fork is reporting true,
so the pid is never placed into the pid hash table.

is_idle_task(p) is true because it is testing task_pid(p) two lines
before task_pid(p) is set.  So task_pid(p) is still it's parents value
and the parent of the kthreadd_task is the initial idle task.

So I should have just tested (pid != &init_struct_pid) sigh.  Silly me.

Fixed and pushed out.  That you for reporting this to me.

Eric
