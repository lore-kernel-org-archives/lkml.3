Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3GWPBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:01:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab3GWPBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:01:34 -0400
Date: Tue, 23 Jul 2013 08:02:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Andre Naujoks <nautsch2@gmail.com>,
        Dean Jenkins <Dean_Jenkins@mentor.com>
Subject: Re: [PATCH v2 20/20] tty: Remove extra wakeup from pty write() path
Message-ID: <20130723150245.GB12292@kroah.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-21-git-send-email-peter@hurleysoftware.com>
 <51EAC23F.9050101@hurleysoftware.com>
 <51EE7DC8.3060004@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE7DC8.3060004@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:57:44AM -0400, Peter Hurley wrote:
> On 07/20/2013 01:00 PM, Peter Hurley wrote:
> >On 06/15/2013 10:21 AM, Peter Hurley wrote:
> >>Acquiring the write_wait queue spin lock now accounts for the largest
> >>slice of cpu time on the tty write path. Two factors contribute to
> >>this situation; a overly-pessimistic line discipline write loop which
> >>_always_ sets up a wait loop even if i/o will immediately succeed, and
> >>on ptys, a wakeup storm from reads and writes.
> >>
> >>Writer wakeup does not need to be performed by the pty driver.
> >>Firstly, since the actual i/o is performed within the write, the
> >>line discipline write loop will continue while space remains in
> >>the flip buffers. Secondly, when space becomes avail in the
> >>line discipline receive buffer (and thus also in the flip buffers),
> >>the pty unthrottle re-wakes the writer (non-flow-controlled line
> >>disciplines unconditionally unthrottle the driver when data is
> >>received). Thus, existing in-kernel i/o is guaranteed to advance.
> >>Finally, writer wakeup occurs at the conclusion of the line discipline
> >>write (in tty_write_unlock()). This guarantees that any user-space write
> >>waiters are woken to continue additional i/o.
> >
> >Greg,
> >
> >I thought I should let you know I'm tracking down a bug/regression
> >related to this patch.
> >
> >In certain unusual pty/ldisc configurations, i/o fails to make
> >forward progress. I still stand by my commit message above, so I'm
> >in the process of instrumenting the i/o path so I can uncover the
> >cause of the failure.
> 
> Mystery solved.
> 
> [PATCH v4 23/24] n_tty: Special case pty flow control
> from the lockless n_tty receive path series introduced a regression
> in which i/o failed to advance.
> 
> This only occurred when one end of a pty pair was set to an ldisc
> other than N_TTY. The special case optimization which that patch
> introduces failed to address that configuration.
> 
> I've sent a v5 of that patch to resolve the regression.

Thanks for that, I'll work to queue all of your tty patches up today, as
they have been sitting out of the tree for too long :)

greg k-h
