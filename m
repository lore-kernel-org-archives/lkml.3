Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423341Ab3CVVyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:54:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422936Ab3CVVyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:54:51 -0400
Date: Fri, 22 Mar 2013 14:54:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-Id: <20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
In-Reply-To: <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
	<20130227175427.GQ26411@outflux.net>
	<20130227180145.GH2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
	<1361998001.2110.22.camel@localhost>
	<20130227221954.GJ2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


poke.  Nothing got applied.  I'll drop
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch, see if that has any
effect ;) 


From: Josh Boyer <jwboyer@redhat.com>
Subject: kmsg: honor dmesg_restrict sysctl on /dev/kmsg

Originally, the addition of dmesg_restrict covered both the syslog
method of accessing dmesg, as well as /dev/kmsg itself.  This was done
indirectly by security_syslog calling cap_syslog before doing any LSM
checks.

However, commit 12b3052c3ee ("capabilities/syslog: open code cap_syslog
logic to fix build failure") moved the code around and pushed the checks
into the caller itself.  That seems to have inadvertently dropped the
checks for dmesg_restrict on /dev/kmsg.  Most people haven't noticed
because util-linux dmesg(1) defaults to using the syslog method for access
in older versions.  With util-linux 2.22 and a kernel newer than 3.5,
dmesg(1) defaults to reading directly from /dev/kmsg.

Fix this by making an explicit check in the devkmsg_open function.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg kernel/printk.c
--- a/kernel/printk.c~kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg
+++ a/kernel/printk.c
@@ -620,6 +620,9 @@ static int devkmsg_open(struct inode *in
 	struct devkmsg_user *user;
 	int err;
 
+	if (dmesg_restrict && !capable(CAP_SYSLOG))
+		return -EACCES;
+
 	/* write-only does not need any file context */
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		return 0;
_

