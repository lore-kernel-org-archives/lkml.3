Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3JCVOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:14:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab3JCVOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:14:49 -0400
Date: Thu, 3 Oct 2013 22:14:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131003211448.GN13318@ZenIV.linux.org.uk>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <20131003174439.GG13318@ZenIV.linux.org.uk>
 <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
 <20131003194351.GK13318@ZenIV.linux.org.uk>
 <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
 <20131003204142.GL13318@ZenIV.linux.org.uk>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:52:45PM -0700, Linus Torvalds wrote:

> Yeah, I think we should be guaranteed that, because the
> synchronize_rcu() will guarantee that all other CPU's go through an
> idle period. So the "read A" on CPU2 cannot possibly see a 1 _unless_
> it happens so early that synchronize_rcu() definitely sees it (ie it's
> a "preexisting reader" by definition), in which case synchronize_rcu()
> will be waiting for a subsequent idle period, in which case the B=0 on
> CPU2 is not only guaranteed to happen but also be visible out, so the
> "read B" on CPU1 will see 0. And that's true even if CPU2 doesn't have
> an explicit memory barrier, because the "RCU idle" state implies that
> it has gone through a barrier.
> 
> So I don't see how they could possibly see ones. Modulo terminal bugs
> in synchronize_barrier() (which can be very slow, but for umount I
> wouldn't worry). Or modulo my brain being fried.

There's one more place similar to that - kern_unmount().  There we also
go from "longterm vfsmount, mntput() doesn't need to bother checking"
to NULL ->mnt_ns.  We can, of course, slap synchronize_rcu() there as
well, but that might make pid_ns and ipc_ns destruction slow...
