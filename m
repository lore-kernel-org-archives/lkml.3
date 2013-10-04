Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3JDCx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:53:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3JDCxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:53:54 -0400
Date: Fri, 4 Oct 2013 03:53:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004025351.GO13318@ZenIV.linux.org.uk>
References: <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <20131003174439.GG13318@ZenIV.linux.org.uk>
 <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
 <20131003194351.GK13318@ZenIV.linux.org.uk>
 <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
 <20131003204142.GL13318@ZenIV.linux.org.uk>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
 <20131003211448.GN13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003211448.GN13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:14:48PM +0100, Al Viro wrote:

> > So I don't see how they could possibly see ones. Modulo terminal bugs
> > in synchronize_barrier() (which can be very slow, but for umount I
> > wouldn't worry). Or modulo my brain being fried.
> 
> There's one more place similar to that - kern_unmount().  There we also
> go from "longterm vfsmount, mntput() doesn't need to bother checking"
> to NULL ->mnt_ns.  We can, of course, slap synchronize_rcu() there as
> well, but that might make pid_ns and ipc_ns destruction slow...

OK, fuse side of things done, smp_mb() in mntput_no_expire() dropped,
kern_umount() got synchronize_rcu() (I'm not happy about the last one,
but... hell knows; I want to see profiles before deciding what to do
about it).

Updated branch force-pushed.  BTW, brlock defines can go after that;
we still two instances of lg_lock, but they spell the primitives
out instead of using br_{read,write}_lock aliases.

Speaking of those two - I really want to see file_table.c one killed.
Christoph, do you have anything along the lines of getting rid of the
mark_files_ro() nonsense?  After all, a combination of r/w vfsmount
and a superblock with MS_RDONLY in flags should do about the right thing
these days...  I can probably knock something together tomorrow, but
you've brought that thing up quite a few times, so if you happen to have
a patch more or less ready...
