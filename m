Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaJGGXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 02:23:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53303 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaJGGXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 02:23:37 -0400
Date: Mon, 6 Oct 2014 23:23:05 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        dev@codyps.com, linuxppc-dev@lists.ozlabs.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/5] powerpc/perf: Miscellaneous fixes
Message-ID: <20141007062305.GA20849@us.ibm.com>
References: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100706-9332-0000-0000-000002415E17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| Miscellaenous fixes for perf and 24x7 counters in powerpc.
| 
| Patches 1,3,4 were submitted earlier as a part of the parametrized
| events for 24x7 counters. But they are not directly related to the
| parametrized events.
| 
| Patch 2 simplifies and fixes a bug in catalog_read() which causes the
| catalog file to not read first page.
| 
| Changelog[v3]
| 	[Michael Ellerman] Cleanup patches 1 and 2 and fix a bug
| 	Add patch 5/5 to update contact info for 24x7 and GPCI counters
| 
| Changelog[v2]
| 	Rebase to perf/core tree.
| 
| Cody P Schafer (3):
|   powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack
|     allocations
|   perf Documentation: sysfs events/ interfaces
|   perf Documentation: remove duplicated docs for powerpc cpu specific
|     events

Per Michael Ellerman's suggestion, attaching an informal test case to
demonstrate the bug and the fix.

Sukadev

--FCuugMFkClbJLl1L
Content-Type: text/x-csrc; charset=us-ascii
Content-Description: cp-catalog.c
Content-Disposition: attachment; filename="cp-catalog.c"

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

/*
 * Usage: cp-catalog <read_size>
 *
 * Read the catalog from beginning to end. Read 'read_size' bytes
 * on each read.
 *
 * To ensure that a bug in catalog_read() in the kernel code is fixed.
 * 	cp-catalog 5 > /tmp/catalog-5
 * 	cp-catalog  > /tmp/catalog-4096
 * 	diff /tmp/catalog-5 /tmp/catalog-4096
 *
 * If both files are identical and size is about 256K, the bug is fixed.
 */
#define CATALOG	"/sys/bus/event_source/devices/hv_24x7/interface/catalog"
#define TMP_CATALOG	"/tmp/catalog"

main(int argc, char *argv[])
{
	int read_size, rfd, wfd, rc;
	struct stat stat_buf;
	char *input_file;
	char buf[4096];
	char output_file[256];

	read_size = 4096;
	if (argc > 1)
		read_size = atoi(argv[1]);

	if (read_size > sizeof(buf))
		read_size = sizeof(buf);

	input_file = CATALOG;
	sprintf(output_file, "%s-%d", TMP_CATALOG, read_size);

	rfd = open(input_file, O_RDONLY);
	if (rfd < 0) {
		perror(input_file);
		_Exit(1);
	}

	wfd  = open(output_file, O_WRONLY|O_CREAT|O_TRUNC);
	if (wfd < 0) {
		perror(output_file);
		_Exit(1);
	}

	while(1) {
		memset(buf, 0, sizeof(buf));
		rc = read(rfd, buf, read_size);
		if (rc <= 0)
			break;
		if (write(wfd, buf, rc) != rc) {
			perror("write()");
			break;
		}
	}
	if (fstat(wfd, &stat_buf) < 0) {
		perror("fstat()");
		_Exit(1);
	}
	printf("catalog size %zd\n", stat_buf.st_size);
}

--FCuugMFkClbJLl1L--

