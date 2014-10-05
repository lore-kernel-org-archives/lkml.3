Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaJEU2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:28:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJEU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:28:44 -0400
Date: Sun, 5 Oct 2014 13:28:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Noakes <jjnoakes@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject_init and the zeroed-out-memory requirement
Message-ID: <20141005202843.GA1282@kroah.com>
References: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN2+FEJY29jDF2PkGAYcG_0z=VQ4T+y7Ro56aeqrhSPYQ6ZEdw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 04:02:14PM -0400, Jason Noakes wrote:
> I noticed that kobject_init() requres the kobject passed in to be zeroed out
> fully first.

That is because people were trying to reuse objects without destroying
them first.  So try to detect this and prevent the developer from doing
something "foolish" like this.

Is there any in-kernel code that does not properly zero out the memory
before calling kobject_init()?

> Many other *_init kernel routines (cdev_init, kref_init, mutex_init,
> spin_lock_init, etc) do not have the same requirement - they work on fully
> uninitialized memory.

They all do different things, you can't compare apples to oranges :)

> Documentation/kobject.txt does not mention the requirement that the memory be
> zero-initialized before it is passed to kobject_init.
> 
> I would like to submit a patch - which solution is preferred?
> 
>   (a) Update Documentation/kobject.txt and explicitly add the requirement
>   (b) Modify kobject_init to zero out the memory itself like other *_init
> routines
>         (It already initializes most of its members - just not all of them)

As mentioned above, this is not going to be ok, look at the third if
statement in kobject_init() for why not.

>   (c) Something else?

Add a line of text to the kerneldoc for kobject_init to mention this?

Or (a) is fine as well, if it makes you feel better, but if you do so,
just say that all memory for kobjects must be created with kzalloc() and
don't mention memset as that will cause people to try to reuse kobjects,
like they have in the past, and bad things will happen then.

hope this helps,

greg k-h
