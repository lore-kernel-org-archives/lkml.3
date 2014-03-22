Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaCVNtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 09:49:41 -0400
Received: from numidia.opendz.org ([98.142.220.152]:50106 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaCVNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 09:49:40 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH resend - v2 0/2] procfs: make /proc/*/{stack,syscall,pagemap} 0400
Date: Sat, 22 Mar 2014 14:37:38 +0100
Message-Id: <1395495460-7652-1-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please note: this is a resend of version 2, I got two Acked-by, but no
one replied on why it should not be applied...)


The following patches make /proc/*/{stack,syscall,personality,pagemap}
0400.

These files contain sensitive information that can be used by an
unprivileged process to leak address space and bypass ASLR. This will
make the VFS able to bloc unprivileged processes from getting file
descriptors on *already* *running* processes (privileged processes).

This does not protect all the /proc and exec-suid cases. It just reduces
the scope of ASLR leaks by protecting *already running* processes. The
leak is still possible on these files *only* if an attacker opens its
/proc/*/file and can *spawn* a target setuid process, then read from it.

So, only already running processes are protected.

Patches were Acked by Kees Cook and Andy Lutomirski. Thank you!


This is a resend, first send:
https://lkml.org/lkml/2013/12/15/114

Of the already version 2, the original discussion:
https://lkml.org/lkml/2013/8/26/354
(date: Aug 2013, and it can be used to leak ASLR).


Kees Cook also confirmed the security exposure here:
https://lkml.org/lkml/2013/8/28/564

At least we have a VFS protection for now.


Reminder:
I've discussed the technique to use the 'file->f_cred' to protect proc
entries here:
https://lkml.org/lkml/2013/10/1/371

Eric suggest it, I did the implementation and it was rejected.

Good I've took _all_ the comments in consideration, and came up with
another scheme. It will protect *already running* processes, but first
I need to get this simple series accepted!


Thanks!


Djalal Harouni (2):
 procfs: make /proc/*/{stack,syscall,personality} 0400
 procfs: make /proc/*/pagemap 0400

 fs/proc/base.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)
