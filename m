Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3IDSVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:21:46 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53706 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755653Ab3IDSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:21:35 -0400
Date: Wed, 4 Sep 2013 19:21:13 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130904182113.GD5599@mudshark.cambridge.arm.com>
References: <20130828193457.140443630@linux.com>
 <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com>
 <20130830100105.GF25628@mudshark.cambridge.arm.com>
 <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
 <20130904093335.GA8007@mudshark.cambridge.arm.com>
 <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com>
 <20130904142324.GD3643@mudshark.cambridge.arm.com>
 <00000140e97747d2-ee164a4d-d692-409a-a919-083eff3a41ca-000000@email.amazonses.com>
 <20130904174624.GB5599@mudshark.cambridge.arm.com>
 <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140ea29d3c8-5110dd9f-9dcf-470f-9b7e-4e7ff0874052-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 07:09:04PM +0100, Christoph Lameter wrote:
> On Wed, 4 Sep 2013, Will Deacon wrote:
> 
> > On ARM, yes. I'm worried that there may be an architecture where the change-
> > or-fail operation would only fail if the access from the interrupt handler
> > *also* used that change-or-fail instruction, which isn't the case with
> > this_cpu_inc.
> >
> > I have no idea if such an architecture exists :)
> 
> Atomic operations use atomic_t. this_cpu operations can only use regular
> scalars. So the set of variables that are updated by each should be
> distinct.

Right, except that your patch contained the following hunk:

Index: linux/arch/arm64/kernel/debug-monitors.c
===================================================================
--- linux.orig/arch/arm64/kernel/debug-monitors.c       2013-08-26 13:48:40.956794980 -0500
+++ linux/arch/arm64/kernel/debug-monitors.c    2013-08-26 13:48:40.952795024 -0500
@@ -98,11 +98,11 @@ void enable_debug_monitors(enum debug_el

        WARN_ON(preemptible());

-       if (local_inc_return(&__get_cpu_var(mde_ref_count)) == 1)
+       if (this_cpu_inc_return(mde_ref_count) == 1)
                enable = DBG_MDSCR_MDE;

        if (el == DBG_ACTIVE_EL1 &&
-           local_inc_return(&__get_cpu_var(kde_ref_count)) == 1)
+           this_cpu_inc_return(kde_ref_count) == 1)
                enable |= DBG_MDSCR_KDE;

        if (enable && debug_enabled) {


Then we have:

#define local_inc_return(l) atomic_long_inc_return(&(l)->a)

static inline long atomic_long_inc_return(atomic_long_t *l)
{
	atomic_t *v = (atomic_t *)l;

	return (long)atomic_inc_return(v);
}


So that casting lets the two interfaces overlap (and indeed they do after
your patch, since local_dec_and_test is still used to the same variable).

Will
