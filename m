Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3AQTdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:33:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11159 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3AQTdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:33:44 -0500
X-Authority-Analysis: v=2.0 cv=e+OEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RpxbY9SB1lYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xuEBzIZCvhQA:10 a=HgKo-zgG2VTG7G0oivUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358451222.23211.40.camel@gandalf.local.home>
Subject: A little side effect of the rt throttling
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Date: Thu, 17 Jan 2013 14:33:42 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running on a 40 core box, I hit this nice latency while running
cyclictest on an idle box. The sched_rt_period_timer() grabbed locks
(I'm assuming the rq locks) 80 times!

      <idle>-0       0d..30  7151.231650: sched_switch:         swapper/0:0 [120] R ==> cyclictest:6178 [4]
    cyclicte-6178    0d.h20  7151.231651: funcgraph_entry:        0.051 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h40  7151.231663: hrtimer_cancel:       hrtimer=0xffffffff81bf4cd8
    cyclicte-6178    0d.h30  7151.231664: hrtimer_expire_entry: hrtimer=0xffffffff81bf4cd8 now=7153000011042  function=sched_rt_period_timer/0x0
    cyclicte-6178    0d.h20  7151.231667: funcgraph_entry:        0.050 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231668: funcgraph_entry:        0.043 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231668: funcgraph_entry:        0.075 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231668: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231669: funcgraph_entry:        4.008 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231673: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231674: funcgraph_entry:        0.082 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231674: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231674: funcgraph_entry:        0.081 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231675: funcgraph_entry:        0.049 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231675: funcgraph_entry:        0.761 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231677: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231677: funcgraph_entry:        0.099 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231678: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231682: funcgraph_entry:        0.081 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231682: funcgraph_entry:        0.049 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231682: funcgraph_entry:        0.103 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231683: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231683: funcgraph_entry:        0.083 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231683: funcgraph_entry:        0.049 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231686: funcgraph_entry:        0.182 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231692: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231693: funcgraph_entry:        0.165 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231694: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231694: funcgraph_entry:        7.818 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231703: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231704: funcgraph_entry:        6.887 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231714: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231720: funcgraph_entry:        0.171 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231722: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231723: funcgraph_entry:        1.654 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231725: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231726: funcgraph_entry:        0.177 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231727: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231727: funcgraph_entry:        0.170 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231731: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231731: funcgraph_entry:      + 11.838 us  |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231744: funcgraph_entry:        0.046 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231748: funcgraph_entry:        0.170 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231749: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231749: funcgraph_entry:        0.184 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231750: funcgraph_entry:        0.047 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231751: funcgraph_entry:        0.166 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231753: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231753: funcgraph_entry:        0.172 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231754: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231755: funcgraph_entry:        3.062 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231759: funcgraph_entry:        0.046 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231759: funcgraph_entry:        6.617 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231766: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231767: funcgraph_entry:        0.172 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231768: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231769: funcgraph_entry:        0.173 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231769: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231770: funcgraph_entry:        0.172 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231770: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231771: funcgraph_entry:        0.182 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231771: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231772: funcgraph_entry:        2.779 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231776: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231776: funcgraph_entry:        9.457 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231786: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231789: funcgraph_entry:        1.107 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231791: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231791: funcgraph_entry:        0.174 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231792: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231794: funcgraph_entry:        0.175 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231796: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231800: funcgraph_entry:      + 12.141 us  |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231812: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231814: funcgraph_entry:        0.173 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231816: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231817: funcgraph_entry:        0.175 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231817: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231818: funcgraph_entry:        0.175 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231819: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231819: funcgraph_entry:        0.944 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231821: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h20  7151.231821: funcgraph_entry:        0.175 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231823: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231824: hrtimer_expire_exit:  hrtimer=0xffffffff81bf4cd8
    cyclicte-6178    0d.h20  7151.231824: funcgraph_entry:        0.045 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h40  7151.231825: hrtimer_start:        hrtimer=0xffffffff81bf4cd8 function=sched_rt_period_timer expires=7154000000000 softexpires=7154000000000
    cyclicte-6178    0d.h40  7151.231825: hrtimer_cancel:       hrtimer=0xffff88103f80c4c0
    cyclicte-6178    0d.h30  7151.231826: hrtimer_expire_entry: hrtimer=0xffff88103f80c4c0 now=7153000011042
    cyclicte-6178    0d.h20  7151.231828: funcgraph_entry:        0.182 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231829: funcgraph_entry:        0.052 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h30  7151.231830: hrtimer_expire_exit:  hrtimer=0xffff88103f80c4c0
    cyclicte-6178    0d.h20  7151.231830: funcgraph_entry:        0.043 us   |  _raw_spin_lock();
    cyclicte-6178    0d.h40  7151.231831: hrtimer_start:        hrtimer=0xffff88103f80c4c0 function=tick_sched_timer expires=7153001000000 softexpires=7153001000000
    cyclicte-6178    0d..30  7151.231832: funcgraph_entry:        0.044 us   |  _raw_spin_lock_irqsave();

That function ran for 160 usecs! That function doesn't get called if you
disable the sched_rt_runtime_us (setting it to -1).

-- Steve


