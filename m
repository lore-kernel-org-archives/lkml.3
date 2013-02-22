Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3BVIgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:36:51 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53818
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab3BVIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:36:50 -0500
Message-ID: <1361522197.26780.39.camel@laptop>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 09:36:37 +0100
In-Reply-To: <5126D9E0.7040108@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
> But that's really some benefit hardly to be estimate, especially when
> the workload is heavy, the cost of wake_affine() is very high to
> calculated se one by one, is that worth for some benefit we could not
> promise?

Look at something like pipe-test.. wake_affine() used to ensure both
client/server ran on the same cpu, but then I think we added
select_idle_sibling() and wrecked it again :/

$ taskset 1 perf bench sched pipe
# Running sched/pipe benchmark...
# Extecuted 1000000 pipe operations between two tasks

     Total time: 3.761 [sec]

       3.761725 usecs/op
         265835 ops/sec

$ perf bench sched pipe
# Running sched/pipe benchmark...
# Extecuted 1000000 pipe operations between two tasks

     Total time: 29.809 [sec]

      29.809720 usecs/op
          33546 ops/sec


Now as far as I can see there's two options, either we find there's
absolutely no benefit in wake_affine() as it stands today and we simply
disable/remove it, or we go fix it. What we don't do is completely
wreck it at atrocious cost.

