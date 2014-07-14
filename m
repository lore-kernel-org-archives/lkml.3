Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbaGNTvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:51:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:11022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902AbaGNTuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:50:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="543227683"
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140714191504.GO9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
	 <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
	 <1405364908.2970.729.camel@schen9-DESK>
	 <20140714191504.GO9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jul 2014 12:50:50 -0700
Message-ID: <1405367450.2970.750.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 21:15 +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 12:08:28PM -0700, Tim Chen wrote:
> > On Mon, 2014-07-14 at 20:17 +0200, Peter Zijlstra wrote:
> 
> > > Your multi-buffer thing isn't generic either, it seems lmiited to sha1.
> > 
> > We actually have many other multi-buffer crypto algorithms already
> > published for encryption and other IPSec usages.  So 
> > multi-buffer algorithm is not just limited to SHA1.
> > We hope to port those to the kernel crypto library eventually.
> > http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-multi-buffer-ipsec-implementations-ia-processors-paper.pdf 
> 
> That's all nice and such; but the code as I've seen in these patches is
> very much sha1 specific. The mb part isn't separated out.

There is a generic multi-buffer infrastructure portion that manages
pulling and queuing jobs on the crypto workqueue, and it is separated out
in patch 1 of the patchset.  The other portions are algorithm specific that defines
algorithm specific data structure and  does the crypto computation 
for a particular algorithm, mostly in
assemblies and C glue code.  The infrastructure code is 
meant to be reused for other similar 
multi-buffer algorithms.

> 
> > > It does not reuse padata, 
> > padata tries to speed things up by parallelizing jobs to *multiple*
> > cpus.  Whereas multi-buffer tries to speed things up by speeding things
> > up by using multiple data lanes in SIMD register in a *single* cpu.
> > These two usages are complementary but not the same.
> 
> And if its single cpu, wth do you need that nr_running thing for another
> cpu for?

We use nr_running_cpu to check whether there are other tasks running on
the *current* cpu, (not for another cpu), to decide if we should flush
and compute crypto jobs accumulated.  If there's nobody else running,
we can take advantage of available cpu cycles on the cpu we are running 
on to do computation on the existing jobs in a SIMD mannner. 
Waiting a bit longer may accumulate more jobs to process in parallel
in a single SIMD instruction, but will have more delay.  

> 
> Also, this difference wasn't clear to me.
> 
> I still loathe all the async work, because it makes a mockery of
> accounting etc.. but that's a story for another day I suppose :-(
> 
> 

Thanks.

Tim


