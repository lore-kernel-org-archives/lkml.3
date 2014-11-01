Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaKAA7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:59:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55435 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKAA7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:59:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Aditya Kali <adityakali@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        cgroups@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-6-git-send-email-adityakali@google.com>
	<CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
Date: Fri, 31 Oct 2014 17:58:14 -0700
In-Reply-To: <CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 31 Oct 2014 17:02:41 -0700")
Message-ID: <87y4rvspnd.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18YSn05g7ANB7QklxQ/aXnk5F8pOXdq+qM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 318 ms - load_scoreonly_sql: 0.24 (0.1%),
	signal_user_changed: 7 (2.2%), b_tie_ro: 5 (1.6%), parse: 1.45 (0.5%),
	extract_message_metadata: 21 (6.7%), get_uri_detail_list: 2.3 (0.7%),
	tests_pri_-1000: 10 (3.2%), tests_pri_-950: 1.49 (0.5%), tests_pri_-900: 1.20
	(0.4%), tests_pri_-400: 22 (6.9%), check_bayes: 21 (6.5%), b_tokenize: 6
	(2.0%), b_tok_get_all: 7 (2.4%), b_comp_prob: 2.0 (0.6%), b_tok_touch_all:
	2.5 (0.8%), b_finish: 0.74 (0.2%), tests_pri_0: 242 (76.1%), tests_pri_500: 7
	(2.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Oct 31, 2014 at 12:18 PM, Aditya Kali <adityakali@google.com> wrote:

<snip>

>> +static void *cgroupns_get(struct task_struct *task)
>> +{
>> +       struct cgroup_namespace *ns = NULL;
>> +       struct nsproxy *nsproxy;
>> +
>> +       rcu_read_lock();
>> +       nsproxy = task->nsproxy;
>> +       if (nsproxy) {
>> +               ns = nsproxy->cgroup_ns;
>> +               get_cgroup_ns(ns);
>> +       }
>> +       rcu_read_unlock();
>
> How is this correct?  Other namespaces do it too, so it Must Be
> Correct (tm), but I don't understand.  What is RCU protecting?

The code is not correct.  The code needs to use task_lock.

RCU used to protect nsproxy, and now task_lock protects nsproxy.
For the reasons of of all of this I refer you to the commit
that changed this, and the comment in nsproxy.h

commit 728dba3a39c66b3d8ac889ddbe38b5b1c264aec3
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Mon Feb 3 19:13:49 2014 -0800

    namespaces: Use task_lock and not rcu to protect nsproxy
    
    The synchronous syncrhonize_rcu in switch_task_namespaces makes setns
    a sufficiently expensive system call that people have complained.
    
    Upon inspect nsproxy no longer needs rcu protection for remote reads.
    remote reads are rare.  So optimize for same process reads and write
    by switching using rask_lock instead.
    
    This yields a simpler to understand lock, and a faster setns system call.
    
    In particular this fixes a performance regression observed
    by Rafael David Tinoco <rafael.tinoco@canonical.com>.
    
    This is effectively a revert of Pavel Emelyanov's commit
    cf7b708c8d1d7a27736771bcf4c457b332b0f818 Make access to task's nsproxy lighter
    from 2007.  The race this originialy fixed no longer exists as
    do_notify_parent uses task_active_pid_ns(parent) instead of
    parent->nsproxy.
    
    Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
