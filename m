Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaFZGSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:18:50 -0400
Received: from jablonecka.jablonka.cz ([91.219.244.36]:42471 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaFZGSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:18:49 -0400
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 02:18:48 EDT
Date: Thu, 26 Jun 2014 07:50:25 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org, tj@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, akpm@linux-foundation.org,
        andi@firstfloor.org, paulmck@linux.vnet.ibm.com, pavel@ucw.cz,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/21] kGraft
Message-ID: <20140626055025.GA5660@suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
 <20140625135421.67cd5f5f@alan.etchedpixels.co.uk>
 <alpine.LNX.2.00.1406251748170.15939@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1406251748170.15939@pobox.suse.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 05:54:50PM +0200, Jiri Kosina wrote:
> > -		wait_event_freezable(khubd_wait,
> > +		wait_event_freezable(khubd_wait,
> >   ({ kgr_task_safe(current);
> > 
> > The changes are somewhat ugly with all the kgraft crap leaking into plces
> > like jbd and freezer and usb. That says to me its not well isolated and
> > there must be a better way of hiding that kgr stuff so we don't have to
> > kepe putting more code into all the kthreads, and inevitably missing them
> > or have people getting it wrong.
> 
> Tejun commented on this very issue during the first RFC submission a 
> couple weeks ago. Part of his proposal was actually to take this as a good 
> pretext to review the existing kernel threads, as the idea is that a big 
> portion of those could easily be converted to workqueues.

In the past few years there was a significant proliferation of kernel
threads just for cases where something needs to be done from a process
context now and then.

This is underlined by the fact that on an average installation there are
more kernel threads than real userspace processes.

Converting these bits to workqueues would then also take care of their
interaction with freezer, kthread_stop. The main loop code wouldn't have
to be replicated over and over with slight variations. kgr_taks_safe
would then plug into that rather elegantly.

In the absence of this rework, kGraft hijacks the freezer and
kthread_stop to pinpoint the 'end' of the main loop of most kernel
threads and annotates the rest that doesn't handle freezing or stopping
with kgr_task_safe directly.


> It of course has its own implications, such as not being able to 
> prioritize that easily, but there is probably a lot of low-hanging fruits 
> where driver authors and their grandmas have been creating kthreads where 
> workqueue would suffice.

Indeed, on the other hand, there are enough workqueues today and on
realtime systems the need for prioritizing them exists already.

> But it's a very long term goal, and it's probably impractical to make 
> kGraft dependent on it.

Should the kernel thread changes turn to be a big issue, we could do the
initial submission without them and depend on the kthread->workqueue
rework. Once we add support for multiple patches in progress, the fact
that we don't support kernel threads would not be as painful.
 
> > You add instructions to various hotpaths (despite the CONFIG
> > comment).
> 
> Kernel entry is hidden behind _TIF_WORK_SYSCALL_ENTRY and
> _TIF_ALLWORK_MASK, so it doesn't add any overhead if kGraft is not
> enabled. What other hot paths do you refer to?

As Jiøí says, I don't see any hot path where kGraft would add
instructions: Kernel exit and entry are handled outside the hot path
in the _TIF_WORK_SYSCALL_ENTRY and _TIF_ALLWORK_MASK handlers. [patch 15/21]

It adds instructions into the main loops of kernel threads, but those
can hardly be called hot paths as they mostly sleep for long times.

-- 
Vojtech Pavlik
Director SUSE Labs
