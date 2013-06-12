Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3FLTSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab3FLTSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:18:47 -0400
Date: Wed, 12 Jun 2013 21:14:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130612191425.GA7098@redhat.com>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com> <20130612170835.GA4682@redhat.com> <20130612175915.GB6151@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612175915.GB6151@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Kent Overstreet wrote:
>
> So we'd need at least an atomic counter, but a bitmap isn't really any
> more trouble and it lets us skip most of the percpu lists that are empty

Yes, yes, I understand.

> - which should make a real difference in scalability to huge nr_cpus.

But this is not obvious to me. I mean, I am not sure I understand why
this all is "optimal". In particular, I do not really understand
"while (cpus_have_tags-- * TAG_CPU_SIZE > pool->nr_tags / 2)" in
steal_tags(), even if "the workload should not span more cpus than
nr_tags / 128" is true. I guess this connects to "we guarantee that
nr_tags / 2 can always be allocated" and we do not want to call
steal_tags() too often/otherwise, but cpus_have_tags * TAG_CPU_SIZE
can easily overestimate the number of free tags.

But I didn't read the patch carefully, and it is not that I think I
can suggest something better.

In short: please ignore ;)

> > > +enum {
> > > +	TAG_FAIL	= -1U,
> > > +	TAG_MAX		= TAG_FAIL - 1,
> > > +};
> >
> > This can probably go to .c, and it seems that TAG_MAX is not needed.
> > tag_init() can check "nr_tags >= TAG_FAIL" instead.
>
> Users need TAG_FAIL to check for allocation failure.

Ah, indeed, !__GFP_WAIT...

Hmm. but why gfp_t? why not "bool atomic" ?

Probably this is because you expect that most callers should have
gfp anyway. Looks a bit strange but I won't argue.

> > > +		if (nr_free) {
> > > +			memcpy(tags->freelist,
> > > +			       remote->freelist,
> > > +			       sizeof(unsigned) * nr_free);
> > > +			smp_mb();
> > > +			remote->nr_free = 0;
> > > +			tags->nr_free = nr_free;
> > > +			return true;
> > > +		} else {
> > > +			remote->nr_free = 0;
> > > +		}
> >
> > Both branches clear remote->nr_free.
>
> Yeah, but clearing it has to happen after the memcpy() and the smp_mb().

Yes, yes, we need mb() between memcpy() and "remote = 0",

> I couldn't find a way to combine them that I liked, but if you've got
> any suggestions I'm all ears.

Please ignore. Somehow I missed the fact we need to return or continue,
so we need "else" or another check.

Oleg.

