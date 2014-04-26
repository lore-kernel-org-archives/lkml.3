Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaDZRDM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:03:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaDZRDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:03:10 -0400
Date: Sat, 26 Apr 2014 19:03:06 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm: make variable named "refcount" atomic, like most
 refcounts in the kernel.
Message-ID: <20140426170305.GA17562@mguzik.redhat.com>
References: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 06:06:15PM +0200, Lionel Debroux wrote:
> Based on PaX.
> 
> ---
> 
> From 7c712cadd97d43d03ff3d7ca04fd85bd8c6eb34a Mon Sep 17 00:00:00 2001
> From: Lionel Debroux <lionel_debroux@yahoo.fr>
> Date: Sat, 26 Apr 2014 15:53:55 +0200
> Subject: drm: make variable named "refcount" atomic, like most refcounts in
>  the kernel.
> 
> Extracted from the PaX patch.
> 
> 
[snip]
>  	mutex_lock(&item->mutex);
> -	BUG_ON(item->refcount == 0);
> +	BUG_ON(atomic_read(&item->refcount) == 0);
>  	BUG_ON(ref->object != item->object);
> -	if (--item->refcount == 0) {
> +	if (atomic_dec_and_test(&item->refcount)) {
>  		ref->release(ref);
>  		item->object = NULL;
>  	}

I believe this change is in grsecurity so that overflow detector can be
used, there is clearly no reason to use mere atomic ops.

It may be that kernel devs would accept a patch implementing generic
refcount manipulation primitives without atomicity guarantees, which
could be used in cases like this.

Then atomic and non-atomic versions could be used to detect overflows and
overputs at least in debug kernels.

-- 
Mateusz Guzik
