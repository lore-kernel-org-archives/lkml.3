Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbaHHVix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:38:53 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:45843 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716AbaHHVit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:38:49 -0400
X-Cam-AntiVirus: found ScamNailer.Phish.viro_AT_zeniv.linux.org.uk
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: Bug introduced in 3b93f911d5
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20140808155407.GT18016@ZenIV.linux.org.uk>
Date: Fri, 8 Aug 2014 22:38:47 +0100
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <154E0CCF-6F9D-4270-BAF9-FE9F76833669@cam.ac.uk>
References: <435E586E-2045-4070-8FA7-8DF468280E3C@cam.ac.uk> <20140808155407.GT18016@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 8 Aug 2014, at 16:54, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Aug 08, 2014 at 12:11:39AM +0100, Anton Altaparmakov wrote:
>> Hi Al,
>> 
>> Was just looking at __generic_file_write_iter() and found a bug in the code that you added in 3b93f911d5.
>> 
>> Consider the case where generic_file_direct_write() returns a partial write, i.e. written > 0 && written < count.
>> 
>> Also consider that the following generic_perform_write() fails with an error, i.e. status < 0.
> 
> *nod*
> 
> What we ought to do, AFAICS, is this:
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 900edfa..8163e04 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2584,7 +2584,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> 		 * that this differs from normal direct-io semantics, which
> 		 * will return -EFOO even if some bytes were written.
> 		 */
> -		if (unlikely(status < 0) && !written) {
> +		if (unlikely(status < 0)) {
> 			err = status;
> 			goto out;
> 		}
> 
> Note that we return written ? written : err, so assignment to err will be
> the right thing both when status < 0 && written == 0 and when status < 0 &&
> written > 0.  In the latter case err will be simply ignored.
> 
> Objections?

No objections from me.  As you say, that will do the right thing in all cases.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

