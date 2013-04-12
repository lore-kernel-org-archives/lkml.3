Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3DLVCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab3DLVCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:02:19 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 11/33] aio: make aio_put_req() lockless
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
	<1363883754-27966-12-git-send-email-koverstreet@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Apr 2013 17:01:53 -0400
In-Reply-To: <1363883754-27966-12-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Thu, 21 Mar 2013 09:35:32 -0700")
Message-ID: <x49k3o7sbsu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> Freeing a kiocb needed to touch the kioctx for three things:
>
>  * Pull it off the reqs_active list
>  * Decrementing reqs_active
>  * Issuing a wakeup, if the kioctx was in the process of being freed.
>
> This patch moves these to aio_complete(), for a couple reasons:
>
>  * aio_complete() already has to issue the wakeup, so if we drop the
>    kioctx refcount before aio_complete does its wakeup we don't have to
>    do it twice.
>  * aio_complete currently has to take the kioctx lock, so it makes sense
>    for it to pull the kiocb off the reqs_active list too.
>  * A later patch is going to change reqs_active to include unreaped
>    completions - this will mean allocating a kiocb doesn't have to look
>    at the ringbuffer. So taking the decrement of reqs_active out of
>    kiocb_free() is useful prep work for that patch.
>
> This doesn't really affect cancellation, since existing (usb) code that
> implements a cancel function still calls aio_complete() - we just have
> to make sure that aio_complete does the necessary teardown for cancelled
> kiocbs.
>
> It does affect code paths where we free kiocbs that were never
> submitted; they need to decrement reqs_active and pull the kiocb off the
> reqs_active list. This occurs in two places: kiocb_batch_free(), which
> is going away in a later patch, and the error path in io_submit_one.

After reading the patch description and the patch, I'm left wondering
whether you did this as a cleanup or a performance patch.

Anyway, I don't see any issue with it.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
