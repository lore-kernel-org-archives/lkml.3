Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaBLUNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:13:21 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58146 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaBLUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140212113928.GO18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com>
	<20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
Date: Wed, 12 Feb 2014 12:13:19 -0800
X-Google-Sender-Auth: pxORrkSP4cPaPAaczNRJC15i-Ok
Message-ID: <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 3:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 11, 2014 at 10:28:12PM -0800, Linus Torvalds wrote:
>
>> It looks like just "do_signal()" has a stack frame that is about 230
>> bytes even under normal circumstancs (largely due to "struct ksignal"
>> - which in turn is largely due to the insane 128-byte padding in
>> siginfo_t). Add a few other frames in there, and I guess that if it
>> was close before, the coredump path just makes it go off.
>
> We could, in principle, put it into task_struct and make get_signal()
> return its address - do_signal() is called only in the code that does
> assorted returns to userland...

We have better uses for random buffers in "struct task_struct", I'd
hate to put a siginfo_t there.

The thing is, siginfo_t has that idiotic 128-byte area, but it's all
"for future expansion". I think it's some damn glibc disease - we've
seen these kinds of insane paddings before.

The actual *useful* part of siginfo_t is on the order of 32 bytes. If that.

Sad.

                Linus
