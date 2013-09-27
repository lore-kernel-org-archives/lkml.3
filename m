Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3I0UxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:53:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40243 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3I0UxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:53:12 -0400
Date: Fri, 27 Sep 2013 21:47:43 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vojtech Bocek <vbocek@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About atags_proc buffer size
Message-ID: <20130927204743.GK12758@n2100.arm.linux.org.uk>
References: <5245E9C9.9030509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245E9C9.9030509@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 10:25:45PM +0200, Vojtech Bocek wrote:
> I want to ask something about atags_proc.c implementation. Currently,
> it uses a buffer to temporarily store atags. The buffer size is set to
> 1.5kb for some reason, but as far as I know, atag list's size is not
> limited in any way. I've got a device (HTC One) which uses about 12kb
> of tags, that means it panics during boot if CONFIG_ATAGS_PROC is
> enabled, because the buffer contains only part of the tag list without
> an end tag.

The tags are supposed to be a short-lived structure which gets used to
pass barest minimum of details to the kernel, and the data stored in
them almost certainly gets overwritten before the kernels memory
allocators are up and running.

So, we need to statically allocate some space to save these things -
it can't be done dynamically.

The problem is this: for the vast majority of platforms, they pass no
more than 1.5kB (lower case b is *bits* not *bytes*) to the kernel in
their tagged list.  Having a static allocation of 12k would be wasteful
for the majority of users.

> I don't know much about the way ARM boot process works, but I tried to
> store just the pointer to atag list, and it works fine (quick patch
> attached). Do atags get erased later in boot process on some platforms,
> is that the reason why buffer had to be used?

This may appear to work, but check it after you've been running for
some time and have exercised the memory systems.  You'll probably find
that your tags have vanished!
