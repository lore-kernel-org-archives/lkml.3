Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaCTIIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:08:36 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60792 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaCTIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyNORiS2XidhWoDBVyO6foZuPJTg_BOP3aLtvVhY1R6mw@mail.gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFyNORiS2XidhWoDBVyO6foZuPJTg_BOP3aLtvVhY1R6mw@mail.gmail.com>
Date: Thu, 20 Mar 2014 09:07:06 +0100
Message-ID: <CANq1E4TuiU6_J=N0WoPav=0AxOJ9G1w+FGvO15kmGP76i+-caw@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Mar 20, 2014 at 4:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Is there really any use-case where the sealer isn't also the same
> thing that *created* the file in the first place? Because I would be a
> ton happier with the notion that you can only seal things that you
> yourself created. At that point, the exclusive reference isn't such a
> big deal any more, but more importantly, you can't play random
> denial-of-service games on files that aren't really yours.

My first idea was to add MFD_ALLOW_SEALING as memfd_create() flag,
which enables the sealing-API for that file. Then I looked at POSIX
mandatory locking and noticed that it provides similar restrictions on
_all_ files. Mandatory locks can be more easily removed, but an
attacker could just re-apply them in a loop, so that's not really an
argument. Furthermore, sealing requires _write_ access so I wonder
what kind of DoS attacks are possible with sealing that are not
already possible with write access? And sealing is only possible if no
writable, shared mapping exists. So even if an attacker seals a file,
all that happens is EPERM, not SIGBUS (still a possible
denial-of-service scenario).

But I understand that it is quite hard to review all the possible
scenarios. So I'm fine with checking inode-ownership permissions for
SET_SEALS. We could also make sealing a one-shot operation. Given that
in a no-trust situation there is never a guarantee that the other side
drops its references, re-using a sealed file is usually not possible.
However, in sane environments, this could be a nice optimization in
case the other side plays along. The one-shot semantics would allow
dropping reference-checks entirely. The inode-ownership semantics
would still require it.

Thanks
David
