Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3IZTRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab3IZTRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:17:04 -0400
Date: Thu, 26 Sep 2013 21:10:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Fix SIGTTOU not sent with tcflush()
Message-ID: <20130926191034.GA26591@redhat.com>
References: <52437AA2.5040907@hurleysoftware.com> <1380154395-4232-1-git-send-email-peter@hurleysoftware.com> <20130926163633.GA22849@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926163633.GA22849@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26, Oleg Nesterov wrote:
>
> Thanks Peter.
>
> Well. I'am afraid my testing was wrong, because Karel reports
> it fixes the problem...
>
> But. I applied this patch to my 3.11 tree (last commit is bff157b3a)
> which also has the additional patch (03e12617 "tty: disassociate_ctty()
> sends the extra SIGCONT"), and
>
> 	TET_CONFIG=CFG TET_ROOT=.  ./T.tcflush 4
>
> still fails... T.tcflush was compiled on another (Karel's) machine,
> perhaps there is something in libc, I do not know.
>
> So let me ask just in case, I assume the fix below doesn't depend on
> other changes I could miss?
>
> I'll retest after git-pull and report...

Still fails under the Linus's tree + this patch.

However!!!

Tested-by: Oleg Nesterov <oleg@redhat.com>




It turns out, T.tcflush doesn't expect it can start as a process group
leader. In this case setsid() fails, then tty_open() doesn't set
signal->tty, and thus this patch makes no difference: tty_check_change()
fails because tty doesn't match signal->tty.

And indeed, this test passes if you run it under strace, or simply do

	$ TET_CONFIG=CFG TET_ROOT=. perl -e "system './T.tcflush 4'"

And damn, the fact it doesn't fail under strace doesn't allow you to
see that setsid() fails ;)

This is probably explains why Karel reported success, perhaps he
didn't run this test individually.

Thanks again Peter. Perhaps my analysis was wrong (and I do not see
setsid() in the sources), I do not really care. but perhaps tcflush.c
should be updated.

Oleg.

