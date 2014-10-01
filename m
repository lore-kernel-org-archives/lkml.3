Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaJACiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:38:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39976 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaJACit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:38:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aditya Kali <adityakali@google.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
References: <CAGr1F2FPLCfZjMCoLM3h-8okHcJSkdE7et25_TKU-2Xtx03OTg@mail.gmail.com>
	<87bnpwwrsz.fsf@x220.int.ebiederm.org>
	<CAGr1F2Ei=S=75XUOZN05V=63eGXJOPjapfKhpXn9jimFR41eHw@mail.gmail.com>
Date: Tue, 30 Sep 2014 19:38:20 -0700
In-Reply-To: <CAGr1F2Ei=S=75XUOZN05V=63eGXJOPjapfKhpXn9jimFR41eHw@mail.gmail.com>
	(Aditya Kali's message of "Tue, 30 Sep 2014 17:51:11 -0700")
Message-ID: <87fvf8v7j7.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/MQz9NxYlHdQolD+LkWdV+Jaa7aLzfwok=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4986]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.2 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Aditya Kali <adityakali@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2752 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4.2 (0.2%), b_tie_ro: 3.0 (0.1%), parse: 1.48 (0.1%),
	extract_message_metadata: 19 (0.7%), get_uri_detail_list: 6 (0.2%),
	tests_pri_-1000: 6 (0.2%), tests_pri_-950: 1.18 (0.0%), tests_pri_-900: 0.96
	(0.0%), tests_pri_-400: 25 (0.9%), check_bayes: 24 (0.9%), b_tokenize: 10
	(0.4%), b_tok_get_all: 8 (0.3%), b_comp_prob: 2.2 (0.1%), b_tok_touch_all:
	2.3 (0.1%), b_finish: 0.61 (0.0%), tests_pri_0: 2686 (97.6%), tests_pri_500:
	3.5 (0.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: uid=0 inside user-namespace and procfs file permissions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aditya Kali <adityakali@google.com> writes:

> On Tue, Sep 30, 2014 at 5:35 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Aditya Kali <adityakali@google.com> writes:
>>
>>> Hi all,
>>>
>>> I am trying to run a process with uid=0 inside userns. But in the when
>>> I also do capset() after setresuid(0, 0, 0), I am seeing inconsistent
>>> proc file permissions. Almost all the files in /proc/<pid>/ has global
>>> 'root' as owner and group even if the actual process uid is correctly
>>> changed.
>>>
>>> I wrote a simple program that demonstrate the issue:
>>>
>>> 1. parent, as global root (uid=0 in init_user_ns) fork()s a child
>>> 2. child:
>>>     a) unshare(CLONE_NEWUSER)
>>>     b) [wait for parent to write uid_map]
>>>     c) setresgid(id, id, id) ; setresuid(0, 0, 0);
>>>     d) conditionally call capset() to clear capabilities
>>>     e) execve(/bin/sleep)
>>> 3. parent:
>>>     a) populates child's uid_map and maps some uid to 0 inside userns. ex:
>>>     0 99 1
>>>     b) waitpid()
>>>
>>> (the actual program can be found at http://pastebin.com/f4P17VFn for
>>> your reference).
>>>
>>> When there is no capset() call after setresuid(0,0,0), everything is
>>> fine. But when I do a capset() to clear all capabilities, the 'owner'
>>> and 'group' of all the files under /proc/<child_pid>/  of the child
>>> process are reverted to global 'root' user.
>>>
>>> # without capset (2.d):
>>> root@vm1# id
>>> uid=0(root) gid=0(root) groups=0(root)
>>>
>>> root@vm1# ./userns_uid0
>>> child_pid: 24277
>>> proc_file: /proc/24277/uid_map
>>> proc_file: /proc/24277/gid_map
>>> child resuming
>>>
>>> ^Z
>>> [1]+  Stopped                 ./userns_uid0
>>> root@vm1# cat /proc/24277/uid_map
>>>          0         99          1
>>> root@vm1# cat /proc/24277/status | grep -e "Uid:" -e "Gid:"
>>> Uid: 99 99 99 99
>>> Gid: 99 99 99 99
>>> root@vm1# ls -l /proc/24277/
>>> total 0
>>> dr-xr-xr-x 2 nobody nobody 0 2014-09-30 16:31 attr
>>> -r-------- 1 nobody nobody 0 2014-09-30 16:31 auxv
>>> -r--r--r-- 1 nobody nobody 0 2014-09-30 16:31 cgroup
>>> --w------- 1 nobody nobody 0 2014-09-30 16:31 clear_refs
>>> -r--r--r-- 1 nobody nobody 0 2014-09-30 16:31 cmdline
>>> -rw-r--r-- 1 nobody nobody 0 2014-09-30 16:31 comm
>>> -rw-r--r-- 1 nobody nobody 0 2014-09-30 16:31 coredump_filter
>>> -r--r--r-- 1 nobody nobody 0 2014-09-30 16:31 cpuset
>>> ...
>>> [All files have owner='nobody' and group='nobody' .. same as that of
>>> the process]
>>>
>>> With the additional capset() call, the files under /proc/<child_pid>/
>>> are now owned by global root:
>>>
>>> root@vm1# ./userns_uid0 resetcaps
>>> child_pid: 24706
>>> proc_file: /proc/24706/uid_map
>>> proc_file: /proc/24706/gid_map
>>> child resuming
>>> resetting caps
>>> ^Z
>>> [2]+  Stopped                 ./userns_uid0 resetcaps
>>> root@vm1# cat /proc/24706/uid_map
>>>          0         99          1
>>> root@vm1# cat /proc/24706/status | grep -e "Uid:" -e "Gid:"
>>> Uid: 99 99 99 99
>>> Gid: 99 99 99 99
>>>
>>> [Everything as before till now]
>>>
>>> root@vm1# ls -l /proc/24706/
>>> total 0
>>> dr-xr-xr-x 2 nobody nobody 0 2014-09-30 16:47 attr
>>> -r-------- 1 root   root   0 2014-09-30 16:47 auxv
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 cgroup
>>> --w------- 1 root   root   0 2014-09-30 16:47 clear_refs
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 cmdline
>>> -rw-r--r-- 1 root   root   0 2014-09-30 16:47 comm
>>> -rw-r--r-- 1 root   root   0 2014-09-30 16:47 coredump_filter
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 cpuset
>>> ...
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 mountinfo
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 mounts
>>> -r-------- 1 root   root   0 2014-09-30 16:47 mountstats
>>> dr-xr-xr-x 5 nobody nobody 0 2014-09-30 16:47 net
>>> dr-x--x--x 2 root   root   0 2014-09-30 16:47 ns
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 numa_maps
>>> ...
>>> -r--r--r-- 1 root   root   0 2014-09-30 16:47 status
>>> -r-------- 1 root   root   0 2014-09-30 16:47 syscall
>>> dr-xr-xr-x 3 nobody nobody 0 2014-09-30 16:47 task
>>> ..
>>>
>>> Only the directories 'attr', 'net' and 'task' are owned by the uid=99.
>>> Rest all files are owned by global root.
>>>
>>> This behavior seems inconsistent. I ran this on 3.17 kernel. Can
>>> someone with expertise in this area explain if this is expected?
>>
>> So I am not quite certain what you are seeing.
>>
>> In general proc files are expected to be owned by the euid of a process.
>> However when the task_dumpable is cleared the files become owned by the
>> global root user.  We have considered relaxing that to the namespace
>> root user but so far implementing a more granular task_dumpable has not
>> been done.
>>
>
> I tried explicitly setting PR_SET_DUMPABLE before execve(), but that
> didn't either.
>
>> The directories are world readable so they don't matter.
>>
>> What puzzles me is that you have directories owned by nobody, and you
>> are talking about uid = 99 and gid = 99.  Nobody is traditionally
>> (u16_t)-2 and there should never actually be used by anyone.   And is
>> used as the default number of unmapped uids and gids.
>>
>> It looks like you are doing something weird with nobody so I don't have
>> a clue what is actually going on.
>>
>
> The issue is not specific to uid 99 or "nobody". Its just a dummy user
> I have for testing. The issue happens with any user with non-zero uid.

But my issue with reading your directory listings of proc is.

I can't tell if you are giving me a listing of proc from a process in
the user namespace or outside of the user namespace.

If the process 24706 had uid == 99 and gid == 99 (outside of the user
namespace).  And your are listing the files from outside of the user
namespace.  And uid 99 is mapped to nobody in /etc/passwd and
gid 99 is mapped to nobody in /etc/group.  And your ls process is
not running in your user namespace.  Then this looks like proper
handling of dumpable.   Otherwise I don't have a clue what is going on
because I can't make sense of your directory listings.

Eric
