Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaI3SW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:22:58 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49100 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaI3SW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 11:22:56 -0700
X-Google-Sender-Auth: vu9mhGnN5iYXo3iGb7UBc1g6ays
Message-ID: <CA+55aFwuit+5j2=k2Ks+um+ooH_iyX1pWCMEx==dw2r_4N2ouA@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anand Avati <avati@gluster.org>
Cc: Maxim Patlasov <MPatlasov@parallels.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:33 PM, Anand Avati <avati@gluster.org> wrote:
>
> In general that sounds reasonable. The problem (as described in the original
> thread, at http://sourceforge.net/p/fuse/mailman/message/29889055/) happens
> in the presence of dup(). Tools like dd (and others) call dup(), and a
> second file descriptor is created for the same filp. Every descriptor's
> close() results in a ->flush(). The final close() of course results in
> ->release() as well.

The thing is, that final close() does not AT ALL "of course result in
->release() as well".

There are any number of things that can delat that release. Not just
mmap(), but simply things like some other process looking at the file
descriptor in /proc.

So I agree that flush can - and will - be called multiple times. So
what? That's the only thing you have if you want something
*synchronous*. Really.

fput() is not synchronous, and never will be. End of discussion. If
you think it is, you are wrong. If you try to make it so, you're
making things worse. Really. Really really.

Real filesystems handle this flush vs release difference well. If
yours does not, yours is broken. Understand that.

          Linus
