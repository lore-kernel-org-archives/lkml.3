Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067AbaJ3Pyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:54:32 -0400
Received: from svenfoo.org ([82.94.215.22]:48655 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758284AbaJ3Pya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:54:30 -0400
Message-ID: <54525F32.3040502@zonque.org>
Date: Thu, 30 Oct 2014 16:54:26 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        alban.crequy@collabora.co.uk,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: kdbus: add code to gather metadata
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com> <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com> <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
In-Reply-To: <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 03:07 PM, Andy Lutomirski wrote:
> On Thu, Oct 30, 2014 at 1:45 AM, Daniel Mack <daniel@zonque.org> wrote:
>>
>> 1. At open() time, So we can tell peers (through KDBUS_CMD_CONN_INFO)
>> about the credentials a connection had when it was created with
>> KDBUS_CMD_HELLO.
> 
> Then the API that tells peers about this information needs to make
> this very clear.

Yes, that's an API that tells you something about a connection, and with
that KDBUS_CMD_CONN_INFO call, you'll always get the information about
the creator of the connection. IOW: by calling that particular ioctl,
you'll always get the same kind of information. I guess it's valid to
just define the API that way?

>> 2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
>> later query the credentials of the owner of the bus they're connected to.
> 
> Ditto.  Although, why on earth should a bus have credentials?  This
> sounds like a misdesign.  It seems to me that this type of policy
> belongs all the way in userspace.  If you want a bus, you ask the
> owner of the entire domain to make you a bus.  Or you make it yourself
> and hand off references in some authenticated way.

Yes, that's the way it works. However, the idea is that a bus stays
alive as long as the file descriptor that was used to the create that
bus remains open, and it is immediately shut down when the fd is closed.
We merely allow user that are connected to a bus to query the
credentials of the creator of the bus they're connected to. So it's not
the bus which has credentials, but its original creator, at the time of
creation.

>> 3. When we dispatch a KDBUS_CMD_MSG_SEND ioctl(), because we want to
>> attach the metadata that was authoritative when the message was sent.
>> IOW: We want metadata that actually matches the message payload.
> 
> What does that "metadata that actually matches the message payload"
> mean? 

A bus client posted something in some point in time. We want metadata of
the time the message was posted.

> If I create an endpoint and delegate some processing to a less
> privileged child, other things on the bus MUST NOT be able to detect
> that delegation in any sensible design.  Otherwise everything will
> appear to work in testing because other processes never checked the
> problematic credential, but then it will randomly fail because someone
> decided to do something daft and validate my unprivileged child's
> argv[0], which is, of course, not what they expected.

Not sure whether I got your point, but if a privileged service that
takes action on behalf of unprivileged clients, it may well depend on
certain credential information to be present along with the message, and
refuse to take action otherwise.

For example, if a privileged service can reboot the system, it checks
whether the asking peer has CAP_SYS_BOOT set. If it checks for uid==0
instead, and it works in your tests because you happen to test as root,
that just a bug in the service, right? But I might have missed your point.

> I suspect that, if you make credential sending opt-in, you will
> quickly discover that the current model for which credentials matter
> makes no sense.

While for the example above, opting-in for creds items on the sender
side might actually work (the asking service would be refused in his
request to reboot the machine). However, for any sort of logging or
system services, for example, allowing the sender to select which creds
it wants to reveal is supporting a hide-and-seek game, and that's
something that won't work.

Thanks for sharing your thoughts on this - I appreciate this discussion
stays on such technical grounds :)

Daniel


