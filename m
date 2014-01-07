Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaAGURS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:17:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbaAGURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:17:11 -0500
Date: Tue, 7 Jan 2014 15:16:41 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: kobject: provide kobject_put_wait to fix module unload race
In-Reply-To: <20140107191910.GA8884@redhat.com>
Message-ID: <alpine.LRH.2.02.1401071506420.26598@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <52C98BCC.9040900@acm.org> <20140105182640.GA2522@kroah.com> <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com> <20140106213111.GA2536@redhat.com>
 <alpine.LRH.2.02.1401062249020.17811@file01.intranet.prod.int.rdu2.redhat.com> <CA+55aFw+kS-jJencvQgQcn0yTw_a4=2RDynopL7Gu0PNemkUvA@mail.gmail.com> <alpine.LRH.2.02.1401071253510.8158@file01.intranet.prod.int.rdu2.redhat.com>
 <20140107191910.GA8884@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Jan 2014, Mike Snitzer wrote:

> On Tue, Jan 07 2014 at  1:00pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Tue, 7 Jan 2014, Linus Torvalds wrote:
> > 
> > > This looks completely broken to me. You do a "kobject_put()" and then
> > > after you've dropped that last use, you wait for the completion of
> > > something that may already have been free'd.
> > > 
> > > Wtf? Am I missing something?
> > > 
> > >                Linus
> > 
> > It is correct. The release method dm_kobject_release doesn't free the 
> > kobject. It just signals the completion and returns.
> > 
> > This is the sequence of operations:
> > * call kobject_put
> > * wait until all users stop using the kobject, when it happens the release 
> >   method is called
> > * the release method signals the completion and returns
> > * the unload code that waits on the completion continues
> > * the unload code frees the mapped_device structure that contains the 
> >   kobject
> > 
> > Using kobject this way avoids the module unload race that was mentioned at 
> > the beginning of this thread.
> 
> I've staged your patch in linux-next for 3.14, see:
> http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=af7b1e5c767fc895788c971c8f4686402ac8344f

Looking at this patch, I realize that it is buggy too. If module unload 
happens at this point (after the completion is signaled, but before the 
release function returns), it crashes.

static void dm_kobject_release(struct kobject *kobj)
{
	complete(dm_get_completion_from_kobject(kobj));
	>========== module unload here ===============<
}

The patch that I sent initially in this thread doesn't have this bug 
because the completion is signaled in non-module code.

That goes back to my initial claim - it is impossible to use the kobject 
interface correctly! But if Greg doesn't want a patch that fixes the 
kobject interface, I don't really know what to do about it.

Maybe another possibility - maintain a list of all kobjects and walk them 
in the generic module unload code to check if their release method ponits 
to the module that is being unloaded? Greg, would you accept a patch like 
this?

Mikulas
