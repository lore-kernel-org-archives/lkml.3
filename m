Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3CEXUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:20:38 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58600 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3CEXUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:20:37 -0500
Message-ID: <51367DB4.9080602@gmail.com>
Date: Wed, 06 Mar 2013 10:20:20 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
References: <1362194662-2344-1-git-send-email-tj@kernel.org> <1362194662-2344-17-git-send-email-tj@kernel.org> <20130304183742.GI30413@htj.dyndns.org> <513671CF.5050705@gmail.com> <20130305223327.GA1227@htj.dyndns.org> <20130305223434.GB1227@htj.dyndns.org> <51367470.5040909@gmail.com> <20130305224444.GC1227@htj.dyndns.org>
In-Reply-To: <20130305224444.GC1227@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 09:44, Tejun Heo wrote:
> Hello,
> 
> On Wed, Mar 06, 2013 at 09:40:48AM +1100, Ryan Mallon wrote:
>>> Ooh, right, and that cpumask_t is going away and you can't statically
>>> allocate cpumask_var_t, so it needs an allocation and error check from
>>> it anyway.
>>
>> Not sure I follow. I mean drop the pointer, eg:
>>
>> 	struct workqueue_attr attrs;
>>
>> Since, at least in this patch, struct worker_pool appears to always
>> alloc the attrs field. You do still of course need the cpumask_t
>> initialisation. Am I missing something?
> 
> So, new usages of cpumask_t is frowned upon and we gotta use
> cpumask_var_t which needs alloc_cpumask_var() which may fail, so we
> have try-to-alloc-and-check-for-failure no matter what.  Now, if we
> want to embed workqueue_attrs, we have to separate out initialization
> of allocated attrs from the actaul allocation.  ie. we'll need
> init_workqueue_attrs() and alloc_workqueue_attrs() and as the former
> may fail too, it doesn't really simplify pool initilaization path.
> So, we end up with more code.  The added code is minor but it also
> doesn't buy anything.

I don't get why you would need to separate init/alloc. Nothing in the
patch series appears to have optional attrs (e.g. a case where attrs
might be NULL), so allocing isn't necessary, which is my point. The init
function can fail due to the cpumask_t, as you point out, but at least
you can remove one alloc/free per attrs struct:

static int workqueue_init_attrs(struct workqueue_attrs *attrs,
				gfp_t gfp_mask)
{
	memset(attrs, 0, sizeof(*attrs));
	if (!alloc_cpumask_var(&attrs->cpumask, gfp_mask))
		return -ENOMEM;
	cpumask_setall(attrs->cpumask);
	return 0;
}

static void workqueue_deinit_attrs(struct workqueue_attrs *attrs)
{
	free_cpumask_var(attrs->cpumask);
}

In patch 17 unbound_std_wq_attrs can easily be changed to a non-pointer
type, and in patch 31 you remove the need to alloc/free the attrs
structure in wq_nice_store, so you would have something like:

	struct workqueue_attrs attrs;
	int err;

	err = workqueue_init_attrs(&attrs, GFP_KERNEL);
	if (err)
		return err;

	rcu_read_lock_sched();
	copy_workqueue_attrs(&attrs, first_pwq(wq)->pool->attrs);
	rcu_read_unlock_sched();

	apply_workqueue_attrs(wq, &attrs);

	/* Needed to free the temp cpumask */
	workqueue_deinit_attrs(&attrs);

If there are cases where the attrs need to be a pointer (e.g. it can
optionally be NULL, which needs to be tested against), then you could
just leave the responsibility of allocation to the caller.

~Ryan


