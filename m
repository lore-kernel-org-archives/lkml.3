Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaDKVeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:34:24 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37024 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaDKVeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <53485BB8.1000106@mit.edu>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<53483487.6030103@zytor.com>
	<53485BB8.1000106@mit.edu>
Date: Fri, 11 Apr 2014 14:34:20 -0700
X-Google-Sender-Auth: DOmfa8Y4hwbg45TVFdFeaK6b3d0
Message-ID: <CA+55aFz_s2P9=kQNgOstUeRrv6yN4o7BSciT6t1mMR7ZdNQOsA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I wonder if there's an easy-ish good-enough fix:

Heh. Yes. Check the thread on lkml about three weeks ago under the
subject "x86-64: Information leak: kernel stack address leaks to user
space". It had exactly that as a suggestion.

Anyway, I ended up pulling the current change - let's see if anybody even cares.

And if somebody *does* care, maybe we can just do a trivial sysctl. If
you are running 16-bit apps under wine, the default kernel setup
already stops you: the 'mmap_min_addr' being non-zero means that that
already will not run.

But yeah, I personally don't care about the high bits of rsp one whit,
since that has never worked on x86-64. But the information leak needs
to be plugged, and a percpu stack can fix that.

I'm a bit worried that a percpu stack can cause issues with NMI's,
which already have too much complexity in them, so I don't think it's
*entirely* trivial to do. And the exception that the 'iretq' can take
adds more complexity wrt kernel stack pointer games. Which is why I'm
not at all sure it's worth it.

              Linus
