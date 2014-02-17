Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaBQMvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:51:43 -0500
Received: from relay.parallels.com ([195.214.232.42]:52650 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaBQMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:51:42 -0500
Message-ID: <530205D9.1010908@parallels.com>
Date: Mon, 17 Feb 2014 16:51:37 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Unkillable R-state process stuck in sendfile
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running trinity syscall fuzzer I noticed that sometimes it does
not get killed immediately, even by SIGKILL - it takes several minutes
before it exits. What is interesting it "hangs" in R-state consuming
100% of CPU time. Analyzing its trace I found that it loops in
sendfile(2) with the out fd pointing to an evenfd object, i.e. it does
something like this:

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/eventfd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <limits.h>
#include <err.h>

#define SIZE            INT_MAX

int main()
{
        int in_fd, out_fd;
        ssize_t ret;

        in_fd = open("tmpfile", O_RDWR|O_CREAT, 0666);
        if (in_fd < 0)
                err(1, "open");
        if (ftruncate64(in_fd, SIZE) < 0)
                err(1, "ftruncate");
        out_fd = eventfd(0, 0);
        if (out_fd < 0)
                err(1, "eventfd");
        ret = sendfile64(out_fd, in_fd, NULL, SIZE);
        if (ret < 0)
                err(1, "sendfile");
}

This program will ignore SIGKILL for 2-5 minutes depending on how fast
the host processor is. This happens, because eventfd_write does not
check for pending signals when making progress (not waiting), neither
does file read.

I'm not sure if this is actually bad and should be fixed, but perhaps
it's worth making do_generic_file_read() check for fatal signals pending
and break the read loop if so?

FWIW, generic_perform_write() isn't prone to this problem, because
recently it was made interruptible by a fatal signal - see commit
a50527b19c62c ("fs: Make write(2) interruptible by a fatal signal").

Thanks.
