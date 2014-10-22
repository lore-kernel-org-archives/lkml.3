Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaJVRea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:34:30 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49264 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031AbaJVRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:34:27 -0400
Message-ID: <5447EA9F.1070401@hurleysoftware.com>
Date: Wed, 22 Oct 2014 13:34:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next 11/27] tty: Don't release tty locks for wait queue
 sanity check
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>	<1413491125-20134-12-git-send-email-peter@hurleysoftware.com> <20141022162911.432c9bcc@alan.etchedpixels.co.uk>
In-Reply-To: <20141022162911.432c9bcc@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 11:29 AM, One Thousand Gnomes wrote:
>> However, without needing the global tty_mutex held, the tty locks for
>> the releasing tty can now be held through the sleep. The sanity check
>> is for abnormal conditions caused by kernel bugs, not for recoverable
>> errors caused by misbehaving userspace; dropping the tty locks only
>> allows the tty state to get more sideways.
> 
> An open with O_NDELAY on the closing port now appears to be able to jam
> for 2 minutes ? Peviously it would at least be released by a signal.
> 
> That seems like a regression (and given the timeout is long) a bug.

This patch should only affect _really abnormal_ situations.

The only way that a tty is spinning in this loop and not getting released
is if the tty count is going to zero but some other thread is still on one
of the wait queues, but that's only possible if either:
1. the other thread never removed itself from the wait queue because it
crashed while on the wait queue, or
2. if somehow a thread is sleeping on one of the wait queues without having
passed through vfs.

IOW, since the tty count is going zero, the release in progress must be
for the last file descriptor for this tty, so how can some other thread
be on one of the wait queues without an in-use descriptor.

Both are serious errors, and the failed sanity test shows that the tty state
is corrupted; an open should not succeed as long as this is true.

It'll take some experimentation to see if the first situation is identifiable
and remediable; I'll put it on my todo list.

> Given that some code handles multiple tty devices using select and
> nonblocking opens on physical ports this one bothers me a little. The old
> behaviour wasn't right either (and actually stops Linux running some
> modem manager type tools), but the new behaviour looks worse.
> 
> Probably though the right way to fix it is in the open path ?

Yes, the tty lock in tty_open() should be interruptible. I've built a matrix
of how open() races with the previous release behavior at different locking
points so that the existing outcome can be replicated (or more easily analyzed
to decide if that's the behavior we want and how/whether to change that
behavior). The sticking point right now is dealing with how ASYNC_HUP_NOTIFY
modifies the outcome of the open. This also entails significant code archaeology.

I'm also exploring making the tty count atomic so that a racing open
can prevent a concurrent release from going to final close, which will
help to minimize the time window that an open will fail with EIO.

But first, I need to push out some more patches that have been unit-tested
(and -- don't laugh -- explore why printk disables interrupts and prevents
cpu migration while calling the console drivers. Seems ok to me...)

Regards,
Peter Hurley
