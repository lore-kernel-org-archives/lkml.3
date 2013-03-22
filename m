Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3CVBkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:40:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39621 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3CVBkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:40:39 -0400
Date: Fri, 22 Mar 2013 01:40:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS deadlock ?
Message-ID: <20130322014037.GK21522@ZenIV.linux.org.uk>
References: <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
 <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
 <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 06:33:35PM -0700, Linus Torvalds wrote:
> On Thu, Mar 21, 2013 at 6:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > In theory, we can make vfs_rmdir() and vfs_unlink() check the presense of
> > the corresponding method before locking the victim; that would suffice to
> > kludge around that mess on procfs.  Along with ->d_inode comparison in
> > lock_rename() it *might* suffice.
> 
> Hmm, yes. Maybe we can do that as a stopgap, backport that, and leave
> any bigger changes for the development tree. That would make the issue
> less urgent, never mind all the other worries about backporting
> complicated patches for subtle issues.
> 
> I realize you aren't entirely thrilled about it, but we actually
> already seem to do that check in both vfs_rmdir().and vfs_unlink()
> before getting the child i_mutex.  I wonder if that is because we've
> already seen lockdep splats for this case...

Yeah, I went to do such patch after sending the previous mail and noticed
that we already did it that way.  Simplicity of error recovery was probably
more important consideration there - I honestly don't remember the reasoning
in such details; it had been a decade or so...  So lock_rename() doing
->d_inode comparison (with dire comment re not expecting that to be sufficient
for anything other than this bug in procfs) will probably suffice for fs/namei.c
part of it; I'm still looking at dcache.c side of things...
