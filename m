Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3CKUxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:53:51 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45234 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753889Ab3CKUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:53:50 -0400
Date: Mon, 11 Mar 2013 16:53:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Security Officers <security@kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix: compat_rw_copy_check_uvector() misuse in aio,
	readv, writev, and security keys
Message-ID: <20130311205345.GA9410@Krystal>
References: <20130225152036.GA3405@Krystal> <20130311204601.GA22369@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311204601.GA22369@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Kroah-Hartman (gregkh@linuxfoundation.org) wrote:
> On Mon, Feb 25, 2013 at 10:20:36AM -0500, Mathieu Desnoyers wrote:
> > Looking at mm/process_vm_access.c:process_vm_rw() and comparing it to
> > compat_process_vm_rw() shows that the compatibility code requires an
> > explicit "access_ok()" check before calling
> > compat_rw_copy_check_uvector(). The same difference seems to appear when
> > we compare fs/read_write.c:do_readv_writev() to
> > fs/compat.c:compat_do_readv_writev().
> > 
> > This subtle difference between the compat and non-compat requirements
> > should probably be debated, as it seems to be error-prone. In fact,
> > there are two others sites that use this function in the Linux kernel,
> > and they both seem to get it wrong:
> > 
> > Now shifting our attention to fs/aio.c, we see that aio_setup_iocb()
> > also ends up calling compat_rw_copy_check_uvector() through
> > aio_setup_vectored_rw(). Unfortunately, the access_ok() check appears to
> > be missing. Same situation for
> > security/keys/compat.c:compat_keyctl_instantiate_key_iov().
> > 
> > I propose that we add the access_ok() check directly into
> > compat_rw_copy_check_uvector(), so callers don't have to worry about it,
> > and it therefore makes the compat call code similar to its non-compat
> > counterpart. Place the access_ok() check in the same location where
> > copy_from_user() can trigger a -EFAULT error in the non-compat code, so
> > the ABI behaviors are alike on both compat and non-compat.
> > 
> > While we are here, fix compat_do_readv_writev() so it checks for
> > compat_rw_copy_check_uvector() negative return values.
> > 
> > And also, fix a memory leak in compat_keyctl_instantiate_key_iov() error
> > handling.
> > 
> > Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > ---
> >  fs/compat.c            |   15 +++++++--------
> >  mm/process_vm_access.c |    8 --------
> >  security/keys/compat.c |    4 ++--
> >  3 files changed, 9 insertions(+), 18 deletions(-)
> 
> What ever happened to this patch?  I don't see it in Linus's tree, was
> it not correct?

Not sure. My guess would be that there is missing proof that I actually
tested the patch by generating a OOPS splat and proof that it actually
fixes it. I mainly tested that it does not break _correct_ use of aio,
but I did not have enough time to created my own custom aio lib to
generate the issue. So if this is what is expected, I might need a bit
of help on this front. Testing odd behavior through libaio proved to
non-straightforward.

Thoughts ?

Thanks,

Mathieu

> 
> thanks,
> 
> greg k-h

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
