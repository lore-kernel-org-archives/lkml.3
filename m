Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3H3Xtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:49:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37079 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3H3Xtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:49:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <87ob8gys0d.fsf@xmission.com> <87a9k0yrvu.fsf@xmission.com>
	<20130830163805.GB18857@mail.hallyn.com>
Date: Fri, 30 Aug 2013 16:49:40 -0700
In-Reply-To: <20130830163805.GB18857@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 30 Aug 2013 16:38:05 +0000")
Message-ID: <87ppsuviwb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+bYUI3azYpgEuX406hfAgQ+pSE5xpB5KQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0469]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 3/5] pidns: Don't have unshare(CLONE_NEWPID) imply CLONE_THREAD
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> I goofed when I made unshare(CLONE_NEWPID) only work in a
>> single-threaded process.  There is no need for that requirement and in
>> fact I analyzied things right for setns.  The hard requirement
>> is for tasks that share a VM to all be in the pid namespace and
>> we properly prevent that in do_fork.
>
> I don't understand though - copy_process does have the right test:
>
>    1176          * If the new process will be in a different pid namespace
>    1177          * don't allow the creation of threads.
>    1178          */
>    1179         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
>    1180             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>    1181                 return ERR_PTR(-EINVAL);
>
> but why is it ok for sys_unshare not to do that?  Note that
> in order for check_unshare_flags() to bail on &current->mm->mm_users > 1
> you do have to set CLONE_VM (for inverse interpretation).
>
> So it seems to me this isn't safe as is, and we need to at least
> set CLONE_VM if CLONE_PID is set.

Partly this is the difference in the meaning of the flags between
unshare and clone.

Basically in unshare all othat gets changed is
current->nsproxy->pid_ns_for_children (the rename is in the net tree).

So because unshare of the pid namespace does not actually effect the
current processes, just the pid namespace the children of the current
thread will be in this is safe.

And frankly having the checks be obviously different is a good thing
because it means that people will ask why in the world this is so and
realize the difference in meaning.

Eric
