Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3EaSM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:12:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39921 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3EaSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:12:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
References: <20130527202822.GA19288@redhat.com> <87ppwa1jn0.fsf@xmission.com>
	<20130529133930.GB5741@redhat.com> <878v2xzfl7.fsf@xmission.com>
	<20130531163834.GA31086@redhat.com>
Date: Fri, 31 May 2013 11:12:28 -0700
In-Reply-To: <20130531163834.GA31086@redhat.com> (Oleg Nesterov's message of
	"Fri, 31 May 2013 18:38:34 +0200")
Message-ID: <87a9nbt3w3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18D8ysFE4ngcAADZs8lNRdX24CMQQxpVMM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3064]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/3] proc: simplify proc_task_readdir/first_tid paths
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Eric, sorry for delay.
>
> On 05/29, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > Why the empty "." + ".." dir is bad if the task(s) has gone away after
>> > opendir?
>>
>> Because the definition of a deleted directory that you are in is that
>> getdents will return -ENOENT.
>>
>> You can reproduce this with any linux filesystem.
>> mkdir foo
>> cd foo
>> rmdir ../foo
>> strace -f ls .
>>
>>    open(".", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
>>    getdents(3, 0x1851c88, 32768)           = -1 ENOENT (No such file or directory)
>>    close(3)                                = 0
>
> Heh. Indeed, vfs_readdir() checks IS_DEADDIR().
>
> Thanks.
>
> OK. But this means that even 1/3 is not 100% right, exactly because
> leader can be unhashed right before first_tid() takes rcu lock. Easy
> to fix, we should simply factor out the "nr != 0" check.
>
> And this also means that 3/3 is not right by the same reason. I'll
> make a simpler patch which only avoids the unnecessary get/put in
> proc_task_readdir().
>
> Unless we can tolerate this very unlikely rase when the leader goes
> away after initial ENOENT check at the start, of course... Or unless
> we add canceldir() which resets getdents_callback->previous so that
> we could return ENOENT after filldir() was already called ;)

A small race is fine and is fundamental to the process of readdir.

The guarantee of open+readdir+close is that all directory entries that
exited before open and after close are returned.  Directory entries that
are added or removed during the open+readir+close are returned at most
once.

The important case to handle is when someone has opened the directory a
very long time ago or has chdir'd to the directory.  With the result
the directory was removed before we start the readdir process entirely.

If the tasks die in the narrow window while we are inside of readdir
races are impossible to avoid.

Eric

