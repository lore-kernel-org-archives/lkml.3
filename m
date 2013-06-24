Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3FXVaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:30:02 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7790 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860Ab3FXV36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:29:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQOAHi5yFF5LPX0/2dsb2JhbABagwmDFrd5hSsEAYELF3SCIwEBBTocIxAIAxgJJQ8FJQMhE4gNuwIWjhyBHQeDYwOXQpFFgyIq
Date: Tue, 25 Jun 2013 07:29:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <esandeen@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "a.sangwan@samsung.com" <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Message-ID: <20130624212953.GS29338@dastard>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard>
 <20130624070656.GA20166@infradead.org>
 <CAKYAXd-hJ71+zDn5c2ABb2J-zL=kb2M=GNzOWNHkS7-C4KXEzA@mail.gmail.com>
 <C0F0BC787567C848B2C90989451123DA2363CDB7@ATLEXMBX4.ARRS.ARRISI.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C0F0BC787567C848B2C90989451123DA2363CDB7@ATLEXMBX4.ARRS.ARRISI.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:37:57AM +0000, Sidorov, Andrei wrote:
> On 24.06.2013 13:36, Namjae Jeon wrote:
> > Currently, we can try implementing dave's suggesstion of introducing a
> > new flag FALLOC_FL_COLLAPSE_RANGE for falloctae instead of individual
> > ioctls for both XFS and EXT4. Thanks.
> 
> Hi,
> 
> Currently PUNCH_HOLE requires KEEP_SIZE to be set as well. I think there
> is no need to invent COLLAPSE_RANGE, but instead fallocate should
> support PUNCH_HOLE without KEEP_SIZE. However I'm not sure that putting
> block alignment restriction is a right way to go.

No, it doesn't make sense. Punching a hole *leaves a hole* in the
file, not that all the data on the high side of the region being
punched out is *moved* into the hole that was punched out. i.e.
PUNCH_HOLE does not affect data outside the range of the holebeing
punched, while COLLAPSE_RANGE significantly affects data in the
file outside the range being removed. Hence that are not the same
operation at all.

FYI, what KEEP_SIZE means for punching a hole is that preserve the
file size is explicitly required by the operation. It's
documentation of the expected behaviour more than anything.  i.e if
the hole is at the end of the file, punching a hole won't -truncate-
the file.  Also, you can punch holes *beyond EOF* (so you can punch
blocks allocated beyond EOF) and KEEP_SIZE means that it doesn't
change the file size when it does this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
