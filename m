Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbaD2RvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbaD2RvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:51:13 -0400
Message-ID: <535FE68C.8060002@redhat.com>
Date: Tue, 29 Apr 2014 19:51:08 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: Add "initialized" variable to proc
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com> <20140428214112.GC7857@thunk.org>
In-Reply-To: <20140428214112.GC7857@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 11:41 PM, Theodore Ts'o wrote:
> On Mon, Apr 28, 2014 at 09:52:11PM +0200, Florian Weimer wrote:
>> Before this change, you had to check kernel log messages to see if the
>> non-blocking pool had been properly initialized.  With this change, you
>> can consult the file /proc/sys/kernel/random/intialized instead.
>>
>> Signed-off-by: Florian Weimer <fweimer@redhat.com>
>
> The main reason why I hadn't added a facility like this was because
> the main goal was to make knowledge of when the /dev/urandom entropy
> pool had been fully initialized could be made clear.  In fact, at
> least on my laptop, this happened at 2.5 seconds after boot, which is
> after the hard drives had been probed, and before all of the various
> laptop devices have been fully probed.

I've got a (physical) machine where it happens after ten seconds, or 
much longer if there is no activity.

I've seen cases where on the first boot of virtual machines, the SSH key 
was generated before the printk with the initialization message.  It's 
not a problem if you install the OS first and then generate the keys, 
but for booting from pre-provisioned images, it could be.  (I have no 
evidence that this hurts the quality of the generated key material, this 
is just based on what's reported by the kernel.)

> My goal was to see if we could make it be more or less guaranteed that
> by the time userspace daemons started coming up, in practice
> /dev/urandom would be initialized, so we wouldn't have to change
> userspace.  And for the most part, this isn't a problem.

I'm not sure if I want to bet an increasingly crucial part of the boot 
design on the continuing availability of the current entropy levels 
(which could go down as the result of environmental changes or a 
reassessment of the entropy that actually comes into the system).

> Now there may be systems where the device probe can happen much more
> quickly. in which case it does make sense for really paranoid crypto
> libraries to check if the urandom pool has been fully initialized.
> But in that case, instead of (or perhaps in addition to) providing a
> file which a library daemon could poll on, to provide an ioctl
> interface which allows userspace to block until /dev/urandom has been
> initialized.

Or a new /dev/?random device that blocks until initialized, but behaves 
just like /dev/urandom after that.   The question is how useful it would 
be because of the deadlock scenario.

-- 
Florian Weimer / Red Hat Product Security Team
