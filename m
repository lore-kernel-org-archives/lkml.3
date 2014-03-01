Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaCABjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 20:39:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaCABjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 20:39:05 -0500
Date: Fri, 28 Feb 2014 17:41:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ning Qu <quning@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>
Subject: Re: [PATCH 0/1] mm, shmem: map few pages around fault address if
 they are in page cache
Message-Id: <20140228174150.8ff4edca.akpm@linux-foundation.org>
In-Reply-To: <CACQD4-5U3P+QiuNKzt5+VdDDi0ocphR+Jh81eHqG6_+KeaHyRw@mail.gmail.com>
References: <1393625931-2858-1-git-send-email-quning@google.com>
	<CACQD4-5U3P+QiuNKzt5+VdDDi0ocphR+Jh81eHqG6_+KeaHyRw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 16:35:16 -0800 Ning Qu <quning@gmail.com> wrote:

> Sorry about my fault about the experiments, here is the real one.
> 
> Btw, apparently, there are still some questions about the results and
> I will sync with Kirill about his test command line.
> 
> Below is just some simple experiment numbers from this patch, let me know if
> you would like more:
> 
> Tested on Xeon machine with 64GiB of RAM, using the current default fault
> order 4.
> 
> Sequential access 8GiB file
>                         Baseline        with-patch
> 1 thread
>     minor fault         8,389,052    4,456,530
>     time, seconds    9.55            8.31

The numbers still seem wrong.  I'd expect to see almost exactly 2M minor
faults with this test.

Looky:

#include <sys/mman.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define G (1024 * 1024 * 1024)

int main(int argc, char *argv[])
{
	char *p;
	int fd;
	unsigned long idx;
	int sum = 0;

	fd = open("foo", O_RDONLY);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	p = mmap(NULL, 1 * G, PROT_READ, MAP_PRIVATE, fd, 0);
	if (p == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	for (idx = 0; idx < 1 * G; idx += 4096)
		sum += p[idx];
	printf("%d\n", sum);
	exit(0);
}

z:/home/akpm> /usr/bin/time ./a.out
0
0.05user 0.33system 0:00.38elapsed 99%CPU (0avgtext+0avgdata 4195856maxresident)k
0inputs+0outputs (0major+262264minor)pagefaults 0swaps

z:/home/akpm> dc
16o
262264 4 * p
1001E0

That's close!
