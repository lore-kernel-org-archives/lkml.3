Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3AUJpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:45:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62977 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3AUJpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:45:05 -0500
Message-ID: <1358761496.4994.118.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 10:44:56 +0100
In-Reply-To: <50FD08E1.8000302@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:1QclwQHRqgTlhch9ikLOLzbtdnPcsO7mukU5GPsGe4G
 fDibknaUU6Ia28ZWYzRT0s9TQlfqiEqf32VO+rV1yo51EKoPMa
 tsagKu8S1alFCin8RXchAayIpkrHbL7qmiDpb2yFdvMav7wBwR
 w9snPPfHq4fNwB+B3/a1p++DHp59JNNEh9OtrknBC6YSdqVlVd
 D/em6MyKpsAjb36TyoUzqEhKr/Nc6tBsVnZZEtoyYWp7sS8Df7
 WFbmDp5sV5HtxzbYBQJsP2NUtemTa6s45269XRqFdshNNnQPDG
 ApiIQKIBEYDgbc9UtKMNbGF4mtx6bzv3e5kDTuTO9HAZOvvRjH
 9IfiAhZ9KRrcgGzj5s5M2pIe6jdWZSzXtHKJCM69zg+twM+WCi
 oiAHnsncXv42Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 17:22 +0800, Michael Wang wrote: 
> On 01/21/2013 05:09 PM, Mike Galbraith wrote:
> > On Mon, 2013-01-21 at 15:45 +0800, Michael Wang wrote: 
> >> On 01/21/2013 03:09 PM, Mike Galbraith wrote:
> >>> On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
> >>>> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> >>>
> >>>>> May be we could try change this back to the old way later, after the aim
> >>>>> 7 test on my server.
> >>>>
> >>>> Yeah, something funny is going on.
> >>>
> >>> Never entering balance path kills the collapse.  Asking wake_affine()
> >>> wrt the pull as before, but allowing us to continue should no idle cpu
> >>> be found, still collapsed.  So the source of funny behavior is indeed in
> >>> balance_path.
> >>
> >> Below patch based on the patch set could help to avoid enter balance path
> >> if affine_sd could be found, just like the old logical, would you like to
> >> take a try and see whether it could help fix the collapse?
> > 
> > No, it does not.
> 
> Hmm...what have changed now compared to the old logical?

What I did earlier to confirm the collapse originates in balance_path is
below.  I just retested to confirm.

Tasks    jobs/min  jti  jobs/min/task      real       cpu
    1      435.34  100       435.3448     13.92      3.76   Mon Jan 21 10:24:00 2013
    1      440.09  100       440.0871     13.77      3.76   Mon Jan 21 10:24:22 2013
    1      440.41  100       440.4070     13.76      3.75   Mon Jan 21 10:24:45 2013
    5     2467.43   99       493.4853     12.28     10.71   Mon Jan 21 10:24:59 2013
    5     2445.52   99       489.1041     12.39     10.98   Mon Jan 21 10:25:14 2013
    5     2475.49   99       495.0980     12.24     10.59   Mon Jan 21 10:25:27 2013
   10     4963.14   99       496.3145     12.21     20.64   Mon Jan 21 10:25:41 2013
   10     4959.08   99       495.9083     12.22     21.26   Mon Jan 21 10:25:54 2013
   10     5415.55   99       541.5550     11.19     11.54   Mon Jan 21 10:26:06 2013
   20     9934.43   96       496.7213     12.20     33.52   Mon Jan 21 10:26:18 2013
   20     9950.74   98       497.5369     12.18     36.52   Mon Jan 21 10:26:31 2013
   20     9893.88   96       494.6939     12.25     34.39   Mon Jan 21 10:26:43 2013
   40    18937.50   98       473.4375     12.80     84.74   Mon Jan 21 10:26:56 2013
   40    18996.87   98       474.9216     12.76     88.64   Mon Jan 21 10:27:09 2013
   40    19146.92   98       478.6730     12.66     89.98   Mon Jan 21 10:27:22 2013
   80    37610.55   98       470.1319     12.89    112.01   Mon Jan 21 10:27:35 2013
   80    37321.02   98       466.5127     12.99    114.21   Mon Jan 21 10:27:48 2013
   80    37610.55   98       470.1319     12.89    111.77   Mon Jan 21 10:28:01 2013
  160    69109.05   98       431.9316     14.03    156.81   Mon Jan 21 10:28:15 2013
  160    69505.38   98       434.4086     13.95    155.33   Mon Jan 21 10:28:29 2013
  160    69207.71   98       432.5482     14.01    155.79   Mon Jan 21 10:28:43 2013
  320   108033.43   98       337.6045     17.95    314.01   Mon Jan 21 10:29:01 2013
  320   108577.83   98       339.3057     17.86    311.79   Mon Jan 21 10:29:19 2013
  320   108395.75   98       338.7367     17.89    312.55   Mon Jan 21 10:29:37 2013
  640   151440.84   98       236.6263     25.61    620.37   Mon Jan 21 10:30:03 2013
  640   151440.84   97       236.6263     25.61    621.23   Mon Jan 21 10:30:29 2013
  640   151145.75   98       236.1652     25.66    622.35   Mon Jan 21 10:30:55 2013
 1280   190117.65   98       148.5294     40.80   1228.40   Mon Jan 21 10:31:36 2013
 1280   189977.96   98       148.4203     40.83   1229.91   Mon Jan 21 10:32:17 2013
 1280   189560.12   98       148.0938     40.92   1231.71   Mon Jan 21 10:32:58 2013
 2560   217857.04   98        85.1004     71.21   2441.61   Mon Jan 21 10:34:09 2013
 2560   217338.19   98        84.8977     71.38   2448.76   Mon Jan 21 10:35:21 2013
 2560   217795.87   97        85.0765     71.23   2443.12   Mon Jan 21 10:36:32 2013

That was with your change backed out, and the q/d below applied.

---
 kernel/sched/fair.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3337,6 +3337,8 @@ select_task_rq_fair(struct task_struct *
 		goto unlock;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
+		new_cpu = prev_cpu;
+
 		/*
 		 * Tasks to be waked is special, memory it relied on
 		 * may has already been cached on prev_cpu, and usually
@@ -3348,33 +3350,16 @@ select_task_rq_fair(struct task_struct *
 		 * from top to bottom, which help to reduce the chance in
 		 * some cases.
 		 */
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		new_cpu = select_idle_sibling(p, new_cpu);
 		if (idle_cpu(new_cpu))
 			goto unlock;
 
-		/*
-		 * No idle cpu could be found in the topology of prev_cpu,
-		 * before jump into the slow balance_path, try search again
-		 * in the topology of current cpu if it is the affine of
-		 * prev_cpu.
-		 */
-		if (!sbm->affine_map[prev_cpu] ||
-				!cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-			goto balance_path;
-
-		new_cpu = select_idle_sibling(p, cpu);
-		if (!idle_cpu(new_cpu))
-			goto balance_path;
+		if (wake_affine(sbm->affine_map[cpu], p, sync))
+			new_cpu = select_idle_sibling(p, cpu);
 
-		/*
-		 * Invoke wake_affine() finally since it is no doubt a
-		 * performance killer.
-		 */
-		if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
-			goto unlock;
+		goto unlock;
 	}
 
-balance_path:
 	new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
 	sd = sbm->sd[type][sbm->top_level[type]];
 




