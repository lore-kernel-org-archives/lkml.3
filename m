Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaGNTIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:08:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:4704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385AbaGNTIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:08:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="543214411"
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
In-Reply-To: <20140714181738.GI9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
	 <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jul 2014 12:08:28 -0700
Message-ID: <1405364908.2970.729.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 20:17 +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 10:05:34AM -0700, Tim Chen wrote:
> > I was trying to explain why the algorithm is implemented this way
> > because of its batching nature.
> > 
> > There is a whole class of async algorithm that can provide
> > substantial speedup by doing batch processing and uses workqueue.
> > The multi-buffer sha1 version has 2.2x speedup over existing
> > AVX2 version, and can have even more speedup when AVX3 
> > comes round.  Workqueue is a natural way to implement 
> > this.  I don't think a throughput speedup of 2.2x is "crap".
> > 
> > We are not inventing anything new, but ask for a 
> > very simple helper function to know if there's something else
> > running on our cpu to help us make a better decision 
> > of whether we should flush the batched jobs immediately.
> > 
> > And also asynchronous crypto interface is already used substantially
> > in crypto and has a well established infrastructure.  
> 
> The crap I was talking about is that there's a metric ton of 'async'
> interfaces all different.

Async interfaces when used appropriately, actually speed things up
substantially for crypto.  We actually have a case with
ecyrptfs not using the async crypto interface, causing cpu to stall
and slowing things down substantially with AES-NI.  And async interface
with workqueue speed things up (30% to 35% on encryption with SSD). 
http://marc.info/?l=ecryptfs-users&m=136520541407248 
http://www.spinics.net/lists/ecryptfs/msg00228.html 
 
> 
> Your multi-buffer thing isn't generic either, it seems lmiited to sha1.

We actually have many other multi-buffer crypto algorithms already
published for encryption and other IPSec usages.  So 
multi-buffer algorithm is not just limited to SHA1.
We hope to port those to the kernel crypto library eventually.
http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/fast-multi-buffer-ipsec-implementations-ia-processors-paper.pdf 

> It does not reuse padata, 
padata tries to speed things up by parallelizing jobs to *multiple*
cpus.  Whereas multi-buffer tries to speed things up by speeding things
up by using multiple data lanes in SIMD register in a *single* cpu.
These two usages are complementary but not the same.

> it does not extend workqueues, 
Why do I need to extend workqueues if the existing ones already
meet my needs?

> it does not
> remove the btrfs nonsense, 
Not much I can do about btrfs as I don't understand the issues there.

> it adds yet anotehr thing.


Thanks.

Tim




