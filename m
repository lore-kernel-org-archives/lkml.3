Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaBLG2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:28:15 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:43894 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBLG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:28:13 -0500
MIME-Version: 1.0
In-Reply-To: <20140212054043.GB13997@dastard>
References: <20140211172707.GA1749@redhat.com>
	<20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
Date: Tue, 11 Feb 2014 22:28:12 -0800
X-Google-Sender-Auth: zoDCgIsVmi8gSgx8XGVhucqn2vc
Message-ID: <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 9:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> None of the XFS code disables interrupts in that path, not does is
> call outside XFS except to dispatch IO. The stack is pretty deep at
> this point and I know that the standard (non stacked) IO stack can
> consume >3kb of stack space when it gets down to having to do memory
> reclaim during GFP_NOIO allocation at the lowest level of SCSI
> drivers. Stack overruns typically show up with symptoms like we are
> seeing.

That would also explain why it shows up for do_coredump(), even though
clearly interrupts are not disabled at that point. It's just because
do_coredump() opens a filename at a deeper point in the stack than the
more normal system call paths do.

It looks like just "do_signal()" has a stack frame that is about 230
bytes even under normal circumstancs (largely due to "struct ksignal"
- which in turn is largely due to the insane 128-byte padding in
siginfo_t). Add a few other frames in there, and I guess that if it
was close before, the coredump path just makes it go off.

And some of the debug options that I'm sure DaveJ has enabled tend to
make the stack usage worse (simply because they make a lot of data
structures bigger).

             Linus
