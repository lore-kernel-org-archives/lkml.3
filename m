Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaHHPyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:54:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56629 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbaHHPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:54:09 -0400
Date: Fri, 8 Aug 2014 16:54:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bug introduced in 3b93f911d5
Message-ID: <20140808155407.GT18016@ZenIV.linux.org.uk>
References: <435E586E-2045-4070-8FA7-8DF468280E3C@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <435E586E-2045-4070-8FA7-8DF468280E3C@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 12:11:39AM +0100, Anton Altaparmakov wrote:
> Hi Al,
> 
> Was just looking at __generic_file_write_iter() and found a bug in the code that you added in 3b93f911d5.
> 
> Consider the case where generic_file_direct_write() returns a partial write, i.e. written > 0 && written < count.
> 
> Also consider that the following generic_perform_write() fails with an error, i.e. status < 0.

*nod*

What we ought to do, AFAICS, is this:

diff --git a/mm/filemap.c b/mm/filemap.c
index 900edfa..8163e04 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2584,7 +2584,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * that this differs from normal direct-io semantics, which
 		 * will return -EFOO even if some bytes were written.
 		 */
-		if (unlikely(status < 0) && !written) {
+		if (unlikely(status < 0)) {
 			err = status;
 			goto out;
 		}

Note that we return written ? written : err, so assignment to err will be
the right thing both when status < 0 && written == 0 and when status < 0 &&
written > 0.  In the latter case err will be simply ignored.

Objections?
