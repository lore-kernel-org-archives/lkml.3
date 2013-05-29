Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967050Ab3E2UjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:39:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50256 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966316Ab3E2UjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:39:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
References: <20130527202822.GA19288@redhat.com> <87ppwa1jn0.fsf@xmission.com>
	<20130529133930.GB5741@redhat.com>
Date: Wed, 29 May 2013 13:38:44 -0700
In-Reply-To: <20130529133930.GB5741@redhat.com> (Oleg Nesterov's message of
	"Wed, 29 May 2013 15:39:30 +0200")
Message-ID: <878v2xzfl7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19AI+5gg1tTV2vhi8htsHo/XrftC9ZGNho=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1089]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/3] proc: simplify proc_task_readdir/first_tid paths
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 05/28, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > proc_task_readdir() does not really need "leader", first_tid()
>> > has to revalidate it anyway. Just pass proc_pid(inode) to
>> > first_tid() instead, it can do pid_task(PIDTYPE_PID) itself
>> > and read ->group_leader only if necessary.
>> >
>> > Note: I am not sure proc_task_readdir() really needs the initial
>> > -ENOENT check, but this is what the current code does.
>>
>> This looks like a nice cleanup.
>>
>> We would need either -ENOENT or a return of 0 and an empty directory at
>> the least.  We need the check so that empty directories don't have "."
>> and ".." entries.
>
> And this is not clear to me...
>
> Why the empty "." + ".." dir is bad if the task(s) has gone away after
> opendir?

Because the definition of a deleted directory that you are in is that
getdents will return -ENOENT.

You can reproduce this with any linux filesystem.
mkdir foo
cd foo
rmdir ../foo
strace -f ls .

   open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
   getdents(3, 0x1851c88, 32768)           = -1 ENOENT (No such file or directory)
   close(3)                                = 0

Proc is no different in this regard, and the task could have gone away
before opendir if the process made the task directory it's current
working directory before opening the file.

>> >  	if (tid && (nr > 0)) {
>> >  		pos = find_task_by_pid_ns(tid, ns);
>> > -		if (pos && (pos->group_leader == leader))
>> > +		if (pos && same_thread_group(pos, task))
>>
>> Sigh this reminds me we need to figure out how to kill task->pid and
>> task->tgid,
>
> Yeah.
>
>> which I assume means fixing same_thread_group.
>
> Now that ->signal can't go away before task_struct, we can make it
>
> 	static inline
> 	int same_thread_group(struct task_struct *p1, struct task_struct *p2)
> 	{
> 		return p1->signal == p2->signal;
> 	}

Oh cool.  I will review that patch in just a moment.

>> > +	if (!pid_task(proc_pid(inode), PIDTYPE_PID))
>> > +		return -ENOENT;
>>
>> Strictly speaking this call to pid_task needs to be in a rcu critical
>> section.
>
> Argh, thanks.
>
> we do not really need rcu, we are not going to dereference this pointer,
> but we should make __rcu_dereference_check() happy...
>
> I'll change this... but once again, can't we simply remove this check?

I can understand the desire but I think we need something to see if the
task for the directory has at least a zombie around.

> While you are here. Could you explain the ->d_inode check in
> proc_fill_cache() ? The code _looks_ wrong,
>
> 	if (!child || IS_ERR(child) || !child->d_inode)
> 		goto end_instantiate;
>
> If d_inode == NULL, who does dput() ?
>
> OTOH, if we ensure d_inode != NULL, why do we check "if (inode)" after
> inode = child->d_inode ?
>
> IOW, it seems that this check should be simply removed?

I seem to agree as I have a patch removing it on my development branch.
I think I wrote that before realizing that negative dentries don't
happen in proc.

Eric
