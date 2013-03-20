Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3CTOtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:49:08 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46636 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3CTOtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:49:06 -0400
Date: Wed, 20 Mar 2013 07:48:59 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 01/10] workqueue: add wq_numa_tbl_len and
 wq_numa_possible_cpumask[]
Message-ID: <20130320144859.GU3042@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <1363737629-16745-2-git-send-email-tj@kernel.org>
 <CAAmzW4OosERgCwGnDx7HGHOf7BxbBPNYugA_V8wbegKvOiDqgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4OosERgCwGnDx7HGHOf7BxbBPNYugA_V8wbegKvOiDqgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:08:29PM +0900, JoonSoo Kim wrote:
> 2013/3/20 Tejun Heo <tj@kernel.org>:
> > Unbound workqueues are going to be NUMA-affine.  Add wq_numa_tbl_len
> > and wq_numa_possible_cpumask[] in preparation.  The former is the
> > highest NUMA node ID + 1 and the latter is masks of possibles CPUs for
> > each NUMA node.
> 
> It is better to move this code to topology.c or cpumask.c,
> then it can be generally used.

Yeah, it just isn't clear where it should go.  Most NUMA
initialization happens during early boot and arch-specific and
different archs expect NUMA information to be valid at different
point.  We can do it from one of the early initcalls by which all NUMA
information should be valid but, I don't know, having different NUMA
information coming up at different times seems error-prone.  There
would be no apparent indication that certain part is available while
others are not.

We could solve this by unifying how NUMA information is represented
and initialized.  e.g. if all NUMA archs used
CONFIG_USE_PERCPU_NUMA_NODE_ID, we can simply modify
set_cpu_numa_node() to build all data structures as NUMA nodes are
discovered.  Unfortunately, this isn't true yet and it's gonna be a
bit of work to get it in consistent state as it spans over multiple
architectures (not too many tho, NUMA fortunately is rare), so if
somebody can clean it up, I'll be happy to move these to topology.
Right now, I think it's best to just carry it in workqueue.c.

Thanks.

-- 
tejun
