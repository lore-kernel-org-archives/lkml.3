Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3LMOwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:52:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3LMOwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:52:19 -0500
Message-ID: <1386946334.2919.5.camel@localhost>
Subject: Re: [GIT] SELinux fixes
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Fri, 13 Dec 2013 09:52:14 -0500
In-Reply-To: <CAHC9VhRHeukZ0e_RYDFuh_eQThZnNtNnsUgtB5S+VjHjAXcCKQ@mail.gmail.com>
References: <alpine.LRH.2.02.1312131351140.31472@tundra.namei.org>
	 <CA+5PVA4fcf526u=AF4TwQP3xdajV-qE5Jn6NKG2mme=YK8nvhw@mail.gmail.com>
	 <CAHC9VhRHeukZ0e_RYDFuh_eQThZnNtNnsUgtB5S+VjHjAXcCKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 09:36 -0500, Paul Moore wrote:
> On Fri, Dec 13, 2013 at 9:02 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > Should probably figure out which path to take on this one soon:
> >
> > http://thread.gmane.org/gmane.linux.kernel/1611662
> >
> > A revert might be the easiest for now.
> 
> Yeah, I followed the discussion you and Eric were having earlier this
> week; I was hoping that you guys would be able to arrive at a fix as I
> would much prefer to fix the issue and not have to revert.
> 
> If I don't see something from Eric within the next couple of hours
> I'll go ahead and do the revert.

Paul, please revert 102aefdda4d8275ce7d7100bc16c88c74272b260

SELinux policy can specify if it should use a filesystem's xattrs or
not.  In current policy we have a specification that fuse should not use
xattrs but fuse.glusterfs should use xattrs.  This patch has a bug in
which non-glusterfs filesystems would match the rule saying
fuse.glusterfs should use xattrs.  If both fuse and the particular
filesystem in question are not written to handle xattr calls during the
mount command, they will deadlock.

I have fixed the bug to do proper matching, however I believe a revert
is still the correct solution.  The reason I believe that is because the
code still does not work.  The s_subtype is not set until after the
SELinux hook which attempts to match on the ".gluster" portion of the
rule.  So we cannot match on the rule in question.  The code is useless.

In the next cycle the code should be re-re-verted and fixed, but we also
need to address the fact that it just plain doesn't work.

-Eric

