Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaIKApI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:45:08 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35211 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbaIKApF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:45:05 -0400
Message-ID: <5410F08D.10707@hurleysoftware.com>
Date: Wed, 10 Sep 2014 20:45:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com> <20140911000343.GA5328@kroah.com> <5410E8A2.5030802@hurleysoftware.com> <20140911002410.GA11732@kroah.com>
In-Reply-To: <20140911002410.GA11732@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 08:24 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 10, 2014 at 08:11:14PM -0400, Peter Hurley wrote:
>> On 09/10/2014 08:03 PM, Greg Kroah-Hartman wrote:
>>> On Wed, Sep 10, 2014 at 05:28:19PM -0400, Peter Hurley wrote:
>>>> This patch changes user-space behavior (for the better) but I'm not sure
>>>> that it's consequence-free. Also, it might not be enough to unwedge the
>>>> terminal if the driver got its own flow control state mangled.
>>>>
>>>> Thoughts?
>>>>
>>>> --- >% ---
>>>> Subject: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
>>>>
>>>> If terminal flow has been stopped, the terminal can be unwedged
>>>> by:
>>>> 	tcflow(fd, TCOOFF);
>>>> 	tcflow(fd, TCOON);
>>>> This works because tcflow(TCOOFF) ensures that ->flow_stopped is set,
>>>> which allows tcflow(TCOON) to override the terminal flow state in
>>>> __start_tty().
>>>>
>>>> Instead, allow unwedging with only:
>>>>         tcflow(fd, TCOON);
>>>> by disregarding the existing ->flow_stopped state.
>>>
>>> I don't see the benifit here, what are you trying to solve?  Sending one
>>> extra tcflow command?
>>
>> It's not common knowledge (and its certainly counterintuitive) that
>> turning off output when output is already turned off (ie., tcflow(TCOOFF))
>> is the required trickery to unwedge a terminal.
>>
>> Unwedging directly seems the straightforward approach.
> 
> What's the odds we break POSIX with this type of change?

SUSv3 and v4 do not specify how tcflow() interacts with flow control
from the remote side, so POSIX breakage is not possible.

> I'm all for working around broken hardware in the kernel, but this seems
> like a very old issue, if it's even one at all, that we would be
> changing for no one who has reported it (that I know of...)

How to unwedge a terminal comes up from time to time.

> In other words, I'm really leary of changing userspace functionality
> without having a real need/reason to.

It's possible that this may cause userspace breakage. Some app
may call tcflow(TCOON) thus accidently overriding the flow control
state when it would have had no effect before.

I'm not invested in this patch so I have no problem if you don't
want to take this.

Regards,
Peter Hurley
