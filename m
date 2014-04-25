Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaDYU0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:26:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54146 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaDYUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:25:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
	<87ha5h42va.fsf@x220.int.ebiederm.org>
	<CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
Date: Fri, 25 Apr 2014 13:25:27 -0700
In-Reply-To: <CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 25 Apr 2014 12:50:49 -0700")
Message-ID: <87tx9h2m2w.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/BnXxdg05Rz1xngAy+X60bDN1p3lFsW0E=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0738]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: pid ns feature request
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Apr 25, 2014 at 12:37 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> Unless I'm missing some trick, it's currently rather painful to mount
>>> a namespace /proc.  You have to actually be in the pid namespace to
>>> mount the correct /proc instance, and you can't unmount the old /proc
>>> until you've mounted the new /proc.  This means that you have to fork
>>> into the new pid namespace before you can finish setting it up.
>>
>> Yes.  You have to be inside just about all namespaces before you can
>> finish setting them up.
>>
>> I don't know the context in which needed to be inside the pid namespace
>> is a burden.
>
> I'm trying to sandbox myself.  I unshare everything, setup up new
> mounts, pivot_root, umount the old stuff, fork, and wait around for
> the child to finish.
>
> This doesn't work: the parent can't mount the new /proc, and the child
> can't either because it's too late.
>
> The only solution I can think of without kernel changes is to fork the
> child (pid 1) before pivot_root, which makes everything more
> complicated.  I suppose I can unshare, fork immediately, have the
> child set up all the mounts, and then wake the parent, but this is an
> annoying bit of extra complexity for no obvious gain.

Or perhaps just use clone and clone flags.

What are you doing with the parent process?  What value does it serve?

>>> Would it make sense to add a mount option to procfs to request a mount
>>> for pid_ns_for_children instead of task_active_pid_ns?
>>
>> This is about the using setns and unshare?
>>
>> Adding a proc amount option that takes a pid namespace file descriptor
>> would be the general solution, and might be worth implementing.
>>
>> Getting a pid namespace file descriptors when there are no pids might be
>> a challenge.
>
> Indeed, hence my request for a specific mode to mount /proc for
> pid_ns_for_children.
>
> FWIW, I also tried forking, having the child mount /proc and exit,
> then forking again later on.  That also doesn't work -- it looks like
> you can't recreate pid 1 after it does.

Nope. Once pid 1 (init) is dead the pid namespace is dead.

Eric
