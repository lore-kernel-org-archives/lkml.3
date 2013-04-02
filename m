Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab3DBBcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:32:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57974 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab3DBBce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:32:34 -0400
Date: Mon, 1 Apr 2013 21:32:14 -0400
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
Subject: Re: [PATCH 12/33] aio: refcounting cleanup
Message-ID: <20130402013214.GA30122@thunk.org>
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
 <1363883754-27966-13-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-13-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:33AM -0700, Kent Overstreet wrote:
> The usage of ctx->dead was fubar - it makes no sense to explicitly check
> it all over the place, especially when we're already using RCU.
> 
> Now, ctx->dead only indicates whether we've dropped the initial
> refcount. The new teardown sequence is:
> set ctx->dead
> hlist_del_rcu();
> synchronize_rcu();
> 
> Now we know no system calls can take a new ref, and it's safe to drop
> the initial ref:
> put_ioctx();
> 
> We also need to ensure there are no more outstanding kiocbs.  This was
> done incorrectly - it was being done in kill_ctx(), and before dropping
> the initial refcount.  At this point, other syscalls may still be
> submitting kiocbs!
> 
> Now, we cancel and wait for outstanding kiocbs in free_ioctx(), after
> kioctx->users has dropped to 0 and we know no more iocbs could be
> submitted.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Zach Brown <zab@redhat.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Asai Thambi S P <asamymuthupa@micron.com>
> Cc: Selvan Mani <smani@micron.com>
> Cc: Sam Bradshaw <sbradshaw@micron.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
