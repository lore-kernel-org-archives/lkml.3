Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3JKPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:31:31 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:44655 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab3JKPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:31:29 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 11:31:29 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=fZWnKKVzkIC2hyXv6es1YtgRS7nipJp2wcNCObr7o2LBgHArI9ywvIB1wuLyIJO0;
  h=Received:From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:Thread-Index:Content-Language:X-ELNK-Trace:X-Originating-IP;
From: "Frank Filz" <ffilzlnx@mindspring.com>
To: "'Jeff Layton'" <jlayton@redhat.com>, <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com> <20131011093510.7ed9871a@tlielax.poochiereds.net>
In-Reply-To: <20131011093510.7ed9871a@tlielax.poochiereds.net>
Subject: RE: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX) locks
Date: Fri, 11 Oct 2013 08:20:59 -0700
Message-ID: <01f801cec695$7e5d17e0$7b1747a0$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIaxc2XaXMwhFVmMgrl8lqeyFTt4AN2GInOmTvsxIA=
Content-Language: en-us
X-ELNK-Trace: 136157f01908a8929c7f779228e2f6aeda0071232e20db4d8a8611511604b525f85982445e690e2c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > At LSF this year, there was a discussion about the "wishlist" for
> > userland file servers. One of the things brought up was the goofy and
> > problematic behavior of POSIX locks when a file is closed. Boaz
> > started a thread on it here:
> >
> >     http://permalink.gmane.org/gmane.linux.file-systems/73364
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
> > This patchset is a first stab at an approach to address this problem
> > by adding two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is
> > short for "private" -- I'm open to changing that if you have a better
> > mnemonic).
> >
> > For all intents and purposes these lock types act just like their
> > "non-P" counterpart. The difference is that they are only implicitly
> > released when the fd against which they were acquired is closed. As a
> > side effect, these locks cannot be merged with "non-P" locks since
> > they have different semantics on close.
> >
> > I've given this patchset some very basic smoke testing and it seems to
> > do the right thing, but it is still pretty rough. If this looks
> > reasonable I'll plan to do some documentation updates and will take a
> > stab at trying to get these new lock types added to the POSIX spec (as
> > HCH recommended).
> >
> > At this point, my main questions are:
> >
> > 1) does this look useful, particularly for fileserver implementors?
> >
> > 2) does this look OK API-wise? We could consider different "cmd" values
> >    or even different syscalls, but I figured this makes it clearer that
> >    "P" and "non-P" locks will still conflict with one another.

This is a good start.

I'd prefer a model where the private locks are maintained even if all file
descriptors are closed and released on garbage collection when the process
terminates. The model presented would require a server to potentially have
at least two file descriptors open (the descriptor originally used for the
locks, and a descriptor used for current access mode needed for some I/O
operation). The server will also need to "remember" to do all locks using
the first file descriptor.

Another thing that would be very useful for servers is to be able to specify
an arbitrary lock owner. Currently, Ganesha has to manage a union of all
locks held on a file and carefully pick it apart when a client does an
unlock. Allowing a process specified owner would allow Ganesha (or other
servers) to have separate locks for each client lock owner.

Frank

