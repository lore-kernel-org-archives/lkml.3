Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab3EOJBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:01:32 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64824 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab3EOJBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:01:30 -0400
Date: Wed, 15 May 2013 02:00:53 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130515090053.GC16164@moria.home.lan>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514145932.GA6607@mtj.dyndns.org>
 <20130514152836.GA21972@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514152836.GA21972@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 05:28:36PM +0200, Oleg Nesterov wrote:
> On 05/14, Tejun Heo wrote:
> >
> > > +int percpu_ref_tryget(struct percpu_ref *ref)
> > > +{
> > > +	int ret = 1;
> > > +
> > > +	preempt_disable();
> > > +
> > > +	if (!percpu_ref_dead(ref))
> > > +		percpu_ref_get(ref);
> > > +	else
> > > +		ret = 0;
> > > +
> > > +	preempt_enable();
> > > +
> > > +	return ret;
> > > +}
> ...
> > BTW, why is this
> > function necessary?  What's the use case?
> 
> Yes, I was wondering too.
> 
> And please note that this code _looks_ wrong, percpu_ref_get() still
> can increment ref->count.

Yeah I see what you mean, I changed how ret is set.

But also splitting tryget() and count() out into another patch to go
with the module conversion.

> Hmm. Just noticed this comment above percpu_ref_kill()
> 
> 	* The caller must issue a synchronize_rcu()/call_rcu() before calling
> 	* percpu_ref_put() to drop the initial ref.
> 
> Really?

That's also left over from the dynamic version, whoops.
