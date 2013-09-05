Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240Ab3IEMMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:12:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60384 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965170Ab3IEMMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:12:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Savchenko <bircoph@gmail.com>, linux-kernel@vger.kernel.org,
        suspend-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        linux-pm@vger.kernel.org
Subject: Re: [Suspend-devel] [BUG] 3.7-rc regression bisected: s2disk fails to resume image: Processes could not be frozen, cannot continue resuming
Date: Thu, 05 Sep 2013 14:23:25 +0200
Message-ID: <2662480.5erkm9ACQI@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130905120811.GC15161@amd.pavel.ucw.cz>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com> <20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com> <20130905120811.GC15161@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 05, 2013 02:08:11 PM Pavel Machek wrote:
> Hi!
> 
> Rafael, Al: apparently we have a regression caused by
> ba4df2808a86f8b103c4db0b8807649383e9bd13 .

I noticed that, but I'm not sure how to deal with it.

Also, s2disk still works on my test machines, so that seems to be
specific to this particular configuration.

> > > after a kernel update from 3.5.7 to the latest stable I found that
> > > user-space resume (from suspend-1.0 aka uswsusp) no longer works.
> > > Kernel-space suspend and resume work fine (e.g. echo disk
> > > > /sys/power/state), problem is with user-space support. (I need
> > > user-space version because it supports image encryption.)
> > > 
> > > After resume (essentially linuxrc) application loads image it fails
> > > to apply it:
> > > 
> > > ========================================================
> > > Processes could not be frozen, cannot continue resuming.
> > > Error 11: Resource temporarily unavailable
> > > 
> > > You can now boot the system and lose the saved state
> > > or reboot and try again.
> > > 
> > > [Notice that if you decide to reboot, you MUST NOT mount
> > > any filesystems before a successful resume.
> > > Resuming after some filesystems have been mounted
> > > will badly damage these filesystems.]
> > > 
> > > Do you want to continue booting (Y/n)?
> > > ========================================================
> > > 
> > > Error code wasn't originally showed, I added it to suspend tool to
> > > aid debugging. Essentially freeze ioctl on /dev/snapshot fails with
> > > this error.
> > > 
> > > I bisected a commit which introduces this bug:
> > > 
> > > ========================================================
> > > commit ba4df2808a86f8b103c4db0b8807649383e9bd13 
> > > Author: Al Viro <viro@zeniv.linux.org.uk> 
> > > Date:   Tue Oct 2 15:29:10 2012 -0400 
> > > 
> > >     don't bother with kernel_thread/kernel_execve for launching
> > > linuxrc 
> > >     exec_usermodehelper_fns() will do just fine... 
> > >     
> > >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk> 
> > > ========================================================
> > > 
> > > In fact this commit induced/triggered at least two bugs: the first one
> > > I'm facing now and the second one was fixed in commit
> > > f0de17c0babe7f29381892def6b37e9181a53410:
> > > make sure that /linuxrc has std{in,out,err}.
> > > 
> > > As a temporarily workaround for this issue I reverted all changes for
> > > init/do_mounts_initrd.c up to the latest working commit
> > > cb450766bcafc7bd7d40e9a5a0050745e8c68b3e considering the kernel API
> > > changes (kernel_execve -> sys_execve). See linuxrc-workaround.patch.
> > > I understand this isn't a proper solution, I just want to show what
> > > code works for me.
> > > 
> > > I also found an interesting LKML discussion about s2disk and freezer
> > > issue: http://www.spinics.net/lists/linux-nfs/msg38160.html
> > > Maybe it is related to this bug, but patch proposed there doesn't in
> > > my case.
> > > 
> > > Kernel config which fails with
> > > ba4df2808a86f8b103c4db0b8807649383e9bd13 and works with
> > > f0de17c0babe7f29381892def6b37e9181a53410 is also attached.
> > > 
> > > As this issue maybe hardware related, the system is 32-bit EEE PC
> > > 1000H with Atom N270, 2GB RAM, 750 GB SATA drive.
> > > 
> > > Additional (but probably useless) information on this bug may be found
> > > here: https://forums.gentoo.org/viewtopic-p-7371120.html
> > 
> > This bug is still here with 3.11-rc7 and 3.10.9.
> > I opened a kernel bug 60802 for this issue:
> > https://bugzilla.kernel.org/show_bug.cgi?id=60802
> > 
> > Any ideas?
> > 
> > Best regards,
> > Andrew Savchenko
> 
> 
> 
> > ------------------------------------------------------------------------------
> > Introducing Performance Central, a new site from SourceForge and 
> > AppDynamics. Performance Central is your source for news, insights, 
> > analysis and resources for efficient Application Performance Management. 
> > Visit us today!
> > http://pubads.g.doubleclick.net/gampad/clk?id=48897511&iu=/4140/ostg.clktrk
> 
> > _______________________________________________
> > Suspend-devel mailing list
> > Suspend-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/suspend-devel
> 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
