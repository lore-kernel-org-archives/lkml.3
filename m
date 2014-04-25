Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaDYTSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:18:09 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52973 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDYTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:18:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
References: <1398415405-19872-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<20140425185645.GA10637@redhat.com>
Date: Fri, 25 Apr 2014 12:17:33 -0700
In-Reply-To: <20140425185645.GA10637@redhat.com> (Oleg Nesterov's message of
	"Fri, 25 Apr 2014 20:56:45 +0200")
Message-ID: <87a9b95icy.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19nkW2Uh7KWwoWcCcXhux8ugJvR1IpeeIE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4957]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Resend][PATCH] ns,proc: introduce pid_in_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/25, Chen Hanxiao wrote:
>>
>> We lacked of convenient method of getting the pid inside containers.

Are unix domain sockets not convinient?

>> If some issues occurred inside container guest, host user
>> could not know which process is in trouble just by guest pid:
>> the users of container guest only knew the pid inside containers.
>> This will bring obstacle for trouble shooting.
>>
>> This patch introduces pid_in_ns:
>> If one process is in init_pid_ns, /proc/PID/pid_in_ns
>> equals to /proc/PID;
>> if one process is in pidns, /proc/PID/pid_in_ns
>> will tell the pid inside containers;
>> if pidns is nested, it depends on which pidns are you in.
>
> Yes another /proc/pid/ file...
>
> Perhaps it would be better to change /proc/pid/status["Pid:"] to report the
> list of pid_nr's, from its namespace up to the observer's namespace. The same
> for "Tgid:".
>
> (Hmm. And why "Ngid:" was inserted between tid and tgid ?)

Add to that Ngid has a completely hosed implementation.  It is a pid
stored in a pid_t, not a struct pid *.  Sigh.

I am getting more and more tempted to obliterate task->pid.  It just
encourages bad code.

>> +int proc_pid_in_ns(struct seq_file *m, struct pid_namespace *ns,
>> +			struct pid *pid, struct task_struct *task)
>> +{
>> +	pid_t pid_in_ns;
>> +	unsigned int level;
>> +
>> +	level = pid->level;
>> +	pid_in_ns = task_pid_nr_ns(task, pid->numbers[level].ns);
>
> This looks overcomplicated or I missed something?

I do think if we care we need to print the entire set of pids.
I don't know if /proc/pid/status is the proper place but ...

Eric

