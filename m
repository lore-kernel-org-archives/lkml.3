Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab3GWM5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:57:51 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:45934 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932168Ab3GWM5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:57:48 -0400
Message-ID: <51EE7DC8.3060004@hurleysoftware.com>
Date: Tue, 23 Jul 2013 08:57:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Andre Naujoks <nautsch2@gmail.com>,
        Dean Jenkins <Dean_Jenkins@mentor.com>
Subject: Re: [PATCH v2 20/20] tty: Remove extra wakeup from pty write() path
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com> <1371306096-5571-1-git-send-email-peter@hurleysoftware.com> <1371306096-5571-21-git-send-email-peter@hurleysoftware.com> <51EAC23F.9050101@hurleysoftware.com>
In-Reply-To: <51EAC23F.9050101@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 01:00 PM, Peter Hurley wrote:
> On 06/15/2013 10:21 AM, Peter Hurley wrote:
>> Acquiring the write_wait queue spin lock now accounts for the largest
>> slice of cpu time on the tty write path. Two factors contribute to
>> this situation; a overly-pessimistic line discipline write loop which
>> _always_ sets up a wait loop even if i/o will immediately succeed, and
>> on ptys, a wakeup storm from reads and writes.
>>
>> Writer wakeup does not need to be performed by the pty driver.
>> Firstly, since the actual i/o is performed within the write, the
>> line discipline write loop will continue while space remains in
>> the flip buffers. Secondly, when space becomes avail in the
>> line discipline receive buffer (and thus also in the flip buffers),
>> the pty unthrottle re-wakes the writer (non-flow-controlled line
>> disciplines unconditionally unthrottle the driver when data is
>> received). Thus, existing in-kernel i/o is guaranteed to advance.
>> Finally, writer wakeup occurs at the conclusion of the line discipline
>> write (in tty_write_unlock()). This guarantees that any user-space write
>> waiters are woken to continue additional i/o.
>
> Greg,
>
> I thought I should let you know I'm tracking down a bug/regression
> related to this patch.
>
> In certain unusual pty/ldisc configurations, i/o fails to make
> forward progress. I still stand by my commit message above, so I'm
> in the process of instrumenting the i/o path so I can uncover the
> cause of the failure.

Mystery solved.

[PATCH v4 23/24] n_tty: Special case pty flow control
from the lockless n_tty receive path series introduced a regression
in which i/o failed to advance.

This only occurred when one end of a pty pair was set to an ldisc
other than N_TTY. The special case optimization which that patch
introduces failed to address that configuration.

I've sent a v5 of that patch to resolve the regression.

Regards,
Peter Hurley
