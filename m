Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3LVI50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 03:57:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62397 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3LVI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 03:57:25 -0500
Message-ID: <1387702631.5412.101.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 22 Dec 2013 09:57:11 +0100
In-Reply-To: <1387681647.5412.25.camel@marge.simpson.net>
References: <20131221193900.GA8427@linutronix.de>
	 <1387681647.5412.25.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:EatatWPMffuAJ1Fj4jwQnhix30SkObingYGMWTDXKlt
 GrulPyzCpeTvUF3QRQ+d1RhTuRwD1GBDjirdgTrYNpEk5Fxx7V
 t5HEhsPWc9B6ipGxe0/LURgvM6bd8lzs1x3UaNs0upOxjf/Wa9
 mLI9ckjFzT/pnW1DeeEuZruYfCZwpDlYIWZtcdSYUQRSdl/2yn
 dOV9gE9G651aTvV7gYWkVclgkAb+tjbGUCvwWIOEcoQ81IRNjA
 LpkpX3ydxlvRzEUclOk423z3Nv6YhI7v3IplvWSJvlZrJCK26I
 zgXiVkZM4RGLXmajmfsS0ZKZonF1yBOZ7WPB9+Oc//pbyRXvPR
 +og/c5tH0UlYjBOI0vfARIyGHlyRZ7iDlIehrYCbPJZEixJJEa
 tBt8xmf1W9iMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-22 at 04:07 +0100, Mike Galbraith wrote: 
> On Sat, 2013-12-21 at 20:39 +0100, Sebastian Andrzej Siewior wrote: 
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Running RCU out of softirq is a problem for some workloads that would
> > like to manage RCU core processing independently of other softirq work,
> > for example, setting kthread priority.  This commit therefore moves the
> > RCU core work from softirq to a per-CPU/per-flavor SCHED_OTHER kthread
> > named rcuc.  The SCHED_OTHER approach avoids the scalability problems
> > that appeared with the earlier attempt to move RCU core processing to
> > from softirq to kthreads.  That said, kernels built with RCU_BOOST=y
> > will run the rcuc kthreads at the RCU-boosting priority.
> 
> I'll take this for a spin on my 64 core test box.
> 
> I'm pretty sure I'll still end up having to split softirq threads again
> though, as big box has been unable to meet jitter requirements without,
> and last upstream rt kernel tested still couldn't.

Still can't fwiw, but whatever, back to $subject.  I'll let the box give
RCU something to do for a couple days.  No news is good news.

-Mike

30 minute isolated core jitter test says tinkering will definitely be
required.  3.0-rt does single digit worst case on same old box.  Darn.

(test is imperfect, but good enough)

FREQ=960 FRAMES=1728000 LOOP=50000 using CPUs 4 - 23
FREQ=1000 FRAMES=1800000 LOOP=48000 using CPUs 24 - 43
FREQ=300 FRAMES=540000 LOOP=160000 using CPUs 44 - 63
on your marks... get set... POW!
Cpu Frames    Min     Max(Frame)      Avg     Sigma     LastTrans Fliers(Frames) 
4   1727979   0.0159  181.66 (1043545)0.4492  0.5876    0 (0)     16 (828505,828506,859225,859226,889945,..1043546)
5   1727980   0.0159  181.90 (1013305)0.4560  0.6118    0 (0)     16 (798265,798266,828985,828986,859705,..1013306)
6   1727981   0.0159  189.05 (1013785)0.3691  0.6225    0 (0)     16 (798745,798746,829465,829466,860185,..1013786)
7   1727982   0.0159  177.88 (983546) 0.2885  0.5269    0 (0)     16 (768505,768506,799225,799226,829945,..983546)
8   1727984   0.0159  192.63 (984025) 0.3131  0.6307    0 (0)     18 (738265,738266,768985,768986,799705,..984026)
9   1727985   0.0159  16.43 (801406)  0.6562  0.5794    0 (0)     
10  1727986   0.0159  186.94 (954266) 0.3514  0.6252    0 (0)     16 (739225,739226,769945,769946,800665,..954266)
11  1727987   0.0159  194.06 (954745) 0.4341  0.6547    0 (0)     18 (708985,708986,739705,739706,770425,..954746)
12  1727989   0.0159  13.61 (67116)   0.3364  0.4294    0 (0)     
13  1727990   0.0159  186.19 (894265) 0.3955  0.6113    0 (0)     16 (679225,679226,709945,709946,740665,..894266)
14  1727991   0.0159  192.18 (894746) 0.4410  0.6449    0 (0)     18 (648985,648986,679705,679706,710425,..894746)
15  1727993   0.0159  183.36 (833786) 0.5582  0.6655    0 (0)     16 (618745,618746,649465,649466,680185,..833786)
16  1727994   0.0159  193.61 (895706) 0.6073  0.7382    0 (0)     17 (649945,680665,680666,711385,711386,..895706)
17  1727995   0.0159  36.94 (739943)  0.7135  0.7543    0 (0)     6 (173558,173559,739943,739944,1224751,1224752)
18  1727996   0.0159  167.39 (835226) 0.8385  0.8287    0 (0)     16 (620185,620186,650905,650906,681625,..835226)
19  1727997   0.0159  172.84 (804985) 0.5110  0.6959    0 (0)     17 (589946,620665,620666,651385,651386,..835706)
20  1727999   0.0159  180.47 (774745) 0.7566  0.7562    0 (0)     16 (559705,559706,590425,590426,621145,..774746)
21  1728000   0.0159  169.74 (744505) 0.7719  0.8154    0 (0)     16 (560185,560186,590905,590906,621625,..775226)
22  1728000   0.0159  194.80 (836667) 0.6799  0.7063    0 (0)     16 (590906,590907,622105,622106,652346,..836667)
23  1728000   0.0159  183.12 (745466) 0.6733  0.7091    0 (0)     16 (530425,530426,561145,561146,591865,..745466)
24  1800000   0.0725  7.46 (132730)   0.5375  0.4462    0 (0)     
25  1800000   0.0725  7.23 (132730)   0.5725  0.4816    0 (0)     
26  1800000   0.0725  7.23 (132730)   0.5119  0.4194    0 (0)     
27  1800000   0.0725  4.93 (132730)   0.4102  0.3379    0 (0)     
28  1800000   0.0725  5.08 (444312)   0.4275  0.3510    0 (0)     
29  1800000   0.0725  6.75 (132717)   0.5501  0.5232    0 (0)     
30  1800000   0.0725  11.61 (12026)   0.3811  0.3934    0 (0)     
31  1800000   0.0725  11.61 (12526)   0.4054  0.4551    0 (0)     
32  1800000   0.0725  50.95 (13026)   0.6015  0.5617    0 (0)     31 (13026,13027,45026,45027,77026,..909027)
33  1800000   0.0725  62.63 (13526)   0.5643  0.5922    0 (0)     112 (13526,13527,45526,45527,77526,..1773527)
34  1800000   0.0725  70.26 (14026)   0.3698  0.6132    0 (0)     112 (14026,14027,46026,46027,78026,..1774027)
35  1800000   0.0725  84.57 (14526)   0.6490  0.7981    0 (0)     112 (14526,14527,46526,46527,78526,..1774527)
36  1800000   0.0725  81.94 (943026)  0.3917  0.6387    0 (0)     112 (15026,15027,47026,47027,79026,..1775027)
37  1800000   0.0725  93.86 (15526)   0.6346  0.8580    0 (0)     112 (15526,15527,47526,47527,79526,..1775527)
38  1800000   0.0725  82.66 (144026)  0.4776  0.7459    0 (0)     112 (16026,16027,48026,48027,80026,..1776027)
39  1800000   0.0725  96.63 (16527)   0.4559  0.6881    0 (0)     112 (16526,16527,48526,48527,80526,..1776527)
40  1800000   0.0725  169.44 (17026)  0.4103  1.2801    0 (0)     112 (17026,17027,49026,49027,81026,..1777027)
41  1800000   0.0725  172.07 (145526) 0.6840  1.4300    0 (0)     112 (17526,17527,49526,49527,81526,..1777527)
42  1800000   0.0725  180.41 (18026)  0.5174  1.4290    0 (0)     112 (18026,18027,50026,50027,82026,..1778027)
43  1800000   0.0725  193.52 (466526) 1.4156  2.1665    0 (0)     112 (18526,18527,50526,50527,82526,..1778527)
44  540000    0.0032  11.92 (465332)  0.6862  0.7986    0 (0)     
45  540000    0.0032  14.30 (452401)  1.2460  0.9368    0 (0)     
46  540000    0.0032  13.35 (452402)  1.1379  0.9079    0 (0)     
47  540000    0.0032  12.64 (457991)  1.0116  0.8752    0 (0)     
48  540000    0.0032  10.49 (412210)  0.6312  0.7135    0 (0)     
49  540000    0.0032  10.01 (412210)  0.5195  0.6649    0 (0)     
50  540000    0.0032  9.53 (382891)   0.4586  0.6074    0 (0)     
51  540000    0.0032  10.02 (374093)  0.5366  0.6469    0 (0)     
52  540000    0.0032  13.35 (360263)  0.6725  0.7738    0 (0)     
53  540000    0.0032  10.73 (344411)  1.0863  0.9166    0 (0)     
54  540000    0.0032  12.16 (345014)  0.8779  0.7472    0 (0)     
55  540000    0.0032  11.45 (339953)  0.8549  0.7650    0 (0)     
56  540000    0.0032  11.45 (220829)  0.6262  0.7004    0 (0)     
57  540000    0.0032  9.77 (209623)   0.5978  0.6652    0 (0)     
58  540000    0.0032  9.78 (188624)   0.5481  0.6939    0 (0)     
59  540000    0.0032  5.96 (124615)   1.1515  0.8079    0 (0)     
60  540000    0.0032  13.11 (162649)  0.7490  0.7415    0 (0)     
61  540000    0.0032  11.92 (161653)  0.7996  0.8211    0 (0)     
62  540000    0.0032  13.12 (163325)  0.6313  0.8024    0 (0)     
63  540000    0.0032  9.30 (182608)   0.5861  0.6881    0 (0)


