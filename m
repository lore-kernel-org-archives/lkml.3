Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968132Ab3E3KPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:15:44 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46546 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967701Ab3E3KPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:15:39 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CA+55aFwmUsDW+y0k2jgF-Z0uCiTP3FrioQEwU9ue7UAJVkCDtg@mail.gmail.com>
References: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFzTG_fU6SxWVAag-8oCDT1ozNdH96vmfDNkphLCvas-MA@mail.gmail.com>
	<CAJfpeguL6psFDbS2JY3ieVCvMXAezR3vk24e1nRW+ReHXSSfdw@mail.gmail.com>
	<CA+55aFwmUsDW+y0k2jgF-Z0uCiTP3FrioQEwU9ue7UAJVkCDtg@mail.gmail.com>
Date: Thu, 30 May 2013 12:15:38 +0200
Message-ID: <CAJfpegvG2uVy6vsoGHnsjpOeR+40VVT9dAdjBs7xYYXtyYZadA@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: add permute operation
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 11:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 30, 2013 at 5:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>>  1) check if destination directory is empty:  upper directory contains a
>> whiteout for each lower directory entry and nothing else
>>  2) if empty then remove whiteouts in destination directory
>>  3) and then go on with the normal rename procedure, replacing the empty
>> destination directory with the source directory ,
>>
>> This is done with directory locking, so atomicity is not usually a problem.
>> But in case of a crash between 2) and 3)  we just seriously corrupted the
>> overlay.
>>
>> Suggestions for fixing that?
>
> Why not just do the NFS thing. That has worked forever - using a
> sillyrename as a "pending deletion" instead of actually deleting
> things.
>
> So in between (1) and (2), silly-rename the pseudo-empty target. At
> that point (2) is no longer even an atomicity requirement, because you
> can do the whiteout removal later. In fact, you probably want to do it
> at the end, after doing the "real" rename.

Okay, nice idea.   More specifically we want to replace the directory
containing whiteouts with an opaque empty directory, which can be done
with a cross-rename.

Then we are left with basically two new variants of rename:

  - cross rename - exchange two names
  - plain overwriting rename but whiteout source

I'm fine with that.

As for userspace interfaces I think the cross-rename is useful enough
to justify a new syscall (rename/renameat don't have flags
unfortunately).

Thanks,
Miklos
