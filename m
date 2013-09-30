Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3I3UT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:19:28 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52683 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab3I3UT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:19:27 -0400
Date: Mon, 30 Sep 2013 14:19:25 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Sparse files, sendfile and tmpfs ENOSPC
Message-ID: <20130930201925.GA2007@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks, I hope this is a good CC list for this misbehavior..

I've noticed that tmpfs is eager to expand holes in sparse files and
ends up accounting for that memory as counting against the filesystem
limit.

Specifically, it does this if you try to sendfile() from a holey file,
or mmap(PROT_READ) (and then touch pages). In both cases allocation
errors can happen.

I've attached a short test program to show what I mean..

$ mount -t tmpfs -o size=1048576 tmpfs jnk/
$ df -h jnk/
tmpfs           1.0M     0  1.0M   0% /mnt/jnk
$ strace a.out jnk/test
open("jnk/test", O_RDWR|O_CREAT|O_TRUNC, 0666) = 3
lseek(3, 524288000, SEEK_SET)           = 524288000
write(3, "\3\0\0\0", 4)                 = 4
open("/dev/null", O_WRONLY)             = 4
sendfile(4, 3, [0], 524288000)          = 1044480
sendfile(4, 3, [1044480], 523243520)    = -1 ENOSPC (No space left on device)
$ df -h jnk/
tmpfs           1.0M  1.0M     0 100% /mnt/jnk

The scenario I have that is making this behavior problematic is core
files on embedded. Our system is setup to write core files to a tmpfs,
and the core files are very sparse. When the system tries to send the
core over the network (eg with sendfile or mmap+write) it quickly runs
the tmpfs out of space, fails and blows up. read() works fine without
expanding the hole..

We've been doing this for a long time on PPC, but new systems use ARM
and the ARM core files have significantly more sparse area, exposing
this problem..

I find this surprising since I would have thought the hole would have
just map'd the zero page multiple times? Is this an accounting
error someplace? I've seen Hugh's comments in past threads that this
area is very complex..

Regards,
Jason

#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/sendfile.h>
#include <assert.h>

int main (int argc,const char *argv[])
{
	int fd;
	int fd2;
	off_t off = 0;
	size_t count = 500*1024*1024;
	ssize_t rc;
	off_t orc;

	fd = open(argv[1],O_CREAT | O_TRUNC | O_RDWR,0666);
	assert(fd != -1);

	orc = lseek(fd,count,SEEK_SET);
	assert(orc == count);
	rc = write(fd,&fd,sizeof(fd));
	assert(rc == sizeof(fd));

	fd2 = open("/dev/null",O_WRONLY);
	assert(fd2 != -1);

	while (count != 0) {
		rc = sendfile(fd2,fd,&off,count);
		assert(rc > 0);
		count -= rc;
	}
	return 0;
}
