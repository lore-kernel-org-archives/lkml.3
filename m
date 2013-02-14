Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459Ab3BNBbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:31:34 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:54516 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3BNBbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:31:32 -0500
MIME-Version: 1.0
In-Reply-To: <511C35CB.2010103@zytor.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com> <511C35CB.2010103@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 17:31:09 -0800
X-Google-Sender-Auth: wnaHLSb82vPh3ETomjV2xRNEBFI
Message-ID: <CA+55aFz6qr_9sjG0Z3Cku3ahHX5zYOMiroryh2rL-HLJ=w0=_g@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 4:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> It does for the callee, but only on a whole-file basis.  It would be a
> lot nicer if we could do it with function attributes.

A way to just set the callee-clobbered list on a per-function basis
would be lovely. Gcc has limited support for this on some
architectures, where you can specify "save every register for this
function" in order to do things like interrupt handlers etc without
even resorting to asm. But there is no generic (or even just x86)
support for anything like it :-(

There are other calling-convention attributes that make me suspect gcc
could easily do this (it already supports per-function ABI
specification, so presumably it already has some concept of
callee-saved registers being different for different attributes), but
from my reading you currently have to generate asm wrappers by hand
(and call them by hand with inline asm) if you want to do something
like this.

And the straightforward "just wrap it in asm" approach sadly then
causes double "call" instructions etc. So that slows down the slow
case unnecessarily much ;(

                 Linus
