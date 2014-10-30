Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829AbaJ3VCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:02:14 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36740 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934506AbaJ3VCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <54525F32.3040502@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
 <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
 <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
 <54525F32.3040502@zonque.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Oct 2014 14:01:50 -0700
Message-ID: <CALCETrV6MLYUQN6mqZbH=FrLyrETVoemtdC05po8+X=6SKQ70A@mail.gmail.com>
Subject: Re: kdbus: add code to gather metadata
To: Daniel Mack <daniel@zonque.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 8:54 AM, Daniel Mack <daniel@zonque.org> wrote:
> On 10/30/2014 03:07 PM, Andy Lutomirski wrote:
>> On Thu, Oct 30, 2014 at 1:45 AM, Daniel Mack <daniel@zonque.org> wrote:
>>> 2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
>>> later query the credentials of the owner of the bus they're connected to.
>>
>> Ditto.  Although, why on earth should a bus have credentials?  This
>> sounds like a misdesign.  It seems to me that this type of policy
>> belongs all the way in userspace.  If you want a bus, you ask the
>> owner of the entire domain to make you a bus.  Or you make it yourself
>> and hand off references in some authenticated way.
>
> Yes, that's the way it works. However, the idea is that a bus stays
> alive as long as the file descriptor that was used to the create that
> bus remains open, and it is immediately shut down when the fd is closed.
> We merely allow user that are connected to a bus to query the
> credentials of the creator of the bus they're connected to.

Why do you allow this?  What purpose does it serve?  Is that idea that
each application will own one bus?  If so, what goes wrong if you only
capture the specific credentials that the creator of a given bus asks
to have captured?

[snip]

>
>> If I create an endpoint and delegate some processing to a less
>> privileged child, other things on the bus MUST NOT be able to detect
>> that delegation in any sensible design.  Otherwise everything will
>> appear to work in testing because other processes never checked the
>> problematic credential, but then it will randomly fail because someone
>> decided to do something daft and validate my unprivileged child's
>> argv[0], which is, of course, not what they expected.
>
> Not sure whether I got your point, but if a privileged service that
> takes action on behalf of unprivileged clients, it may well depend on
> certain credential information to be present along with the message, and
> refuse to take action otherwise.
>
> For example, if a privileged service can reboot the system, it checks
> whether the asking peer has CAP_SYS_BOOT set. If it checks for uid==0
> instead, and it works in your tests because you happen to test as root,
> that just a bug in the service, right? But I might have missed your point.

The issue is the following: if have the privilege needed to talk to
journald, I may want to enhance security by opening a connection to
journald (and capture that privilege) and then drop privilege.  I
should still be able to talk to journald.

Alternatively, if the privilege needed to reboot is CAP_SYS_BOOT, then
clients should send that capability bit.  Capturing extra information
to try to give daemons the flexibility to change their authorization
conditions later on just moves the problem if you need to change
policy down the line.

>
>> I suspect that, if you make credential sending opt-in, you will
>> quickly discover that the current model for which credentials matter
>> makes no sense.
>
> While for the example above, opting-in for creds items on the sender
> side might actually work (the asking service would be refused in his
> request to reboot the machine). However, for any sort of logging or
> system services, for example, allowing the sender to select which creds
> it wants to reveal is supporting a hide-and-seek game, and that's
> something that won't work.

What's the actual problem for logging?  I very much understand why a
logging service never wants to log an incorrect credential (and legacy
syslog has serious problems here because it doesn't even try to
capture credential), but what's wrong with having a log that shows the
uid for legit log messages and that reliably says "declined to state"
for messages that decline to state.

(Also, I presume that cmdline is for logging.  Keep in mind that the
cmdline is yanked from user memory and can be freely spoofed.)

A major benefit of opt-in credential passing is that it makes it very
difficult to convince another process to exercise its credential on
your behalf by accident.

>
> Thanks for sharing your thoughts on this - I appreciate this discussion
> stays on such technical grounds :)
>

My pleasure.  I have no desire to see this process devolve into random
flames (and I'm glad it hasn't).  That being said, I'll still continue
to object to credential and namespace issues that I think are
problematic. :)

--Andy
