Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3GZLf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:35:29 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48938 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006Ab3GZLf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:35:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkIAMxd8lF5LPxH/2dsb2JhbABagwa5F4UygRUXdIIkAQEEAScTHCMQCAMVAwklDwUNGAMhE4d+AwkFsCANiF4WjH+CaAeEBQOVdoFojCeFJoMmKg
Date: Fri, 26 Jul 2013 21:35:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] xfs: introduce object readahead to log recovery
Message-ID: <20130726113521.GM13468@dastard>
References: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
 <20130726025009.GE21982@dastard>
 <CAEH94Lh-UCCEs7hQi_t5v+X+ER1DH9dCtjr6e9GVNX5KJ-f1hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94Lh-UCCEs7hQi_t5v+X+ER1DH9dCtjr6e9GVNX5KJ-f1hQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:36:15PM +0800, Zhi Yong Wu wrote:
> Dave,
> 
> All comments are good to me, and will be applied to next version, thanks a lot.
> 
> On Fri, Jul 26, 2013 at 10:50 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jul 25, 2013 at 04:23:39PM +0800, zwu.kernel@gmail.com wrote:
> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >>
> >>   It can take a long time to run log recovery operation because it is
> >> single threaded and is bound by read latency. We can find that it took
> >> most of the time to wait for the read IO to occur, so if one object
> >> readahead is introduced to log recovery, it will obviously reduce the
> >> log recovery time.
> >>
> >>   In dirty log case as below:
> >>     data device: 0xfd10
> >>     log device: 0xfd10 daddr: 20480032 length: 20480
> >>
> >>     log tail: 7941 head: 11077 state: <DIRTY>
> >
> > That's only a small log (10MB). As I've said on irc, readahead won't
> Yeah, it is one 10MB log, but how do you calculate it based on the above info?

length = 20480 blocks. 20480 * 512 = 10MB....

> > And the recovery time from this is between 15-17s:
> >
> > ....
> >     log device: 0xfd20 daddr: 107374182032 length: 4173824
> >                                                    ^^^^^^^ almost 2GB
> >         log tail: 19288 head: 264809 state: <DIRTY>
> > ....
> > real    0m17.913s
> > user    0m0.000s
> > sys     0m2.381s
> >
> > And runs at 3-4000 read IOPs for most of that time. It's largely IO
> > bound, even on SSDs.
> >
> > With your patch:
> >
> > log tail: 35871 head: 308393 state: <DIRTY>
> > real    0m12.715s
> > user    0m0.000s
> > sys     0m2.247s
> >
> > And it peaked at ~5000 read IOPS.
> How do you know its READ IOPS is ~5000?

Other monitoring. iostat can tell you this, though I use PCP...

> > Ok, so you've based the readahead on the transaction item list
> > having a next pointer. What I think you should do is turn this into
> > a readahead queue by moving objects to a new list. i.e.
> >
> >         list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
> >
> >                 case XLOG_RECOVER_PASS2:
> >                         if (ra_qdepth++ >= MAX_QDEPTH) {
> >                                 recover_items(log, trans, &buffer_list, &ra_item_list);
> >                                 ra_qdepth = 0;
> >                         } else {
> >                                 xlog_recover_item_readahead(log, item);
> >                                 list_move_tail(&item->ri_list, &ra_item_list);
> >                         }
> >                         break;
> >                 ...
> >                 }
> >         }
> >         if (!list_empty(&ra_item_list))
> >                 recover_items(log, trans, &buffer_list, &ra_item_list);
> >
> > I'd suggest that a queue depth somewhere between 10 and 100 will
> > be necessary to keep enough IO in flight to keep the pipeline full
> > and prevent recovery from having to wait on IO...
> Good suggestion, will apply it to next version, thanks.

FWIW, I hacked a quick test of this into your patch here and a depth
of 100 brought the reocvery time down to under 8s. For other
workloads which have nothing but dirty inodes (like fsmark) a depth
of 100 drops the recovery time from ~100s to ~25s, and the iop rate
is peaking at well over 15,000 IOPS. So we definitely want to queue
up more than a single readahead...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
