Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaDXXEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:04:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39646 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaDXXEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:04:47 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering
Date: Thu, 24 Apr 2014 16:04:34 -0700
Message-Id: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing the sporadic work on improving the timekeeping
frequency steering logic when NOHZ is enabled, I've made a number
of changes to my re-implementation of Miroslav's patch (most
recently posted here: https://lkml.org/lkml/2014/2/12/401 ),
and I'm getting much closer results in the simulator.

Compared with Miroslav's patch, this avoids doing any extra
divisions, and instead approximates the correction
logarithmically. In addition to trying to lower overhead, this
allows the other accounting bits to be managed in much the
same way we have been doing for awhile.

This patch set contains one portion from Miroslav's patch
(ntp_tick caching) split out into a separate logical patch.

Below are some of the simulator results (BTW Miroslav, w/ 3.15-rc,
you'll need to revert b399fe355b30d01 to get the simulator building)
comparing this patchset to Miroslav's patch to show we're getting in
the right order of magnitude.


Miroslav's patch:
-----------------
$ ./tk_test -t 500 -n 4000
samples: 1-500 reg: 1-500 slope: 1.00 dev: 115.5 max: 300.1 freq: -100.00004
samples: 501-1000 reg: 501-1000 slope: 1.00 dev: 73.7 max: 289.6 freq: -100.00003
samples: 1001-1500 reg: 1001-1500 slope: 1.00 dev: 59.7 max: 283.9 freq: -100.00001
samples: 1501-2000 reg: 1501-2000 slope: 1.00 dev: 50.6 max: 291.6 freq: -100.00000
samples: 2001-2500 reg: 2001-2500 slope: 1.00 dev: 48.6 max: 285.7 freq: -100.00002
samples: 2501-3000 reg: 2501-3000 slope: 1.00 dev: 44.8 max: 293.5 freq: -99.99993
samples: 3001-3500 reg: 3001-3500 slope: 1.00 dev: 40.5 max: 303.8 freq: -99.99996
samples: 3501-4000 reg: 3501-4000 slope: 1.00 dev: 37.6 max: 288.5 freq: -99.99997

$ ./test1.sh 
		freq10          freq100         dev             max
nohz on		0.00601         0.00028         74.0            279.4
nohz off	0.05867         0.00204         0.2             0.6


This patchset:
--------------
$ ./tk_test -t 500 -n 4000
samples: 1-500 reg: 1-500 slope: 1.00 dev: 104.8 max: 278.4 freq: -100.00000
samples: 501-1000 reg: 501-1000 slope: 1.00 dev: 75.9 max: 295.5 freq: -100.00000
samples: 1001-1500 reg: 1001-1500 slope: 1.00 dev: 59.5 max: 284.5 freq: -100.00001
samples: 1501-2000 reg: 1501-2000 slope: 1.00 dev: 52.5 max: 287.3 freq: -99.99998
samples: 2001-2500 reg: 2001-2500 slope: 1.00 dev: 46.2 max: 292.2 freq: -100.00003
samples: 2501-3000 reg: 2501-3000 slope: 1.00 dev: 43.4 max: 294.8 freq: -100.00005
samples: 3001-3500 reg: 3001-3500 slope: 1.00 dev: 39.2 max: 279.5 freq: -99.99999
samples: 3501-4000 reg: 3501-4000 slope: 1.00 dev: 37.6 max: 285.2 freq: -99.99999


$ ./test1.sh 
		freq10          freq100         dev             max
nohz on		0.00748         0.00076         110.8           476.4
nohz off	0.07173         0.03590         0.6             2.1


Again, many many thanks to Miroslav for pointing out this issue, providing
the simulator and initial patches, as well as helping to point out problems
with my rework of his change.

Comments, feedback and testing would be greatly appreciated!

thanks
-john

Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>

John Stultz (3):
  [RFC] timekeeping: Rework frequency adjustments to work better w/ nohz
  [RFC] timekeeping: Use cached ntp_tick_length when accumulating error
  [RFC] timekeeping: Loop in the freqadjust logic to speed up
    convergence

 include/linux/timekeeper_internal.h |   7 ++
 kernel/time/timekeeping.c           | 201 ++++++++++++++++--------------------
 2 files changed, 98 insertions(+), 110 deletions(-)

-- 
1.8.3.2

