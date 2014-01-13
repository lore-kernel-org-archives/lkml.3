Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaAMRvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:51:31 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39274 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaAMRv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:51:28 -0500
Date: Mon, 13 Jan 2014 18:51:16 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
Message-ID: <20140113175114.GA4271@netboy>
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 07:57:03PM -0800, John Stultz wrote:
> 
> I still think this is probably 3.15 or later material, but I'd be
> very interested in feedback, thoughts, and testing.

Over the weekend I did a short test of this new approach. I compiled
two kernels, one plain v3.12.7 and one with the proposed fix. The
test was run on three different kernel variants, the current nohz
kernel, the same with nohz=off, and the same but with John's patch.

I used a simple test script (see below). Using a PCIe express card as
a PHC, the Intel Corporation 82574L, I simply let the this clock run
free (not sync'ed to gps or anything), and then synchronized the Linux
system clock to the PHC using the phc2sys program with a sample rate
of once every 32 seconds. Each of the tests ran for at least three
hours on a system without any other load.

- Linux 3.12.7-nohz-plain-20140106                nohz-plain.log
- Linux 3.12.7-nohz-plain-20140106 NOHZ=OFF       periodic-plain.log
- Linux 3.12.7-nohz-fix-20140106-00001-gd753140   nohz-fix.log

The performance in the log files as reflected in the clock offset is
summarized in this table. The values are in nanoseconds.

 |         | periodic-plain |      nohz-fix |    nohz-plain |
 |---------+----------------+---------------+---------------|
 | minimum |  -1.599000e+03 | -1.051000e+03 | -5.373700e+04 |
 | maximum |  +1.311000e+03 | +1.048000e+03 | +6.389500e+04 |
 | mean    |  +9.880240e-02 | -7.747305e+01 | +1.597904e+01 |
 | stddev  |  +4.610021e+02 | +3.960978e+02 | +1.491263e+04 |

I also made two graphs.

   http://linuxptp.sourceforge.net/nohz-fix/current_nohz.png
   http://linuxptp.sourceforge.net/nohz-fix/periodic_vs_fix.png

(The log files and scripts are also in that directory.)

So in this test, it looks like the new approach performed at least as
well as using regular, periodic ticks.

Thanks,
Richard

---
# nohz-fix-testing.sh
#
# set the ptp clock time from the system time
#
./testptp -s; ./testptp -g; date
#
# wait a bit to let the clocks drift
#
sleep 10
#
# start the servo
#
./phc2sys -s eth4 -m -q -l7 -O0 -P0 -I0 -R.03125
