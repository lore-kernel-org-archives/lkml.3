Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3EWQGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:06:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47095 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3EWQGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:06:37 -0400
Message-ID: <519E3E8A.2010704@wwwdotorg.org>
Date: Thu, 23 May 2013 10:06:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>, Davide Ciminaghi <ciminaghi@gnudd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different contexts
References: <1369314377-22873-1-git-send-email-lars@metafoo.de> <1369314377-22873-2-git-send-email-lars@metafoo.de> <519E38ED.7090202@wwwdotorg.org> <519E3AB7.8020103@metafoo.de>
In-Reply-To: <519E3AB7.8020103@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 09:50 AM, Lars-Peter Clausen wrote:
> On 05/23/2013 05:42 PM, Stephen Warren wrote:
>> On 05/23/2013 07:06 AM, Lars-Peter Clausen wrote:
>>> regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.
>>> Which means in order to avoid race conditions the lock always needs to be taken
>>> from the same context.
>>
>> I'm not really sure what this means. I assume contexts are
>> atomic-vs-nonatomic?
> 
> Yes.
> 
>> If so, spinlocks should work fine for this, right?
> 
> No, you have to take special care if you want to take the same spinlock from
> different contexts. And you have to take even more care if the code that
> takes the lock can run in different contexts.

OK, but what is that "special care" that must be taken? I assume from
this patch, you mean using spin_lock_irqsave() rather than spin_lock().
So the issue isn't so much that spin locks are used, but rather how
they're used. The code still has a spin_lock_t before and after...

>> I guess the core of the issue is that you want to replace spin_lock()
>> with spin_lock_irqsave(). I'd like to see that explicitly described in
>> the commit description, if that is the core aspect of this change.
> 
> Hm, it does.
> 
> 	regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for
> 	locking.
> 	...
> 	This patch updates the adds a flags parameter to the regmap lock
> 	and unlock callbacks and uses spin_lock_irqsave() and
> 	spin_unlock_restore() ...

To me, that doesn't make me realize that the core part of this change is
to switch between the two different APIs that operate on the spin lock.
I'd expect the commit description to say something more like:

regmap-mmio uses a spinlock for locking. In order for this to work
correctly from different contexts (atomic vs non-atomic), this spinlock
must be locked using spin_lock_irqsave() rather than spin_lock(). To
support this, a spinlock_flags field is added to struct regmap to store
the flags between regmap_{,un}lock_spinlock().
