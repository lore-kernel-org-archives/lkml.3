Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaHMRUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:20:39 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34620 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaHMRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:20:37 -0400
Date: Wed, 13 Aug 2014 10:20:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: falcon@meizu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] async: async device driver probing
Message-ID: <20140813172030.GA23628@core.coreip.homeip.net>
References: <1391857539-27782-1-git-send-email-falcon@meizu.com>
 <20140208182729.GB10892@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208182729.GB10892@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, Feb 08, 2014 at 10:27:29AM -0800, Greg KH wrote:
> On Sat, Feb 08, 2014 at 07:05:38PM +0800, falcon@meizu.com wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > [*Note*: NOT applicable, only for comments.]
> > 
> > To async the slow driver probing function of some devices, the device probing
> > support is modified to support async scheduling.
> > 
> > In order to async your driver probing function, please mask the async_probe
> > flag to 1, and to make sure one asynced probing is executed before an specified
> > point, please call async_synchronize_full() in that point..
> > 
> > Usage:
> > 
> > 	static struct i2c_driver test_driver = {
> > 		.driver = {
> > 			.name   = TEST_DEV_NAME,
> > 			.owner  = THIS_MODULE,
> > 	+               .async_probe = 1,
> > 		},
> 
> Why is this needed, we have defered probing and the container stuff, so
> what problem is this solving?

Deferred probing only helps if resources are not ready yet, but
sometimes we have a slow(ish) device which initialization stalls probing
the rest of the system. For example a touchpad can take up to a second
to calibrate itself after reset. One could try scheduling reset
asynchronously, or try to offload it to open(), but that is not always
best:

1. Manual async: what to do when reset fails? Ideally we do not want to
leave driver half-way bound with device not operable, but much rather
signal the rest of the system that binding of the device failed and
release all resources.

2. Offload to open: the same issue as with manually doing async reset,
plus sometimes we do not know all parameters that we should create input
device with until after we reset physical device and queried it for
capabilities.

Marking a driver to tell device core to execute probe asynchronously [at
boot time] seems like a very appealing feature from driver author POV.

What is the container stuff you mention?

Thanks.

-- 
Dmitry
