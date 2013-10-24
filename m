Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3JXOsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:48:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:36906 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab3JXOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:48:45 -0400
Date: Thu, 24 Oct 2013 16:48:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        gregkh@linuxfoundation.org
Subject: Re: [RFC PATCH] debugobject: add support for kref
In-Reply-To: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de>
Message-ID: <alpine.DEB.2.02.1310241615280.14242@ionos.tec.linutronix.de>
References: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013, Sebastian Andrzej Siewior wrote:
>  
>  struct kref {
>  	atomic_t refcount;
> @@ -32,6 +33,9 @@ struct kref {
>  static inline void kref_init(struct kref *kref)
>  {
>  	atomic_set(&kref->refcount, 1);
> +#ifdef CONFIG_DEBUG_OBJECTS_KREF
> +	debug_object_init(kref, NULL);

I rather prefer to have a debug_obj_descr handed in. It also should
activate the object, because then you can catch freeing of an active
kref as well. With state INIT the free checks are not triggering.

>  /**
> @@ -70,6 +74,12 @@ static inline int kref_sub(struct kref *kref, unsigned int count,
>  {
>  	WARN_ON(release == NULL);
>  
> +#ifdef CONFIG_DEBUG_OBJECTS_KREF
> +	if (!debug_object_is_tracked(kref)) {
> +		debugobj_kref_splat(kref, release);
> +		return 0;

Why can't you use debug_object_active_state(kref, descr, 0, 0)? All it
needs is a return value which tells you whether the object is tracked
and its state is ACTIVE.

> +	}
> +#endif
>  	if (atomic_sub_and_test((int) count, &kref->refcount)) {
>  		release(kref);
>  		return 1;

What calls debug_object_free() for the kref? You seem to add tracking
objects without ever releasing them. Are you relying on kfree removing
the inactive object from the debugobjects tracking list?

Not really a good idea. There might be some different release function
than kfree. And it relies on DEBUG_OBJECTS_FREE being enabled.

So an explicit call to debug_objects_free() before release(kref) is
required. Otherwise your new check is going to fail even when the kref
is gone already.

Thanks,

	tglx
