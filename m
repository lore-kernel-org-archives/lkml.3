Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3HVUK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:10:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab3HVUK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:10:56 -0400
Date: Thu, 22 Aug 2013 16:10:53 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm ioctl: allow change device target type to error
Message-ID: <20130822201052.GA22556@redhat.com>
References: <5214CC25.1070307@oracle.com>
 <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
 <20130821150547.GA10987@redhat.com>
 <52157A08.7080701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52157A08.7080701@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21 2013 at 10:40pm -0400,
Joe Jin <joe.jin@oracle.com> wrote:

> On 08/21/13 23:06, Mike Snitzer wrote:
> > On Wed, Aug 21 2013 at 10:48am -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> >>
> >>
> >> On Wed, 21 Aug 2013, Joe Jin wrote:
> >>
> >>> commit a5664da "dm ioctl: make bio or request based device type immutable"
> >>> prevented "dmsetup wape_table" change the target type to "error".
> >>
> >> That commit a5664da is there for a reason (it is not possible to change 
> >> bio-based device to request-based and vice versa) and I don't really see 
> >> how this patch is supposed to work.
> >>
> >> If there are bios that are in flight and that already passed through 
> >> blk_queue_bio, and you change the device from request-based to bio-based, 
> >> what are you going to do with them? - The patch doesn't do anything about 
> >> it.
> >>
> >> A better approach would be to create a new request-based target "error-rq" 
> >> and change the multipath target to "error-rq" target. That way, you don't 
> >> have to change device type from request based to bio based.
> > 
> > My thoughts _exactly_.  This patch is very confused.
> > 
> > Joe, what are you looking to be able to do?  Switch a dm-multipath
> > device to error?  Or allowing switching a target that has
> > DM_TARGET_IMMUTABLE flag set to be switched to error target?
> > 
> > The latter restriction was introduced with commit 36a0456fb ("dm table:
> > add immutable feature").
> 
> Hi Mike,
> 
> So far dmsetup support wipe_table:
> https://bugzilla.redhat.com/show_bug.cgi?id=742607
> As description in the bug Doc Text, "This could be useful, for example, 
> if a long-running process keeps a device open after it has finished using
> it and you need to release the underlying devices before that process exits."
> 
> After apply the commit, wipe_table no long works.

Well, it never _really_ worked even before that commit because it was
switching from request-based to bio-based.  Some queued requests
could've easily slipped through the cracks.

But I now understand what it is you want to be able to do.
