Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3J3Sdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab3J3Sdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:33:49 -0400
Date: Wed, 30 Oct 2013 14:33:39 -0400
From: Dave Jones <davej@redhat.com>
To: sandeen@redhat.com, tytso@mit.edu,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: Fix up bh refcount in xattr code.
Message-ID: <20131030183339.GA11641@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, sandeen@redhat.com,
	tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<post kernel-summit re-ping>

On Tue, Oct 15, 2013 at 02:11:42PM -0400, Dave Jones wrote:
 > On Mon, Oct 14, 2013 at 01:31:23PM -0700, gregkh@linuxfoundation.org wrote:
 >  
 >  > If we take the 2nd retry path in ext4_expand_extra_isize_ea, we
 >  > potentionally return from the function without having freed these
 >  > allocations.  If we don't do the return, we over-write the previous
 >  > allocation pointers, so we leak either way.
 >  > 
 >  > Spotted with Coverity.
 >  > 
 >  > [ Fixed by tytso to set is and bs to NULL after freeing these
 >  >   pointers, in case in the retry loop we later end up triggering an
 >  >   error causing a jump to cleanup, at which point we could have a double
 >  >   free bug. -- Ted ]
 >  > 
 >  > ---
 >  >  fs/ext4/xattr.c |    2 ++
 >  >  1 file changed, 2 insertions(+)
 >  > 
 >  > --- a/fs/ext4/xattr.c
 >  > +++ b/fs/ext4/xattr.c
 >  > @@ -1271,6 +1271,8 @@ retry:
 >  >  				    s_min_extra_isize) {
 >  >  					tried_min_extra_isize++;
 >  >  					new_extra_isize = s_min_extra_isize;
 >  > +					kfree(is); is = NULL;
 >  > +					kfree(bs); bs = NULL;
 >  >  					goto retry;
 >  >  				}
 > 
 > Because this was different in my local tree I ended up looking it over again
 > when I rebased. Do we also need the patch below ?
 > 
 > 	Dave
 > 
 > If we take the retry path here, we end up potentially overwriting bh, leaving
 > it with an elevated reference count.
 > 
 > Signed-off-by: Dave Jones <davej@fedoraproject.org>
 > 
 > diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
 > index 03e9beb..1423c48 100644
 > --- a/fs/ext4/xattr.c
 > +++ b/fs/ext4/xattr.c
 > @@ -1352,6 +1352,7 @@ retry:
 >  					new_extra_isize = s_min_extra_isize;
 >  					kfree(is); is = NULL;
 >  					kfree(bs); bs = NULL;
 > +					brelse(bh);
 >  					goto retry;
 >  				}
 >  				error = -1;
---end quoted text---
