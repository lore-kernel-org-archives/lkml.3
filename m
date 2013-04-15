Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039Ab3DOTNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934987Ab3DOTNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:13:51 -0400
Date: Mon, 15 Apr 2013 15:13:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on CPU
 due to 09a9f1d27
Message-ID: <20130415191304.GC30583@redhat.com>
References: <20130412181348.GA2253@redhat.com>
 <CANN689GKfxM3R96wgY8-+FftpVT76zMFcHdgKccNKnjHGfYq1Q@mail.gmail.com>
 <20130415163552.GA31868@redhat.com>
 <20130415173424.GB31868@redhat.com>
 <20130415175929.GB30583@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415175929.GB30583@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 01:59:29PM -0400, Vivek Goyal wrote:
> CCing akpm.
> 
> Vivek
> 
> On Mon, Apr 15, 2013 at 01:34:24PM -0400, Vivek Goyal wrote:
> > On Mon, Apr 15, 2013 at 12:35:52PM -0400, Vivek Goyal wrote:
> > 
> > [..]
> > > > My first guess would be that mmap_sem is held during exec, so you
> > > > can't have __mm_populate() try holding it recursively.
> > > 
> > > I think it is not mmap_sem as even with VM_LOCKED, we take mmap_sem
> > > and things are fine. 
> > > 
> > > So things work till 3.8 and break in 3.8-rc1 (with both VM_LOCKED and
> > > VM_POPULATE specifed). I will do git bisect and try to figure out which
> > > is first commit which has the issue.
> > 
> > Ok, following seems to be first bad commit.
> > 
> > commit bebeb3d68b24bb4132d452c5707fe321208bcbcd
> > Author: Michel Lespinasse <walken@google.com>
> > Date:   Fri Feb 22 16:32:37 2013 -0800
> > 
> >     mm: introduce mm_populate() for populating new vmas
> > 

Michel,

An interesting observation. After this commit looks like simple
mmap(MAP_LOCKED) of a file was broken and it would hang and give RCU stall
warning similar to my patch of locking /sbin/kexec.

But in latest kernel mmap(MAP_LOCKED) does not hang. So looks like
this problem got fixed in a patch after this first bad commit. But
locking /sbin/kexec issue still remains.

I used following test program to map a arbitray file.

Thanks
Vivek


#define _GNU_SOURCE
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <keyutils.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <attr/xattr.h>
#include <unistd.h>
#include <sys/syscall.h>

main(int argc, char *argv[])
{
	char *filename = argv[1];
	int fd, ret;
	void *file_addr, *data_addr;
	struct stat stats;
	ssize_t sig_sz;
	void *sig;

	if (argc != 2) {
		fprintf(stderr, "Enter file name\n");	
		exit(1);
	}

	fd = open(filename, O_RDONLY);
	if (fd == -1) {
		fprintf(stderr, "Open of file %s failed:%s\n", filename,
					strerror(errno));
		exit(1);
	}

	ret = fstat(fd, &stats);
	if (ret == -1) {
		fprintf(stderr, "fstat of file %s failed:%s\n", filename,
				strerror(errno));
		exit(1);
	}

	file_addr = mmap(NULL, stats.st_size, PROT_READ, MAP_PRIVATE | MAP_LOCKED, fd, 0);

	if (file_addr == MAP_FAILED) {
		fprintf(stderr, "mmap() failed:%s\n", strerror(errno));
		exit(1);
	}
}
