Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3EWPmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:42:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40606 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3EWPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:42:41 -0400
Message-ID: <519E38ED.7090202@wwwdotorg.org>
Date: Thu, 23 May 2013 09:42:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>, Davide Ciminaghi <ciminaghi@gnudd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different contexts
References: <1369314377-22873-1-git-send-email-lars@metafoo.de> <1369314377-22873-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1369314377-22873-2-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 07:06 AM, Lars-Peter Clausen wrote:
> regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.
> Which means in order to avoid race conditions the lock always needs to be taken
> from the same context.

I'm not really sure what this means. I assume contexts are
atomic-vs-nonatomic? If so, spinlocks should work fine for this, right?

I guess the core of the issue is that you want to replace spin_lock()
with spin_lock_irqsave(). I'd like to see that explicitly described in
the commit description, if that is the core aspect of this change.

Re: the other comments about the API change: I think this can be done
non-invasively:

static void regmap_lock_spinlock(void *__map)
{
	struct regmap *map = __map;
	unsigned long local_flags;

	spin_lock_irqsave(&map->spinlock, local_flags);
	/*
	 * Here, we have the lock locked, so we own the flags,
	 * and can write to them.
	 */
	map->spinlock_flags = local_flags;
}

static void regmap_unlock_spinlock(void *__map, unsigned long *flags)
{
	struct regmap *map = __map;
	spin_unlock_irqrestore(&map->spinlock, map->spinlock_flags);
}

... and obviously add a spinlock_flags field to struct regmap (perhaps
start unioning the mutex and spinlock data fields there if you want to
save space).
