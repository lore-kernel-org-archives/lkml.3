Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaETJyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:54:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:44109 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaETJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:54:06 -0400
Date: Tue, 20 May 2014 05:54:02 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: OFD locks and deadlock detection
Message-ID: <20140520055402.6c132d60@tlielax.poochiereds.net>
In-Reply-To: <537A4F3D.7000401@gmail.com>
References: <537A0495.60107@gmail.com>
	<20140519102802.16dee141@tlielax.poochiereds.net>
	<537A4F3D.7000401@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 20:36:45 +0200
"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

> On 05/19/2014 04:28 PM, Jeff Layton wrote:
> > On Mon, 19 May 2014 15:18:13 +0200
> > "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
> > 
> >> Hi Jeff,
> >>
> >> I just happened to notice :
> >>
> >>     commit 57b65325fe34ec4c917bc4e555144b4a94d9e1f7
> >>     Author: Jeff Layton <jlayton@redhat.com>
> >>     Date:   Mon Feb 3 12:13:09 2014 -0500
> >>
> >>         locks: skip deadlock detection on FL_FILE_PVT locks
> >>
> >> And then this thread:
> >>
> >>     http://thread.gmane.org/gmane.linux.file-systems/81318/focus=81327
> >>     From: Jeff Layton <jlayton <at> redhat.com>
> >>     Subject: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
> >>     Date: 2014-01-09 14:19:46 GMT
> >>
> >> I think it's pretty important to document that. All implementations
> >> of traditional process-associated (.k.a. "POSIX") locks that I've ever 
> >> come across do detect deadlocks, so it's important to note that OFD locks 
> >> do not.
> >>
> >> I plan to add the following text to the fcntl(2) page:
> >>
> >> [[
> >> In the current implementation,
> >> no deadlock detection is performed for open file description locks.
> >> (This contrasts with process-associated record locks,
> >> for which the kernel does perform deadlock detection.)
> >> ]]
> >>
> >> Okay?
> >>
> >> cheers,
> >>
> >> Michael
> >>
> >>
> > 
> > (note: I'm no longer with Red Hat, so jlayton@redhat.com no longer works)
> 
> Ahh -- okay. Caches cleared.
> 
> > Sounds fine to me.
> 
> Okay.
> 
> > FWIW, the deadlock detection for process-associated record locks is
> > pretty worthless except in certain narrow circumstances.
> 
> Can you say some more about that, please? Maybe there's something 
> worth putting into the man page. (Are there cases where deadlocks
> are not detected?)
> 

Both false negatives and false positives are possible.

Basically what the deadlock detector does is to walk down a chain of
blocked locks and look to see if any of them are waiting on locks that
the process currently owns.

Unfortunately, ownership is defined by the value of current->files. So
if you call clone with CLONE_FILES, you can have two threads of
execution that share lock ownership. If one is holding a lock that the
other wants to wait on, you'll end up getting EDEADLK back even though
it wouldn't necessarily have been a deadlock.

Also, the existing code gives up after searching a chain of 10
dependencies, so it's possible to hit a deadlock anyway if you have a
chain of dependencies that's longer than that.

> > At some point, we probably should have a discussion as to whether
> > deadlock detection is really something we want to keep. The current
> > implementation requires a global spinlock which has obvious
> > consequences for scalability.
> 
> Could be tricky. I wonder if there's code out there that depends
> on deadlock detection.
> 

What I'd probably do first is add Kconfig option so we could compile it
out. Then we can lobby the distros to do so and see who complains.
Deadlock detection is optional in POSIX, so we aren't required to
support it.

-- 
Jeff Layton <jlayton@poochiereds.net>
