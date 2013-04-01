Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3DAUeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:34:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39636 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab3DAUet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:34:49 -0400
Date: Mon, 1 Apr 2013 21:34:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Yet another pipe related oops.
Message-ID: <20130401203445.GA20862@ZenIV.linux.org.uk>
References: <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com>
 <20130327152030.GY21522@ZenIV.linux.org.uk>
 <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
 <20130327174506.GZ21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130327174506.GZ21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:45:06PM +0000, Al Viro wrote:
> We shouldn't, at least not for something that has been successfully
> opened.  I've a patch series cleaning that up a bit in the local
> queue; will check for bitrot and throw into for-next.

Egads...  OK, that has gone more than slightly out of control - right now
vfs.git#for-next is at 106 commits, -3.6KLoC balance and *still* hadn't
reached the ->f_op part of that work ;-/  OTOH, procfs-related code got
a lot cleaner and we actually have a chance to make the guts of proc_dir_entry
private to fs/proc now...  I'll cull the outright bug fixes into for-linus
and push it your way...

The thing that really worries me is debugfs; that fscker sets whatever
file_operations it's got from the driver that registered a file there
and sticks that into ->i_fop.  When we try to open() that, we get
try_module_get() ->i_fop->owner; so far, so good, but what if the driver
has just been removed *and* file_operations instance we are looking at
has already been freed?

IOW, how do we deal with a race between attempt to open a debugfs file and
its removal on driver unload?  Greg?
