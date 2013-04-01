Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3DAVAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:00:33 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:54372 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab3DAVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:00:32 -0400
Date: Mon, 1 Apr 2013 14:00:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yet another pipe related oops.
Message-ID: <20130401210029.GA3245@kroah.com>
References: <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com>
 <20130327152030.GY21522@ZenIV.linux.org.uk>
 <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
 <20130327174506.GZ21522@ZenIV.linux.org.uk>
 <20130401203445.GA20862@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401203445.GA20862@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 09:34:46PM +0100, Al Viro wrote:
> On Wed, Mar 27, 2013 at 05:45:06PM +0000, Al Viro wrote:
> > We shouldn't, at least not for something that has been successfully
> > opened.  I've a patch series cleaning that up a bit in the local
> > queue; will check for bitrot and throw into for-next.
> 
> Egads...  OK, that has gone more than slightly out of control - right now
> vfs.git#for-next is at 106 commits, -3.6KLoC balance and *still* hadn't
> reached the ->f_op part of that work ;-/  OTOH, procfs-related code got
> a lot cleaner and we actually have a chance to make the guts of proc_dir_entry
> private to fs/proc now...  I'll cull the outright bug fixes into for-linus
> and push it your way...
> 
> The thing that really worries me is debugfs; that fscker sets whatever
> file_operations it's got from the driver that registered a file there
> and sticks that into ->i_fop.  When we try to open() that, we get
> try_module_get() ->i_fop->owner; so far, so good, but what if the driver
> has just been removed *and* file_operations instance we are looking at
> has already been freed?
> 
> IOW, how do we deal with a race between attempt to open a debugfs file and
> its removal on driver unload?  Greg?

Hm, I thought the i_fop->owner thing would be the needed protection, but
I guess you are right, it will not.  I guess we need to do what
character devices do and have an "intermediate" fops in order to protect
this.  Would that work?

As module removal never happens unless an admin does it by hand, it's
not a "real" issue that can be triggered by anyone easily, thankfully.

thanks,

greg k-h
