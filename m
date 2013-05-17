Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3EQGMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:12:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:48184 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3EQGMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:12:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,690,1363158000"; 
   d="scan'208";a="242860590"
Subject: Re: [PATCH] tty_buffer: avoid race due to tty_buffer_free_all()
 being misused
From: channing <chao.bi@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <5194D6F9.5000505@hurleysoftware.com>
References: <1368694762.2911.16.camel@bichao>
	 <5194D6F9.5000505@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 May 2013 14:29:38 +0800
Message-ID: <1368772178.1876.31.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 08:54 -0400, Peter Hurley wrote:
> On 05/16/2013 04:59 AM, channing wrote:
> >
> > In tty_buffer.c, function tty_buffer_free_all() is used to remove
> > all buffers for a tty, although it's declared that it mustn't be called
> > when the tty is in use, it cannot guarantee that. we can observe some
> > device driver make use it by mistake, for example, while tty device is
> > releasing, the tty data forwarding is not stopped, then it might hit
> > the case that tty buffer is being used while tty_buffer_free_all()
> > free this tty buffer, and finally lead to random error at any places,
> > and it's not clear to debug.
> 
> What kernel version?
3.4
> 
> > Although device driver could do better, it's simpler and safer to
> > strengthen protection in the view of tty buffer, by adding a tty->buf.lock
> > in tty_buffer_free_all() to avoid it racing with ongoing tty buffer
> > operations.
> 
> Sorry, but this isn't correct.
> 
> The driver cannot continue to perform i/o concurrently with
> tty_port_destroy().
> 
Thanks for remind, 3.4 haven't tty_port_destroy(), the mainline has
changed the way to call tty_buffer_free_all().

> If the concurrent use you're observing is with flush_to_ldisc(),
> that should be fixed in current mainline.
> 
Yes, when calling flush_to_ldisc() in Kernel 3.4, we could observe the
tty buffer is corrupted, and dummped stack shows that
tty_buffer_free_all() was called before. Is it a known issue fixed in
old version? would you please tell me related patch to solve this
flush_to_ldisc() issue? Thanks very much.

Chao

