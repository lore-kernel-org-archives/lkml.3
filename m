Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaAGQWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:22:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45354 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaAGQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:51 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [4/11] issue 4: Tracking idle states
Date: Tue,  7 Jan 2014 16:19:40 +0000
Message-Id: <1389111587-5923-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:48.0627 (UTC) FILETIME=[492DD630:01CF0BC4]
X-MC-Unique: 114010716195013401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GMAhJ019892

Similar to the issue of knowing the potential capacity of a cpu, the CFS
scheduler also needs to know the idle state of idle cpus. Currently, an
idle cpu is found using cpumask_first() when an extra cpu is needed (for
nohz_idle_balance in find_new_ilb() in sched/fair.c). The energy
trade-off whether to wake another cpu or put tasks on already busy cpus
depend on this information.

The cost of waking up a cpu in terms of latency and energy depends on
the idle state the cpu is in. Deeper idle states typically affects more
than a single cpu. Waking up a single cpu from such state is more
expensive as it also affects the idle states of of its related cpus.

Energy costs are not currently represented in the cpuidle framework, but
latency is. Taking ARM TC2 as an example [1], which has two idle states:
Per-core clock-gating (WFI), and cluster power-down (power down all
related cpus and caches). The target residencies and exit latencies
specified in the driver give an idea about the cost involved in
entering/exiting these states.

			Target		Exit
			residency	latency
Clock-gating (WFI)	1		1
Cluster power-down	2000/2500	500/700		(big/LITTLE)

Picking the cheapest idle cpu would also have the effect that wake-ups
are likely to happen on the same cpu and leave the remaining cpus in
idle for longer.

Potential solution: Make the scheduler idle state aware by either moving
idle handling into the scheduler or let the idle framework (cpuidle)
maintain a cpumask of the cheapest cpus to wake up which is accessible
to the scheduler.

[1] drivers/cpuidle/cpuidle-big_little.c

