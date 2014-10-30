Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbaJ3IpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:45:23 -0400
Received: from svenfoo.org ([82.94.215.22]:46181 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbaJ3IpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:45:20 -0400
Message-ID: <5451FA9B.8070501@zonque.org>
Date: Thu, 30 Oct 2014 09:45:15 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux API <linux-api@vger.kernel.org>,
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
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com> <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
In-Reply-To: <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 01:13 AM, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 3:33 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> From: Daniel Mack <daniel@zonque.org>
>>>
>>> A connection chooses which metadata it wants to have attached to each
>>> message it receives with kdbus_cmd_hello.attach_flags. The metadata
>>> will be attached as items to the messages. All metadata refers to
>>> information about the sending task at sending time, unless otherwise
>>> stated. Also, the metadata is copied, not referenced, so even if the
>>> sending task doesn't exist anymore at the time the message is received,
>>> the information is still preserved.
>>>
> 
> Also, in general, the comments seem to talk about capturing metadata
> at the time that a connection is opened, but the actual code seems to
> capture metadata all over the place.  I think it needs to be very
> clear, both in the code and the interface, when metadata is captured.

Ok, so we should make that cleaner in the comments then.

To clarify, we currently take metadata at the following occasions:


1. At open() time, So we can tell peers (through KDBUS_CMD_CONN_INFO)
about the credentials a connection had when it was created with
KDBUS_CMD_HELLO.

2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
later query the credentials of the owner of the bus they're connected to.

3. When we dispatch a KDBUS_CMD_MSG_SEND ioctl(), because we want to
attach the metadata that was authoritative when the message was sent.
IOW: We want metadata that actually matches the message payload.

4. We create faked metadata to pass around in messages in case the
connection was created 'on behalf' of another task. This case we need to
cover so we can implement a daemon in userspace that translates between
existing D-Bus clients and kdbus. In such cases, we want the receiving
peers to see the creds of the proxied task, rather than the proxy, so we
pass the small amount of reliably credential information that we can get
with SO_PEERCRED into the KDBUS_CMD_HELLO ioctl. In the kernel, we
create a metadata object out of that, so we can reuse when a message is
sent. This case, however, is an considered an exception and limited to
privileged clients.

In all such cases, we share some implementation in metadata.c, and we
operate on the same kdbus_metadata object, even though the origin of the
data varies in the individual cases. I agree that this should be better
documented, so I've put that on my TODO list.

> And the ns_eq stuff is too far buried (and not even contained in this
> patch!) to be easily verified as being correct, whatever correct means
> in that context.

I see that. As I explained earlier in my reply to Eric, we've chosen to
submit the patch set this way to keep the reply threading clean, so it
was some sort of a trade-off. Still, I think the best way to review it
is to pull in Greg's patches and look at the actual files.


Thanks,
Daniel

