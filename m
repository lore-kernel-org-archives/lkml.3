Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3JKXVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab3JKXVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:21:30 -0400
Date: Fri, 11 Oct 2013 19:21:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        samba-technical@lists.samba.org
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131011192118.483e436f@tlielax.poochiereds.net>
In-Reply-To: <EE732BCB-C38E-4874-AEDF-2EB9E1389A86@dilger.ca>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
	<20131011200756.GB22160@fieldses.org>
	<EE732BCB-C38E-4874-AEDF-2EB9E1389A86@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 15:36:43 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> On Fri, Oct 11, 2013 at 08:25:17AM -0400, Jeff Layton wrote:
> > At LSF this year, there was a discussion about the "wishlist" for
> > userland file servers. One of the things brought up was the goofy and
> > problematic behavior of POSIX locks when a file is closed. Boaz started
> > a thread on it here:
> > 
> >    http://permalink.gmane.org/gmane.linux.file-systems/73364
> > 
> > Userland fileservers often need to maintain more than one open file
> > descriptor on a file. The POSIX spec says:
> > 
> > "All locks associated with a file for a given process shall be removed
> > when a file descriptor for that file is closed by that process or the
> > process holding that file descriptor terminates."
> > 
> > This is problematic since you can't close any file descriptor without
> > dropping all your POSIX locks. Most userland file servers therefore
> > end up opening the file with more access than is really necessary, and
> > keeping fd's open for longer than is necessary to work around this.
> > 
> > This patchset is a first stab at an approach to address this problem by
> > adding two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is short
> > for "private" -- I'm open to changing that if you have a better
> > mnemonic).
> > 
> > For all intents and purposes these lock types act just like their
> > "non-P" counterpart. The difference is that they are only implicitly
> > released when the fd against which they were acquired is closed. As a
> > side effect, these locks cannot be merged with "non-P" locks since they
> > have different semantics on close.
> 
> It isn't explicitly stated here, but will the POSIX and non-POSIX
> locks interact with each other?  For example, if one process is using
> the old POSIX semantics for lock release, but another process is using
> the new non-POSIX semantics for lock release, will the two locks
> otherwise behave as expected and conflict with each other if needed?
> 
> Cheers, Andreas
> 

Yes, they'll still conflict with "legacy" POSIX locks. The idea is to
keep mutual exclusion with "legacy" POSIX locks, but give them more
flock()-like semantics with respect to dealing with multiple open file
descriptors. By doing this, we allow these programs to keep working in
parallel with those that don't use the new lock types.

> > I've given this patchset some very basic smoke testing and it seems to
> > do the right thing, but it is still pretty rough.  If this looks
> > reasonable I'll plan to do some documentation updates and will take a
> > stab at trying to get these new lock types added to the POSIX spec (as
> > HCH recommended).
> > 
> > At this point, my main questions are:
> > 
> > 1) does this look useful, particularly for fileserver implementors?
> > 
> > 2) does this look OK API-wise? We could consider different "cmd" values
> >   or even different syscalls, but I figured this makes it clearer that
> >   "P" and "non-P" locks will still conflict with one another.
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


-- 
Jeff Layton <jlayton@redhat.com>
