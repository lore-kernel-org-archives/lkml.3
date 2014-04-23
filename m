Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaDWWMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:12:36 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44752 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbaDWWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:12:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArNfAEM6WFN5LEcvPGdsb2JhbABagwaDZIUKowKZboEbFwMBAQEBODWCJQEBBAE6HCMQCAMOCgklDwUlAwcaE4g5B81oFxaOQgeEOQSYdJRIgVEr
Date: Thu, 24 Apr 2014 08:12:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Ivan Pantovic <gyro.ivan@gmail.com>
Cc: Speedy Milan <speedy.milan@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
 15x 4TB of HDDs (52TB)
Message-ID: <20140423221229.GS18672@dastard>
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
 <20140423021835.GI15995@dastard>
 <53576A7D.9020303@gmail.com>
 <20140423082538.GR18672@dastard>
 <53578632.1060005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53578632.1060005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:21:54AM +0200, Ivan Pantovic wrote:
> Hi Dave,
> 
> >xfs_db> freesp
> >   from      to extents  blocks    pct
> >      1       1   52463   52463   0.00
> >      2       3   73270  181394   0.01
> >      4       7  134526  739592   0.03
> >      8      15  250469 2870193   0.12
> >     16      31  581572 13465403   0.58
> >     32      63  692386 32096932   1.37
> >     64     127 1234204 119157757   5.09

So these are the small free spaces that lead to problems. There's
around 3 million small free space extents in the filesystems,
totalling 7% of the free space. That's quite a lot, and it means
that there is a good chance that small allocations will find these
small free spaces rather than find a large extent and start from
there.

> >    128     255   91015 16690243   0.71
> >    256     511   18977 6703895   0.29
> >    512    1023   12821 8611576   0.37
> >   1024    2047   23209 33177541   1.42
> >   2048    4095   43282 101126831   4.32
> >   4096    8191   12726 55814285   2.39
> >   8192   16383    2138 22750157   0.97
> >  16384   32767    1033 21790120   0.93
> >  32768   65535     433 19852497   0.85
> >  65536  131071     254 23052185   0.99
> > 131072  262143     204 37833000   1.62
> > 262144  524287     229 89970969   3.85
> > 524288 1048575     164 124210580   5.31
> >1048576 2097151     130 173193687   7.40
> >2097152 4194303      22 61297862   2.62
> >4194304 8388607      16 97070435   4.15
> >8388608 16777215      26 320475332  13.70
> >16777216 33554431       6 133282461   5.70
> >33554432 67108863      12 616939026  26.37
> >134217728 268435328       1 207504563   8.87

There are some large free spaces still, so your filesystem is still
in fairly good shape from that perspective. You can get a better
idea of whether the fragmentation is isolated to specific AGs by
using the freesp -a <agno> command to dump each individual freespace
index. You can then use the xfs_bmap command to find files that are
located in those fragmented AGs.

The only way to fix freespace fragmentation right now is to remove
the extents that are chopping up the freespace. Moving data around
on a per-directory basis (e.g. cp the regular files to a temp
directory, rename them back over the original) is one way of
acheiving this, though you have to carefully control the destination
AG and make sure it is an AG that is made up mostly of contiguous
freespace to begin with....

But you only really need to do this if you are seeing ongoing
problems. Often just freeing up space in the filesystem will fix the
problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
