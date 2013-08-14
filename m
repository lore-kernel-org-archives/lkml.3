Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3HNUuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:50:46 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:35845 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab3HNUuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:50:44 -0400
Date: Wed, 14 Aug 2013 16:50:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] mm: make lru_add_drain_all() selective
Message-ID: <20130814205029.GN28628@htj.dyndns.org>
References: <20130814200748.GI28628@htj.dyndns.org>
 <201308142029.r7EKTMRw023404@farm-0002.internal.tilera.com>
 <20130814134430.50cb8d609643620b00ab3705@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814134430.50cb8d609643620b00ab3705@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 14, 2013 at 01:44:30PM -0700, Andrew Morton wrote:
> > +static bool need_activate_page_drain(int cpu)
> > +{
> > +	return pagevec_count(&per_cpu(activate_page_pvecs, cpu)) != 0;
> > +}
> 
> static int need_activate_page_drain(int cpu)
> {
> 	return pagevec_count(&per_cpu(activate_page_pvecs, cpu));
> }
> 
> would be shorter and faster.  bool rather sucks that way.  It's a
> performance-vs-niceness thing.  I guess one has to look at the call
> frequency when deciding.

"!= 0" can be dropped but I'm fairly sure the compiler would be able
to figure out that the type conversion can be skipped.  It's a trivial
optimization.

> > +			schedule_work_on(cpu, work);
> > +			cpumask_set_cpu(cpu, &has_work);
> > +		}
> > +	}
> > +
> > +	for_each_cpu(cpu, &has_work)
> 
> for_each_online_cpu()?

That would lead to flushing work items which aren't used and may not
have been initialized yet, no?

> > +		flush_work(&per_cpu(lru_add_drain_work, cpu));
> > +
> > +	put_online_cpus();
> > +	mutex_unlock(&lock);
> >  }
> 

Thanks.

-- 
tejun
