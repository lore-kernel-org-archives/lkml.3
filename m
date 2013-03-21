Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3CUV0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:26:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38163 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3CUV0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:26:19 -0400
Date: Thu, 21 Mar 2013 21:26:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321212617.GA21522@ZenIV.linux.org.uk>
References: <20130321190653.GA15479@redhat.com>
 <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 02:18:15PM -0700, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 2:02 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > here we go...
> >
> > WARNING: at fs/namei.c:2335 lock_rename+0x156/0x160()
> > p1=irda p2=irda
> 
> Ok, good. I ssupect it's /proc or /sys, we do have that entry there.
> 
> But in fact I suspect we do want the parent name after all, because I
> think we have multiple "irda" directories. There's the one in
> /proc/net/ (added by net/irda/irproc.c), and there's a sysctl  CTL_DIR
> "irda" directory (kernel/sysctl_binary.c). And there might even be a
> few other ones in /sys too, thanks to the ldisc called "irda" etc.
> 
> I don't see where the shared inode comes from, but I suspect that
> would be easier to guess if we actually see which particular case it
> ends up being..

Well, something like
	static char path[4096];
	d_absolute_path(p1, path, 4096);
	printk(KERN_ERR "%s %s %d %d"
		path, p1->d_sb->s_type->name, d_unlinked(p1), d_unlinked(p2));
might be useful - pathname within fs, fs type and which of those suckers are
unlinked...
