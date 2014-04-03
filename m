Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaDCRGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:06:23 -0400
Received: from imap.thunk.org ([74.207.234.97]:49609 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaDCRGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:06:12 -0400
Date: Thu, 3 Apr 2014 13:05:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140403170541.GA19010@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joerg Roedel <joro@8bytes.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mateusz Guzik <mguzik@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
	Kay Sievers <kay@vrfy.org>
References: <20140402144219.4cafbe37@gandalf.local.home>
 <20140402221212.GD16570@mguzik.redhat.com>
 <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
 <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
 <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
 <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
 <20140403104308.GP13491@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403104308.GP13491@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:43:08PM +0200, Joerg Roedel wrote:
> 
> How about just ignoring writes to /dev/kmsg altogether by default
> (unless explicitly enabled in Kconfig or on the kernel cmdline)? Maybe I
> am missing something but what are the legitimate use-cases for generally
> allowing user-space to write into the kernel-log?

I'll give you one example which where /dev/kmesg is useful --- if you
are running automated kernel tests, echoing "running test shared/127"
.... several minutes later .... "running test shared/128", is very
useful since if the kernel starts spewing warnings, or even
oops/panics/livelocks, you know what test was running at the time of
the failure.

So in general, most of the valid use cases I can see for /dev/kmesg
are small amounts of information where understanding the relationship
between what is going in userspace can help understand the kernel
warnings, errors, or other printk messages.  Which is why I think rate
limiting, even with a very low threshold, is a perfectly good alternative.

If you need to do bulk logging, and the problem is you want to make
sure the information doesn't get lost because syslogd/journald hasn't
started up yet, or the file system hasn't been remounted read/write
yet, there is a simple answer to this, and it doesn't involve spamming
the kernel ring buffer (because kernel memory is non-swappable).

The answer is logsave(8), which I developed to solve this specific
problem.  I wanted to make sure distributions could capture the output
of fsck, even when checking the read-only root file system.  Note that
I did not even *consider* spamming the dmesg log with e2fsck output.
Instead, I created a userspace logsave process which could buffer the
output (which of course was still displayed on the console) until the
root file system was writeable (and/or /var was mounted), at which
point the contents could be saved to a file in /var/log.

So there are so many other ways of solving this problem without trying
to abuse the kernel logging facilities (which were never intended to
be a general-purpose syslog replacement).  I suspect some systemd
developer was being lazy....

					- Ted
