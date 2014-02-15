Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaBOWnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 17:43:08 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34564 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaBOWnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:43:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140215222844.GA18201@redhat.com>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard>
	<20140214002427.GN13997@dastard>
	<20140214160123.GA28125@redhat.com>
	<20140215222356.GU13997@dastard>
	<20140215222844.GA18201@redhat.com>
Date: Sat, 15 Feb 2014 14:43:03 -0800
X-Google-Sender-Auth: swUowRsGrSNTEo6YcDhjGhC_ZE0
Message-ID: <CA+55aFyGgjSgdJm=cBXGdrSO1pV95yxjVymC1QbjvonB-_GF8g@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 2:28 PM, Dave Jones <davej@redhat.com> wrote:
>
> I've got a shitload of debug options enabled, which may explain it.
> Or perhaps that new STACK_PROTECTOR_STRONG stuff ?

Well, a lot of it is just the callee-saved registers. The compiler
will tend to preferentially allocate registers in the callee-trashed
registers, but if the function isn't a leaf function, any registers
that are live around a function call will have to be saved somewhere -
either explicitly around the function call, or - more likely - in
callee-saved registers that then get saved in the prologue/epilogue of
the function. And this will happen even in leaf functions when there
is enough register pressure that the callee-trashed registers aren't
sufficient (which is pretty common).

So saving 5-6 registers on the stack (in addition to any actual stack
frame) is pretty much the norm for anything but the very simplest
cases.

But yeah, I'm sure some config options make it worse.
STACK_PROTECTOR_STRONG could easily be one of those.

            Linus
