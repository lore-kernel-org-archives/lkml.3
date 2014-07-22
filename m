Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaGVDbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:31:49 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59801 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaGVDbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:31:47 -0400
Date: Mon, 21 Jul 2014 22:30:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 3/3] fuse: Allow mounts from user namespaces
Message-ID: <20140722033044.GE111224@ubuntu-hedt>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	lxc-devel@lists.linuxcontainers.org,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
 <1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
 <CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
 <20140721124725.GB111224@ubuntu-hedt>
 <CAJfpegs=V5BpNdgn1JSLsvUsAnmhPvGJZobF1y_NAysb==Z1-A@mail.gmail.com>
 <20140721143442.GD111224@ubuntu-hedt>
 <87r41er3n6.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r41er3n6.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:02:53AM -0700, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > On Mon, Jul 21, 2014 at 03:09:14PM +0200, Miklos Szeredi wrote:
> >> On Mon, Jul 21, 2014 at 2:47 PM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > On Fri, Jul 18, 2014 at 05:33:23PM +0200, Miklos Szeredi wrote:
> >> >> On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
> >> >> <seth.forshee@canonical.com> wrote:
> >> >> > Update fuse to allow mounts from user namespaces. During mount
> >> >> > current_user_ns() is stashed away,
> >> >>
> >> >> Same thing here.  While practically this may work, it's theoretically
> >> >> wrong, and possibly may go wrong in special situations.   In fuse
> >> >> there's no official "server process", so storing information, like
> >> >> namespace, about one is going to be wrong.
> >> >
> >> > What you're suggesting would probably work fine when dealing with pids.
> >> > It's not going to work though for the checks I've added in
> >> > fuse_allow_current_process() that the process is in the mount owner's
> >> > user ns, and without those checks or something similar I don't think
> >> > it's safe to permit allow_other for user ns mounts.
> >> 
> >> You can add that check in fuse_dev_do_read() as well.  If the
> >> fsuid/fsgid doesn't exist in the "server's" namespace, then set
> >> req->out.h.error and call request_end().
> >
> > Okay, that seems like it should work.
> >
> >> > Can you elaborate on what special situations might violate these
> >> > assumptions or otherwise cause problems?
> >> 
> >> What's preventing a fuse fs implementation from handling FUSE_INIT in
> >> one process and then handling the rest in a different process
> >> (possibly in a different namespace)?
> >
> > Nothing, but I'm having a hard time imagining why that would ever be
> > useful. The user/group ids passed in the mount options would have to be
> > mapped into that namespace, otherwise all requests will just fail in the
> > check you suggest above. The only thing I can think of would be if
> > someone wanted to proxy mounts trough a process in a more privileged
> > context, but then the main point of these patches is to make that
> > unnecessary.
> >
> > But I also think your approach should work just as well as mine for the
> > use cases that do make sense to me, so I'll go ahead and give it a
> > try.
> 
> A few observations that I don't think I have seen come up in this
> thread.
> 
> In my earlier experiments with mounting filesystems in other user
> namespaces it did wind up making sense to have a notion of this is
> the user namespace that things are represented in on disk, and
> that wound up covering odd corner cases like acls.  For fuse
> I don't recall if any of those corner cases exists.
> 
> At the same time my conversion experience also showed that performing
> the conversion to/from kuid and kgids as close to the user space
> interface as close as possible was the lease error prone and most
> secure way of handling things.

My approach and the one suggested by Miklos will both do the conversion
only when copying the ids into/from the structs which are directly
exchanged with userspace, so we're already as close to userspace as
possible. The difference between the approaches is that one does it
before inserting the data into the queue that services userspace reads
whereas the other does it after dequeueing (and thus in the context of
the process doing the read).

> For the file descriptors used for talking to a fuse server I would be
> inclined to capture a user and pid namespace at open time to use for
> your conversions.   This avoids using current and getting into the
> problem of file descriptors that change behavior when passed from
> process to process.

This seems best to me too. It would require restructuring the way fuse
handles file private data for /dev/fuse, but that should be doable.

Miklos, after looking at the code again I noticed that to move all the
id conversions into the context of the userspace process we also have to
handle it for FUSE_GETATTR and FUSE_SETATTR, probably by special casing
these ops in the read/write code. Do you favor this approach or Eric's
suggestion?

Thanks,
Seth
