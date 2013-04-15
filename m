Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935228Ab3DOVr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:47:29 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:33123 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934905Ab3DOVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:47:27 -0400
Date: Mon, 15 Apr 2013 14:47:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vivek Goyal <vgoyal@redhat.com>
cc: Michel Lespinasse <walken@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on
 CPU due to 09a9f1d27
In-Reply-To: <20130415191304.GC30583@redhat.com>
Message-ID: <alpine.LNX.2.00.1304151425540.1030@eggly.anvils>
References: <20130412181348.GA2253@redhat.com> <CANN689GKfxM3R96wgY8-+FftpVT76zMFcHdgKccNKnjHGfYq1Q@mail.gmail.com> <20130415163552.GA31868@redhat.com> <20130415173424.GB31868@redhat.com> <20130415175929.GB30583@redhat.com>
 <20130415191304.GC30583@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Vivek Goyal wrote:
> On Mon, Apr 15, 2013 at 01:59:29PM -0400, Vivek Goyal wrote:
> > On Mon, Apr 15, 2013 at 01:34:24PM -0400, Vivek Goyal wrote:
> > > On Mon, Apr 15, 2013 at 12:35:52PM -0400, Vivek Goyal wrote:
> > > 
> > > [..]
> > > > > My first guess would be that mmap_sem is held during exec, so you
> > > > > can't have __mm_populate() try holding it recursively.
> > > > 
> > > > I think it is not mmap_sem as even with VM_LOCKED, we take mmap_sem
> > > > and things are fine. 
> > > > 
> > > > So things work till 3.8 and break in 3.8-rc1 (with both VM_LOCKED and
> > > > VM_POPULATE specifed). I will do git bisect and try to figure out which
> > > > is first commit which has the issue.
> > > 
> > > Ok, following seems to be first bad commit.
> > > 
> > > commit bebeb3d68b24bb4132d452c5707fe321208bcbcd
> > > Author: Michel Lespinasse <walken@google.com>
> > > Date:   Fri Feb 22 16:32:37 2013 -0800
> > > 
> > >     mm: introduce mm_populate() for populating new vmas
> > > 
> 
> Michel,
> 
> An interesting observation. After this commit looks like simple
> mmap(MAP_LOCKED) of a file was broken and it would hang and give RCU stall
> warning similar to my patch of locking /sbin/kexec.
> 
> But in latest kernel mmap(MAP_LOCKED) does not hang. So looks like
> this problem got fixed in a patch after this first bad commit. But
> locking /sbin/kexec issue still remains.

I haven't tried to understand that.  But I did just try your
def_flags |= VM_LOCKED hack to fs/binfmt_elf.c, and CONFIG_DEBUG_VM=y
quickly suggested the patch below - without the BUG, yes, __mm_populate
might well loop forever trying to populate 0 pages.

Whether a fix is actually needed, and whether it should be fixed here
or elsewhere, I'll leave to Michel.

Hugh

--- 3.9-rc7/mm/mlock.c	2013-04-01 09:08:05.736012852 -0700
+++ linux/mm/mlock.c	2013-04-15 14:20:24.454773245 -0700
@@ -397,8 +397,7 @@ int __mm_populate(unsigned long start, u
 	long ret = 0;
 
 	VM_BUG_ON(start & ~PAGE_MASK);
-	VM_BUG_ON(len != PAGE_ALIGN(len));
-	end = start + len;
+	end = start + PAGE_ALIGN(len);
 
 	for (nstart = start; nstart < end; nstart = nend) {
 		/*

