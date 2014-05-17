Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaEQA5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:57:25 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40626 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaEQA5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:57:24 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
Date: Fri, 16 May 2014 17:56:41 -0700
Message-Id: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I managed to find some time to further work on the next iteration here.

This patch set, based on ideas from Miroslav, tries to improve the ntp
freq steering when using NOHZ. 

Rather then just doing error proportional correction, this patchset
splits the logic to two steps: frequency correction and error
correction. By doing this, we are able to cap the rate of the error
correction, so it is small and we avoid the strong over-corrections
seen with the previous implementation when NOHZ was enabled.

This version of the patch set corrects a few issues Miroslav pointed
out, as well as adapts his approach almost completely for the last
patch. This pulls the results in to be very close to his original
patch.

I'm not 100% sure we need the last patch in this series, as
it has additional computational cost and testing on real
hardware has shown NOHZ=y performance matching NOHZ=n with a
earlier version of just the first patch:
	https://lkml.org/lkml/2014/1/13/501
(though admittedly, the patch has changed since Richard's testing,
so the results are a bit stale).

Below are some of the simulator results comparing this patchset
to vanilla and Miroslav's original patch.

Vanilla 3.15-rc
---------------
$  ./tk_test -t 500 -n 4000
samples: 1-500 reg: 1-500 slope: 1.00 dev: 2252427.1 max: 9614317.1 freq: -99.94417
samples: 501-1000 reg: 501-1000 slope: 1.00 dev: 1426381.1 max: 7957313.5 freq: -100.23188
samples: 1001-1500 reg: 1001-1500 slope: 1.00 dev: 1146520.7 max: 7795769.4 freq: -99.96096
samples: 1501-2000 reg: 1501-2000 slope: 1.00 dev: 942903.0 max: 7091089.3 freq: -100.24301
samples: 2001-2500 reg: 2001-2500 slope: 1.00 dev: 927526.2 max: 6688226.0 freq: -99.74349
samples: 2501-3000 reg: 2501-3000 slope: 1.00 dev: 843482.1 max: 10259091.7 freq: -100.01513
samples: 3001-3500 reg: 3001-3500 slope: 1.00 dev: 935390.6 max: 9055331.8 freq: -99.74709
samples: 3501-4000 reg: 3501-4000 slope: 1.00 dev: 760640.7 max: 8755998.4 freq: -99.75966

$ ./test1.sh 
		freq10          fre100          dev             max
nohz on		38.38368        2.72579         1468940.9       9846788.2
nohz off	3.89181         0.10436         0.2             0.6

Miroslav's original patch:
--------------------------
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
samples: 1-500 reg: 1-500 slope: 1.00 dev: 111.0 max: 276.4 freq: -100.00000
samples: 501-1000 reg: 501-1000 slope: 1.00 dev: 76.5 max: 286.7 freq: -99.99998
samples: 1001-1500 reg: 1001-1500 slope: 1.00 dev: 59.3 max: 291.8 freq: -100.00003
samples: 1501-2000 reg: 1501-2000 slope: 1.00 dev: 51.2 max: 290.7 freq: -100.00001
samples: 2001-2500 reg: 2001-2500 slope: 1.00 dev: 48.0 max: 275.9 freq: -100.00002
samples: 2501-3000 reg: 2501-3000 slope: 1.00 dev: 44.8 max: 293.2 freq: -99.99993
samples: 3001-3500 reg: 3001-3500 slope: 1.00 dev: 40.1 max: 300.4 freq: -99.99998
samples: 3501-4000 reg: 3501-4000 slope: 1.00 dev: 37.6 max: 285.7 freq: -99.99999

$ ./test1.sh 
		freq10          freq100         dev             max
nohz on		0.00582         0.00033         74.1            279.9
nohz off	0.06275         0.06440         0.4             1.4


Again, many many thanks to Miroslav for pointing out this issue, providing
the simulator and initial patches, as well as helping to point out problems
with my rework of his change.

Comments, and feedback and testing (particularly on 32bit systems, and
systems like powerpc) would be greatly appreciated!

thanks
-john

Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>

John Stultz (3):
  [RFC] timekeeping: Rework frequency adjustments to work better w/ nohz
  [RFC] timekeeping: Use cached ntp_tick_length when accumulating error
  [RFC] timekeeping: Calculate freq adjustment directly

 include/linux/timekeeper_internal.h |  12 +++
 kernel/time/timekeeping.c           | 175 ++++++++++++++----------------------
 2 files changed, 77 insertions(+), 110 deletions(-)

-- 
1.9.1

