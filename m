Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3KXAXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:23:07 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41046 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3KXAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:23:04 -0500
Date: Sun, 24 Nov 2013 00:22:54 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 5/7] n_tty: Refactor input_available_p() by
 call site
Message-ID: <20131124002254.265c2d28@alan.etchedpixels.co.uk>
In-Reply-To: <1385135965-4235-6-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
	<1385135965-4235-6-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 10:59:23 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> Distinguish if caller is n_tty_poll() or n_tty_read(), and
> set the read/wakeup threshold accordingly.

That looks very wrong to me. The poll() and read() wakeup should always
match. In addition if MIN_CHAR is set without a timeout then it should not
wake up until MIN_CHAR characters are present. The MIN_CHAR feature is
used by various (these days obscure) protocols to optimise block transfer
rates.

Changing this is also a userspace visible API change.

So NAK.

The underlying intention of the system (and SYS5.4) is that you can do

	MIN_CHAR = 64

	alarm(some_timeout)
	while(1) {
		poll();
		events
		read(chunksized blocks)
	}

while it's hardly as critical with modern fast hardware its still the API
and necessary to avoid SWS type behaviours in the queue turning it from
block/syscall to byte I/O.

Alan
