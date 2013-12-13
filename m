Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3LMNGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:06:54 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50005 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3LMNGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:06:52 -0500
Date: Fri, 13 Dec 2013 14:06:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213130648.GA10870@gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <52AA4BC8.1080207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA4BC8.1080207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ryan Mallon <rmallon@gmail.com> wrote:

> On 13/12/13 08:13, Kees Cook wrote:
> > On Thu, Dec 12, 2013 at 11:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> >> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
> >>> From: Vegard Nossum <vegard.nossum@oracle.com>
> >>>
> >>> The idea is simple -- since different kernel versions are vulnerable to
> >>> different root exploits, hackers most likely try multiple exploits before
> >>> they actually succeed.
> > 
> > I like this idea. It serves a few purposes, not the least of which is
> > very clearly marking in code where we've had problems, regardless of
> > the fact that it reports badness to the system owner. And I think
> > getting any additional notifications about bad behavior is a nice idea
> > too.
> 
> Though, if an attacker is running through a series of exploits, and 
> one eventually succeeds then the first thing to do would be to clean 
> traces of the _exploit() notifications from the syslog. [...]

There are several solutions to that:

1)

Critical sites use remote logging over a fast LAN, so a successful 
exploit would have to zap the remote logging daemon pretty quickly 
before the log message goes out over the network.

2)

Some sites also log to append-only media [such as a printer] or other 
append-only storage interfaces - which cannot be manipulated from the 
attacked system alone after a successful break-in.

3)

In future the exploit() code could trigger actual active defensive 
measures, such as immediately freezing all tasks of that UID and 
blocking further fork()s/exec()s of that UID.

Depending on how critical the security of the system is, such active 
measures might still be a preferable outcome even if there's a chance 
of false positives. (Such active measures that freeze the UID will 
also help with forensics, if the attack is indeed real.)

> [...] Since running through a series of exploits is pretty quick, 
> this can probably all be done before the sysadmin ever notices.

It's not necessarily the sysadmin the attacker is racing against, but 
against append-only logging and other defensive measures - which too 
are programs.

> The _exploit() notifications could also be used to spam the syslogs. 
> Although they are individually ratelimited, if there are enough 
> _exploit() markers in the kernel then an annoying person can cycle 
> through them all to generate large amounts of useless syslog.

AFAICS they are globally rate-limited, just like many other 
attacker-triggerable printk()s the kernel may generate.

Thanks,

	Ingo
