Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbbAPQEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:04:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbbAPQES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:04:18 -0500
Date: Fri, 16 Jan 2015 17:03:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        pbonzini@redhat.com, tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 3/3] x86, fpu: fix math_state_restore() race with
	kernel_fpu_begin()
Message-ID: <20150116160308.GB7249@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150115192028.GD27332@redhat.com> <54B877BC.3070905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B877BC.3070905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Rik van Riel wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 01/15/2015 02:20 PM, Oleg Nesterov wrote:
> > math_state_restore() can race with kernel_fpu_begin() if irq comes
> > right after __thread_fpu_begin(), __save_init_fpu() will overwrite
> > fpu->state we are going to restore.
> >
> > Add 2 simple helpers, kernel_fpu_disable() and kernel_fpu_enable()
> > which simply set/clear in_kernel_fpu, and change
> > math_state_restore() to exclude kernel_fpu_begin() in between.
> >
> > Alternatively we could use local_irq_save/restore, but probably
> > these new helpers can have more users.
> >
> > Perhaps they should disable/enable preemption themselves, in this
> > case we can remove preempt_disable() in __restore_xstate_sig().
>
> Given that math_state_restore does an implicit preempt_disable
> through local_irq_disable,

Not really. do_device_not_available() calls it with irqs disabled,
__restore_xstate_sig() calls it under preempt_disable().

> I am not sure whether adding an
> explicit preempt_disable would be good or bad.

Me too, but this code needs cleanups in any case imo, lets do this
later.

> Reviewed-by: Rik van Riel <riel@redhat.com>

Thanks!


I'll try to send another short series today, we need to remove
__thread_has_fpu() from interrupted_kernel_fpu_idle() before we
add TIF_LOAD_FPU.

Oleg.

