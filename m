Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab3EWPua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:50:30 -0400
Received: from smtp-out-100.synserver.de ([212.40.185.100]:1085 "EHLO
	smtp-out-100.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3EWPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:50:28 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23984
Message-ID: <519E3AB7.8020103@metafoo.de>
Date: Thu, 23 May 2013 17:50:15 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@kernel.org>, Davide Ciminaghi <ciminaghi@gnudd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different contexts
References: <1369314377-22873-1-git-send-email-lars@metafoo.de> <1369314377-22873-2-git-send-email-lars@metafoo.de> <519E38ED.7090202@wwwdotorg.org>
In-Reply-To: <519E38ED.7090202@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 05:42 PM, Stephen Warren wrote:
> On 05/23/2013 07:06 AM, Lars-Peter Clausen wrote:
>> regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.
>> Which means in order to avoid race conditions the lock always needs to be taken
>> from the same context.
> 
> I'm not really sure what this means. I assume contexts are
> atomic-vs-nonatomic?

Yes.

> If so, spinlocks should work fine for this, right?

No, you have to take special care if you want to take the same spinlock from
different contexts. And you have to take even more care if the code that
takes the lock can run in different contexts.

> 
> I guess the core of the issue is that you want to replace spin_lock()
> with spin_lock_irqsave(). I'd like to see that explicitly described in
> the commit description, if that is the core aspect of this change.

Hm, it does.

	regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for
	locking.
	...
	This patch updates the adds a flags parameter to the regmap lock
	and unlock callbacks and uses spin_lock_irqsave() and
	spin_unlock_restore() ...


> 
> Re: the other comments about the API change: I think this can be done
> non-invasively:
> 
> static void regmap_lock_spinlock(void *__map)
> {
> 	struct regmap *map = __map;
> 	unsigned long local_flags;
> 
> 	spin_lock_irqsave(&map->spinlock, local_flags);
> 	/*
> 	 * Here, we have the lock locked, so we own the flags,
> 	 * and can write to them.
> 	 */
> 	map->spinlock_flags = local_flags;
> }
> 
> static void regmap_unlock_spinlock(void *__map, unsigned long *flags)
> {
> 	struct regmap *map = __map;
> 	spin_unlock_irqrestore(&map->spinlock, map->spinlock_flags);
> }
> 
> ... and obviously add a spinlock_flags field to struct regmap (perhaps
> start unioning the mutex and spinlock data fields there if you want to
> save space).

Hm, that might work.
