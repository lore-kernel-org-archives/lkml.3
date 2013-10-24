Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3JXBye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 21:54:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52323 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3JXByd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 21:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <5267D85D.5030505@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
	<1382304926-1641-2-git-send-email-prarit@redhat.com>
	<CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
	<5265A9A4.2000100@redhat.com>
	<CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>
	<526706FC.2070105@redhat.com>
	<CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com>
	<5267A6CA.1000505@redhat.com>
	<5267BAE7.2090300@redhat.com>
	<CACVXFVPSyNu6rUuDrqT2YZVucSgyeDN_toS-Y+WoT7Ye15iGRA@mail.gmail.com>
	<5267D85D.5030505@redhat.com>
Date: Thu, 24 Oct 2013 09:54:30 +0800
Message-ID: <CACVXFVOESiUpwNY1iQk3pWw0CFqG9qoF0o44KyL5u5VqK1JMvg@mail.gmail.com>
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
From: Ming Lei <ming.lei@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 10:08 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 10/23/2013 09:21 AM, Ming Lei wrote:
>> On Wed, Oct 23, 2013 at 8:02 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>
>>>
>>> After all this I completely forgot the problem I'm trying to solve here.  The
>>> issue is that with HOTPLUG & request_microcode_nowait(), if the microcode image
>>> is not found (that is the file is not found on disk), then EACH cpu waits 1
>>> minute and it takes 2 hours for a 120 cpu box to load the microcode module.
>>>
>>> Which is terrible... so HOTPLUG doesn't work here.
>>>
>>> Let me back up Ming and see if you have a better solution for me.  I have a
>>> system that does not have the x86 microcode loaded on disk.  I use the microcode
>>> module which calls request_firmware_nowait() to load the microcode image and I
>>> want it done as fast as possible.  The microcode loader does not have a uevent
>>> so I'm not waiting on userspace for completion.
>>>
>>> How do I avoid the 60 second delay/cpu introduced in the microcode path?  I
>>> don't see one.  If I use HOTPLUG I'm waiting 60 seconds.  If I use NOHOTPLUG
>>> AFAICT the loading function never will return.  AFAICT the same issue arises
>>> with the dell_rbu code -- it appears to never load the dell_rbu firmware.
>>
>> As I said, the 60 second delay is from udev, so that is the root cause.
>
> Okay, so then my other option is to use NOHOTPLUG.  I've correctly modified it
> to return and not wait for a NULL uevent.  The synchronization between the cont
> function return and the actual application of the firmware is done in the driver
> (in my 2/2 patch) where I've used a completion struct.  ... Am I still missing
> something at this point?

If you plan to use NOHOTPLUG to stop sending uevent to user space, you
need to make sure all distributions(include old ones) do not require
the notification previously, and you'd better to explain the microcode
upgrading principle in a bit detail so that we can make sure it won't
break the loading protocol between kernel and user space, at least
current code is using request_fimrware() and the uevent is surely
sent to userspace, right?

>
> I also have to make that change to the dell_rbu code because it too, is broken
> the same way.  That is, I can load the dell_rbu module and it just hangs without
> applying the firmware.

Because userspace does not handle the request and write fw data to driver,
how can you expect the driver to apply firmware?

Anyway, you need Cc dell_rbu guys to make sure the change.

> I'll submit a new version of these patches and we can continue from there.
>
> P.
>>
>> There are some workarounds for your reference:
>>
>
> These are workarounds for an issue that arises in the kernel.

Sorry, I don't understand, the root cause is surely from udev.

Thanks,
--
Ming Lei
