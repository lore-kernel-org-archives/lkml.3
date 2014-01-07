Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaAGQVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:21:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45427 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaAGQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:52 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [5/11] issue 5: Frequency and uarch invariant task load
Date: Tue,  7 Jan 2014 16:19:41 +0000
Message-Id: <1389111587-5923-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:49.0158 (UTC) FILETIME=[497EDC60:01CF0BC4]
X-MC-Unique: 114010716195027201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GLg6w019880

Related to the issue of potential cpu capacity, task load is influenced
directly by the current P-state of the cpu it is running on. For
energy-aware task placement decisions the scheduler would need to
estimate the energy impact of scheduling a specific task on a specific
cpu. Depending on the resulting P-state it may be more energy efficient
to wake-up another cpu (see system 1 in mail 11 for energy efficiency
example).

The frequency and uarch impact can be rather significant. On modern
systems frequency scaling covers a range of 5-6x. On top of that uarch
differences may give another 1.5-3x for a total cpu capacity range
covering >10x.

Measurements on ARM TC2 for a simple periodic test workload (single
task, 16 ms period):

        cpu load        load_avg_contrib (10 sample avg.)
Freq    A7      A15     A7      A15
500     16.76%   9.94%  ~201    ~135
700     12.06%   6.95%  ~145     ~87
1000     8.19%   5.23%  ~103     ~65

The cpu load estimate used for load balancing is based on
load_avg_contrib which means that for this example the load estimate may
vary 3x depending on where tasks are scheduled and the frequency scaling
governors used.

Potential solution: Frequency invariance has been proposed before [1]
where the task load is scaled by the cur/max freq ratio. Another
possibility is to use hardware counters if such are available on the
platform.

[1] https://lkml.org/lkml/2013/4/16/289

