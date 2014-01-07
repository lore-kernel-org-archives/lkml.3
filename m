Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaAGQUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:20:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45709 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaAGQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:56 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [10/11] use-case 4: Game on Android
Date: Tue,  7 Jan 2014 16:19:46 +0000
Message-Id: <1389111587-5923-11-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:52.0111 (UTC) FILETIME=[4B4173F0:01CF0BC4]
X-MC-Unique: 114010716195504101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GKtBW019872

Games generally have periodic load pattern synchronized to the
frame-rate (30 or 60 Hz). Games workloads typically involve both
graphics rendering (game engine) and audio mixing.

Performance Criteria

Keep the frame-rate as close to the target as possible. Variations are
acceptable. Audio must be handled before the audio buffers runs empty.

Task behaviour

This description is based on one particular Android game, but similar
patterns have been observed for a number of games. Overall, 10+ threads
are active and context switches happen very often. Key game engine tasks
and graphics driver tasks are scheduled ~200-700 times per second. The
top 10 tasks (by cpu time) consists of: One game task, one main game
engine task, three graphics related tasks, three audio tasks, one event
handling task, and one kworker task.

Game engine task: By far the most cpu intensive task. Accounts for about
50% of all cpu load. It is scheduled ~375 times per second (average).
The scheduling pattern repeats every ~16 ms (~60 Hz), where the task
runs for ~12 ms, followed by three shorter periods of activity where the
longest is ~2 ms (unless it is preempted by other tasks). In addition,
the game engine has a worker thread for each cpu. Each of the worker
threads account for ~0.4% of the load, is scheduled ~115 times per
second (average), and only runs for ~56 us (average).

Rendering task: Accounts for ~6% of the load. Scheduled ~200 times per
second (average) and runs for ~420 us (average).

Graphics driver task: Accounts for ~6% of the load. Scheduled ~700 times
per second (average) and runs for 11 us (average).

Game main task: Accounts for ~4% of the load. Scheduled ~170 times per
second (average) and runs for ~37 us (average).

Audio system task: Accounts for ~3% of the load. Scheduled ~120 times
per second (average) and runs for ~42 us (average).

kworker task: Accounts for ~3% of the load. Scheduled ~320 times per
second (average) and runs for ~13 us (average).

