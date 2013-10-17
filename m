Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3JQQ0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:26:02 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49541 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3JQQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:26:00 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 17 Oct 2013 09:25:52 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christopher Li <sparse@chrisli.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sparse: possible false report of context imbalance
Message-ID: <20131017162551.GA4123@jtriplet-mobl1>
References: <525F584C.5010106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525F584C.5010106@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:23:56PM -0500, Larry Finger wrote:
> Sparse reports the following:
> 
>   CHECK   drivers/staging/rtl8188eu/core/rtw_mlme.c
> drivers/staging/rtl8188eu/core/rtw_mlme.c:1003:9: warning: context
> imbalance in 'rtw_free_assoc_resources' - different lock contexts
> for basic block
> 
> The code in question is as follows:
> 
>         if (lock_scanned_queue)
>                 spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
> 
>         pwlan = rtw_find_network(&pmlmepriv->scanned_queue,
> tgt_network->network.MacAddress);
> 
>         if (lock_scanned_queue)
>                 spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
> 
> As this fragment uses the identical test to unlock that is used to
> lock, and the test variable is not touched, I think this is a false
> indication. I am using version 0.4.4 of sparse.

Sparse can't track conditional contexts like this; sparse intentionally
complains here that you're running the same basic block (the
rtw_find_network call) with and without a lock held.

The following workaround works when this is legitimate, though it isn't
ideal:

if (condition) {
	lock
	do_thing
	unlock
} else {
	do_thing
}

Ideally, Sparse should be able to track conditional contexts, but that
would require some form of abstract evaluation, or as a simplistic hack,
looking for identical side-effect-free conditional expressions.

- Josh Triplett
