Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaE0KUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:20:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:58849 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaE0KUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,918,1392192000"; 
   d="scan'208";a="518241966"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, kirill.shutemov@linux.intel.com
In-Reply-To: <20140527091335.GC20436@moon>
References: <20140527091335.GC20436@moon>
Subject: RE: [linux-next] splice call weird results
Content-Transfer-Encoding: 7bit
Message-Id: <20140527102013.3BF61E009B@blue.fi.intel.com>
Date: Tue, 27 May 2014 13:20:13 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Hi! While been trying to run criu on linux-next (due to recent Kirill's patch related
> to /proc/pid/clear_refs with THP enabled) I noticed that it fails dumping programs when
> moves data from memory pages into an image file. So I wrote pretty idiotic test and
> run it on current fedora 20 kernel and then on linux-next.
> 

+Al. He reworked splice code in linux-next.

> fedora-20 output
> ----------------
> [cyrill@moon criu] ~/pipe 
> Opened pipe-test.SQBcJa
> vmspliced 8192 bytes
> spliced 4096 bytes
> 
> linux-next
> ----------
> [root@fc criu]# ~/pipe
> Opened pipe-test.9nZSW7
> vmspliced 8192 bytes
> spliced 8192 bytes
> 
> In test I fill pipe with 8K data then splice 4K of it into a file (the test
> is below). Is it intended, or I did some silly mistake?
> ---
> #define _GNU_SOURCE
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <string.h>
> #include <fcntl.h>
> 
> #include <sys/uio.h>
> 
> #define ARRAY_SIZE(x)	(sizeof(x)/sizeof(x[0]))
> 
> static char buf[8 << 20];
> 
> int main(int argc, char *argv[])
> {
> 	char *tmpname, t[64] = "pipe-test.XXXXXX";
> 	int _pipe[2], fd, ret = 0;
> 
> 	struct iovec iov[] = {
> 		[0] = {
> 			.iov_base	= &buf[0],
> 			.iov_len	= 4096,
> 		},
> 
> 		[1] = {
> 			.iov_base	= &buf[4096],
> 			.iov_len	= 4096,
> 		},
> 	};
> 
> 	if (pipe(_pipe)) {
> 		perror("Can't create pipe");
> 		exit(1);
> 	}
> 
> 	memset(buf, 0x1, sizeof(buf));
> 	tmpname = mktemp(t);
> 
> 	fd = open(tmpname, O_RDWR | O_CREAT | O_TRUNC);
> 	if (fd < 0) {
> 		perror("Can't open temp file");
> 		close(_pipe[0]);
> 		close(_pipe[1]);
> 		exit(1);
> 	}
> 	printf("Opened %s\n", tmpname);
> 
> 	ret = vmsplice(_pipe[1], iov, ARRAY_SIZE(iov), SPLICE_F_GIFT);
> 	printf("vmspliced %li bytes\n", (long)ret);
> 
> 	ret = splice(_pipe[0], NULL, fd, NULL, iov[0].iov_len, SPLICE_F_MOVE);
> 	printf("spliced %li bytes\n", (long)ret);
> 
> out:
> 	close(_pipe[0]);
> 	close(_pipe[1]);
> 	close(fd);
> 	unlink(tmpname);
> 	return ret;
> }

-- 
 Kirill A. Shutemov
