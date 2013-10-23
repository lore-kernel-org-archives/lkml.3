Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3JWOIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:08:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab3JWOIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:08:46 -0400
Message-ID: <5267D85D.5030505@redhat.com>
Date: Wed, 23 Oct 2013 10:08:29 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>	<1382304926-1641-2-git-send-email-prarit@redhat.com>	<CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>	<5265A9A4.2000100@redhat.com>	<CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>	<526706FC.2070105@redhat.com>	<CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com>	<5267A6CA.1000505@redhat.com>	<5267BAE7.2090300@redhat.com> <CACVXFVPSyNu6rUuDrqT2YZVucSgyeDN_toS-Y+WoT7Ye15iGRA@mail.gmail.com>
In-Reply-To: <CACVXFVPSyNu6rUuDrqT2YZVucSgyeDN_toS-Y+WoT7Ye15iGRA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/23/2013 09:21 AM, Ming Lei wrote:
> On Wed, Oct 23, 2013 at 8:02 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> 
>>
>> After all this I completely forgot the problem I'm trying to solve here.  The
>> issue is that with HOTPLUG & request_microcode_nowait(), if the microcode image
>> is not found (that is the file is not found on disk), then EACH cpu waits 1
>> minute and it takes 2 hours for a 120 cpu box to load the microcode module.
>>
>> Which is terrible... so HOTPLUG doesn't work here.
>>
>> Let me back up Ming and see if you have a better solution for me.  I have a
>> system that does not have the x86 microcode loaded on disk.  I use the microcode
>> module which calls request_firmware_nowait() to load the microcode image and I
>> want it done as fast as possible.  The microcode loader does not have a uevent
>> so I'm not waiting on userspace for completion.
>>
>> How do I avoid the 60 second delay/cpu introduced in the microcode path?  I
>> don't see one.  If I use HOTPLUG I'm waiting 60 seconds.  If I use NOHOTPLUG
>> AFAICT the loading function never will return.  AFAICT the same issue arises
>> with the dell_rbu code -- it appears to never load the dell_rbu firmware.
> 
> As I said, the 60 second delay is from udev, so that is the root cause.

Okay, so then my other option is to use NOHOTPLUG.  I've correctly modified it
to return and not wait for a NULL uevent.  The synchronization between the cont
function return and the actual application of the firmware is done in the driver
(in my 2/2 patch) where I've used a completion struct.  ... Am I still missing
something at this point?

I also have to make that change to the dell_rbu code because it too, is broken
the same way.  That is, I can load the dell_rbu module and it just hangs without
applying the firmware.

I'll submit a new version of these patches and we can continue from there.

P.
> 
> There are some workarounds for your reference:
> 

These are workarounds for an issue that arises in the kernel.

P.
