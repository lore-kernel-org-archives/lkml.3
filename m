Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbaFTTq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:46:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaFTTq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:46:57 -0400
Date: Fri, 20 Jun 2014 15:46:39 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: kernel BUG at /src/linux-dev/mm/mempolicy.c:1738! on v3.16-rc1
Message-ID: <20140620194639.GA30729@nhori.bos.redhat.com>
References: <20140619215641.GA9792@nhori.bos.redhat.com>
 <alpine.DEB.2.11.1406200923220.10271@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406200923220.10271@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:24:36AM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Naoya Horiguchi wrote:
>
> > I'm suspecting that mbind_range() do something wrong around vma handling,
> > but I don't have enough luck yet. Anyone has an idea?
>
> Well memory policy data corrupted. This looks like you were trying to do
> page migration via mbind()?

Right.

> Could we get some more details as to what is
> going on here? Specifically the parameters passed to mbind would be
> interesting.

My view about the kernel behavior was in another email a few hours ago.
And as for what userspace did, I attach the reproducer below. It's simply
doing mbind(mode=MPOL_BIND, flags=MPOL_MF_MOVE_ALL) on random address/length/node.

What I did to trigger the bug is like below:

  while true ; do
      dd if=/dev/urandom of=testfile bs=4096 count=1000
      for i in $(seq 10) ; do
          ./mbind_bug_reproducer testfile > /dev/null &
      done
      sleep 3
      pkill -SIGUSR1 -f mbind_bug_reproducer
  done

mbind_bug_reproducer.c
---
#include <stdio.h>
#include <signal.h>
#include <sys/mman.h>
#include <numa.h>
#include <numaif.h>
#include <fcntl.h>

#define ADDR_INPUT 0x700000000000
#define PS 4096
#define err(x) perror(x),exit(EXIT_FAILURE)
#define errmsg(x, ...) fprintf(stderr, x, ##__VA_ARGS__),exit(EXIT_FAILURE)

int flag = 1;

void sig_handle_flag(int signo) { flag = 0; }

void set_new_nodes(struct bitmask *mask, unsigned long node) {
	numa_bitmask_clearall(mask);
	numa_bitmask_setbit(mask, node);
}

int main(int argc, char *argv[]) {
	int nr = 1000;
	int fd = -1;
	char *pfile;
	struct timeval tv;
	struct bitmask *nodes;
	unsigned long nr_nodes;
	unsigned long memsize = nr * PS;

	nr_nodes = numa_max_node() + 1; /* numa_num_possible_nodes(); */
	nodes = numa_bitmask_alloc(nr_nodes);
	if (nr_nodes < 2)
		errmsg("A minimum of 2 nodes is required for this test.\n");

	gettimeofday(&tv, NULL);
	srandom(tv.tv_usec);

	fd = open(argv[1], O_RDWR, S_IRWXU);
	if (fd < 0)
		err("open");
	pfile = mmap((void *)ADDR_INPUT, memsize, PROT_READ|PROT_WRITE,
		      MAP_SHARED, fd, 0);
	if (pfile == (void*)-1L)
		err("mmap");

	signal(SIGUSR1, sig_handle_flag);

	while (flag) {
		int node;
		unsigned long offset;
		unsigned long length;

		memset(pfile, 'a', memsize);

		node = random() % nr_nodes;
		set_new_nodes(nodes, random() & nr_nodes);
		offset = (random() % nr) * PS;
		length = (random() % (nr - offset/PS)) * PS;
		printf("[%d] node:%x, offset:%x, length:%x\n",
		       getpid(), node, offset, length);
		mbind(pfile + offset, length, MPOL_BIND, nodes->maskp,
		      nodes->size + 1, MPOL_MF_MOVE_ALL);
	}

	munmap(pfile, memsize);
	return 0;
}
