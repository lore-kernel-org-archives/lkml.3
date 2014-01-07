Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaAGQUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:20:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45292 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAGQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:51 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [1/11] issue 1: Missing power topology information in scheduler
Date: Tue,  7 Jan 2014 16:19:37 +0000
Message-Id: <1389111587-5923-2-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:47.0002 (UTC) FILETIME=[4835E1A0:01CF0BC4]
X-MC-Unique: 114010716194913801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GKGdZ019852

The current mainline scheduler has no power topology information
available to enable it to make energy-aware decisions. The energy cost
of running a cpu at different frequencies and the energy cost of waking
up another cpu are needed.

One example where this could be useful is audio on Android. With the
current mainline scheduler it would utilize three cpus when active. Due
to the size of the tasks it is still possible to meet the performance
criteria when execution is serialized on a single cpu. Depending on the
power topology leaving two cpus idle and running one longer may lead to
energy savings if the cpus can be power-gated individually.

The audio performance requirements can be satisfied by most cpus at the
lowest frequency. Video is a more interesting use-case due to its higher
performance requirements. Running all tasks on a single cpu is likely to
require a higher frequency than if the tasks are spread out across
more cpus.

Running Android video playback on an ARM Cortex-A7 platform with 1, 2,
and 4 cpus online has lead to the following power measurements
(normalized):

video 720p (Android)
cpus	power
1	1.59
2	1.00
4	1.10

Restricting the number of cpus to one forces the frequency up to cope
with the load, but the overall cpu load is only ~60% (busy %-age). Using
two cpus keeps the frequency in the more power efficient range and gives
a ~37% power reduction. With four cpus the power consumption is worse,
likely due to the wake/idle transitions increase (~100%).

For this use-case it appears that the optimal busy %-age is ~30% (use
two cpus). However, that is likely to vary depending on the use-case.

Proposed solution: Represent energy costs for each P-states and C-states
in the topology to enable the scheduler to estimate the energy cost of
the scheduling decisions. Coupled with P-state awareness that would
allow the scheduler to avoid expensive high P-states.


