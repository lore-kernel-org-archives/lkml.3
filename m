Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3HSXbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:31:41 -0400
Received: from peace.netnation.com ([204.174.223.2]:41014 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3HSXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:31:40 -0400
Date: Mon, 19 Aug 2013 16:31:38 -0700
From: Simon Kirby <sim@hostway.ca>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20130819233138.GE23608@hostway.ca>
References: <20130706000949.GD16853@hostway.ca>
 <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
 <20130819212441.17880.16729@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819212441.17880.16729@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 05:24:41PM -0400, Chris Mason wrote:

> Quoting Linus Torvalds (2013-08-19 17:16:36)
> > On Mon, Aug 19, 2013 at 1:29 PM, Christoph Lameter <cl@gentwo.org> wrote:
> > > On Mon, 19 Aug 2013, Simon Kirby wrote:
> > >
> > >>    [... ]  The
> > >> alloc/free traces are always the same -- always alloc_pipe_info and
> > >> free_pipe_info. This is seen on 3.10 and (now) 3.11-rc4:
> > >>
> > >> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
> > >
> > > This looks like an increment after free in the second 32 bit value of the
> > > structure. First 32 bit value's poison is unchanged.
> > 
> > Ugh. If that is "struct pipe_inode_info" and I read it right, that's
> > the "wait_lock" spinlock that is part of the mutex.
> > 
> > Doing a "spin_lock()" could indeed cause an increment operation. But
> > it still sounds like a very odd case. And even for some wild pointer
> > I'd then expect the spin_unlock to also happen, and to then increment
> > the next byte (or word) too. More importantly, for a mutex, I'd expect
> > the *other* fields to be corrupted too (the "waiter" field etc). That
> > is, unless we're still spinning waiting for the mutex, but with that
> > value we shouldn't, as far as I can see.
> > 
> 
> Simon, is this box doing btrfs send/receive?  If so, it's probably where
> this pipe is coming from.

No, not for some time (a few kernel versions ago).

> Linus' CONFIG_DEBUG_PAGE_ALLOC suggestions are going to be the fastest
> way to find it, I can give you a patch if it'll help.

I presume it's just:

diff --git a/fs/pipe.c b/fs/pipe.c
index d2c45e1..30d5b8d 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -780,7 +780,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
 {
 	struct pipe_inode_info *pipe;
 
-	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
+	pipe = (void *)get_zeroed_page(GFP_KERNEL);
 	if (pipe) {
 		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL);
 		if (pipe->bufs) {
@@ -790,7 +790,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
 			mutex_init(&pipe->mutex);
 			return pipe;
 		}
-		kfree(pipe);
+		free_page((unsigned long)pipe);
 	}
 
 	return NULL;
@@ -808,7 +808,7 @@ void free_pipe_info(struct pipe_inode_info *pipe)
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
 	kfree(pipe->bufs);
-	kfree(pipe);
+	free_page((unsigned long)pipe);
 }
 
 static struct vfsmount *pipe_mnt __read_mostly;

...and CONFIG_DEBUG_PAGEALLOC enabled.

> It would be nice if you could trigger this on plain 3.11-rcX instead of
> btrfs-next.

On 3.10 it was with some btrfs-next pulled in, but the 3.11-rc4 traces
were from 3.11-rc4 with just some of our local patches:

> git diff --stat v3.11-rc4..master
 firmware/Makefile                         |    4 +-
 firmware/bnx2/bnx2-mips-06-6.2.3.fw.ihex  | 5804 ++++++++++++++++++++++
 firmware/bnx2/bnx2-mips-09-6.2.1b.fw.ihex | 6496 +++++++++++++++++++++++++
 kernel/acct.c                             |   21 +-
 net/sunrpc/auth.c                         |    2 +-
 net/sunrpc/clnt.c                         |   10 +
 net/sunrpc/xprt.c                         |    8 +-
 7 files changed, 12335 insertions(+), 10 deletions(-)

None of them look relevant, but I'm building vanilla -rc4 with
CONFIG_DEBUG_PAGEALLOC and the patch above.

Simon-
