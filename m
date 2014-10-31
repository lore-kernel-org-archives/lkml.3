Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422680AbaJaAXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:23:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161331AbaJaAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:23:43 -0400
Date: Fri, 31 Oct 2014 01:23:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Thomas Gleixner <tglx@linutronix.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, marcel@holtmann.org, desrt@desrt.ca,
        hadess@hadess.net, dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no, Peter Zijlstra <peterz@infradead.org>
Subject: Re: kdbus: add driver skeleton, ioctl entry points and utility
 functions
In-Reply-To: <alpine.DEB.2.11.1410302224230.5308@nanos>
Message-ID: <alpine.LRH.2.00.1410310114290.11562@twin.jikos.cz>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-4-git-send-email-gregkh@linuxfoundation.org> <alpine.DEB.2.11.1410302224230.5308@nanos>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Thomas Gleixner wrote:

> > +static long kdbus_handle_ioctl(struct file *file, unsigned int cmd,
> > +			       unsigned long arg)
> > +{
> > +	struct kdbus_handle *handle = file->private_data;
> > +	void __user *argp = (void __user *)arg;
> > +	enum kdbus_handle_type type = handle->type;
> > +
> > +	/* make sure all handle fields are set if handle->type is */
> > +	smp_rmb();
> 
> Sure. You really need this kind of serialization because your design
> choice of allowing opaque handles in the first place.
> 
> I'm really interested why you need this rmb() at all. Just because you
> have several threads in user space which might race with the type
> assignment when they call the ioctl?
> 
> We have a strict requirement to document memory barriers. The
> following comment definitely does not fulfil this requirement as it
> just documents that someone observed a race of unknown provenance and
> got it 'fixed' with a 'smp_rmb()'
> 
> > +     /* make sure all handle fields are set if handle->type is */
> 
> That's really hillarious, The user space side knows excatly upfront
> which type of 'handle' it wants to open. Making it an opaque handle in
> the first place and let the kernel deal with the actual type
> assignment is beyond silly. Especially if that involves undocumented
> memory barriers.

I have been staring at exactly this for rather a long time today. 

Apparently this barrier pairs with smp_wmb() in kdbus_handle_transform() 
and tries to make sure that whenever handle->type is seen as updated, 
handle->ptr is as well.

But it's still difficult for me to understand all the memory ordering 
rules and consequences of this strict ordering (my current understanding 
is that the barrier is not needed, but I will have to think about it a 
little bit more), so a nice and explanatory comment precisely describing 
the race this is protecting against would be very welcome.

Thanks,

-- 
Jiri Kosina
SUSE Labs

