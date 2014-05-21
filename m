Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaEUTOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaEUTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:14:05 -0400
Date: Wed, 21 May 2014 15:13:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, thomas.mingarelli@hp.com
Subject: Re: [PATCH 5/6] x86, nmi: Move default external NMI handler to its
 own routine
Message-ID: <20140521191319.GD50500@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-6-git-send-email-dzickus@redhat.com>
 <20140521103846.GA2485@laptop.programming.kicks-ass.net>
 <20140521164848.GZ50500@redhat.com>
 <20140521181756.GJ2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521181756.GJ2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 08:17:56PM +0200, Peter Zijlstra wrote:
> On Wed, May 21, 2014 at 12:48:48PM -0400, Don Zickus wrote:
> > On Wed, May 21, 2014 at 12:38:46PM +0200, Peter Zijlstra wrote:
> > > On Thu, May 15, 2014 at 03:25:48PM -0400, Don Zickus wrote:
> > > > Now that we have setup an NMI subtye called NMI_EXT, there is really
> > > > no need to hard code the default external NMI handler in the main
> > > > nmi handler routine.
> > > > 
> > > > Move it to a proper function and register it on boot.  This change is
> > > > just code movement.
> > > > 
> > > > In addition, update the hpwdt to allow it to unregister the default
> > > > handler on its registration (and vice versa).  This allows the driver
> > > > to take control of that io port (which it ultimately wanted to do
> > > > originally), but in a cleaner way.
> > > 
> > > wanting that is one thing, but is it also a sane thing? You don't do
> > > thing just because drivers want it.
> > 
> > Heh. I understand.
> > 
> > Today, I have hacked up the SERR and IOCHK handlers to give hpwdt the
> > chance to do its 'magic' bios call to collect information before
> > panic'ing.
> > 
> > I was trying to clean things up by removing those hacks, but I guess I can
> > see your point, there is no guarantee they handle the hardware correctly.
> > :-/
> 
> So while I'll leave the decision to the x86 people, I find the changelog
> entirely devoid of a good reason to do this.
> 
> An in my personal opinion any hardware that triggers non detectable NMIs
> is just plain broken.

I do agree.  And I am not looking to argue against your opinion, but the
'broken' part is what is interesting to vendors.  With firmware becoming
more prevalent these days, I have seen large upticks in unknown NMIs with
RHEL-X due to broken firmware implementing the latest bells and whistles.

With so much firmware on the system (various pci cards, system firmware,
etc), no one knows which piece is broken.  What hpwdt is trying to do (and
other vendors too), is the momemnt an unknown NMI happens, jump into
bios and start poking registers on various system bridges to figure out
who is causing the problems and log them somehow (on a BMC and its ilk).
Then the hardware guys know what to fix.

Of course, ACPI's APEI was supposed to create a framework to properly
deliver these errors to the OS for reliable reporting (using a properly
registerd NMI handler with a detectable NMI).  But I think it is still a
work in progress. :-/

So the problem is the hardware _is_ broken, but how to communicate that is
difficult and unknown NMI appears to be the cheap and easy way to do that.

Cheers,
Don
