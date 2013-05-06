Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3EFUCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab3EFUCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:02:03 -0400
Date: Mon, 6 May 2013 22:01:33 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
Cc: Isaku Yamahata <yamahata@valinux.co.jp>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 4/4] mm: sys_remap_anon_pages
Message-ID: <20130506200133.GA12538@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
 <1367870221-12676-5-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367870221-12676-5-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 09:57:01PM +0200, Andrea Arcangeli wrote:
> ===
> 
> static unsigned char *c, *tmp;
> 
> void userfault_sighandler(int signum, siginfo_t *info, void *ctx)

oops, the hash of the test program got cut... so I append it below
which is nicer without leading whitespaces.

===
#define _GNU_SOURCE
#include <sys/mman.h>
#include <pthread.h>
#include <strings.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <sys/syscall.h>
#include <sys/types.h>

#define USE_USERFAULT
#define THP

#define MADV_USERFAULT	18

#define SIZE (1024*1024*1024)

#define SYS_remap_anon_pages 314

static unsigned char *c, *tmp;

void userfault_sighandler(int signum, siginfo_t *info, void *ctx)
{
	unsigned char *addr = info->si_addr;
	int len = 4096;
	int ret;

#ifdef THP
	addr = (unsigned char *) ((unsigned long) addr & ~((2*1024*1024)-1));
	len = 2*1024*1024;
#endif
	if (addr >= c && addr < c + SIZE) {
		unsigned long offset = addr - c;
		ret = syscall(SYS_remap_anon_pages, c+offset, tmp+offset, len);
		if (ret)
			perror("sigbus remap_anon_pages"), exit(1);
		//printf("sigbus offset %lu\n", offset);
		return;
	}

	printf("sigbus error addr %p c %p tmp %p\n", addr, c, tmp), exit(1);
}

int main()
{
	struct sigaction sa;
	int ret;
	unsigned long i;
#ifndef THP
	/*
	 * Fails with THP due lack of alignment because of memset
	 * pre-filling the destination
	 */
	c = mmap(0, SIZE, PROT_READ|PROT_WRITE,
		 MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
	if (c == MAP_FAILED)
		perror("mmap"), exit(1);
	tmp = mmap(0, SIZE, PROT_READ|PROT_WRITE,
		   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
	if (tmp == MAP_FAILED)
		perror("mmap"), exit(1);
#else
	ret = posix_memalign((void **)&c, 2*1024*1024, SIZE);
	if (ret)
		perror("posix_memalign"), exit(1);
	ret = posix_memalign((void **)&tmp, 2*1024*1024, SIZE);
	if (ret)
		perror("posix_memalign"), exit(1);
#endif
	/*
	 * MADV_USERFAULT must run before memset, to avoid THP 2m
	 * faults to map memory into "tmp", if "tmp" isn't allocated
	 * with hugepage alignment.
	 */
	if (madvise(c, SIZE, MADV_USERFAULT))
		perror("madvise"), exit(1);
	memset(tmp, 0xaa, SIZE);

	sa.sa_sigaction = userfault_sighandler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_SIGINFO;
	sigaction(SIGBUS, &sa, NULL);

#ifndef USE_USERFAULT
	ret = syscall(SYS_remap_anon_pages, c, tmp, SIZE);
	if (ret)
		perror("remap_anon_pages"), exit(1);
#endif

	for (i = 0; i < SIZE; i += 4096) {
		if ((i/4096) % 2) {
			/* exercise read and write MADV_USERFAULT */
			c[i+1] = 0xbb;
		}
		if (c[i] != 0xaa)
			printf("error %x offset %lu\n", c[i], i), exit(1);
	}

	return 0;
}
