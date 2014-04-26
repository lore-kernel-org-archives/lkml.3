Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaDZQfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:35:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35532 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaDZQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:35:39 -0400
Date: Sat, 26 Apr 2014 17:35:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm: make variable named "refcount" atomic, like most
 refcounts in the kernel.
Message-ID: <20140426163537.GF18016@ZenIV.linux.org.uk>
References: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 06:06:15PM +0200, Lionel Debroux wrote:
> Based on PaX.

Lovely - cargo-cult at its finest.  "Most refcounts are atomic, must be
good medicine.  Shaman has spoken".

> -	int refcount;
> +	atomic_t refcount;

... therefore, all places that modify that sucker will have to be visible
in the patch.  And those are
  
> -	++item->refcount;
> +	atomic_inc(&item->refcount);
>  	ref->object = item->object;
>  	mutex_unlock(&item->mutex);

and

>  	mutex_lock(&item->mutex);
> -	BUG_ON(item->refcount == 0);
> +	BUG_ON(atomic_read(&item->refcount) == 0);
>  	BUG_ON(ref->object != item->object);
> -	if (--item->refcount == 0) {
> +	if (atomic_dec_and_test(&item->refcount)) {
>  		ref->release(ref);
>  		item->object = NULL;

Mind explaining how could we manage to reach either without item->mutex
being held, serializing the modifications?

NAK, in case it's not obvious from the above...
