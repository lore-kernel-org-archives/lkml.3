Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab3CID1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:27:14 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50006 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245Ab3CID1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:27:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFxBvyLcWJB0JMNcaCXHtgvPLt3cFQqJeRFcb=6rkZFtvA@mail.gmail.com>
	<20130308235514.GA5605@redhat.com>
	<CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
	<20130309001917.GA6015@redhat.com> <20130309003617.GB6743@redhat.com>
	<CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
	<20130309020318.GA11449@redhat.com>
	<CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
	<20130309022623.GB11449@redhat.com>
	<20130309025631.GA13188@redhat.com>
	<20130309025752.GA13913@redhat.com>
Date: Fri, 08 Mar 2013 19:27:01 -0800
In-Reply-To: <20130309025752.GA13913@redhat.com> (Dave Jones's message of
	"Fri, 8 Mar 2013 21:57:52 -0500")
Message-ID: <871ubpnth6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/MZG9D3LRJ/MnTUutqxuDkpq96WqJ+HMQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Fri, Mar 08, 2013 at 09:56:31PM -0500, Dave Jones wrote:
>  > On Fri, Mar 08, 2013 at 09:26:23PM -0500, Dave Jones wrote:
>  >  > On Fri, Mar 08, 2013 at 06:08:52PM -0800, Linus Torvalds wrote:
>  >  >  > On Fri, Mar 8, 2013 at 6:03 PM, Dave Jones <davej@redhat.com> wrote:
>  >  >  > >
>  >  >  > > existing pathname + 'a' = fine.
>  >  >  > >
>  >  >  > > existing pathname + '/' + 'a' = boom.
>  >  >  > 
>  >  >  > Good.
>  >  >  > 
>  >  >  > > Looks like if I do this..
>  >  >  > >
>  >  >  > >        if (isdigit(newpath[len]) != 0) {
>  >  >  > >                 newpath[len] = '/';
>  >  >  > >                newpath[len+1] = 'A';
>  >  >  > >                newpath[len+2] = 0;
>  >  >  > >
>  >  >  > > no bug.
>  >  >  > 
>  >  >  > Well, but that will never trigger. newpath[len] will always be NUL, so
>  >  >  > you just disabled things entirely. Use "len-1".
>  >  >  > 
>  >  >  > So I don't think that did what you meant it to do.
>  >  > 
>  >  > Fixed that up, and even double checked my sanity by printing stuff out.
>  >  > 
>  >  > Confirmed that it's something that doesn't end in a number.
>  >  
>  > I've got a hunch that it's /proc/$$/ns/uts.
>  > 
>  > After 3-4 runs, that's the only common file in the last few that got mangled.
>  > 
>  > I'll do some more tests, but this might be the one.
>  
> confirmed.  A simple 
>
> mkdir /proc/self/ns/uts/A
>
> will trigger it.

This is a magic symlink similar to the other magic symlinks in proc so I
don't know if the test is wrong or my code is doing something to clever.

But I can reproduce it so I will look at it and see if I can make sense
of what is going on.

Eric

