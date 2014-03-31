Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaCaW7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:59:36 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:25433 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaCaW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:59:34 -0400
Message-ID: <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 31 Mar 2014 15:59:33 -0700
In-Reply-To: <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 14:32 -0700, Andrew Morton wrote:
> On Sun, 30 Mar 2014 20:06:39 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > 
> > The default size is, and always has been, 32Mb. Today, in the
> > XXI century, it seems that this value is rather small, making
> > users have to increase it via sysctl, which can cause unnecessary
> > work and userspace application workarounds[1]. I have arbitrarily
> > chosen a 4x increase, leaving it at 128Mb, and naturally, the
> > same goes for shmall. While it may make more sense to set the value
> > based on the system memory, this limit must be the same across all
> > systems, and left to users to change if needed.
> > 
> > ...
> >
> > --- a/include/uapi/linux/shm.h
> > +++ b/include/uapi/linux/shm.h
> > @@ -12,7 +12,7 @@
> >   * be increased by sysctl
> >   */
> >  
> > -#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
> > +#define SHMMAX 0x8000000		 /* max shared seg size (bytes) */
> >  #define SHMMIN 1			 /* min shared seg size (bytes) */
> >  #define SHMMNI 4096			 /* max num of segs system wide */
> >  #ifndef __KERNEL__
> 
> urgh.  Perhaps we should have made the default "zero bytes" to force
> everyone to think about what they really need and to configure their
> systems.  Of course that just means that distros will poke some random
> number in there at init time.
> 
> - With this change, the limit is no longer "the same across all
>   systems" because the patch increases it for more recent kernels.
> 
>   Why do you say it "must be the same" and why is this not a problem
>   in the develop-on-new-kernel, run-on-old-kernel scenario?

I was referring to the fact that the user shouldn't have to be
calculating the size himself, at least not the default size (if he wants
to use sysctl instead then that's his business). So, "shmmax is X% of Y
RAM" isn't really what we want, as opposed to something much simpler
such as "up to Linux 3.14 it is 32mb, for newer versions is 128mb". In
fact, that percentage method is more of a posix way of working
via /dev/shm. Furthermore, maintaining "tradition" in sysv is important
for users.

> - The sysctl became somewhat pointless when we added ipc namespaces. 
>   shm_init_ns() ignores the sysctl and goes straight to SHMMAX, and
>   altering the sysctl will have no effect upon existing namespaces
>   anyway.

Well, true, at least for kernel ipc initialization bits. If the value is
going to be changed, the MO is usually to simply change it at later
startup through sysctl.conf and then start the workload, hence ignoring
SHMMAX altogether. This is with or without namespaces, and fwiw, I don't
think they are really used at all nowadays :)

> 
> - Shouldn't there be a way to alter this namespace's shm_ctlmax?

Unfortunately this would also add the complexity I previously mentioned.

> - What happens if we just nuke the limit altogether and fall back to
>   the next check, which presumably is the rlimit bounds?

afaik we only have rlimit for msgqueues. But in any case, while I like
that simplicity, it's too late. Too many workloads (specially DBs) rely
heavily on shmmax. Removing it and relying on something else would thus
cause a lot of things to break.

Thanks,
Davidlohr

