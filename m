Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3CZK3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:29:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58942 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3CZK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:29:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Caj Larsson <caj@omnicloud.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <CAMoAvfEsvah6VELu9D7k1prB2GLhvyubd35tKgBaJdB=P08+pQ@mail.gmail.com>
	<87txo1kqj5.fsf@xmission.com> <20130324132047.GA13419@redhat.com>
Date: Tue, 26 Mar 2013 03:29:05 -0700
In-Reply-To: <20130324132047.GA13419@redhat.com> (Oleg Nesterov's message of
	"Sun, 24 Mar 2013 14:20:47 +0100")
Message-ID: <87fvzia1zi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX184Mm12LB53vYzQTISmnTnys7JIz4Fu9oo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Zombie stuck in zap_pid_ns_processes()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 03/24, Eric W. Biederman wrote:
>>
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -181,6 +181,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>>  	int nr;
>>  	int rc;
>>  	struct task_struct *task, *me = current;
>> +	int init_pids = task_pid_vnr(me) == 1 ? 1 : 2;
>                         ^^^^^^^^^^^^^^^^^^^^^
>
> Ah, mt-init.
>
> perhaps thread_group_leader(me) would be more clean/simple,
> but I won't insist of course.

It is.  Thanks, I was going to follow the reaper but that changes when the
initial thread exits...

Here is my final version of the patch, that I will push shortly.

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 26 Mar 2013 02:27:11 -0700
Subject: [PATCH] pid: Handle the exit of a multi-threaded init.

When a multi-threaded init exits and the initial thread is not the
last thread to exit the initial thread hangs around as a zombie
until the last thread exits.  In that case zap_pid_ns_processes
needs to wait until there are only 2 hashed pids in the pid
namespace not one.

v2. Replace thread_pid_vnr(me) == 1 with the test thread_group_leader(me)
    as suggested by Oleg.

Cc: stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>
Reported-by: Caj Larsson <caj@omnicloud.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid_namespace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c1c3dc1..bea15bd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -181,6 +181,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	int nr;
 	int rc;
 	struct task_struct *task, *me = current;
+	int init_pids = thread_group_leader(me) ? 1 : 2;
 
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
@@ -230,7 +231,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 */
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (pid_ns->nr_hashed == 1)
+		if (pid_ns->nr_hashed == init_pids)
 			break;
 		schedule();
 	}
-- 
1.7.5.4


