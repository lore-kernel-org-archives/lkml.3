Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3FKNL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:11:57 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62362 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3FKNLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:11:55 -0400
X-Nat-Received: from [202.181.97.72]:51481 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1370956313.9414
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 0/4] LSM/TOMOYO: Introduce per a task_struct variables.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Jun 2013 22:11:52 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11062013 #10379665, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is for fixing two of TOMOYO's long-standing bugs which exists
since Linux 2.6.30.

Bug 1:

  TOMOYO has been unable to check binary loader's permission upon execve()
  because TOMOYO uses different permission for the program passed to execve()
  request and the binary loader requested by the program passed to the execve()
  request, but TOMOYO was not able to distinguish them due to lack of ability
  to pass the proposed credential argument. Some attempt to pass the proposed
  credential was made but was not successful because it breaks DAC's behavior.

Bug 2:

  TOMOYO has been unable to remember that the current thread was once granted
  for managing policy, for there is no mechanism for cleanly allocating per a
  task_struct variables. As a result, TOMOYO needlessly has to check permission
  for updating policy whenever a line of policy was written. Also, if the
  userspace once deleted a line that is needed for updating policy, the current
  thread (which should be able to update policy) fails to write the rest of
  lines.
  Variables associated with copy on write credential do not help for fixing
  this bug because TOMOYO may not be allowed to modify it when TOMOYO wants to
  modify it.

This patchset has four patches. Patch 1 and 2 are essentially revival of LSM
hooks which existed until Linux 2.6.28.

[PATCH 1/4] LSM: Add security_bprm_aborting_creds() hook.
[PATCH 2/4] LSM: Revive security_task_alloc() hook.
[PATCH 3/4] TOMOYO: Remember the proposed domain while in execve() request.
[PATCH 4/4] TOMOYO: Allow caching policy manager's state until execve() request.

 b/fs/exec.c                |    1
 b/include/linux/security.h |   11 +++
 b/kernel/fork.c            |    7 +
 b/security/capability.c    |    5 +
 b/security/security.c      |    5 +
 b/security/tomoyo/common.c |   22 +++++-
 b/security/tomoyo/common.h |   34 +++++++++
 b/security/tomoyo/tomoyo.c |  163 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/security.h   |   10 ++
 security/capability.c      |    6 +
 security/security.c        |    5 +
 security/tomoyo/common.h   |    6 +
 security/tomoyo/tomoyo.c   |   32 ++++++++
 13 files changed, 298 insertions(+), 9 deletions(-)
