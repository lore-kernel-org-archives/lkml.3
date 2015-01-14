Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbbANAXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:23:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4345 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbbANAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:23:52 -0500
Date: Tue, 13 Jan 2015 16:23:41 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <calvinowens@fb.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150114002341.GA6469@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_08:2015-01-13,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=51.5900229690472
 compositescore=0.165369342820785 urlsuspect_oldscore=0.165369342820785
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.165369342820785 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501140002
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a simple program to trigger the issue with /proc/<pid>/maps.

Thanks,
Calvin

/* Simple program to reproduce O(N^2) behavior reading /proc/<pid>/maps
 *
 * Example on a random server:
 *
 * 	$ ./map_repro 0
 * 	Spawning 0 threads
 * 	Reading /proc/self/maps... read 2189 bytes in 1 syscalls in 33us!
 * 	$ ./map_repro 10
 * 	Spawning 10 threads
 * 	Reading /proc/self/maps... read 3539 bytes in 1 syscalls in 55us!
 * 	$ ./map_repro 100
 * 	Spawning 100 threads
 * 	Reading /proc/self/maps... read 15689 bytes in 4 syscalls in 373us!
 * 	$ ./map_repro 1000
 * 	Spawning 1000 threads
 * 	Reading /proc/self/maps... read 137189 bytes in 34 syscalls in 32376us!
 * 	$ ./map_repro 2000
 * 	Spawning 2000 threads
 * 	Reading /proc/self/maps... read 272189 bytes in 68 syscalls in 119980us!
 * 	$ ./map_repro 4000
 * 	Spawning 4000 threads
 * 	Reading /proc/self/maps... read 544912 bytes in 134 syscalls in 712200us!
 * 	$ ./map_repro 8000
 * 	Spawning 8000 threads
 * 	Reading /proc/self/maps... read 1090189 bytes in 268 syscalls in 3650718us!
 * 	$ ./map_repro 16000
 * 	Spawning 16000 threads
 * 	Reading /proc/self/maps... read 2178189 bytes in 534 syscalls in 42701311us!
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <limits.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>
#include <fcntl.h>

static char buf[65536] = {0};
static void time_maps_read(void)
{
	struct timespec then, now;
	long usec_elapsed;
	int ret, fd;
	int count = 0;
	int rd = 0;

	fd = open("/proc/self/maps", O_RDONLY);
	if (fd == -1) {
		printf("Couldn't open /proc/self/maps, bailing...\n");
		return;
	}

	printf("Reading /proc/self/maps... ");
	ret = clock_gettime(CLOCK_MONOTONIC, &then);

	while (1) {
		ret = read(fd, &buf, 65536);
		if (!ret || ret == -1)
			break;
		rd += ret;
		count++;
	}

	ret = clock_gettime(CLOCK_MONOTONIC, &now); 
	usec_elapsed = (now.tv_sec - then.tv_sec) * 1000000L;
	usec_elapsed += (now.tv_nsec - then.tv_nsec) / 1000L;

	printf("read %d bytes in %d syscalls in %ldus!\n", rd, count, usec_elapsed);
	close(fd);
}

static void *do_nothing_forever(void *unused)
{
	while (1)
		sleep(60);

	return NULL;
}

int main(int args, char **argv)
{
	int i, ret, threads_to_spawn = 0;	
	pthread_t tmp;

	if (args != 1) {
		threads_to_spawn = atoi(argv[1]);
		printf("Spawning %d threads\n", threads_to_spawn);
	}

	for (i = 0; i < threads_to_spawn; i++) {
		ret = pthread_create(&tmp, NULL, do_nothing_forever, NULL);
		if (ret)
			printf("Thread %d failed to spawn?\n", i);
	}

	time_maps_read();
	return 0;
}
