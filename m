Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3A3VY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:24:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab3A3VYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:24:24 -0500
Date: Wed, 30 Jan 2013 16:24:18 -0500
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH 10/14] dlm: don't use idr_remove_all()
Message-ID: <20130130212417.GJ24014@redhat.com>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
 <1359163872-1949-11-git-send-email-tj@kernel.org>
 <20130128155723.GC16789@redhat.com>
 <20130129151317.GA11609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129151317.GA11609@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:13:17AM -0500, David Teigland wrote:
> On Mon, Jan 28, 2013 at 10:57:23AM -0500, David Teigland wrote:
> > On Fri, Jan 25, 2013 at 05:31:08PM -0800, Tejun Heo wrote:
> > > idr_destroy() can destroy idr by itself and idr_remove_all() is being
> > > deprecated.
> > > 
> > > The conversion isn't completely trivial for recover_idr_clear() as
> > > it's the only place in kernel which makes legitimate use of
> > > idr_remove_all() w/o idr_destroy().  Replace it with idr_remove() call
> > > inside idr_for_each_entry() loop.  It goes on top so that it matches
> > > the operation order in recover_idr_del().
> > > 
> > > Only compile tested.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Christine Caulfield <ccaulfie@redhat.com>
> > > Cc: David Teigland <teigland@redhat.com>
> > > Cc: cluster-devel@redhat.com
> > > ---
> > > This patch depends on an earlier idr patch and given the trivial
> > > nature of the patch, I think it would be best to route these together
> > > through -mm.  Please holler if there's any objection.
> > 
> > Yes, that's good for me.  I'll grab the set and test the dlm bits.
> 
> Hi Tejun,
> Unfortunately, the list_for_each_entry doesn't seem to be clearing
> everything.  I've seen "warning: recover_list_count 39" at the end of that
> function.

I don't want to pretend to understand the internals of this idr code, but
it's not clear that idr_for_each is equivalent to idr_for_each_entry when
iterating through all id values.  The "++id" in idr_for_each_entry looks
like it could lead to some missed entries?  The comment about idr_get_next
returning the "next number to given id" sounds like an entry with an id of
"++id" would be missed.

Dave
