Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaAGQVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:21:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45460 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaAGQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:53 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [7/11] use-case 1: Webbrowsing on Android
Date: Tue,  7 Jan 2014 16:19:43 +0000
Message-Id: <1389111587-5923-8-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:50.0408 (UTC) FILETIME=[4A3D9880:01CF0BC4]
X-MC-Unique: 114010716195110601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GLRE5019876

Common webbrowsing use-cases (no embedded videos, but dynamic contents
is ok) typically exhibit three distinct modes of operation depending on
what it is doing in relation to the user:

1)
Mode: Page load and rendering.

Behaviour: The duration is highly depends on the website but is
relatively short. Typically a few seconds. Page loading time impacts
user experience directly.  Minor performance drops may be acceptable if
it comes with good overall energy savings.

Performance criteria: Complete as fast as possible.
 

2)
Mode: Display website (user reading, no user interaction)

Behaviour: Low load. Only minor updates of dynamic contents.

Performance criteria: Minimize energy.


3)
Mode: Page scrolling.

Behaviour: Relatively short in duration. Rendering of contents which was
previously off screen.

Performance criteria: Ensure smooth UI interaction. Without UI
experience feedback (lag, etc.), optimizing for best performance might
the only way to get necessary performance.


Task behaviour

The task descriptions are based on traces from a modern ARM platform
with a fairly recent version of Android. It may be different other
platforms and software stacks. This serves just as an example.

There are three main tasks involved on the browser side, and one or more
tasks related to the graphics driver. Each of them behaves differently
in each of the three modes of operation.

Render task: Mainly active in mode 1, but also active in mode 3.
Accounts for about a third of the total cpu time. May run for a more or
less continuous burst of 1-2s in 1.

Texture task: Active in all modes, but mainly in modes 1 and 3. Active
after the render task burst in mode 1. Somewhat periodic behaviour
during modes 1 and 3 indicating dependencies on other tasks.  Account
for about a sixth of the cpu time.

Browser task: Active in all modes. Blocks often. Only running about half
the time when it is active. Short occasional periods of activity in mode
2 along with the texture task. Accounts for about a third of the cpu
time.

Graphics driver task: Mainly active in mode 1 and 3, very little
activity in mode 2 and only when browser and texture tasks are
active. Runs for a short amount of time but frequently when active.
Accounts for about a sixth of the cpu time.

