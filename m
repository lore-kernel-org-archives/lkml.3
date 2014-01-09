Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaAIXxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:53:46 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54788 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaAIXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <1389310626.15209.92.camel@localhost>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<1389310626.15209.92.camel@localhost>
Date: Fri, 10 Jan 2014 07:53:41 +0800
X-Google-Sender-Auth: FY5HZCkT3qD0dEur4cKlPAmdzyI
Message-ID: <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in inode_permission()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 7:37 AM, Eric Paris <eparis@redhat.com> wrote:
>
> but at least from an SELinux PoV, I think it's quick and easy, but wrong
> for maintainability...

Yeah, it's a hack, and it's wrong, and we should figure out how to do
it right. Likely we should just tie the lifetime of the i_security
member directly to the lifetime of the inode itself, and just make the
rule be that security_inode_free() gets called from whatever frees the
inode itself, and *not* have an extra rcu callback etc. But that
sounds like a bigger change than I'm comfy with right now, so the
hacky one might be the band-aid to do for stable..

The problem, of course, is that all the different filesystems have
their own inode allocations/freeing. Of course, they all tend to share
the same pattern ("call_rcu xyz_i_callback"), so maybe we could try to
make that a more generic thing? Like have a "free_inode" vfs callback,
and do the call_rcu delaying at the VFS level..

And maybe, just maybe, we could just say that that is what
"destroy_inode()" is, and that we will just call it from rcu context.
All the IO has hopefully been done earlier  Yes/no?

                 Linus
