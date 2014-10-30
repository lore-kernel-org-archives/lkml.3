Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbaJ3OIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:08:21 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56868 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbaJ3OIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <5451FA9B.8070501@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
 <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com> <5451FA9B.8070501@zonque.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Oct 2014 07:07:57 -0700
Message-ID: <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
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
        alban.crequy@collabora.co.uk,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 1:45 AM, Daniel Mack <daniel@zonque.org> wrote:
>
> 1. At open() time, So we can tell peers (through KDBUS_CMD_CONN_INFO)
> about the credentials a connection had when it was created with
> KDBUS_CMD_HELLO.

Then the API that tells peers about this information needs to make
this very clear.

>
> 2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
> later query the credentials of the owner of the bus they're connected to.
>

Ditto.  Although, why on earth should a bus have credentials?  This
sounds like a misdesign.  It seems to me that this type of policy
belongs all the way in userspace.  If you want a bus, you ask the
owner of the entire domain to make you a bus.  Or you make it yourself
and hand off references in some authenticated way.

> 3. When we dispatch a KDBUS_CMD_MSG_SEND ioctl(), because we want to
> attach the metadata that was authoritative when the message was sent.
> IOW: We want metadata that actually matches the message payload.
>

What does that "metadata that actually matches the message payload"
mean?  If I create an endpoint and delegate some processing to a less
privileged child, other things on the bus MUST NOT be able to detect
that delegation in any sensible design.  Otherwise everything will
appear to work in testing because other processes never checked the
problematic credential, but then it will randomly fail because someone
decided to do something daft and validate my unprivileged child's
argv[0], which is, of course, not what they expected.

I suspect that, if you make credential sending opt-in, you will
quickly discover that the current model for which credentials matter
makes no sense.

>> And the ns_eq stuff is too far buried (and not even contained in this
>> patch!) to be easily verified as being correct, whatever correct means
>> in that context.
>
> I see that. As I explained earlier in my reply to Eric, we've chosen to
> submit the patch set this way to keep the reply threading clean, so it
> was some sort of a trade-off. Still, I think the best way to review it
> is to pull in Greg's patches and look at the actual files.

This wasn't a comment about the threading.  The call, in the patches
in the git tree, is buried and very difficult to follow.

--Andy
