Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3HUUtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:49:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3HUUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:49:47 -0400
Date: Wed, 21 Aug 2013 13:49:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-Id: <20130821134945.16b32c045e28272c5b0ba610@linux-foundation.org>
In-Reply-To: <00000140a14ae6bb-f0fca267-cdd6-4039-8c6b-f715999a83c5-000000@email.amazonses.com>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
	<1375896905-6074-5-git-send-email-kmo@daterainc.com>
	<0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
	<20130807183345.GA11612@kmo-pixel>
	<000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
	<20130807195733.GB11612@kmo-pixel>
	<000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
	<1377033546.32763.4.camel@haakon3.risingtidesystems.com>
	<00000140a14ae6bb-f0fca267-cdd6-4039-8c6b-f715999a83c5-000000@email.amazonses.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 14:32:55 +0000 Christoph Lameter <cl@linux.com> wrote:

> On Tue, 20 Aug 2013, Nicholas A. Bellinger wrote:
> 
> > On Thu, 2013-08-08 at 14:32 +0000, Christoph Lameter wrote:
> > > On Wed, 7 Aug 2013, Kent Overstreet wrote:
> > >
> > > > One thing that was bugging me - I was never able to figure out for sure
> > > > if smp_processor_id() returns a number in the range [0, nr_cpu_ids), at
> > > > least I couldn't find where it was documented - could you tell me if
> > > > that's true?
> > >
> > > I always assumed that it was in the range 0 ... nr_cpu_ids - 1 and that is
> > > the assumption under which the kernel code was written. Things would break
> > > horribly if smp_process_id would return nr_cpu_ids or higher.
> > >
> >
> > Hi guys,
> >
> > Just a heads up that I've put Kent's standalone percpu-ida patch (with
> > Christoph's recommend changes) into target-pending/for-next here:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=47bd524a5b3eb6429b058b8b562b45329ab2c9e7
> >
> > I've got a number of target patches that depend on this code for v3.12,
> > and a delay on this particular piece would be painful to endure..
> >
> > Sooo, please yell loudly if there is an objection to percpu-ida merge as
> > a completely standalone item, that does not effect any existing ida
> > code.
> 
> Well the performance is still going to be limited due to the spinlock in
> the percpu handling. You do not need the spinlock. Once preempt is off you
> should have exclusive access to the per cpu data.

The lock is needed so that one cpu can steal tags from another cpu's cache.
See (the needlessly inlined!) steal_tags().
