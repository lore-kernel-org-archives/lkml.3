Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaIBTnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:43:06 -0400
Received: from fieldses.org ([174.143.236.118]:54602 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbaIBTnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:43:03 -0400
Date: Tue, 2 Sep 2014 15:43:00 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Jeff Layton <jlayton@poochiereds.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Message-ID: <20140902194300.GE31793@fieldses.org>
References: <5405FBAE.5020303@parallels.com>
 <20140902184456.GC31793@fieldses.org>
 <54061562.4080306@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54061562.4080306@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:07:14PM +0400, Pavel Emelyanov wrote:
> On 09/02/2014 10:44 PM, J. Bruce Fields wrote:
> > On Tue, Sep 02, 2014 at 09:17:34PM +0400, Pavel Emelyanov wrote:
> >> Hi,
> >>
> >> There's a problem with getting information about who has a flock on
> >> a specific file. The thing is that the "owner" field, that is shown in
> >> /proc/locks is the pid of the task who created the flock, not the one
> >> who _may_ hold it.
> >>
> >> If the flock creator shared the file with some other task (by forking
> >> or via scm_rights) and then died or closed the file, the information
> >> shown in proc no longer corresponds to the reality.
> >>
> >> This is critical for CRIU project, that tries to dump (and restore)
> >> the state of running tasks. For example, let's take two tasks A and B
> >> both opened a file "/foo", one of tasks places a LOCK_SH lock on the 
> >> file and then "obfuscated" the owner field in /proc/locks. After this
> >> we have no ways to find out who is the lock holder.
> >>
> >> I'd like to note, that for LOCK_EX this problem is not critical -- we
> >> may go to both tasks and "ask" them to LOCK_EX the file again (we can
> >> do it in CRIU, I can tell more if required). The one who succeeds is 
> >> the lock holder.
> > 
> > It could be both, actually, right?
> 
> Two succeeding with LOCK_EX? AFAIU no. Am I missing something?

After a fork, two processes "own" the lock, right?:

	int main(int argc, char *argv[])
	{
		int fd, ret;
	
		fd = open(argv[1], O_RDWR);
		ret = flock(fd, LOCK_EX);
		if (ret)
			err(1, "flock");
		ret = fork();
		if (ret == -1)
			err(1, "flock");
		ret = flock(fd, LOCK_EX);
		if (ret)
			err(1, "flock");
		printf("%d got exclusive lock\n", getpid());
		sleep(1000);
	}

	$ touch TMP
	$ ./test TMP
	15882 got exclusive lock
	15883 got exclusive lock
	^C

I may misunderstand what you're doing.

> >> With LOCK_SH this doesn't work. Trying to drop the
> >> lock doesn't work either, as flock(LOCK_UN) reports 0 in both cases:
> >> if the file is locked and if it is not.
> >>
> >> That said, I'd like to propose the LOCK_TEST flag to the flock call,
> >> that would check whether the lock of the given type (LOCK_SH or LOCK_EX)
> >> exists on the file we test. It's not the same as the existing in-kernel
> >> FL_ACCESS flag, which checks whether the new lock is possible, but
> >> it's a new FL_TEST flag, that checks whether the existing lock is there.
> >>
> >> What do you think?
> > 
> > I guess I can't see anything really wrong with it.
> > 
> > It ignores the (poorly documented) LOCK_MAND case, but maybe that's OK.
> 
> I actually checked it and it seemed to work. What problems do
> you see with this case?

On its own it just doesn't tell you whether or not LOCK_MAND is set.
But I guess you can still get that out of /proc/locks.

To be honest I don't really know whether LOCK_MAND works or is used.

--b.
