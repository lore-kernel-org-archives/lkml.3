Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaB0Bbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:31:38 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36904 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaB0Bbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:31:34 -0500
Date: Wed, 26 Feb 2014 17:30:35 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Chinner <david@fromorbit.com>
cc: Hugh Dickins <hughd@google.com>, Namjae Jeon <linkinjeon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, "Theodore Ts'o" <tytso@mit.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, viro@zeniv.linux.org.uk,
        bpm@sgi.com, adilger.kernel@dilger.ca, jack@suse.cz,
        mtk.manpages@gmail.com, lczerner@redhat.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
 for fallocate
In-Reply-To: <20140227012431.GW13647@dastard>
Message-ID: <alpine.LSU.2.11.1402261729020.29071@eggly.anvils>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com> <20140224005710.GH4317@dastard> <20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au> <20140225041346.GA29907@dastard> <alpine.LSU.2.11.1402251217030.2380@eggly.anvils>
 <20140226011347.GL13647@dastard> <alpine.LSU.2.11.1402251856060.1114@eggly.anvils> <20140226064224.GU13647@dastard> <alpine.LSU.2.11.1402261454270.2808@eggly.anvils> <20140227012431.GW13647@dastard>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Dave Chinner wrote:
> On Wed, Feb 26, 2014 at 03:08:58PM -0800, Hugh Dickins wrote:
> > 
> > Thanks for explaining more, I was just about to acknowledge what a good
> > example that is.  Indeed, it seems not unreasonable to be editing the
> > earlier part of a file while the later part of it is still streaming in.
> > 
> > But damn, it now occurs to me that there's still a problem at the
> > streaming end: its file write offset won't be updated to reflect
> > the collapse, so there would be a sparse hole at that end.  And
> > collapse returns -EPERM if IS_APPEND(inode).
> 
> Well, we figure that most applications won't be using append only
> inode flags for files that they know they want to edit at random
> offsets later on. ;)
> 
> However, I can see how DVR apps would use open(O_APPEND) to obtain
> the fd they write to because that sets the write position to the EOF
> on every write() call (i.e. in generic_write_checks()). And collapse
> range should behave sanely with this sort of usage.
> 
> e.g. XFS calls generic_write_checks() after it has taken the IO lock
> to set the current write position to EOF. Hence it will be correctly
> serialised against collapse range calls and so O_APPEND writes will
> not leave sparse holes if collapse range calls are interleaved with
> the write stream....

Right, I was getting confused between O_APPEND and APPEND_Only!
Thanks, I'm back to being convinced by your example.

Hugh
