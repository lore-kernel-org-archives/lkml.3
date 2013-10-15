Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3JOSLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793Ab3JOSLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:11:52 -0400
Date: Tue, 15 Oct 2013 14:11:42 -0400
From: Dave Jones <davej@redhat.com>
To: sandeen@redhat.com, tytso@mit.edu,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Patch "ext4: fix memory leak in xattr" has been added to the
 3.0-stable tree
Message-ID: <20131015181142.GA23581@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, sandeen@redhat.com,
	tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>
References: <13817826832984@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13817826832984@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 01:31:23PM -0700, gregkh@linuxfoundation.org wrote:
 
 > If we take the 2nd retry path in ext4_expand_extra_isize_ea, we
 > potentionally return from the function without having freed these
 > allocations.  If we don't do the return, we over-write the previous
 > allocation pointers, so we leak either way.
 > 
 > Spotted with Coverity.
 > 
 > [ Fixed by tytso to set is and bs to NULL after freeing these
 >   pointers, in case in the retry loop we later end up triggering an
 >   error causing a jump to cleanup, at which point we could have a double
 >   free bug. -- Ted ]
 > 
 > ---
 >  fs/ext4/xattr.c |    2 ++
 >  1 file changed, 2 insertions(+)
 > 
 > --- a/fs/ext4/xattr.c
 > +++ b/fs/ext4/xattr.c
 > @@ -1271,6 +1271,8 @@ retry:
 >  				    s_min_extra_isize) {
 >  					tried_min_extra_isize++;
 >  					new_extra_isize = s_min_extra_isize;
 > +					kfree(is); is = NULL;
 > +					kfree(bs); bs = NULL;
 >  					goto retry;
 >  				}

Because this was different in my local tree I ended up looking it over again
when I rebased. Do we also need the patch below ?

	Dave

If we take the retry path here, we end up potentially overwriting bh, leaving
it with an elevated reference count.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 03e9beb..1423c48 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1352,6 +1352,7 @@ retry:
 					new_extra_isize = s_min_extra_isize;
 					kfree(is); is = NULL;
 					kfree(bs); bs = NULL;
+					brelse(bh);
 					goto retry;
 				}
 				error = -1;
