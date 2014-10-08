Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaJHD4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:56:12 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49825 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbaJHD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:56:10 -0400
Message-ID: <5434B5D3.4060308@hurleysoftware.com>
Date: Tue, 07 Oct 2014 23:56:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, Arnd Bergmann <arnd@arndb.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH tty-next 14/22] tty: Remove tty_wait_until_sent_from_close()
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com> <1402924639-5164-15-git-send-email-peter@hurleysoftware.com> <4575870.N9RCpZ4UMg@wuerfel> <53A01F02.7000202@hurleysoftware.com> <063D6719AE5E284EB5DD2968C1650D6D1725DAF6@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1725DAF6@AcuExch.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 07:03 AM, David Laight wrote:
> From: Peter Hurley
> ...
>>> I don't understand the second half of the changelog, it doesn't seem
>>> to fit here: there deadlock that we are trying to avoid here happens
>>> when the *same* tty needs the lock to complete the function that
>>> sends the pending data. I don't think we do still do that any more,
>>> but it doesn't seem related to the tty lock being system-wide or not.
>>
>> The tty lock is not used in the i/o path; it's purpose is to
>> mutually exclude state changes in open(), close() and hangup().
>>
>> The commit that added this [1] comments that _other_ ttys may wait
>> for this tty to complete, and comments in the code note that this
>> function should be removed when the system-wide tty mutex was removed
>> (which happened with the commit noted in the changelog).

I just wanted to revisit this discussion briefly so I can clarify the
situation regarding holding the tty lock while closing, and how that
affects parallel opens.

I've unnested the tty lock from the tty mutex (which I'm still testing)
but will be submitting after the merge window re-opens for 3.19. So this
is more relevant now.

The original patch that led to this thread is here:
https://lkml.org/lkml/2014/6/16/306


> What happens if another process tries to do a non-blocking open
> while you are sleeping in close waiting for output to drain?
> 
> Hopefully this returns before that data has drained.

Current mainline blocks on _any_ racing re-open while this lock is
dropped in tty_wait_until_sent_from_close(); blocking while
ASYNC_CLOSING has been in mainline since at least 2.6.29 and that just
merged existing code together. See tty_port_block_til_ready(); note
the test for O_NONBLOCK is after the wait while ASYNC_CLOSING.

IOW, currently a non-blocking open will sleep for the _entire_ duration
of a parallel hardware shutdown, and when it wakes, the error return will
cause a release of its tty, and it will restart with a fresh attempt
to open. Same with a blocking open that is already waiting; when its
woken the hardware shutdown has already completed so ASYNC_INITIALIZED
is cleared, which forces a release and restart too.

The point being that holding the tty lock across the _entire_ close
is equivalent to the current outcome, regardless of O_NONBLOCK.

I'm reluctant to start returning EGAIN for non-blocking tty opens
because no tty driver does that now, and I don't think userspace will
deal well with new return codes from tty opens.

Regards,
Peter Hurley

