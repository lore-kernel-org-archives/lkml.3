Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3DGGaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 02:30:18 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37200 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3DGGaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 02:30:16 -0400
Date: Sun, 7 Apr 2013 02:29:30 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Message-ID: <338291050.277410.1365316170850.JavaMail.root@redhat.com>
In-Reply-To: <1101781431.260745.1365313808038.JavaMail.root@redhat.com>
Subject: [BUG?] thp: too much anonymous hugepage caused 'khugepaged' thread
 stopped
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF17 (Linux)/8.0.3_GA_5664)
Thread-Topic: too much anonymous hugepage caused 'khugepaged' thread stopped
Thread-Index: qBAnzGDUef+vPqgoKJ1pHNNipVLSxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

When I did some testing to check thp's performance, the following
strange action occurred:

when a process try to allocate 500+(or other large value)
anonymous hugepage, the 'khugepaged' thread will stop to
scan vma. the testing system has 2Gb RAM, and the thp
enabled value is 'always', set 0 to 'scan_sleep_millisecs'

you can use the following steps to confirm the issue:

---------------- example code ------------
/* file test_thp.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
	int nr_thps = 1000, ret = 0;
	unsigned long hugepagesize, size;
	void *addr;

	hugepagesize = (1UL << 21);

	if (argc == 2)
		nr_thps = atoi(argv[1]);

	printf("try to allocate %d transparent hugepages\n", nr_thps);
	size = (unsigned long)nr_thps * hugepagesize;

	ret = posix_memalign(&addr, hugepagesize, size);
	if (ret != 0) {
		printf("posix_memalign failed\n");
		return ret;
	}

	memset (addr, 10, size);

	sleep(50);

	return ret;
}
-------- end example code -----------

executing './test_thp 500' in a system with 2GB RAM, the values in
/sys/kernel/mm/transparent_hugepage/khugepaged/* will never change,
you can  repeatedly do '# cat /sys/kernel/mm/transparent_hugepage/khugepaged/*' to check this.

as we know, when we set 0 to /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs,
the /sys/kernel/mm/transparent_hugepage/khugepaged/full_to_scans will increasing at least,
but the actual is opposite, the value is never change, so I checked 'khugepaged' thread,
and found the 'khugepaged' is stopped:
# ps aux | grep -i hugepaged
root        67 10.9  0.0      0     0 ?        SN   Apr06 172:10 [khugepaged]
                                               ^^ 
also I did the same actions on some large machine, e.g on 16Gb RAM, 1000+ anonymous hugepages
will cause 'khugepaged' stopped, but there are 2Gb+ free memory, why is it? is that normal?
comments?

-- 
Thanks,
Zhouping
