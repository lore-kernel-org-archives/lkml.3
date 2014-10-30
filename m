Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161481AbaJ3XiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:38:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211AbaJ3XiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:38:08 -0400
Date: Thu, 30 Oct 2014 23:38:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no, Linus Torvalds <torvalds@linux-foundation.org>
Subject: How Not To Use kref (was Re: kdbus: add code for buses, domains and
 endpoints)
Message-ID: <20141030233801.GF7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:

> +static void __kdbus_domain_user_free(struct kref *kref)
> +{
> +	struct kdbus_domain_user *user =
> +		container_of(kref, struct kdbus_domain_user, kref);
> +
> +	BUG_ON(atomic_read(&user->buses) > 0);
> +	BUG_ON(atomic_read(&user->connections) > 0);
> +
> +	mutex_lock(&user->domain->lock);
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +	idr_remove(&user->domain->user_idr, user->idr);
> +	hash_del(&user->hentry);
	^^^^^^^^^^^^^^^^^^^^^^^^
> +	mutex_unlock(&user->domain->lock);
> +
> +	kdbus_domain_unref(user->domain);
> +	kfree(user);
> +}

> +struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u)
> +{
> +	if (u)
> +		kref_put(&u->kref, __kdbus_domain_user_free);
> +	return NULL;
> +}

If you remove an object from some search structures, taking the lock in
destructor is Too Fucking Late(tm).  Somebody might have already found
that puppy and decided to pick it (all under that lock) just as we'd
got to that point in destructor and blocked there.  Oops...

Normally I'd say "just use kref_put_mutex()", but this case is even worse.
Look:

refcount is 1
A: kref_put_mutex() 
	see that it's potential 1->0 crossing, need to take mutex
	mutex_lock()
B: kref_get()
refcount is 2
A:	got the sodding mutex
	atomic_dec_and_test
refcount is 1 now
	OK, it's not 1->0, after all, just drop the mutex and bugger off
B: kref_put_mutex()
	see that it's potential 1->0 crossing, need to take mutex
	mutex_lock() blocks
A:	mutex_unlock() lets B go
B:	... got it
	atomic_dec_and_test
refcount is 0
	call the destructor now, which ends with
	kdbus_domain_unref(user->domain);
	... which just happens to be the last reference to ->domain
	... and frees it, along with ->domain->mutex

But what's to guarantee that A will be past the last point where mutex_unlock()
is looking at the mutex?  Sure, it's hard to hit, but AFAICS it's not
impossible, especially if the following happens (assuming mutex-dec.h-style
mutices):

B: mutex_lock()
	atomic_dec_return -> -1
	__mutex_lock_slowpath()
A: mutex_unlock()
	atomic_inc_return -> 0
	get preempted
B: note that A has already incremented it to 0 and bugger off - we'd got it

and there we go, with A getting the timeslice back and deciding to call
__mutex_unlock_slowpath() when B has already freed the damn thing.

Basically, kref_put_mutex() is only usable when destructor callback cannot end
up freeing the mutex.

kref_get_unless_zero() might be a usable approach, but IMO the whole thing is
simply outside of kref applicability.  Using it for something that needs to
deal with removal from search structures from the destructor callback is
already stretching the things; this one is far worse.  kref isn't a universal
tool for expressing lifetime cycles.  It works for really simple cases and
might eliminate some amount of boilerplate code.  It's been greatly oversold
and overused, though...
