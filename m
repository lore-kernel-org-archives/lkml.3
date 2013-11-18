Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3KRRhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:37:15 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54344 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297Ab3KRRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:37:10 -0500
Message-ID: <528A5043.6030901@hurleysoftware.com>
Date: Mon, 18 Nov 2013 12:37:07 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Heorhi Valakhanovich <valahanovich@tut.by>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] tty: Only hangup once
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>	<20131117203850.46df2124@tormoz-pc> <20131118134211.17861db3@alan.etchedpixels.co.uk>
In-Reply-To: <20131118134211.17861db3@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 08:42 AM, One Thousand Gnomes wrote:
>> After upgrading to kernel 3.12 I noticed one issue with tmux software.
>> The easiest way to reproduce will be:
>> 1. Start tmux session as root.
>> 2. Connect via ssh and use "tmux attach" to attach to the running
>> session.
>> 3. Kill ssh client.

Heorhi,

Thanks for the report.

>> You can notice that shell (zsh in my case) and "tmux attach" are still
>> remains in process' list. That didn't happen in previous kernels.

This may have been a bug in previous kernels.
The tmux(1) man page has this to say:

      Each session is persistent and will survive accidental disconnection
      (such as ssh(1) connection timeout) or intentional detaching (with the
      `C-b d' key strokes).  tmux may be reattached using:

            $ tmux attach


I'll confirm with tmux author(s) what the intended behavior is.

>> I've tried to bisect this in kernel sources and found commit
>> cb50e5235b8ae5aa0fe422eaaa8e444024c5bd98 which contains this exact
>> patch. I have not enough experience to investigate more so most likely
>> I will not find anything more. But it will be good if someone more
>> experienced will have a look at it.
>
> The patch should be reverted. The submission gives no reason that the
> patch was required - it just adds code and optimises a path that doesn't
> need optimising anyway.

Alan,

This patch isn't about optimizing; it's about guaranteeing the line discipline
and a tty driver that ops->hangup() will only occur once for any given tty.

> It's theoretically true you only need one hangup, unfortunately however
> I think it has to be the *last* hangup not the first or there are races
> between the tty code and the process group handling.

I doubt this is caused by a race condition; the first hangup would do most
of the destruction regardless, and a second hangup can't really race with
the first because of the tty_lock() held for most of the hangup.

In any event, it's worth discovering what state a subsequent hangup can
effect that the first hangup left incomplete. I'll look into it.

Regards,
Peter Hurley
