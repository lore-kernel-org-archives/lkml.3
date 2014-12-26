Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaLZOqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:46:07 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56697 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaLZOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:46:00 -0500
MIME-Version: 1.0
Reply-To: ivo.welch@gmail.com
From: ivo welch <ivo.welch@anderson.ucla.edu>
Date: Fri, 26 Dec 2014 22:45:38 +0800
X-Google-Sender-Auth: u_dzNb7TKaIYt2iCm2xD_91qy_8
Message-ID: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
Subject: fanotify bug on gdb -- hard crash
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not a kernel developer, so forgive the intrusion.

I suspect I have found either a bug in gdb (less likely) or a bug in
fanotify (more likely).  it is replicable, and the code is almost
unchanged from the example in the fanotify man page.  to trigger it,
all an su needs to do is to step through the program below with gdb
7.8.1 'n' command, and linux locks up the system pretty hard (reboot
required).  I have confirmed the replicability of this issue on a
clean arch 2014.12.01 3.17.6-1 system and on a clean ubuntu 14.10
system, both VMs created just to check it.  /iaw


#define _GNU_SOURCE     /* Needed to get O_LARGEFILE definition */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <sys/fanotify.h>

int main(int argc, char *argv[]) {
  int fd;
  fd = fanotify_init(FAN_CLOEXEC | FAN_CLASS_CONTENT | FAN_NONBLOCK,
O_RDONLY | O_LARGEFILE);
  if (fd == -1) exit(1);
  fprintf(stderr, "calling fanotify_mark: fd=%d\n", fd);
  if (fanotify_mark(fd, FAN_MARK_ADD | FAN_MARK_MOUNT, FAN_OPEN_PERM |
FAN_CLOSE_WRITE, -1, "/") == -1) exit(2);
  fprintf(stderr, "in gdb step through with 'n' for repeat.\n");
  fprintf(stderr, "  (and sometimes otherwise), a ^C works, but a ^Z
and then ^C does not.\n");
}

I don't know who else to tell this.  I hope this report is useful, if
someone competent can confirm it.  /iaw


PS: Is there an alternative to fanotify to avoid this?  I want to
learn of all file-open requests on a ro device.
----
Ivo Welch (ivo.welch@gmail.com)
