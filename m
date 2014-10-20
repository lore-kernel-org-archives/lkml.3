Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaJTAXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:23:10 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:39108 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaJTAXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:23:06 -0400
MIME-Version: 1.0
In-Reply-To: <54445079.4000803@oracle.com>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
	<20141019210348.GA28144@drone.musicnaut.iki.fi>
	<CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
	<20141019231031.GB9319@node.dhcp.inet.fi>
	<CA+55aFxf6_cA5hTtDGqPU4=DkKz_6OUizhiqge+Xf5u34RxeXw@mail.gmail.com>
	<54445079.4000803@oracle.com>
Date: Sun, 19 Oct 2014 17:23:04 -0700
X-Google-Sender-Auth: rHY3t-8mKrLkbGRrKJ-0DKPkr-E
Message-ID: <CA+55aFwGWbRcrRxnmc7JrEZh+25zNVw7_PqQiCThHr1An=C4_g@mail.gmail.com>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andrew Pinski <pinskia@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 4:59 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> AndrewP, mind explaing the other difference you mentioned (ie wrt
>> "extern inline")? I thought we had already long since ended up
>> following the gcc semantics (ie use "static inline" if we don't have
>> an external version somehwre), what exactly changed?
>
> (Stolen from gcc changelog:)
>
> gnu89: extern inline: Will not generate an out-of-line version, but
>         might call one.
> gnu99: extern inline: like GNU "inline", externally visible code is
>         emitted.
>
> (So what happens is that with gnu99 you end up with multiple definitions
> of the symbol since it was externed from multiple compilation units).

Oh Christ. So this got broken yet again, even *after* they had
documented the old behavior?

Originally, gcc documented that "extern inline" is a good replacement
for a macro. Then, that changed, and "static inline" became the
replacement for a macro, and "extern inline" was to mean that *if* it
gets inlined, that definition is used, but otherwise there's supposed
to be an external non-inlined copy somewhere else (so the inline
definition of the function is basically entirely ignored when not
inlining for one reason or another).

So now we have a *third* semantic of "extern inline", and one that
seems to be entirely inappropriate to *ever* be used in a header file
due to duplicate symbol problems. What a mess.

Maybe we should just specify "gnu89" to avoid these kinds of insane
semantic changes.

                     Linus
