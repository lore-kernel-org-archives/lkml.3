Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaKEOe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:34:58 -0500
Received: from svenfoo.org ([82.94.215.22]:46473 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbaKEOe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:34:56 -0500
Message-ID: <545A3588.2010903@zonque.org>
Date: Wed, 05 Nov 2014 15:34:48 +0100
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
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com>
In-Reply-To: <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 11:19 PM, Andy Lutomirski wrote:
> I think that each piece of trustable metadata needs to be explicitly
> opted-in to by the sender at the time of capture.  Otherwise you're
> asking for lots of information leaks and privilege escalations.  This
> is especially important given that some of the items in the current
> list could be rather sensitive.

Alright, the above seems to pretty much sum up that end of our
discussion. To address this, We've now added the following functionality
for v2:

 * The attach_flags in kdbus_cmd_hello was split into two parts,
   attach_flags_send and attach_flags_recv, so each peer may chose what
   exactly it want to transmit or receive.

 * Metadata will only be attached to the final message in the
   receiver's pool if both the sender's attach_flags_send and the
   receiver's attach_flags_recv bit are set.

 * Consequently, the existing KDBUS_ITEM_ATTACH_FLAGS item type is
   split into KDBUS_ITEM_ATTACH_FLAGS_SEND and
   KDBUS_ITEM_ATTACH_FLAGS_RECV, so that both connection details can be
   separately updated through KDBUS_CMD_CONN_UPDATE.

 * To allow for use cases that require certain metadata to be attached
   on each message, we've added a negotiation mechanism to the HELLO
   ioctl: An optional metadata mask can be passed during the creation
   of buses, so bus owners may require certain bits in
   attach_flags_send to be set. That way, the creator of the bus will
   specify which metadata is required to fulfill the requirements of
   the specification of the role of the bus.


Thanks again for your input!

Daniel
