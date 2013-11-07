Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3KGUSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:18:49 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46386 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab3KGUSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:18:12 -0500
Date: Thu, 7 Nov 2013 15:26:21 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: SIGIO after RT signal queue full issues
Message-ID: <alpine.DEB.2.10.1311071506530.1503@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I have a program that generates a lot of signals (perf_event_open 
overflows).  The signals are set up to be RT signals with sigaction().

The program sometimes gets enough signals that the RT signal queues fill 
up.  In that case the kernel responds by ignoring the signal settings
and unconditionally sends a SIGIO.

The code that does this is (I think) in fs/fcntl.h, line 472

		if (!do_send_sig_info(signum, &si, p, group))
			break;
	/* fall-through: fall back on the old plain SIGIO signal */
	case 0:
		do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, group);

The probelm is this SIGIO is sent ignoring the 
  sa_flags = SA_SIGINFO;
setting.  So the si_fd value isn't set, making it hard to tell which
fd has overflowed (which would be useful so I could shut down the
offending fd to stop the signal flood).

Is this the expected behavior?  It dates back to pre-git.

A related issue:
If I try to read the si->si_fd value anyway, I get garbage.
It seems that the code that implementes SEND_SIG_PRIV
only sets the uid and pid fields, and possibly is leaking kernel
state through the rest of the siginfo_t structure.

as best I can tell this happens in kernel/signal.c line 1106:

	case (unsigned long) SEND_SIG_PRIV:
		q->info.si_signo = sig;
		q->info.si_errno = 0;
		q->info.si_code = SI_KERNEL;
		q->info.si_pid = 0;
		q->info.si_uid = 0;
		break;

values past the pid and uid fields aren't zerod when read from the
siginfo_t field passed to the signal handler.
static void sigio_handler(int signum, siginfo_t *info, void *uc);

Thanks,

Vince
