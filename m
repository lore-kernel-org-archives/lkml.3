Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaJTMuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:50:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:60712 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaJTMuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:50:02 -0400
Date: Mon, 20 Oct 2014 08:49:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
Message-ID: <20141020124929.GA23177@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andrey Ryabinin <a.ryabinin@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
	x86@kernel.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Dmitry Vyukov <dvyukov@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <5444EBFA.5030103@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5444EBFA.5030103@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 03:03:22PM +0400, Andrey Ryabinin wrote:
> Hi, Theodore.
> 
> I've got this while booting kernel with ubsan:
> 
>     [    0.000000] ================================================================================
>     [    0.000000] UBSan: Undefined behaviour in ../include/linux/bitops.h:107:33
>     [    0.000000] shift exponent 32 is to large for 32-bit type 'unsigned int'
      ...
>     [    0.000000] _mix_pool_bytes (/home/andrew/linux/ubsan_x86//include/linux/bitopsh:107 /home/andrew/linux/ubsan_x86//drivers/char/randomc:509)

So this doesn't make any sense to me.   This is triggering here:

	w = rol32(*bytes++, input_rotate);

.... but input_rotate should never be >= 32, since it is set this way:

	input_rotate = (input_rotate + (i ? 7 : 14)) & 31;

Just to be sure I've tried adding a:

	WARN_ON(input_rotate >= 32);

before the rol32 line, and it's not triggering for me after booting
under kvm using an i386 kernel.

Is this something you can reliably reproduce?  Can you try putting a
WARN_ON before the rol32() on a kernel w/o usbsan, just to make sure
this isn't some kind of false positive?  And then can you tell me
something more about the .config you are using to build your test kernel?

Thanks,

						- Ted
