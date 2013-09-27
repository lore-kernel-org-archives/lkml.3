Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3I0FUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3I0FUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:20:14 -0400
Subject: Re: [PATCH] tty: Fix SIGTTOU not sent with tcflush()
From: Karel Srot <ksrot@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Matt Newsome <mnewsome@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20130926191034.GA26591@redhat.com>
References: <52437AA2.5040907@hurleysoftware.com>
	 <1380154395-4232-1-git-send-email-peter@hurleysoftware.com>
	 <20130926163633.GA22849@redhat.com>  <20130926191034.GA26591@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Sep 2013 07:19:53 +0200
Message-ID: <1380259193.5654.2.camel@dhcp-30-102.brq.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Thu, 2013-09-26 at 21:10 +0200, Oleg Nesterov wrote:
> On 09/26, Oleg Nesterov wrote:
> >
> > Thanks Peter.
> >
> > Well. I'am afraid my testing was wrong, because Karel reports
> > it fixes the problem...
> >
> > But. I applied this patch to my 3.11 tree (last commit is bff157b3a)
> > which also has the additional patch (03e12617 "tty: disassociate_ctty()
> > sends the extra SIGCONT"), and
> >
> > 	TET_CONFIG=CFG TET_ROOT=.  ./T.tcflush 4
> >
> > still fails... T.tcflush was compiled on another (Karel's) machine,
> > perhaps there is something in libc, I do not know.
> >
> > So let me ask just in case, I assume the fix below doesn't depend on
> > other changes I could miss?
> >
> > I'll retest after git-pull and report...
> 
> Still fails under the Linus's tree + this patch.
> 
> However!!!
> 
> Tested-by: Oleg Nesterov <oleg@redhat.com>
> 
> 
> 
> 
> It turns out, T.tcflush doesn't expect it can start as a process group
> leader. In this case setsid() fails, then tty_open() doesn't set
> signal->tty, and thus this patch makes no difference: tty_check_change()
> fails because tty doesn't match signal->tty.
> 
> And indeed, this test passes if you run it under strace, or simply do
> 
> 	$ TET_CONFIG=CFG TET_ROOT=. perl -e "system './T.tcflush 4'"
> 
> And damn, the fact it doesn't fail under strace doesn't allow you to
> see that setsid() fails ;)
> 
> This is probably explains why Karel reported success, perhaps he
> didn't run this test individually.

This is true, I didn't execute this particular test directly but through
the LSB test suite framework.

> 
> Thanks again Peter. Perhaps my analysis was wrong (and I do not see
> setsid() in the sources), I do not really care. but perhaps tcflush.c
> should be updated.
> 
> Oleg.
> 


Karel

-- 
Karel Srot
Quality Engineer, QE BaseOS Security team

Email: ksrot@redhat.com
Web: www.cz.redhat.com
Red Hat Czech s.r.o., Purkyňova 99/71, 612 45, Brno, Czech Republic

