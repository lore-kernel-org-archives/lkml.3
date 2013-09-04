Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228Ab3IDEe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:34:56 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39439 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3IDEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:34:55 -0400
Message-ID: <1378269728.32763.438.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v5 1/6] idr: Percpu ida
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@gentwo.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Date: Tue, 03 Sep 2013 21:42:08 -0700
In-Reply-To: <20130903182749.21052ab6.akpm@linux-foundation.org>
References: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
	 <1377917556-11955-2-git-send-email-nab@linux-iscsi.org>
	 <1378224418.32763.409.camel@haakon3.risingtidesystems.com>
	 <20130903182749.21052ab6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 18:27 -0700, Andrew Morton wrote:
> On Tue, 03 Sep 2013 09:06:58 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Are there any other review comments to be addressed for this patch..?
> > 
> > If not, please kindly give your Reviewed-by if your OK for an initial
> > standalone merge.
> 
> Sorry, I'm largely offline for the next week...
> 
> It looks OK to me (that's as close as I get to an ack :))
> 

Thanks.  That quote is going in the commit log btw.  ;)

> Nit:
> 
> > +		if (cpu >= nr_cpu_ids)
> > +			cpu = cpumask_first(&pool->cpus_have_tags);
> > +
> > +		if (cpu >= nr_cpu_ids)
> > +			BUG();
> 
> The second `if' can be moved inside the first, but hopefully the
> compiler already did that.

Fixed.

> 
> I have dim memories that doing
> 
> 	local_irq_save()
> 	spin_lock()
> 
> is not equivalent to
> 
> 	spin_lock_irqsave()
> 
> in some circumstances.  Perhaps a lockdep thing.  Or perhaps this was fixed in
> the intervening years and this is no longer the case.

Mmmm, I had wondered the same thing on the release side with
kref_put_spinlock_irqsave() here before:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/linux/kref.h?id=ccf5ae83a6cf3d9cfe9a7038bfe7cd38ab03d5e1

but at some point was convinced it was not a issue anymore..
 
> 
> Such things probably won't be detected during 3.12-rcX because few
> people will test iscsi, I expect.  So please be sure that you've
> runtime tested it with all the lockdeppy things enabled. 
> Documentation/SubmitChecklist section 12 has a list, but it might be
> dated.

<nod>

FYI, my v3.11-rc5 kernel has been running with CONFIG_LOCKDEP_SUPPORT=y
using vhost/iscsi/iser fabrics on the -v5 patch, and not generated any
warnings (yet).

I'll double check against the other debug options in Section 12.

Thank you,

--nab

