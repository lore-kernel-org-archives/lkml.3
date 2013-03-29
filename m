Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3C2SUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:20:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57224 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab3C2SUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:20:04 -0400
Date: Fri, 29 Mar 2013 13:14:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 11/33] aio: make aio_put_req() lockless
Message-ID: <20130329171411.GE21902@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
	Asai Thambi S P <asamymuthupa@micron.com>,
	Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
	Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-12-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-12-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:32AM -0700, Kent Overstreet wrote:
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
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
