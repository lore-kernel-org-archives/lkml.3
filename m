Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbaJ3C2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:28:18 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:57956 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbaJ3C2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141029222729.GB8129@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com> <20141029222729.GB8129@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 19:27:54 -0700
Message-ID: <CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:27 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
>> (reply 1/2 -- I'm replying twice to keep the threading sane)
>>
>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > kdbus is a kernel-level IPC implementation that aims for resemblance to
>> > the the protocol layer with the existing userspace D-Bus daemon while
>> > enabling some features that couldn't be implemented before in userspace.
>> >
>>
>> >  * Support for multiple domains, completely separated from each other,
>> >    allowing multiple virtualized instances to be used at the same time.
>>
>> Given that there is no such thing as a device namespace, how does this work?
>
> See the document for the details.

They seem insufficient to me, so I tried to dig in to the code.  My
understanding is:

The parent container has /dev mounted.  It sends an IOCTL (which
requires global capabilities).  In response, kdbus creates a whole
bunch of devices that get put (by udev or devtmpfs, I presume) in a
subdirectory.  Then the parent container mounts that subdirectory in
the new container.

This is IMO rather problematic.

First, it enforces the existence of a kdbus domain hierarchy where
none should be needed.

Second, it's incompatible with nested user namespaces.  The middle
namespace can't issue the ioctl.

Third, it requires a devtmpfs submount in the child container.  This
scares me, especially since there are no device namespaces.  Also, the
child container appears to be dependent on the host udev to arbitrate
everything, which seems totally wrong to me.  (Also, now we're exposed
to attacks where the child container creates busses or endpoints or
whatever with malicious names to try to trick the host into screwing
up.)

ISTM this should be solved either with device namespaces (which is
well known to be a giant can of worms) or by abandoning the concept of
kdbus using device nodes entirely.

What if kdbus were kdbusfs?  If you want to use it in a container, you
mount a brand-new kdbusfs there.  No weird domain hierarchy, no global
privilege, no need to name containers, obvious migration semantics, no
dependence on udev/devtmpfs at all, etc.

Eric, any thoughts here?

--Andy
