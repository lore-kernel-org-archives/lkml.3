Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3FNIFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:05:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60103 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FNIFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:05:30 -0400
Date: Fri, 14 Jun 2013 09:05:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC] should read(2) update the position if it returns an error?
Message-ID: <20130614080528.GM4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	We have an unpleasant HPFS (at least) race with read(2) vs. unlink(2)
The thing is, HPFS and several other filesystems keep track of all opened
struct file for directory and update the position in it upon directory
modifications.  For HPFS it's particulary painful, since it encodes the
location of directory block (times 64 + number of entry in block) as ->f_pos.
lseek() validates the offset under i_mutex, directory modifications update
->f_pos of all files (again, under i_mutex) and readdir does all accesses
under i_mutex.  The trouble with that scheme is sys_read().  There we
save the current position, pass the address of local copy to vfs_read()
and, once vfs_read() has returned an error, store the value in that local
copy back into ->f_pos.  The value is unmodified, of course, and everything
would be fine if not for the following problem: directory modification
done in parallel with that has no idea of that local copy and does *not*
update it.  It does update ->f_pos, but that update gets reverted as soon
as vfs_read() returns and sys_read() does file_pos_write().

	It's not just HPFS - HFS, HFS+ and sysfs have a similar (but probably
milder) issue.  For HPFS it's really nasty - we might end up with subsequent
readdir() reading from a completely unrelated directory ;-/

	We obviously don't want to grab i_mutex in sys_read(), but I really
wonder if we should do file_pos_write() there in case of vfs_read() returning
an error.  Most of the ->read() instances leave *pos unchanged if they
decide to return an error - after all, if we'd consumed some data, the right
thing is short read, with whatever errors happening on subsequent reads.
I'm not sure if it's mandated by POSIX, but it seems to be what the userland
would reasonably expect.  And that matches the usual logics with e.g.
interruptible waits catching signals in ->read() instances...

	Comments?  I'd obviously prefer to solve it that way (i.e. leave
->f_pos untouched if vfs_read() returns an error), but I might be missing
some case where we want position updated even though read() returns an
error.  I can't come up with one, but then I hadn't RTFS through every
->read() instance in drivers in search of weird cases like that - we've
too many instances ;-/
