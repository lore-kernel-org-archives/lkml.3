Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab3GaNfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:35:12 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33626 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759822Ab3GaNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:35:09 -0400
Date: Wed, 31 Jul 2013 08:35:07 -0500
From: Ben Myers <bpm@sgi.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        xfstests <xfs@oss.sgi.com>
Subject: Re: [PATCH v2] xfs: introduce object readahead to log recovery
Message-ID: <20130731133506.GT3111@sgi.com>
References: <1375178347-29037-1-git-send-email-zwu.kernel@gmail.com>
 <20130730231155.GM13468@dastard>
 <CAEH94LjXRG755cTsuGN_R0V+J9aRvEJaS+0aQSAOkNWL1UbXTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94LjXRG755cTsuGN_R0V+J9aRvEJaS+0aQSAOkNWL1UbXTA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Zhi,

On Wed, Jul 31, 2013 at 12:07:32PM +0800, Zhi Yong Wu wrote:
> On Wed, Jul 31, 2013 at 7:11 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Jul 30, 2013 at 05:59:07PM +0800, zwu.kernel@gmail.com wrote:
> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >>
> >>   It can take a long time to run log recovery operation because it is
> >> single threaded and is bound by read latency. We can find that it took
> >> most of the time to wait for the read IO to occur, so if one object
> >> readahead is introduced to log recovery, it will obviously reduce the
> >> log recovery time.
> >>
> >> Log recovery time stat:
> >>
> >>           w/o this patch        w/ this patch
> >>
> >> real:        0m15.023s             0m7.802s
> >> user:        0m0.001s              0m0.001s
> >> sys:         0m0.246s              0m0.107s
> >>
> >> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> >> ---
> >>  fs/xfs/xfs_log_recover.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--
> >>  fs/xfs/xfs_log_recover.h |   2 +
> >>  2 files changed, 159 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >> index 7681b19..029826f 100644
> >> --- a/fs/xfs/xfs_log_recover.c
> >> +++ b/fs/xfs/xfs_log_recover.c
> >> @@ -3116,6 +3116,111 @@ xlog_recover_free_trans(
> >>       kmem_free(trans);
> >>  }
> >>
> >> +STATIC void
> >> +xlog_recover_buffer_ra_pass2(
> >> +     struct xlog                     *log,
> >> +     struct xlog_recover_item        *item)
> >> +{
> >> +     xfs_buf_log_format_t    *buf_f = item->ri_buf[0].i_addr;
> >> +     xfs_mount_t             *mp = log->l_mp;
> >
> >         struct xfs_buf_log_format
> >         struct xfs_mount
> Why? *_t is also used in a lot of other places.

It is just a general style preference for using the struct instead of the _t in
the xfs codebase.  Over the course of the past few years they've slowly been
converted in this direction, and we prefer not to add any more _t if it can be
avoided.

-Ben
