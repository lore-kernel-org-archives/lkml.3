Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3LRLRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:17:33 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:57516 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3LRLRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:17:30 -0500
Date: Wed, 18 Dec 2013 06:17:26 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131218111726.GB3808@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <8951916.gd5Uu6GpK1@vostro.rjw.lan>
 <20131217123457.GD29989@htj.dyndns.org>
 <4108657.rimrPRbHDY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4108657.rimrPRbHDY@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Wed, Dec 18, 2013 at 01:35:13AM +0100, Rafael J. Wysocki wrote:
> So do I understand correctly that you're talking about kernel threads/worqueues
> freezing below?

Yeap, I'm strictly talking about kernel freezables.

> > So, are you saying it's really about giving device drivers easy way to
> > implement suspend/resume?
> 
> Well, that's a side effect rather than a recommeded interface.  A *few* pieces
> of code need to freeze kernel threads/workqueues, but they should know who they
> are and they really really should know *why* they need that (the above-mentioned
> runtime PM workqueue is one example).  The rest is just doing that because they
> can, which may not be entirely reasonable (or because they did that in the past
> and the original author is not responsive and everyone else does not dare to try
> removing that).

I see.  In the long term, I think the right thing to do is making the
freezer interface more specific so that only the ones which actually
need it do so explicitly.  Right now, kernel freezables are
conceptually at a very high level - it's a global task attribute and a
major knob in workqueue.  I suppose most of that is historical but by
perpetuating the model we're encouraging misuse of freezer in large
swaths of the kernel.  Even in this specific case, both writeback and
jbd workers have no fundamental reason to be freezable and yet
they're, eventually developing into totally unnecessary deadlocks.

> They were a lot more of that to start with really.  We removed quite a number
> of try_to_freeze() instances from the kernel a few years ago, but apparently
> people are taking shortcuts.

Great, so we're at least headed towards the right direction.

> The rule should be to require patch submitters to put in comments explaining
> why they need their kernel threads/workqueues to be freezable and generally
> there should be no such things in drivers.

I'm not so sure whether that's something which can be effectively
enforced given the current high visibility and confusion around
freezer.  I think the only way to get this under control is weed out
the current spurious users actively, deprecate the existing interface
and switch the real ones to something a lot more specific.

Thanks.

-- 
tejun
