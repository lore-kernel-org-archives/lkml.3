Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaHAAeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:34:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:59342 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaHAAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:34:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 31 Jul 2014 17:30:46 -0700
Message-ID: <87oaw5caq1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+MFw0ZiipcRv/fRUZA/wjGTsBfegw+5H4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 0/4] /proc/thread-self
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset implements /proc/thread-self a magic symlink that
solves a couple of problems.

- It makes it easy to get to a specific threads directory in /proc
  with gettid() not being exported in glibc this is currently a pain.

- It allows fixing the problem present in /proc/mounts and /proc/net
  that when the thread group leader exits but the entire thread group
  remains /proc/self/net and /proc/self/mounts and thus /proc/mounts and
  /proc/net become empty.

- As mount and network namespaces are per thread it allows /proc/net and
  /proc/mounts to reflect this.

This is small chance changing /proc/net and /proc/mounts will cause
userspace regressions (although nothing has shown up in my testing) if
that happens we can just point the change that moves them from
/proc/self/... to /proc/thread-self/...

Eric W. Biederman (4):
      proc: Have net show up under /proc/<tgid>/task/<tid>
      proc: Implement /proc/thread-self to point at the directory of the current thread
      proc: Point /proc/net at /proc/thread-self/net instead of /proc/self/net
      proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts

 fs/proc/Makefile              |  1 +
 fs/proc/base.c                | 18 ++++++---
 fs/proc/inode.c               |  7 +++-
 fs/proc/internal.h            |  6 +++
 fs/proc/proc_net.c            |  2 +-
 fs/proc/root.c                |  5 ++-
 fs/proc/thread_self.c         | 85 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pid_namespace.h |  1 +
 8 files changed, 117 insertions(+), 8 deletions(-)

Eric
