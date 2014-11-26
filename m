Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaKZAZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbaKZAZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:25:11 -0500
Date: Tue, 25 Nov 2014 19:25:01 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141126002501.GA11752@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 10:33:19PM -0800, Linus Torvalds wrote:

 > I have no ideas left. I'd go for a bisection - rather than try random
 > things, at least bisection will get us a smaller set of suspects if
 > you can go through a few cycles of it. Even if you decide that you
 > want to run for most of a day before you are convinced it's all good,
 > a couple of days should get you a handful of bisection points (that's
 > assuming you hit a couple of bad ones too that turn bad in a shorter
 > while). And 4 or five bisections should get us from 11k commits down
 > to the ~600 commit range. That would be a huge improvement.

There's 8 bisections remaining. The log so far:

git bisect start
# good: [bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9] Linux 3.17
git bisect good bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9
# bad: [f114040e3ea6e07372334ade75d1ee0775c355e1] Linux 3.18-rc1
git bisect bad f114040e3ea6e07372334ade75d1ee0775c355e1
# bad: [f114040e3ea6e07372334ade75d1ee0775c355e1] Linux 3.18-rc1
git bisect bad f114040e3ea6e07372334ade75d1ee0775c355e1
# bad: [35a9ad8af0bb0fa3525e6d0d20e32551d226f38e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect bad 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e
# bad: [35a9ad8af0bb0fa3525e6d0d20e32551d226f38e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect bad 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e
# bad: [683a52a10148e929fb4844f9237f059a47c0b01b] Merge tag 'tty-3.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad 683a52a10148e929fb4844f9237f059a47c0b01b
# bad: [683a52a10148e929fb4844f9237f059a47c0b01b] Merge tag 'tty-3.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad 683a52a10148e929fb4844f9237f059a47c0b01b
# bad: [76272ab3f348d303eb31a5a061601ca8e0f9c5ce] staging: rtl8821ae: remove driver
git bisect bad 76272ab3f348d303eb31a5a061601ca8e0f9c5ce
# bad: [e988e1f3f975a9d6013c6356c5b9369540c091f9] staging: comedi: ni_at_a2150: range check board index
git bisect bad e988e1f3f975a9d6013c6356c5b9369540c091f9
# bad: [bd8107b2b2dc9fb1113bfe1a9cf2533ee19c57ee] Staging: bcm: Bcmchar.c: Renamed variable: "RxCntrlMsgBitMask" -> "rx_cntrl_msg_bit_mask"
git bisect bad bd8107b2b2dc9fb1113bfe1a9cf2533ee19c57ee
# bad: [91ed283ab563727932d6cf92b74dd15226635870] staging: rtl8188eu: Remove unused function rtw_IOL_append_WD_cmd()
git bisect bad 91ed283ab563727932d6cf92b74dd15226635870


The reason I'm checking in at this point, is that I'm starting to see different
bugs at this point, so I don't know if I can call this good or bad, unless
someone has a fix for what I'm seeing now.

Reminiscent of a bug a couple releases ago. Processes about to exit, but stuck
in the kernel continuously faulting..
http://codemonkey.org.uk/junk/weird-hang.txt
The one I'm thinking of got fixed way before 3.17 though.

Does that trace ring a bell of something else I could try on top of
each bisection point ?

I rebooted and restarted my test at the current bisection point,
hopefully it'll show up as 'bad' before the bug above happens again.

	Dave

