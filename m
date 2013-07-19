Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab3GSPij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:38:39 -0400
Received: from mail.sysmocom.de ([144.76.43.93]:63680 "EHLO mail.sysmocom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3GSPii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:38:38 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2013 11:38:38 EDT
Date: Fri, 19 Jul 2013 17:28:00 +0200
From: Holger Hans Peter Freyther <holger@freyther.de>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: /proc/timer_list and weird behavior with dropbear
Message-ID: <20130719152800.GA20792@xiaoyu.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear Nathan,

I am currently upgrading a kernel for a TI Davinci DM644x based design
from Linux 3.2 to Linux 3.10.1. I have a funny re-producible issue that
goes away by reverting b3956a896ea57f25cacd74708b8fab611543a81d.

The dropbear sshd will open several files after accepting a connection to
generate some entropy. The "/proc/timer_list" file is part of that[1].
It will open that file and will try to read until the end of the file, but
most of the time this end never comes. According to strace the read on the
fd will always return 2048. I have attached the testcase I am using to
re-produce the issue.

Can this be re-produced by anyone else?

holger



[1] https://secure.ucc.asn.au/hg/dropbear/file/028fa77f952f/random.c#l204


--3V7upXqbjpZ4EhLz
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="proc_test.c"

#include <sys/stat.h>
#include <fcntl.h>

       #include <stdio.h>
       #include <stdlib.h>
       #include <sys/time.h>
       #include <sys/types.h>
       #include <unistd.h>


int main(int argc, char **argv)
{
	fd_set rfds;
	struct timeval tv;
	char buf[2048];

	int fd = open("/proc/timer_list", O_RDONLY, O_NONBLOCK);
	if (fd < 0) {
		perror("Failed to open");
		abort();
	}

	FD_ZERO(&rfds);
	FD_SET(fd, &rfds);


	while (1) {
		tv.tv_sec = 2;
		tv.tv_usec = 0;

		int retval = select(fd + 1, &rfds, NULL, NULL, &tv);
		if (retval == -1)
			perror("select()");
		else if (retval) {
			int ret = read(fd, buf, sizeof(buf));
			if (ret == 0)
				return EXIT_SUCCESS;
		} else {
			printf("TIMEOUT...\n");
		}
	}
}

--3V7upXqbjpZ4EhLz--
