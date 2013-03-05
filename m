Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3CERkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:40:14 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:53176 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3CERkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:40:12 -0500
Message-ID: <1362505193.18799.57.camel@thor.lan>
Subject: Re: [PATCH v4 00/32] ldisc patchset
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>
Date: Tue, 05 Mar 2013 12:39:53 -0500
In-Reply-To: <1361558250.14402.6.camel@thor.lan>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
	 <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <51261E30.9040907@gmail.com> <1361453910.10685.7.camel@thor.lan>
	 <1361558250.14402.6.camel@thor.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 13:37 -0500, Peter Hurley wrote:
> On Thu, 2013-02-21 at 08:38 -0500, Peter Hurley wrote:
> > On Thu, 2013-02-21 at 08:16 -0500, Sasha Levin wrote:
> > > On 02/20/2013 03:02 PM, Peter Hurley wrote:
> > > > Sasha and Dave, my trinity testbeds die in other areas right now;
> > > > I would really appreciate if you would please re-test this series.
> > > 
> > > Hi Peter,
> > > 
> > > I saw this twice in overnight fuzzing:
> > > 
> > > [ 1473.912280] =================================
> > > [ 1473.913180] [ BUG: bad contention detected! ]
> > > [ 1473.914071] 3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8 Tainted: G        W
> > > [ 1473.915684] ---------------------------------
> > > [ 1473.916549] kworker/1:1/361 is trying to contend lock (&tty->ldisc_sem) at:
> > > [ 1473.918031] [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
> > > [ 1473.919060] but there are no locks held!
> > 
> > Ahh, of course. That explains why the rwsem trylock doesn't track lock
> > stats -- because by the time lock_contended() is called, up_write()
> > could have just called lockdep_release(), so that it appears as if the
> > lock has been released when in fact it has not but is about to.
> > 
> > I'll just remove the lock contention test from the trylocks.

Hi Greg,

I thought I'd recap the various reports so this patchset can move
forward and you don't feel like you're wasting time reviewing it.

1. The 'BUG: bad contention detected' is fixed by the inline patch I
replied with.

2. The various hung task reports specifically wrt. pmtx_open() and
tty_open() actually pre-date this series and have been discovered to be
due to the ircomm_tty driver sleeping holding the tty_lock(). Dave
Miller has that patch and may or may not apply it.  [You were cc'd on
that conversation.]

3. The other hung task reports from Sasha involving hangup are only
indirectly related to this patchset, in that the task signalling done by
the session leader is in the wrong order wrt. the ldisc hangup. Sasha
and I have been running an additional patchset on top of this which
properly orders the foreground process group signalling and fixes that
hung task.

I've delayed rebasing this on tty-next (which will now be necessary
because of the last-minute drop of the "tty is NULL" warning) until
after this review is complete.

Please let me know if you have concerns I haven't addressed here.

Regards,
Peter Hurley



