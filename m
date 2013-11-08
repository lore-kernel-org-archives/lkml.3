Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab3KHR2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:28:43 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45260 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3KHR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:28:41 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <527CA5F3.7090605@vmware.com>
References: <1383895134-4535-1-git-send-email-thellstrom@vmware.com>
	<20131108080638.GA14082@phenom.ffwll.local>
	<527CA5F3.7090605@vmware.com>
Date: Fri, 8 Nov 2013 18:28:39 +0100
Message-ID: <CAKMK7uEZggdDmsnhwU_riNDjia__b010ieVLB4pTb+k82xfYuA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH RFC] dma-buf/fs Add get_[file|dma_buf]_unless_doomed
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 9:50 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> This, however comes with two implications
> 1) Once a DMA-buf is added, it stays alive at least until someone removes
> the gem name of the exporting object, regardless whether there are any
> external users or not. I think this is OK, but unnecessary.

Imo that's actually fairly nice guarantee, since if you have dumb
userspace that always re-does the export/import dance accross a device
the importer can check whether it has the same object already
somewhere.

Without this guarantee we'll end up mapping the same underlying
storage multiple times. btw this is the part where userspace can still
trick the kernel. I have testcases for it, but thus far lacked the
time to implement the fix. It needs a combination of nasty+dumb
userspace though to be a real issue.

> 2) If someone decides to get a new handle from fd, and the gem name has
> already been removed, a new gem name is created for the exporting dma-buf by
> the requested client. This is why I can't do the same. Because of the
> relaxed RCU locking, I can't re-add a name to a TTM base object. Removing it
> is always part of the object destruction sequence.

Yeah, we seem to have a bit a split in how gem handles userspace
handles and the weak references they cause and how ttm does it. ttm
uses kref_get_unless_zero for weak references. Atm gem objects
themselves still need the big mutex, but the only blocker is the mmap
code (actually the has table). My plan (somewhere on my todo list) is
to do the same trick for that weak reference from the mmap offset
lookup structure.

Anyway I just wanted to point out with my original mail that this
problem can be solved in different ways. But I see that the weak ref
approach with a possibly failing get call suits the current ttm design
(and so I guess vmwgfx) a bit better.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
