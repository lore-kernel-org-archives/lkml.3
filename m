Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3CSRJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:09:25 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52972 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab3CSRJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <513BACAC.9050800@gmail.com>
References: <kg69ef$vdb$1@ger.gmane.org>
	<CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
	<5126C3E1.80801@gmail.com>
	<513BACAC.9050800@gmail.com>
Date: Tue, 19 Mar 2013 10:09:22 -0700
X-Google-Sender-Auth: cVSEK3sCFVduf3LlcFAm9-M4pi0
Message-ID: <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is apparently still outstanding, and Mantas hadn't cc'd the
people involved with the commit itself.

Background: with UEFI, commit f9a37be0f02a ("x86: Use PCI setup data")
apparently results in a black screen for Mantas. The commit reverts
fairly easily (there's been a trivial change to the function since due
to dev->rom now being a proper phys_add_t), and considering that the
commit doesn't explain what the f*ck it is needed for, or what it
would help, I'm inclined to do just that.

Trusting firmware-provided values over the things we can find
ourselves is known to be fundamentally crap, so what the hell is the
point of that commit in the first place? The likelihood that firmware
messes up is pretty damn high. Why would we take idiotic "here's the
PCI ROM" data from firmware in the first place? What did this fix? We
know what it broke..

Doing things like blindly trusting the firmware data without even
validating it is a really really bad idea. The commit actually looks
seriously broken in other ways too, like blindly doing phys_to_virt()
on that, and then trusting the result

Mantas, mind changing that "pcibios_add_device()" function so that
instead of setting dev->rom/romlen, it just prints out the values
(including the device address)? Plase also make it print out the
"data->len" field in addition to the rom->xyz fields..

                Linus

On Sat, Mar 9, 2013 at 1:42 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
> On 2013-02-22 03:03, Mantas Mikulėnas wrote:
>> On 2013-02-22 01:54, Dave Airlie wrote:
>>>>
>>>> | radeon 0000:01:00.0: No connectors reported connected with modes
>>>> | [drm] Cannot find any crtc or sizes - going 1024x768
>>>>
>>>> The connector is definitely connected, since this is a laptop with a
>>>> built-in screen...
>>>>
>>>
>>> Can you get the log with drm.debug=6 from both boots as well?
>>
>> Attached.
>
> The log is also at http://nullroute.eu.org/tmp/2013/dmesg-drm-debug.txt
>
> Not to be annoying, but I hope this can be fixed until 3.9...
>
> (I just tested v3.9-rc1-278-g8343bce, and it still does not detect any
> displays. And if I understood it correctly, "nomodeset" is going to go
> away?)
>
> --
> Mantas Mikulėnas <grawity@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
