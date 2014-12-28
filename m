Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaL1QaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:30:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:37903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaL1QaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:30:03 -0500
Date: Sun, 28 Dec 2014 17:23:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 2/8] locking/mutex: Get rid of use_ww_cxt param in common
 paths
Message-ID: <20141228162303.GA12952@dyad.arnhem.chello.nl>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
 <1419757883-4423-3-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419757883-4423-3-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 01:11:17AM -0800, Davidlohr Bueso wrote:
> ... and simplify a bit the parameters of __mutex_lock_common(). This
> is straightforward as we can just check if the ww cxt for NULL if passed
> from non wait/wound paths.


The reason for this trainwreck is because of some older GCC not actually doing
the const propagation of the MULL pointer right.

There were at least two threads on this,
b0267507dfd0187fb7840a0ec461a510a7f041c5 might give clues.

>  static bool mutex_optimistic_spin(struct mutex *lock,
> -				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
> +				  struct ww_acquire_ctx *ww_ctx)
>  {
>  	struct task_struct *task = current;
>  
> @@ -313,7 +313,7 @@ static bool mutex_optimistic_spin(struct mutex *lock,
>  	while (true) {
>  		struct task_struct *owner;
>  
> -		if (use_ww_ctx && ww_ctx->acquired > 0) {
> +		if (ww_ctx && ww_ctx->acquired > 0) {
>  			struct ww_mutex *ww;
>  
>  			ww = container_of(lock, struct ww_mutex, base);
