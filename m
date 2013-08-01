Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3HAB4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:56:47 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35691 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3HAB4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:56:46 -0400
Date: Thu, 1 Aug 2013 09:56:36 +0800
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch]workqueue: copy attr with all fields.
Message-ID: <20130801015636.GA12580@kernel.org>
References: <20130729062412.GA6448@kernel.org>
 <20130729111401.GA20951@mtj.dyndns.org>
 <20130729125259.GA9306@kernel.org>
 <20130729153523.GA22605@mtj.dyndns.org>
 <20130730054955.GA5225@kernel.org>
 <20130730141419.GG12016@htj.dyndns.org>
 <20130731013929.GB1504@kernel.org>
 <20130731102752.GD2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731102752.GD2810@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:27:52AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 31, 2013 at 09:39:29AM +0800, Shaohua Li wrote:
> > Hmm, I didn't agree it's more confusing to change copy_workqueue_attrs(), the
> 
> We're talking past each other.  I'm not saying copy_workqueue_attrs()
> shouldn't copy no_numa.  I'm saying get_unbound_pool() should clear
> no_numa so that pools don't have random no_numa settings.
> 
> > name of the function suggests it is a 'copy'. And clearing no_numa in
> > apply_workqueue_attrs() after copy_workqueue_attrs() looks like a hack to me.
> 
> Why would apply_workqueue_attrs() modify no_numa when it *is* dealing
> with an actual workqueue attr.  I've been talking about
> get_unbound_pool() not apply_workqueue_attrs() the whole time.
> 
> > But it depends on you, feel free to fix it by yourself.
> 
> Please update the patch to add no_numa clearing to get_unbound_pool()
> and explain what's going on.

Something like this?


Subject: workqueue: copy workqueue_attrs with all fields

$echo '0' > /sys/bus/workqueue/devices/xxx/numa
$cat /sys/bus/workqueue/devices/xxx/numa
I got 1. It should be 0, the reason is copy_workqueue_attrs() called in
apply_workqueue_attrs() doesn't copy no_numa field.

Signed-off-by: Shaohua Li <shli@fusionio.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0b72e81..daf3f03 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3411,6 +3411,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 {
 	to->nice = from->nice;
 	cpumask_copy(to->cpumask, from->cpumask);
+	to->no_numa = from->no_numa;
 }
 
 /* hash value of the content of @attr */
@@ -3578,6 +3579,12 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
+	/*
+	 * no_numa isn't a worker_pool attribute, always clear it. See 'struct
+	 * workqueue_attrs' comments for detail.
+	 */
+	pool->attrs->no_numa = 0;
+
 	/* if cpumask is contained inside a NUMA node, we belong to that node */
 	if (wq_numa_enabled) {
 		for_each_node(node) {
