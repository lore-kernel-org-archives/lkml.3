Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaA3ODj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:03:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaA3ODi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:03:38 -0500
Date: Thu, 30 Jan 2014 15:03:32 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: handle out-of-bounds read/write
Message-ID: <20140130150332.64419aee@hananiah.suse.cz>
In-Reply-To: <20140130132827.GA22557@kroah.com>
References: <20140130094802.4ee29435@hananiah.suse.cz>
	<20140130132827.GA22557@kroah.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 05:28:27 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Jan 30, 2014 at 09:48:02AM +0100, Petr Tesarik wrote:
> > The loff_t type may be wider than phys_addr_t (e.g. on 32-bit systems).
> > Consequently, the file offset may be truncated in the assignment.
> > Currently, /dev/mem wraps around, which may cause applications to read
> > or write incorrect regions of memory by accident.
> 
> Does that really happen?  If so, that's a userspace bug, right?

In my case, it was a userspace bug, indeed. But debugging would have
been much easier if I saw read() fail with an EOF condition, rather
than pretend that it actually read some bytes (from above 4G) on a
32-bit box.

> > Let's follow POSIX file semantics here and return 0 when reading from
> > and -EFBIG when writing to an offset that cannot be represented by a
> > phys_addr_t.
> > 
> > Note that the conditional is optimized out by the compiler if loff_t
> > has the same size as phys_addr_t.
> > 
> > Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> > ---
> >  drivers/char/mem.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> 
> What is going to break if we apply this patch?  :)

Nothing, unless it was broken already. I mean, if anyone is trying to
play dirty tricks with 32-bit file offset overflow, I'd call such code
sick and broken.

And on 64-bit platforms, the patch does not even change the generated
code.

Petr T
