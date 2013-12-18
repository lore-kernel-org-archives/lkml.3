Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3LRVjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:39:47 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54168 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3LRVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:39:44 -0500
Date: Wed, 18 Dec 2013 16:39:36 -0500
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
Message-ID: <20131218213936.GA8218@mtj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <4108657.rimrPRbHDY@vostro.rjw.lan>
 <20131218111726.GB3808@htj.dyndns.org>
 <3767261.syB7gLdVqQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3767261.syB7gLdVqQ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Wed, Dec 18, 2013 at 10:48:31PM +0100, Rafael J. Wysocki wrote:
> > I see.  In the long term, I think the right thing to do is making the
> > freezer interface more specific so that only the ones which actually
> > need it do so explicitly.  Right now, kernel freezables are
> > conceptually at a very high level - it's a global task attribute and a
> > major knob in workqueue.  I suppose most of that is historical but by
> > perpetuating the model we're encouraging misuse of freezer in large
> > swaths of the kernel.  Even in this specific case, both writeback and
> > jbd workers have no fundamental reason to be freezable and yet
> > they're, eventually developing into totally unnecessary deadlocks.
> 
> You're right, but I'm not sure how we can make the interface for workqueues
> more specific, for example.  I guess we can simply drop create_freezable_workqueue()
> so that whoever wants to create a freezable workqueue has to use the right
> combination of flags.  Can we make it more specific than that?
> 
> BTW, pm_start_workqueue(), which is a legitimate user, doesn't even use that macro. :-)

Yeah, we can just rip out the whole freezer support and let the
caller's pm notification hooks implement it by doing

	workqueue_set_max_active(wq, 0);
	flush_workqueue(wq);

when it needs to "freeze" the workqueue and then reverse it by doing
the following.

	workqueue_set_max_active(wq, WQ_DFL_ACTIVE);

It'll be a bit more code in the specific users but given the
specificity of the usage I think that's the appropriate way to do it.
It'll drop quite a bit of complexity from the core freezer and
workqueue code paths too.

Thanks.

-- 
tejun
