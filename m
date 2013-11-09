Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3KIHMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:12:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3KIGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.11 40/94] Revert "select: use freezable blocking call"
Date: Fri,  8 Nov 2013 22:51:46 -0800
Message-Id: <20131109065207.057558981@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 59612d187912750f416fbffe0c00bc0811c54ab5 upstream.

This reverts commit 9745cdb36da8 (select: use freezable blocking call)
that triggers problems during resume from suspend to RAM on Paul Bolle's
32-bit x86 machines.  Paul says:

  Ever since I tried running (release candidates of) v3.11 on the two
  working i686s I still have lying around I ran into issues on resuming
  from suspend. Reverting 9745cdb36da8 (select: use freezable blocking
  call) resolves those issues.

  Resuming from suspend on i686 on (release candidates of) v3.11 and
  later triggers issues like:

  traps: systemd[1] general protection ip:b738e490 sp:bf882fc0 error:0 in libc-2.16.so[b731c000+1b0000]

  and

  traps: rtkit-daemon[552] general protection ip:804d6e5 sp:b6cb32f0 error:0 in rtkit-daemon[8048000+d000]

  Once I hit the systemd error I can only get out of the mess that the
  system is at that point by power cycling it.

Since we are reverting another freezer-related change causing similar
problems to happen, this one should be reverted as well.

References: https://lkml.org/lkml/2013/10/29/583
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Fixes: 9745cdb36da8 (select: use freezable blocking call)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/select.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/select.c
+++ b/fs/select.c
@@ -238,8 +238,7 @@ int poll_schedule_timeout(struct poll_wq
 
 	set_current_state(state);
 	if (!pwq->triggered)
-		rc = freezable_schedule_hrtimeout_range(expires, slack,
-							HRTIMER_MODE_ABS);
+		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
 	__set_current_state(TASK_RUNNING);
 
 	/*


