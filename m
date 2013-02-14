Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab3BNFg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:36:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45245 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3BNFg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:36:58 -0500
Date: Thu, 14 Feb 2013 05:36:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
Message-ID: <20130214053656.GS4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	If execve() fails past flush_old_exec(), we are obviously going to
kill the process.  Right now it's implemented in $BIGNUM places in
->load_binary() and that's obviously brittle (and in at least one case
buggy - binfmt_flat lacks send_sig_info() on late failures).  Now, there's
an obvious way to check that we had done successful flush_old_exec() -
bfmt->mm becomes NULL just past the last failure exit there.  So it would
be tempting to have these send_sig_info() moved into search_binary_handler(),
especially since we already have
                        if (retval != -ENOEXEC || bprm->mm == NULL)
                                break;
in there and turning that into
			if (bprm->mm == NULL) {
				/* past the point of no return */
				suicide
				break;
			}
			if (retval != -ENOEXEC)
				break;
would be trivial.

	The only problem is that some suicides do SIGKILL, some SIGSEGV.
AFAICS, it started as SIGSEGV and had been switched to SIGKILL for a.out
(without any comments) in 1.1.62.  By that time ELF had been there, with
SIGSEGV in the same places.  Not replaced with SIGKILL; as the matter of
fact, they are still there.  Additional failure exits in case of ELF had
been added with SIGKILL; ELF-FDPIC has copied ELF and FLAT hadn't bothered
with send_sig_info() at all.

	Since by that point we have an empty sighandler table, the only
real difference is whether we attempt to produce a coredump on such late
failures.  Is there any real reason not to try that?  After all, with that
kind of late failure in execve(2) a coredump is obviously something the
caller might want to take a look at...

	What was the reason for switch in 1.1.62?  It's before my time
and the only exec-related comments I see in 1.1.61->1.1.62 summary are

Don't execute files that are being written to.
If we can't get write access to a core dump file, don't core dump.
Remove redundant test for non-null executables. 
No need to release the shared memory by hand, when loading different executable.

neither of which covers that one...
