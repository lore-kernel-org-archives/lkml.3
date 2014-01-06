Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbaAFVre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:47:34 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35127 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbaAFVr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:47:29 -0500
Date: Mon, 6 Jan 2014 13:47:26 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140106214726.GD9037@kmo>
References: <20131231033827.GA31994@kernel.org>
 <20140104210804.GA24199@kmo-pixel>
 <20140105131300.GB4186@kernel.org>
 <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CB1783.4050205@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:52:19PM -0700, Jens Axboe wrote:
> On 01/06/2014 01:46 PM, Kent Overstreet wrote:
> > On Sun, Jan 05, 2014 at 09:13:00PM +0800, Shaohua Li wrote:
> 
> >>> - we explicitly don't guarantee that all
> >>> the tags will be available for allocation at any given time, only half
> >>> of them. 
> >>
> >> only half of the tags can be used? this is scaring. Of course we hope all tags
> >> are available.
> > 
> > No: that behaviour is explicitly documented and it's the behaviour we want.
> 
> That is going to end horribly, for the cases (ie most cases) where we
> really want to be able to use all tags. If we can't support that
> reliably or in a fast manner with percpu ida, then that's pretty close
> to a show stopper. And I suspect that will be the case for most use
> cases. We can't just feasibly throw away half of the tag space, that's
> crazy.

Sounds like we're coming at this from different use cases, maybe we're going to
need to add some flexibility for different use cases.

For background, I wrote this code for SSDs where the you get 16 bits for the tag
ID; we really don't want the queue to be anywhere near that deep so potentially
wasting half of however many tags you have is no big deal.

If you have a device where the max tag id is small enough that you really do
need to use the entire tag space... yeah, that's going to be an issue.

> But that wont work at all. To take a concrete example, lets assume the
> device is some sort of NCQ. We have 0..31 tags. If we throw away half of
> those tags, we're at 16. You can't double the tag space in software.

Ok, so I hadn't really given any thought to that kind of use case; insofar as I
had I would've been skeptical percpu tag allocation made sense for 32 different
tags at all.

We really don't want to screw over the users that aren't so constrained by the
size of their tag space; there really is a huge performance tradeoff here
(otherwise you're stealing tags and bouncing cachelines for _every_ tag
allocation when the queue is full, and your percpu tag allocation is no longer
very percpu).

I'm not sure what the best strategy is for NCQ-type max nr_tags, though -
thoughts?

Easy thing to do for now is just to add another parameter to percpu_ida_init()
for the number of tags that are allowed to sit unused on other cpu's freelists -
users that have large relatively unbounded nr_tags can set that to nr_tags / 2,
for NCQ you'd set it to 0.

I suspect we can do better for NCQ though, w.r.t. worst case performance.
