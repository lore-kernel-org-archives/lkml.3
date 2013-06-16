Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3FPXKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 19:10:22 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36754 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3FPXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 19:10:21 -0400
Date: Sun, 16 Jun 2013 16:10:41 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.11] percpu-refcount: use RCU-sched insted of
 normal RCU
Message-ID: <20130616231041.GF28664@moria.home.lan>
References: <20130616215546.GB28587@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616215546.GB28587@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 02:55:46PM -0700, Tejun Heo wrote:
> percpu-refcount was incorrectly using preempt_disable/enable() for RCU
> critical sections against call_rcu().  6a24474da8 ("percpu-refcount:
> consistently use plain (non-sched) RCU") fixed it by converting the
> preepmtion operations with rcu_read_[un]lock() citing that there isn't
> any advantage in using sched-RCU over using the usual one; however,
> rcu_read_[un]lock() for the preemptible RCU implementation -
> CONFIG_TREE_PREEMPT_RCU, chosen when CONFIG_PREEMPT - are slightly
> more expensive than preempt_disable/enable().
> 
> In a contrived microbench which repeats the followings,
> 
>  - percpu_ref_get()
>  - copy 32 bytes of data into percpu buffer
>  - percpu_put_get()
>  - copy 32 bytes of data into percpu buffer
> 
> rcu_read_[un]lock() used in percpu_ref_get/put() makes it go slower by
> about 15% when compared to using sched-RCU.
> 
> As the RCU critical sections are extremely short, using sched-RCU
> shouldn't have any latency implications.  Convert to RCU-sched.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <koverstreet@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Kent Overstreet <koverstreet@google.com>
