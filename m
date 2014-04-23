Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbaDWTZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:25:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbaDWTZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:25:27 -0400
Date: Wed, 23 Apr 2014 15:23:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: ams@gnu.org
Cc: libc-alpha@sourceware.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, dalias@libc.org,
        mtk.manpages@gmail.com, samba-technical@lists.samba.org,
        nfs-ganesha-devel@lists.sourceforge.net, carlos@redhat.com,
        metze@samba.org, hch@infradead.org, bharrosh@panasas.com
Subject: Re: [RFC][glibc PATCH] fcntl-linux.h: add new definitions and
 manual updates for open file description locks
Message-ID: <20140423152318.117f291b@tlielax.poochiereds.net>
In-Reply-To: <E1Wd2Os-00061e-GU@fencepost.gnu.org>
References: <1398253172-9221-1-git-send-email-jlayton@redhat.com>
	<E1Wcyo3-0000Eg-UC@fencepost.gnu.org>
	<20140423112843.77889d16@tlielax.poochiereds.net>
	<E1Wd2Os-00061e-GU@fencepost.gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 15:00:06 -0400
ams@gnu.org (Alfred M. Szmidt) wrote:

>    > Likewise.  You infact write that it does get the lock information
>    > later in the document wrt. F_OFD_GETLK.
> 
>    Sorry, I disagree here...GETLK is really a misnomer, IMO. TESTLK
>    would have been a better name.
> 
>    GETLK are used is to "get the first lock".
> 
>    It's a way to test whether a particular lock can be applied, and to
>    return information about a conflicting lock if it can't. If, for
>    instance there is no conflicting lock, then you don't "get" any
>    lock information back (l_type just gets reset to F_UNLCK).
> 
> While I kinda see your point, it isn't what GETLK does; it really does
> get you information about the first lock -- you're not testing
> anything.  It is also the terminology used in the POSIX standard.


You *are* testing a lock.

For instance, a process has locked bytes 0-5 for read in the file. I
then submit a F_GETLK request from another process and set:

    l_type = F_WRLCK
    l_start = 7
    l_len = 1

...this range does not overlap with the original range, and so no lock
will be returned even though one is being held on the file. In order to
determine whether it should return information about a lock it has to
first _test_ whether it conflicts with the information in the struct
flock that was passed down.

Similarly, if the struct flock I submit to the F_GETLK request has this:

   l_type = F_RDLCK
   l_start = 0
   l_len = 1

...then I also will not get any information about a lock back. The
information in the lock request does not conflict with the one being
held on the file (because they are both read locks).

If F_GETLK were just "getting" a lock, then there would be no test
involved, but that's not how this works. F_GETLK has to test and see
whether there is a conflicting lock before it can return anything.

If all you're objecting to is the change in verbiage on those two
pieces, then I'll back that part out in the interest of wrapping this
up.

I still think I'm correct though ;)

-- 
Jeff Layton <jlayton@redhat.com>
