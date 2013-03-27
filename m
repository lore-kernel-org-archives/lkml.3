Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3C0RpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:45:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42580 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab3C0RpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:45:10 -0400
Date: Wed, 27 Mar 2013 17:45:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yet another pipe related oops.
Message-ID: <20130327174506.GZ21522@ZenIV.linux.org.uk>
References: <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com>
 <20130327152030.GY21522@ZenIV.linux.org.uk>
 <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:33:35AM -0700, Linus Torvalds wrote:

> Applied.
> 
> Do we actually have files with NULL f_ops pointers? Should we? What
> could we possibly do with a file descriptor that doesn't have any
> fops?

We shouldn't, at least not for something that has been successfully
opened.  I've a patch series cleaning that up a bit in the local
queue; will check for bitrot and throw into for-next.

Another thing that is a definite for-next fodder - we really have no
reason to put anything non-regular or opened not for write into ->s_files.
And since read-only opens outnumber write-only/read-write ones by far
(two orders of magnitude for something like kernel build), that gives
a nice reduction of files_lglock accesses.  OTOH, the only remaining
user of those lists is forced remount to read-only, and I'm not at all
sure we wouldn't be better off by leaving those opened files alone and
just teaching file_start_write() to fail with EROFS on such fs.  Then
we could get rid of files_lglock and ->s_files completely...

> Also, perhaps we should do something more akin to what we do for
> dentry functions where we validate them on registration, and we could
> fix up or validate read/write pointers, with semantics something like
> 
>     if (!fop->write)
>         fop->write = fop->aio_write ? do_sync_write : EINVAL_write;
>     if (!fop->read)
>         fop->read = fop->aio_read ? do_sync_read : EINVAL_read;
> 
> kind of things?

As it is, file_operations instances are const, and it's a good idea, IMO...
