Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3EOIVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:21:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43398 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3EOIVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:21:46 -0400
Date: Wed, 15 May 2013 01:21:09 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130515082109.GA16164@moria.home.lan>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514135101.GB17587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514135101.GB17587@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 03:51:01PM +0200, Oleg Nesterov wrote:
> On 05/13, Kent Overstreet wrote:
> >
> > +int percpu_ref_kill(struct percpu_ref *ref)
> > +{
> > +	unsigned __percpu *pcpu_count;
> > +	unsigned __percpu *old;
> > +	unsigned count = 0;
> > +	int cpu;
> > +
> > +	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> > +
> > +	do {
> > +		if (!pcpu_count)
> > +			return 0;
> > +
> > +		old = pcpu_count;
> > +		pcpu_count = cmpxchg(&ref->pcpu_count, old, NULL);
> > +	} while (pcpu_count != old);
> 
> This is purely cosmetic, feel free to ignore. But afaics all we
> need is
> 
> 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
> 	if (!cmpxchg(&ref->pcpu_count, pcpu_count, NULL))
> 		return 0;

Whoops, yep. I was ripping out the dynamic stuff from my dynamic percpu
refcount code and missed that bit.
