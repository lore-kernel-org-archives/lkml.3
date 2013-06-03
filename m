Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3FCXSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:18:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758747Ab3FCXSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:18:32 -0400
Message-ID: <1370301501.19018.9.camel@localhost>
Subject: Re: [RFC PATCH 2/2] SELinux: cache inode checks inside struct inode
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Date: Mon, 03 Jun 2013 19:18:21 -0400
In-Reply-To: <alpine.LFD.2.03.1306040628420.25797@pixel.linux-foundation.org>
References: <1370285941-18367-1-git-send-email-eparis@redhat.com>
	 <1370285941-18367-2-git-send-email-eparis@redhat.com>
	 <alpine.LFD.2.03.1306040628420.25797@pixel.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 06:31 +0900, Linus Torvalds wrote:
> 
> 
> On Mon, 3 Jun 2013, Eric Paris wrote:
> >  
> >  #ifdef CONFIG_SECURITY
> > +     seqcount_t              i_security_seqcount;
> > +     u32                     i_last_task_sid;
> > +     u32                     i_last_granting;
> > +     u32                     i_last_perms;
> > +     u32                     i_audit_allow;
> >       void                    *i_security;
> >  #endif
> 
> This is much too big. I was really hoping for "another word that the 
> security layer can use" or similar.

Not sure how that can work   :-(

> Something this big would be acceptable if it would be a *generic* security 
> cache, and others could use it too, and would avoid ever actually calling 
> into any security layer at all (ie we could do the checks entirely at the 
> VFS layer). Then it would be fine. But for just the fact that SELinux is 
> too slow? No.

There is nothing about it that can't be VFS-erized.  The fields are:

readlockless way to get the data
which task was allowed
which perms were allowed
what generation of security policy allowed it
what perms should be forced to call security hook anyway

defining "perms" from a VFS PoV is hard.

doing any of this with 'stacking' is hard.  Then again, I'm only so so
on the value of stacking.  I've waffled a few times...

I can do it entirely inside selinux, but we are still going to have the
cache hit you were originally seeing as we dereference isec to get the
info....


