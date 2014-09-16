Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaIPTTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbaIPTTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:19:49 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/7] O_NONBLOCK flag for readv2/preadv2
References: <cover.1410810247.git.milosz@adfin.com>
	<ead00ff46b581749da6d1a6d2db9d8f8dc3aed67.1410810247.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 15:19:07 -0400
In-Reply-To: <ead00ff46b581749da6d1a6d2db9d8f8dc3aed67.1410810247.git.milosz@adfin.com>
	(Milosz Tanski's message of "Mon, 15 Sep 2014 16:21:14 -0400")
Message-ID: <x4961gnz844.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> Filesystems that generic_file_read_iter will not be allowed to perform
> non-blocking reads. This only will read data if it's in the page cache and if
> there is no page error (causing a re-read).
>
> Signed-off-by: Milosz Tanski <milosz@adfin.com>

> @@ -1662,6 +1676,10 @@ no_cached_page:
>  			goto out;
>  		}
>  		goto readpage;
> +
> +would_block:
> +		error = -EAGAIN;
> +		goto out;
>  	}

Why did you put the wouldblock label inside the loop?  That should be
pushed down to just above out, and then you can get rid of the goto.

Other than that, it looks like you put the check in all the right places
in that function.

>  out:
> @@ -1697,6 +1715,9 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, int flags)
>  		size_t count = iov_iter_count(iter);
>  		loff_t size;
>  
> +		if (flags & O_NONBLOCK)
> +			return -EAGAIN;
> +

If a program is attempting non-blocking reads on a file opened with
O_DIRECT, I think returning -EAGAIN is very misleading.  Better to
return -EINVAL in this case, and maybe check that earlier in the stack?

Cheers,
Jeff
