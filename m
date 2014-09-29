Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaI2Tdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:33:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53418 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaI2Tdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:33:31 -0400
Date: Mon, 29 Sep 2014 20:33:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root
 dir like mountinfo does
Message-ID: <20140929193329.GL7996@ZenIV.linux.org.uk>
References: <20140929180523.GC15829@altlinux.org>
 <20140929183222.GJ7996@ZenIV.linux.org.uk>
 <20140929184333.GD15829@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929184333.GD15829@altlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:43:33PM +0400, Dmitry V. Levin wrote:
> On Mon, Sep 29, 2014 at 07:32:22PM +0100, Al Viro wrote:
> > On Mon, Sep 29, 2014 at 10:05:23PM +0400, Dmitry V. Levin wrote:
> > > Date: Wed, 17 Oct 2012 20:29:55 +0400
> > > 
> > > Change show_vfsmnt() and show_vfsstat() to show mountpoints relative
> > > to the root directory and skip mountpoints outside of chroot jail
> > > the same way as show_mountinfo() does.
> > 
> > Sigh...  Repeat after me:  We  Do  Not  Break  Userland.  Care to explain
> > why that change won't do just that?
> 
> This is definitely an information leak, and I cannot imagine how these
> unaccessible entries listed in /proc/self/mounts and /proc/self/mountstats
> could be used sanely.

How do you think any existing script running chrooted is going to parse
/proc/mounts?  One obvious way is to filter on known prefix and strip it
away.  With your change it will instantly break.  Moreover, any script
working with *new* semantics will break as soon as you boot an older
kernel.

Existing behaviour had been there since mid-90s (at least) and I'm absolutely
certain that such scripts do exist.  I know that, since I had to write such.
Again, we do not break userland.  Especially since the behaviour you want
is trivial to obtain - just create a new namespace instead of messing with
chroot.  Then, in that namespace, pivot_root the sucker to root and unmount
everything else.  Voila.

NAK.  And you really need to realize that changing ABI in a way that breaks
real-world userland code is not acceptable.  Even when the new semantics is
nicer.  And when you cannot imagine how somebody could possibly write code
that would depend on the old one.
