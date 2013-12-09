Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab3LIM73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:59:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48359 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab3LIM70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:59:26 -0500
From: Chris Redpath <chris.redpath@arm.com>
To: pjt@google.com, mingo@redhat.com, peterz@infradead.org,
        alex.shi@linaro.org, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com
Cc: linux-kernel@vger.kernel.org, Chris Redpath <chris.redpath@arm.com>
Subject: [PATCH 0/2] Per-task load tracking errors
Date: Mon,  9 Dec 2013 12:59:08 +0000
Message-Id: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 09 Dec 2013 12:59:22.0163 (UTC) FILETIME=[7ADE5030:01CEF4DE]
X-MC-Unique: 113120912592401401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rB9CxYAH005429

Hi Paul, Peter etc.

I've found a couple of bugs in the load tracking code and here
is my attempt to fix them. I have some test code available which
can trigger the issues if anyone is interested.


The first one is straightforward. We can leave a number in 
se.avg.decay_count after a short sleep. If that task is later
migrated while runnable, then the left-over decay looks like
unaccounted sleep time so the load is decayed.

The second one is similar. Here we are losing sleep time for a
task if it is migrated while sleeping and the CPU it previously
ran on has entered nohz mode.

I don't really like this fix much, but the root of the problem
is that load tracking more-or-less expects the runqueue's
decay_counter to be up to date, and when nohz is in use it is
not. The fix demonstrates the issue anyway, I haven't seen
other occasions where nohz CPUs distort the tracked load.

Chris Redpath (2):
  sched: reset blocked load decay_count during synchronization
  sched: update runqueue clock before migrations away

 kernel/sched/fair.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

-- 
1.7.9.5



