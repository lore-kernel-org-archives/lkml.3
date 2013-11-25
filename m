Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3KYMbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:31:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57851 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178Ab3KYMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:31:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: James Bottomley <jbottomley@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in sysfs_remove_group()
Date: Mon, 25 Nov 2013 13:43:58 +0100
Message-ID: <3149277.4DLRgh8lWk@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385375339.2354.28.camel@dabdike>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com> <20131122160252.GA8981@mtj.dyndns.org> <1385375339.2354.28.camel@dabdike>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 10:29:00 AM James Bottomley wrote:
> On Fri, 2013-11-22 at 11:02 -0500, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Nov 22, 2013 at 08:43:55AM -0700, Bjorn Helgaas wrote:
> > > > So, we do have cases where the parent is removed before the child.  I
> > > > suppose the parent pci bridge is removed already?  AFAICS this
> > > > shouldn't break anything but people did seem to expect the removals to
> > > > be ordered from child to parent.  Bjorn, is this something you expect
> > > > to happened?
> > > 
> > > I do not expect a PCI bridge to be removed before the devices below
> > > it.  We should be removing all the children before removing the parent
> > > bridge.
> > > 
> > > But is this related to PCI?  I don't see the connection yet.  I tried
> > 
> > I'm not sure.  It was from thunderbolt and nobody is reporting it on
> > other interconnects, so it could be.
> > 
> > > to look into this a bit (my notes are at
> > > https://bugzilla.kernel.org/show_bug.cgi?id=65281), but I haven't
> > > figured out the big-picture problem yet.
> > > 
> > > I don't have warm fuzzies that adding a "have we already removed this"
> > > check is the best resolution, but maybe that's just because I don't
> > > understand the problem.
> > 
> > Yeah, the whole thing is sorta pointless.  Just issuing removal and
> > continuing on should do, IMHO.
> 
> I'd go for that as well.  We have huge problems with the _del calls
> because visibility is strict hierarchy and it's not always easy to work
> out who's underneath us.
> 
> It's going to be really annoying when refcounting works perfectly for
> objects, so you can just do puts in any order, but you have to have
> _del() called to remove subordinate objects before their parent.

Well, that would be fine and dandy, but device_del() calls bus_remove_device()
which in turn runs device_release_driver() and the order in which *these*
things are done actually matters in general.

So yes, after we have released all of the drivers in question, we can do _del()
right before the final _put() in any order just fine.

Thanks,
Rafael

