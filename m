Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3JWNns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:43:48 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42565 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275Ab3JWNnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:43:47 -0400
Message-ID: <5267D28B.5020805@hurleysoftware.com>
Date: Wed, 23 Oct 2013 09:43:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: epoll oops.
References: <20131014154627.GA9525@redhat.com>	<CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com> <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
In-Reply-To: <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 04:57 PM, Linus Torvalds wrote:
> [ Adding Pekka to verify the SLAB_DESTROY_BY_RCU semantics, and Peter
> Hurley due to the possible tty association ]

> And I see a few worrisome cases. For example, look at "tty_poll()". It
> ends up doing something very similar, except it uses the tty instead
> of sighand. And exactly like the sighand struct, the tty allocation
> lifespan can - thanks to hangup() - be shorter than the file
> allocation lifespan.
>
> Peter? Does a tty hangup end up actually possibly freeing the tty
> struct? Looking at it, I'm starting to think that it only affects
> f_op, and the "struct tty" stays around, in which case this is all
> fine.

The tty_struct is only freed at the completion of the tty's
file_operations .release method (tty_release()). Further, it should
not be possible to advance past the tty_ldisc_release() call in
tty_release() while file operations such as tty_poll() -> poll_wait()
or a tty hangup are in-progress.

[Notwithstanding the above, if some kernel driver failed to acquire
a tty reference, either directly or via tty_port_tty_hangup(), before
hanging up, then the hangup could be racing with the .release(). But
I don't think that's what's happening here.]


On 10/15/2013 11:48 AM, Oleg Nesterov wrote:>> Hmm? There might be other cases..
 >
 > Yes.
 >
 > Dave, perhaps you have vmcore? I have no idea if this is possible or
 > not, but perhaps you can look at eventpoll_release_file's frame and
 > print file->f_op ?

I think Oleg's suggestion is the next diagnostic step.

Regards,
Peter Hurley





