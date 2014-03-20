Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbaCTSjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:39:52 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:43362 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322AbaCTSju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbOQaVt+KSHwejbLFGy9qzgFG2DG3K84KZE0KOAh3Vyy8YHog@mail.gmail.com>
References: <CAMbOQaVjS3Gzg0iJrxjyb3SD5sA1mm-gZeGEqaTG_B5z4-_pGg@mail.gmail.com>
	<20140319190119.GC16906@thunk.org>
	<CAMbOQaVt+KSHwejbLFGy9qzgFG2DG3K84KZE0KOAh3Vyy8YHog@mail.gmail.com>
Date: Fri, 21 Mar 2014 00:09:49 +0530
Message-ID: <CAMbOQaVGZZjAvvx+PGkTdiBQfYc9xGxkiP1_3P7i304Kg+d_hw@mail.gmail.com>
Subject: Re: Page cache corruption with mount/unmount of USB with Fat file system
From: Nilesh More <nilesh99999@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Prafull Suryawanshi <prafull.net@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I now know the source of page allocations between add_disk call and
mount call. The auto mount service triggers disk check operation which
eventually calls checkfilesys(). This function does open and close
calls which results into page allocations and de-allocations. If I do
an early return from this function, I don't this issue of ext4 file
system corruption.

 Though the file check operation might be expected before mount, it
may be exposing a linux-kernel bug.

Can anybody please comment if the checkfilesys() operation is expected
before actually mounting the file system ? If 'yes', how does it know
about the superblock location, directory structure etc. ?

What should be the next step here ? I am thinking to try and track
down all page/buffer allocations because of open/close calls from auto
mount service - checkfilesys() and see why it is resulting into ext4
corruption.

Thank you,
Nilesh

On Thu, Mar 20, 2014 at 12:38 AM, Nilesh More <nilesh99999@gmail.com> wrote:
> Hi Ted,
>
>>And I'll repeat the comments I made a few weeks ago.  Last time you
>>reported this, you included a dmesg output which included this:
>
>> [ 413.607849] usb 2-1.1: USB disconnect, device number 12
>> [ 414.022630] EXT4-fs error (device mmcblk0p20): ext4_readdir:227: inode
>> #81827: block 328308: comm installd...
>
>  > Are you seeing the same thing?  If so, the fundamental high level
> issue is that the USB driver is reporting a device disconnect,
> presumably of a USB device different from the one that you just
> plugged in.   Are you still seeing this?
>
> The dmesg output that I attached earlier was when I saw the prints
> after actually disconnecting the USB. I am pretty certain that USB
> driver does not report any false disconnect. This issue occurs when I
> connect the USBdrive on android tablet with USB mount support. This
> issue may or may not occur the first time I hotplug the USB drive. It
> might require couple of hotplug/hotunplug to see this issue.
>
> Thank you,
> Nilesh
>
> On Thu, Mar 20, 2014 at 12:31 AM,  <tytso@mit.edu> wrote:
>> On Thu, Mar 20, 2014 at 12:05:44AM +0530, Nilesh More wrote:
>>> Hi all,
>>>
>>> First of all sorry for the lengthy mail but I did not want to miss out
>>> on any details.
>>>
>>> The following issue that I am reporting occurs when I plugin the USB
>>> drive on android tablet with USB mount support. Please note that this
>>> issue may or may not occur the first time I hotplug the USB drive. It
>>> might require couple of hotplug/hotunplug to see this issue. If
>>> anybody has/gets any clue about the possible root cause, please let me
>>> know.
>>
>> And I'll repeat the comments I made a few weeks ago.  Last time you
>> reported this, you included a dmesg output which included this:
>>
>>> [ 413.607849] usb 2-1.1: USB disconnect, device number 12
>>> [ 414.022630] EXT4-fs error (device mmcblk0p20): ext4_readdir:227: inode
>>> #81827: block 328308: comm installd...
>>
>> Are you seeing the same thing?  If so, the fundamental high level
>> issue is that the USB driver is reporting a device disconnect,
>> presumably of a USB device different from the one that you just
>> plugged in.   Are you still seeing this?
>>
>> If so, it's important if you want to root cause this issue to
>> determine why the USB disconnect is happening, and not try to comment
>> out the page invalidations which happens *after* the USB device is
>> reported as disconnected.
>>
>> If I had to guess, it's probably some hardware issue where when you
>> plug in a USB device that draws too much power, it's destablizing the
>> USB bus and causing some other USB device to report a disconnect.
>>
>>                                           - Ted
