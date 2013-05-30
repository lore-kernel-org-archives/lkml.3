Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030280Ab3E3JLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:11:46 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48837 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030209Ab3E3JLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:11:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpeguL6psFDbS2JY3ieVCvMXAezR3vk24e1nRW+ReHXSSfdw@mail.gmail.com>
References: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFzTG_fU6SxWVAag-8oCDT1ozNdH96vmfDNkphLCvas-MA@mail.gmail.com>
	<CAJfpeguL6psFDbS2JY3ieVCvMXAezR3vk24e1nRW+ReHXSSfdw@mail.gmail.com>
Date: Thu, 30 May 2013 18:11:36 +0900
X-Google-Sender-Auth: wh1-HphoyRDXGTQ7lIXezB5b_Zc
Message-ID: <CA+55aFwmUsDW+y0k2jgF-Z0uCiTP3FrioQEwU9ue7UAJVkCDtg@mail.gmail.com>
Subject: Re: [RFC PATCH] vfs: add permute operation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
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

On Thu, May 30, 2013 at 5:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> The third name is because of the replace-empty-directory wart in the
> rename(2) definition.  With overlay/union that can become
>
>  1) check if destination directory is empty:  upper directory contains a
> whiteout for each lower directory entry and nothing else
>  2) if empty then remove whiteouts in destination directory
>  3) and then go on with the normal rename procedure, replacing the empty
> destination directory with the source directory ,
>
> This is done with directory locking, so atomicity is not usually a problem.
> But in case of a crash between 2) and 3)  we just seriously corrupted the
> overlay.
>
> Suggestions for fixing that?

Why not just do the NFS thing. That has worked forever - using a
sillyrename as a "pending deletion" instead of actually deleting
things.

So in between (1) and (2), silly-rename the pseudo-empty target. At
that point (2) is no longer even an atomicity requirement, because you
can do the whiteout removal later. In fact, you probably want to do it
at the end, after doing the "real" rename.

No, it's not perfect, but it works in practice. NFS may not be POSIX,
but nobody really cares. It's usable.

> We could just refuse to do the rename-over-empty-directory and see if anyone
> complains.  I don't think it's often used, but if something is documented
> then people are bound to find some stupid use for it.

I'm sure there are uses for it, since it's traditional unix behavior.
And I'm sure there are good reasons for it too (eg locking over NFS or
whatever)

             Linus
