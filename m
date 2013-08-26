Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3HZSdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:33:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43096 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3HZSdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:33:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20130822201530.GL31117@1wt.eu>
	<20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
	<20130825065039.GB9299@1wt.eu>
	<CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
	<20130825194844.GA16717@redhat.com>
	<CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
	<20130826153301.GA15890@redhat.com>
	<20130826163704.GA21763@redhat.com>
	<20130826175441.GA28856@redhat.com>
Date: Mon, 26 Aug 2013 11:32:53 -0700
In-Reply-To: <20130826175441.GA28856@redhat.com> (Oleg Nesterov's message of
	"Mon, 26 Aug 2013 19:54:41 +0200")
Message-ID: <87ioyspaju.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/1JiajQaxlXXZynWJHGJB5r5l6P7vNcQ0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4661]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: make proc_fd_permission() thread-friendly
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> proc_fd_permission() says "process can still access /proc/self/fd
> after it has executed a setuid()", but the "task_pid() = proc_pid()
> check only helps if the task is group leader, /proc/self points to
> /proc/leader-pid.
>
> Change this check to use task_tgid() so that the whole process can
> access /proc/self/fd.

There is at least a semantic goofiness here.

There is /proc/<tgid>/fd and /proc/<tgid>/task/<pid>/fd, and the same
permission check is used by both.

We might just want to have a /proc/thread symlink as well so people
don't have this issue.  Of course that would require people to use it,
and I think the common case if people care is call gettid() and build
the path themselves.

Eric
