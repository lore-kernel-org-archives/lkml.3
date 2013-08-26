Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3HZTKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:10:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39444 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3HZTKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:10:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
	<20130825065039.GB9299@1wt.eu>
	<CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
	<20130825194844.GA16717@redhat.com>
	<CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
	<20130826153301.GA15890@redhat.com>
	<20130826163704.GA21763@redhat.com>
	<20130826175441.GA28856@redhat.com> <87ioyspaju.fsf@xmission.com>
	<20130826184631.GA30917@redhat.com>
Date: Mon, 26 Aug 2013 12:10:16 -0700
In-Reply-To: <20130826184631.GA30917@redhat.com> (Oleg Nesterov's message of
	"Mon, 26 Aug 2013 20:46:31 +0200")
Message-ID: <8738pwp8tj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1//WIM8yiC3JqZZYmVmdVY93Yc2ynyQxJk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4356]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 08/26, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > proc_fd_permission() says "process can still access /proc/self/fd
>> > after it has executed a setuid()", but the "task_pid() = proc_pid()
>> > check only helps if the task is group leader, /proc/self points to
>> > /proc/leader-pid.
>> >
>> > Change this check to use task_tgid() so that the whole process can
>> > access /proc/self/fd.
>>
>> There is at least a semantic goofiness here.
>>
>> There is /proc/<tgid>/fd and /proc/<tgid>/task/<pid>/fd, and the same
>> permission check is used by both.
>
> Yes, and we have /proc/<tid>/ which includes fd as well.
>
>> We might just want to have a /proc/thread symlink as well so people
>> don't have this issue.
>
> Yes! I agree.
>
> In particular, from the changelog:
>
> 	Note: CLONE_THREAD doesn't require CLONE_FILES so task->files can
> 	differ,
>
> so /proc/self/fd doesn't necessarily mean current->files, this can confuse
> the application.
>
> And I also assume that you agree with this change ;)

I don't disagree.  Comparing tgid to pids is goofy and my brain is
elsewhere so I have no thought through the implications.

Actually thinking I think the check should really be.  In which case we
are comparing what we really care about.

int proc_fd_permission(struct inode *inode, int mask)
{
	int rv = generic_permission(inode, mask);
	if (rv == 0)
		return 0;

        rcu_read_lock();
        struct task *task = pid_task(proc_pid(inode));
        if (task && (current->files == task->files))
		rv = 0;
        rcu_read_unlock();

	return rv;
}

Eric

