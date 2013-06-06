Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3FFRbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab3FFRbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:31:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130606115417.GA520@x4>
References: <20130606115417.GA520@x4>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
Date: Thu, 06 Jun 2013 18:31:01 +0100
Message-ID: <12790.1370539861@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> OSError: [Errno 5] Input/output error
> 
> Basically 'emerge' just writes the build output to stdout in a loop:

I've just upgraded to kernel-3.9.4-200.fc18.x86_64 and I'm now regularly
seeing something very similar from the tee run by "fedpkg local" to log its
output when building a cross-compiler gcc RPM:

	tee: standard output: Input/output error
	tee: write error

Slapping strace on tee after the "Input/output error" line has occurred shows
that tee is still running and still pushing lines from its stdin to the output
named on its command line, but has ceased writing to its stdout.

The stdout is (or was) a TTY that's either the communications channel to an
xterm or the channel to an emacs buffer.  With the xterm, the process can be
suspended (CTRL+Z) stuff can be written to the tty and then the process can be
rstarted.  Indeed, stderr for tee goes to the same tty - and must still be
functional otherwise I wouldn't see the aforementioned error messages...

In ps fax, the tee process can be seen at the bottom of the subtree:

 5158 ?        S      0:06  \_ /usr/bin/xterm
 5198 pts/3    Ss+    0:00  |   \_ bash
 5386 pts/3    Sl     4:50  |       \_ emacs -geometry 100x77
10258 pts/8    SNs+   0:00  |           \_ /usr/bin/python /usr/bin/fedpkg local
10267 pts/8    SN+    0:00  |               \_ rpmbuild --define _sourcedir /dat
10462 pts/8    SN+    0:00  |               |   \_ /bin/sh -e /var/tmp/rpm-tmp.x
16248 pts/8    SN+    0:00  |               |       \_ make -j12
16249 pts/8    SN+    0:00  |               |           \_ /bin/sh -c fail= fail
16253 pts/8    SN+    0:00  |               |               \_ /bin/sh -c fail= 
16254 pts/8    SN+    0:00  |               |                   \_ make all-am
16256 pts/8    SN+    0:00  |               |                       \_ /bin/sh -
16265 pts/8    SN+    0:00  |               |                       |   \_ /bin/
16688 pts/8    SN+    0:00  |               |                       |       \_ /
16700 pts/8    RN+    0:00  |               |                       |           
16704 pts/8    SN+    0:00  |               |                       |           
16267 pts/8    SN+    0:00  |               |                       \_ /bin/sh -
16279 pts/8    SN+    0:00  |               |                       |   \_ /bin/
16694 pts/8    SN+    0:00  |               |                       |       \_ /
16707 pts/8    RN+    0:00  |               |                       |           
16713 pts/8    SN+    0:00  |               |                       |           
16289 pts/8    SN+    0:00  |               |                       \_ /bin/sh -
16306 pts/8    SN+    0:00  |               |                       |   \_ /bin/
17045 pts/8    SN+    0:00  |               |                       |       \_ /
17046 pts/8    RN+    0:00  |               |                       |           
17047 pts/8    SN+    0:00  |               |                       |           
16799 pts/8    SN+    0:00  |               |                       \_ /bin/sh -
16801 pts/8    SN+    0:00  |               |                       |   \_ /bin/
17051 pts/8    SN+    0:00  |               |                       |       \_ /
17053 pts/8    RN+    0:00  |               |                       |           
16819 pts/8    SN+    0:00  |               |                       \_ /bin/sh -
16822 pts/8    SN+    0:00  |               |                       |   \_ /bin/
16943 pts/8    SN+    0:00  |               |                       |       \_ /
16950 pts/8    RN+    0:00  |               |                       |           
16951 pts/8    SN+    0:00  |               |                       |           
16903 pts/8    SN+    0:00  |               |                       \_ /bin/sh -
16915 pts/8    SN+    0:00  |               |                           \_ /bin/
17024 pts/8    SN+    0:00  |               |                               \_ /
17026 pts/8    RN+    0:00  |               |                                   
17028 pts/8    SN+    0:00  |               |                                   
10268 pts/8    SN+    0:00  |               \_ tee .build-4.8.1-1.1.fc20.log

tee's fds look like:

warthog>ls -l /proc/10268/fd/
total 0
lr-x------. 1 dhowells dhowells 64 Jun  6 18:24 0 -> pipe:[1595614]
lrwx------. 1 dhowells dhowells 64 Jun  6 18:24 1 -> /dev/pts/8
lrwx------. 1 dhowells dhowells 64 Jun  6 18:23 2 -> /dev/pts/8
l-wx------. 1 dhowells dhowells 64 Jun  6 18:24 3 -> /data/fedora/cros

David
