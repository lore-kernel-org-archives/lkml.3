Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199Ab3DKSKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:10:09 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030179Ab3DKSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:10:08 -0400
Date: Thu, 11 Apr 2013 20:10:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
Message-ID: <20130411181004.GK16732@two.firstfloor.org>
References: <51662D5B.3050001@hitachi.com>
 <20130411134915.GH16732@two.firstfloor.org>
 <1365693788-djsd2ymu-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365693788-djsd2ymu-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:23:08AM -0400, Naoya Horiguchi wrote:
> On Thu, Apr 11, 2013 at 03:49:16PM +0200, Andi Kleen wrote:
> > > As a result, if the dirty cache includes user data, the data is lost,
> > > and data corruption occurs if an application uses old data.
> > 
> > The application cannot use old data, the kernel code kills it if it
> > would do that. And if it's IO data there is an EIO triggered.
> > 
> > iirc the only concern in the past was that the application may miss
> > the asynchronous EIO because it's cleared on any fd access. 
> > 
> > This is a general problem not specific to memory error handling, 
> > as these asynchronous IO errors can happen due to other reason
> > (bad disk etc.) 
> > 
> > If you're really concerned about this case I think the solution
> > is to make the EIO more sticky so that there is a higher chance
> > than it gets returned.  This will make your data much more safe,
> > as it will cover all kinds of IO errors, not just the obscure memory
> > errors.
> 
> I'm interested in this topic, and in previous discussion, what I was said
> is that we can't expect user applications to change their behaviors when
> they get EIO, so globally changing EIO's stickiness is not a great approach.

Not sure. Some of the current behavior may be dubious and it may 
be possible to change it. But would need more analysis.

I don't think we're concerned that much about "correct" applications,
but more ones that do not check everything. So returning more
errors should be safer.

For example you could have a sysctl that enables always stick
IO error -- that keeps erroring until it is closed.

> I'm working on a new pagecache tag based mechanism to solve this.
> But it needs time and more discussions.
> So I guess Tanino-san suggests giving up on dirty pagecache errors
> as a quick solution.

A quick solution would be enabling panic for any asynchronous IO error.
I don't think the memory error code is the right point to hook into.

-Andi
