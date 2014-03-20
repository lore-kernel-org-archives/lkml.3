Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672AbaCTOmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:42:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43569 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaCTOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:42:13 -0400
Date: Thu, 20 Mar 2014 14:41:27 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@bitplanet.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
Message-ID: <20140320144127.1d411f26@alan.etchedpixels.co.uk>
In-Reply-To: <CANq1E4TuiU6_J=N0WoPav=0AxOJ9G1w+FGvO15kmGP76i+-caw@mail.gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFyNORiS2XidhWoDBVyO6foZuPJTg_BOP3aLtvVhY1R6mw@mail.gmail.com>
	<CANq1E4TuiU6_J=N0WoPav=0AxOJ9G1w+FGvO15kmGP76i+-caw@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My first idea was to add MFD_ALLOW_SEALING as memfd_create() flag,
> which enables the sealing-API for that file. Then I looked at POSIX

This actually seems the most sensible to me. The reason being that if I
have some existing used object there is no way on earth I can be sure who
has existing references to it, and we don't have revoke() to fix that.

So it pretty much has to be a new object in a sane programming model.

> mandatory locking and noticed that it provides similar restrictions on
> _all_ files. Mandatory locks can be more easily removed, but an

The fact someone got it past a standards body doesn't make it a good idea.

> attacker could just re-apply them in a loop, so that's not really an
> argument. Furthermore, sealing requires _write_ access so I wonder
> what kind of DoS attacks are possible with sealing that are not
> already possible with write access? And sealing is only possible if no
> writable, shared mapping exists. So even if an attacker seals a file,
> all that happens is EPERM, not SIGBUS (still a possible
> denial-of-service scenario).

I think you want two things at minimum

owner to seal
root can always override

I would query the name too. Right now your assumption is 'shmem only' but
that might change with other future use cases or types (eg some driver
file handles) so SHMEM_ in the fcntl might become misleading.

Whether you want some way to undo a seal without an exclusive reference as
the file owner is another question.

Alan
