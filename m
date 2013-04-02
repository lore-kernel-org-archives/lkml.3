Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350Ab3DBVf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:35:57 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58665 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761127Ab3DBVf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:35:56 -0400
Date: Tue, 2 Apr 2013 17:35:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Benjamin LaHaise <bcrl@kvack.org>,
        Josh Boyer <jwboyer@redhat.com>, Zach Brown <zab@redhat.com>
Subject: Re: [PATCH 33/33] aio: fix kioctx not being freed after cancellation
 at exit time
Message-ID: <20130402213550.GE5703@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	akpm@linux-foundation.org, Benjamin LaHaise <bcrl@kvack.org>,
	Josh Boyer <jwboyer@redhat.com>, Zach Brown <zab@redhat.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-34-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-34-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:54AM -0700, Kent Overstreet wrote:
> From: Benjamin LaHaise <bcrl@kvack.org>
> 
> The recent changes overhauling fs/aio.c introduced a bug that results in the
> kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
> time.  Specifically, a kiocb that is cancelled has its completion events
> discarded by batch_complete_aio(), which then fails to wake up the process
> stuck in free_ioctx().  Fix this by removing the event suppression in
> batch_complete_aio() and modify the wait_event() condition in free_ioctx()
> appropriately.

Once you remove the event suppression, then it means that every single
cancelled AIO will result in ki_ctx->reqs_available getting double
incremented, right?  But reqs_available gets used in more places than
just free_ioctx().  It also gets used (for example) by
get_reqs_available(), which in turn gets used by aio_get_req() to
decide whether or not it's safe to allocate another aio_request.
Since reqs_available is getting double allocated, won't we end up
allowing more AIO requests to be issued --- more than we would have
room in the ring?

Am I missing something?

						- Ted
