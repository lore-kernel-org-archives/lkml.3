Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbaGPL5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:57:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324AbaGPL5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:57:50 -0400
Date: Wed, 16 Jul 2014 13:57:36 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
Message-ID: <20140716115736.GA24374@localhost>
References: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
 <20140519101439.GE4060@localhost>
 <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com>
 <20140708110816.GB23173@localhost>
 <53C5F95E.6010300@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C5F95E.6010300@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 09:02:38PM -0700, John Stultz wrote:
> On 07/08/2014 04:08 AM, Miroslav Lichvar wrote:
> > It seems it may be a while before the old vsyscalls are fixed. How
> > about including only the first two patches from this set for now?
> 
> Hey! Sorry for the slow response here, I was on the road the last two weeks.
> 
> So thanks for the ping here. If you're happy with the first two as an
> initial step, I'd be willing to try to push those in.

Ok, thanks.

> Thomas: Would you be ok if I push you some patches to improve ntp/ptp
> freq steering w/ NOHZ for this merge window as well? So far the patches
> have only shown nice improvements and no regressions, but its clearly
> subtle code, and there's a lot going on in this merge window.

For the record, here are test results from the simulator. There is a
regression in the performance with disabled nohz, it takes longer for
the clock to converge, but I think it's acceptable. When compared on
the same time scale, disabled nohz still seems to be significantly
better than nohz enabled.

3.16-rc5:
$ ./test1.sh 
                freq10          freq100         dev             max    
nohz on  	38.38368        2.72579         1468940.9       9846788.2
nohz off 	3.89181         0.10436         0.2             0.6

3.16-rc5 + two patches from this set:
$ ./test1.sh 
                freq10          freq100         dev             max    
nohz on		1.13791         0.05155         85.0            313.7
nohz off	1.02364         0.05149         0.5             1.7

Here are results from a new script I added to linux-tktest, which
I think shows better how the clock is converging.

3.16-rc5:

$ ./test2.sh 
nohz on             [1, samples/2]           [samples/2 + 1, samples]
samples         freq       dev       max      freq       dev       max
10          32.08360   16039.4   23435.5  39.61782   11077.4   30938.0
30          13.84304   35033.8   80321.5   8.52682   21495.6   52639.6
100          0.68945   31395.7   86405.6   1.26818   26426.9   98448.1
300          0.18118   33906.1  104062.0   0.11419   21147.4  102418.1
1000         0.02699   32254.1  120619.4   0.02234   21222.3  120107.6
3000         0.00515   31210.4  131688.9   0.00525   23067.8  140999.4
10000        0.00077   31904.1  149537.0   0.00079   21688.2  144957.5
30000        0.00015   31422.9  158176.5   0.00015   21867.9  159288.5
100000       0.00003   31301.3  170099.5   0.00003   22265.5  168985.6

nohz off            [1, samples/2]           [samples/2 + 1, samples]
samples         freq       dev       max      freq       dev       max
10           6.64956      14.0      18.8   7.10428       2.4       5.1
30           2.87697      13.1      33.0   0.02541       0.1       0.4
100          0.38990       9.9      35.1   0.00502       0.2       0.5
300          0.04733       6.5      42.9   0.00096       0.2       0.5
1000         0.00437       3.7      46.2   0.00023       0.2       0.6
3000         0.00049       2.2      47.1   0.00003       0.2       0.6
10000        0.00004       1.2      47.5   0.00000       0.2       0.6
30000        0.00001       0.8      47.6   0.00000       0.2       0.6
100000       0.00000       0.5      47.6   0.00000       0.2       0.6


3.16-rc5 + two patches from this set:

$ ./test2.sh          
nohz on             [1, samples/2]           [samples/2 + 1, samples]
samples         freq       dev       max      freq       dev       max
10           1.47222    1341.3    2217.8   0.06322       0.2       0.5
30           0.20799     849.5    2448.7   0.06311       0.2       0.6
100          0.04101     492.1    2895.2   0.06311       0.2       0.5
300          0.05660     295.5    3026.1   0.02064      28.3     108.9
1000         0.01994     409.8    2732.1   0.00355      13.7      52.2
3000         0.00477     469.1    3238.9   0.00070      11.0      40.9
10000        0.00081     377.3    3791.6   0.00013       9.4      36.2
30000        0.00016     259.9    4055.7   0.00004       8.9      34.1
100000       0.00003     159.0    4177.2   0.00000      13.7      58.4

nohz off            [1, samples/2]           [samples/2 + 1, samples]
samples         freq       dev       max      freq       dev       max
10           3.55062       6.2      10.8   0.05730       0.0       0.0
30           0.44672       4.5      14.1   0.05724       0.2       0.5
100          0.03649       2.7      17.4   0.05711       0.2       0.5
300          0.05815       1.7      18.7   0.06313       0.2       0.5
1000         0.06270       1.0      19.1   0.06315       0.2       0.5
3000         0.05720       1.9      19.9   0.02065       1.1       4.1
10000        0.01947      13.5      41.0   0.00339       0.5       1.7
30000        0.00448      17.5      75.9   0.00065       0.3       1.0
100000       0.00078      14.2     101.7   0.00012       0.2       0.7

-- 
Miroslav Lichvar
