Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3JHCHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:07:32 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44285 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3JHCHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:07:30 -0400
X-AuditID: 9c93017d-b7c3aae000004019-5d-525368e0668a
Date: Tue, 8 Oct 2013 11:08:47 +0900
From: Minchan Kim <minchan@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dhaval.giani@gmail.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 05/14] vrange: Add new vrange(2) system call
Message-ID: <20131008020847.GH25780@bbox>
References: <1380761503-14509-6-git-send-email-john.stultz@linaro.org>
 <52533C12.9090007@zytor.com>
 <5253404D.2030503@linaro.org>
 <52534331.2060402@zytor.com>
 <52534692.7010400@linaro.org>
 <525347BE.7040606@zytor.com>
 <525349AE.1070904@linaro.org>
 <52534AEC.5040403@zytor.com>
 <20131008001306.GD25780@bbox>
 <52535EE1.3060700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52535EE1.3060700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 06:24:49PM -0700, H. Peter Anvin wrote:
> On 10/07/2013 05:13 PM, Minchan Kim wrote:
> >>
> >> The point is that MADV_DONTNEED is very similar in that sense,
> >> especially if allowed to be lazy.  It makes a lot of sense to permit
> >> both scrubbing modes orthogonally.
> >>
> >> The point you're making has to do with withdrawal of permission to flush
> >> on demand, which is a result of having the lazy mode (ongoing
> >> permission) and having to be able to withdraw such permission.
> > 
> > I'm sorry I could not understand what you wanted to say.
> > Could you elaborate a bit?
> > 
> 
> Basically, you need this because of MADV_LAZY or the equivalent, so it
> would be applicable to a similar variant of madvise().
> 
> As such I would suggest that an madvise4() call would be appropriate.
> 
> 	-hpa

Maybe, int madvise5(addr, length, MADV_DONTNEED|MADV_LAZY|MADV_SIGBUS,
        &purged, &ret);

Another reason to make it hard is that madvise(2) is tight coupled with
with vmas split/merge. It needs mmap_sem's write-side lock and it hurt
anon-vrange test performance much heavily and userland might want to
make volatile range with small unit like "page size" so it's undesireable
to make it with vma. Then, we should filter out to avoid vma split/merge
in implementation if only MADV_LAZY case? Doable but it could make code
complicated and lost consistency with other variant of madvise.

I think it would be better to implement MADV_FREE if you really want
MADV_LAZY(http://www.unix.com/man-page/FreeBSD/2/madvise/) which is
differnt with volatile range and vrange is more advanced function, IMHO
because MADV_FREE's cost would be proporational to range size due to
page table/page descriptor operations.

-- 
Kind regards,
Minchan Kim
