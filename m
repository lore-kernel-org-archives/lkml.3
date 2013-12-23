Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3LWDsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:48:07 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:55645 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399Ab3LWDsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:48:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcKAPKxt1J5LHyk/2dsb2JhbABSB4MLtHmFUYEVF3SCJQEBAQMBOhwjBQsIAxgJJQ8FJQMhE4d8B8sOFxaOQQZIB4Q2BJgWkhWBb4FSKIEsIw
Date: Mon, 23 Dec 2013 14:48:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20131223034800.GH20579@dastard>
References: <201205252113.50900.rjw@sisk.pl>
 <CA+5PVA5GWsTdNky-K1-hu5_R55hdKfr-Oa26HpX=FdA1cRZsbQ@mail.gmail.com>
 <CA+5PVA7vsZPd9eXwN-Q+d8c9+0bAmVdr698vv+LFyrn+3iFOMA@mail.gmail.com>
 <20131217230843.GA2911@amd.pavel.ucw.cz>
 <20131217233152.GC20579@dastard>
 <20131218000128.GA3737@amd.pavel.ucw.cz>
 <20131218123952.GI31386@dastard>
 <20131218140842.GA20488@amd.pavel.ucw.cz>
 <20131219002216.GT31386@dastard>
 <20131221233318.GA7126@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131221233318.GA7126@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 22, 2013 at 12:33:18AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > > I disagree - given the problem it is resolving leads to silent
> > > > > > filesystem corruption, this patch should be considered somewhat of a
> > > > > > priority to push...
> > > > > 
> > > > > Umm. Ok, I forgot what it does, really.
> > > > 
> > > > It ensures that the filesystem is in an quiescent state both in
> > > > memory and on disk, and it cannot be modified in memory or on disk
> > > > whilst the suspend image is being generated, or by log recovery
> > > > after a resume before the suspended image has been restored.
> > > 
> > > If someone attempts to run log recovery before resume, that's a bug
> > > and yes, it will corrupt filesystems. (Including ext3). Don't do that.
> > 
> > Freezing the filesystem prevents that accidental mount of the
> > filesystem from being an issue. It fixes a bug that:
> 
> Can you elaborate on that?
> 
> If you do read-write mount of that filesystem, surely filesystem
> metadata will differ from what the filesystem expects. You'll still
> get data corruption AFAICT.

Only if you modify stuff. That's not what we are protecting against,
it's avoiding the automatic journal replay that you can't avoid if
you accidentally mount the filesystem.

> Read-only mount... maybe that will get slightly better -- there'll be
> no journal to play back. But what happens to superblock information
> such as "last mount time"? Mount counts?

If metadata is being modified on a read only mount outside of
journal replay, then the filesystem needs fixing.

> 
> > > Documentation/power/swsusp.txt:
> > > 
> > >  * BIG FAT WARNING
> > >    *********************************************************
> > >  *
> > >  * If you touch anything on disk between suspend and resume...
> > >  *                              ...kiss your data goodbye.
> > 
> > Makes this a whole lot less dangerous.
> 
> Do you claim that it is now safe to mount (rw) and access filesystem
> between suspend and resume?

No, I didn't claim that. "less dangerous" is still dangerous, just
less so than it was before.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
