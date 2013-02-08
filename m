Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab3BHUl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:41:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760255Ab3BHUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:41:27 -0500
Date: Fri, 8 Feb 2013 15:40:38 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, williams@redhat.com
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208204038.GG31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
 <20130207141502.04625ea0.akpm@linux-foundation.org>
 <20130208003501.GC31684@hansolo.jdub.homelinux.org>
 <20130208181949.GD31684@hansolo.jdub.homelinux.org>
 <20130208201826.GE31684@hansolo.jdub.homelinux.org>
 <87fw16v8zr.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw16v8zr.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:36:08PM -0800, Eric W. Biederman wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> >> OK.  I've bisected this down to:
> >> 
> >> 50804fe3737ca6a5942fdc2057a18a8141d00141 is the first bad commit
> >> commit 50804fe3737ca6a5942fdc2057a18a8141d00141
> >> Author: Eric W. Biederman <ebiederm@xmission.com>
> >> Date:   Tue Mar 2 15:41:50 2010 -0800
> >> 
> >>     pidns: Support unsharing the pid namespace.
> >>     
> >> 
> >> I haven't really gotten much farther than that yet, but the bisect was
> >> pretty straight forward.  Eric, is there anything specific I can gather
> >> or do to help figure out why that is causing mock to get such a weird
> >> error?  I can provide the bisect log if you'd like.
> >
> > I took a look at what mock was doing and it was mostly very simple
> > stuff.  The two exceptions were that it was calling unshare, then doing
> > some file checks and I/O, and then calling fork to exec off some helper
> > things.  Up until the point it fails, the forks work and the children go
> > do whatever it is they were supposed to do.  I've CC'd Clark Williams
> > just in case people have questions on mock itself, but I'm not sure that
> > will be needed.
> 
> Our emails crossed paths.  You have just confirmed my suspicion about
> what was going wrong.
> 
> The practical question is why mock is calling unshare(CLONE_NEWPID)
> because it clearly seems not to understand how to unshare the pid
> namespace and use it that way.

I don't know either, and I've CC'd Clark on this thread now (again for
real this time).

> Except for forgeting to reenable irqs in the failure path of alloc_pid
> the behavior is exactly correct and is how the pid namespace is designed
> to behave in the case of unshare.

Well... ok.  Personally, I'm confused why mock was working before that
commit and now it doesn't.  Were we just buggy in the kernel prior to
that?

> > which is consistent with what mock is seeing.  If I comment out the call
> > to unshare, it seems to always work.  It seems to consistently fail with
> > ENOMEM after the first 3-5 forked children, but it varies within that
> > range.
> 
> If you add a waitpid or space out your forks you will see that it always
> fails after your first child in the pid namespace has exited.
> 
> We don't allow children in a pid namespace after fork has exited.

Hm.  Mock seems to make it a ways along as well though, and it isn't
doing rapid fire fork/exec.  I believe it's forking helpers and waiting
for them to return before continuing on.

josh
