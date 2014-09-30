Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaI3TEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:04:11 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:42567 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaI3TEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 12:04:08 -0700
X-Google-Sender-Auth: j1B-SwSOhmxv_-RwSeIvuo38sd8
Message-ID: <CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
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
> thread, at http://sourceforge.net/p/fuse/mailman/message/29889055/)

>From a quick look at that thread, the solution is clear: you *must*
flush your write buffers in the "flush" function.

The fact that you must flush write buffers multiple times if people
have done "dup()" is a complete non-issue. Just flush them each time.
There is no "how do I differentiate the first flush and
the second flush?" The answer is that you don't, and that you MUST
NOT. You need to flush on both (or more). Trying to distinguish first
vs second is broken, and would be wrogn *anyway*. There is no possible
situation where it could validaly matter, and you simply cannot tell.

Don't do any data structure cleanups, that's for "release()". But yes,
you do have to flush write buffers at flush time (and return IO errors
if they happen). That's very much the point of flush.

               Linus
