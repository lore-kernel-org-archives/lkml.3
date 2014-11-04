Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaKDQgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:36:09 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39649 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaKDQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141104154017.GA28113@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com> <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com> <20141104154017.GA28113@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Nov 2014 08:35:40 -0800
Message-ID: <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 7:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 04, 2014 at 06:57:21AM -0800, Andy Lutomirski wrote:
>>
>> I don't particularly care what the foundation is, but given that a
>> misc char device currently looks like it would be considerably less
>> code for a nicer interface, using the firmware class in its current
>> state doesn't look so great.
>
> Then fix the firmware class code.
>
> Please, don't create random /dev nodes for firmware images like this,
> use the firmware code, that is what it is there for, and it is correct
> to use it for this type of interface.
>
>> If I were to write user code for this, I'd really want a single
>> transaction that uploads a capsule and gets a success/failure
>> indication.  Using ioctl or a single big write sound fine.
>
> That's what you are using with the firmware interface, so this patch is
> currect.

Am I missing something here?  The current proposal is missing the
success/failure part, unless you count the loaded count (in a
different sysfs directory) as a useful interface for that.

>
>> Basically, I agree that EFI capsules are firmware, and using the
>> "firmware" mechanism makes logical sense.  But the firmware class is
>> designed for kernel drivers that request firmware, user code that just
>> blindly supplies an existing file, user code that doesn't care at all
>> whether the firmware loaded correctly (because, for many drivers,
>> there is probably no synchronous way to figure out whether the upload
>> worked anyway), and firmware loading being idempotent.
>>
>> For EFI capsules and other flash-my-device mechanisms, we want user
>> code to send firmware independently of any driver request, user code
>> to actively think about what it wants to send, user code to find out
>> what happened as a result of the request, and user code to actively
>> think about whether it should send another update.
>>
>> If someone wants to make firmware_class work very nicely for this
>> interface, that sounds great.  I'd recommend using a non-overlapping
>> set of filenames in the sysfs directory to avoid confusing existing
>> tools, especially since it's not obvious to be that the kernel has any
>> way at all to detect that what it thinks is an intentional capsule
>> load request is actually an old version of udev mindlessly responding
>> to a firmware loading request (via udevadm trigger if nothing else).
>> I kind of suspect that it will end up sharing very little code with
>> the normal firmware mechanism, though.
>>
>> This thing really does sound like it'll be 20-30 lines of code *total*
>> using a misc device, and the earlier patches in the series could
>> possibly be dropped entirely.
>
> I don't want to see the misc interface used for this, sorry you don't
> like it, but I feel the firmware interface is correct.
>

As I said, I don't object to the use of firmware class.  I'd just kind
of like the actual result of doing so to not suck.

Other things I noticed on brief review of the code:

The firmware class has a caching mechanism.  I have no idea how it
works, but it needs to be reliably disabled for efi-capsule-file.  Is
it?

There's a timeout mechanism.  That mechanism should not be invoked for
efi-capsule-file.  I haven't spotted code to disable it.

The count of loaded capsules is in a separate platform device.  It is
really okay for this driver to have two separate sysfs directories
with names that user code needs to hard code?  Shouldn't there be just
one?

Using the NULLness of fw->pages as an indication of where the firmware
came from seems extremely unreliable and likely to break in
interesting ways in the future.

It looks like every firmware request either results in a uevent or a
helper invocation.  Neither is appropriate here.  Should they be
turned off (by some new interface in the firmware class)?

This might all be nicely resolved by adding a new interface to
firmware_class that says "I want userspace to be able to send me
firmware zero or more times, and I want to handle each blob
individually."

--Andy
