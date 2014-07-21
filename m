Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaGUOnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:43:17 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33869 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaGUOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:43:15 -0400
Date: Mon, 21 Jul 2014 09:34:42 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 3/3] fuse: Allow mounts from user namespaces
Message-ID: <20140721143442.GD111224@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	lxc-devel@lists.linuxcontainers.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
 <1405365496-58404-4-git-send-email-seth.forshee@canonical.com>
 <CAJfpegvMeiZG09U3aXvxKV+GPSn6zFgLbUwXGpTuoVSbnvgfmw@mail.gmail.com>
 <20140721124725.GB111224@ubuntu-hedt>
 <CAJfpegs=V5BpNdgn1JSLsvUsAnmhPvGJZobF1y_NAysb==Z1-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs=V5BpNdgn1JSLsvUsAnmhPvGJZobF1y_NAysb==Z1-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 03:09:14PM +0200, Miklos Szeredi wrote:
> On Mon, Jul 21, 2014 at 2:47 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Fri, Jul 18, 2014 at 05:33:23PM +0200, Miklos Szeredi wrote:
> >> On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > Update fuse to allow mounts from user namespaces. During mount
> >> > current_user_ns() is stashed away,
> >>
> >> Same thing here.  While practically this may work, it's theoretically
> >> wrong, and possibly may go wrong in special situations.   In fuse
> >> there's no official "server process", so storing information, like
> >> namespace, about one is going to be wrong.
> >
> > What you're suggesting would probably work fine when dealing with pids.
> > It's not going to work though for the checks I've added in
> > fuse_allow_current_process() that the process is in the mount owner's
> > user ns, and without those checks or something similar I don't think
> > it's safe to permit allow_other for user ns mounts.
> 
> You can add that check in fuse_dev_do_read() as well.  If the
> fsuid/fsgid doesn't exist in the "server's" namespace, then set
> req->out.h.error and call request_end().

Okay, that seems like it should work.

> > Can you elaborate on what special situations might violate these
> > assumptions or otherwise cause problems?
> 
> What's preventing a fuse fs implementation from handling FUSE_INIT in
> one process and then handling the rest in a different process
> (possibly in a different namespace)?

Nothing, but I'm having a hard time imagining why that would ever be
useful. The user/group ids passed in the mount options would have to be
mapped into that namespace, otherwise all requests will just fail in the
check you suggest above. The only thing I can think of would be if
someone wanted to proxy mounts trough a process in a more privileged
context, but then the main point of these patches is to make that
unnecessary.

But I also think your approach should work just as well as mine for the
use cases that do make sense to me, so I'll go ahead and give it a try.

Thanks,
Seth
