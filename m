Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3JUQhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3JUQhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:37:51 -0400
Date: Mon, 21 Oct 2013 12:37:32 -0400
From: Dave Jones <davej@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Jones <davej@fedoraproject.org>, Theodore Tso <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [ 05/11] ext4: fix memory leak in xattr
Message-ID: <20131021163732.GA16581@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Dave Jones <davej@fedoraproject.org>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>
References: <20131018195049.069623827@linuxfoundation.org>
 <20131018195049.436649568@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018195049.436649568@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 12:53:34PM -0700, Greg Kroah-Hartman wrote:
 > 3.4-stable review patch.  If anyone has any objections, please let me know.
 > 
 > ------------------
 > 
 > From: Dave Jones <davej@redhat.com>
 > 
 > commit 6e4ea8e33b2057b85d75175dd89b93f5e26de3bc upstream.
 > 
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
 > Signed-off-by: Dave Jones <davej@fedoraproject.org>
 > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
 > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
 > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm still waiting to hear if we also need this..

Ted ?

-- 

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

