Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3JWMDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:03:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3JWMDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:03:00 -0400
Message-ID: <5267BAE7.2090300@redhat.com>
Date: Wed, 23 Oct 2013 08:02:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>	<1382304926-1641-2-git-send-email-prarit@redhat.com>	<CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>	<5265A9A4.2000100@redhat.com>	<CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>	<526706FC.2070105@redhat.com> <CACVXFVMmp3gOpfEtjQ-fO62=RY+7_ZJ11UW89GXDPNKE61+keg@mail.gmail.com> <5267A6CA.1000505@redhat.com>
In-Reply-To: <5267A6CA.1000505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/23/2013 06:36 AM, Prarit Bhargava wrote:
> 
> 
> On 10/23/2013 12:16 AM, Ming Lei wrote:
>> On Wed, Oct 23, 2013 at 7:15 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>>> On 10/21/2013 10:35 PM, Ming Lei wrote:
>>>>
>>>> That is why NOHOTPLUG isn't encouraged to be taken, actually
>>>> I don't suggest you to do that too, :-)
>>> Okay ... I can certainly switch to HOTPLUG.
>>
>> OK, that should be the right approach.
>>
>>>
>>>>
>>>> You need to make sure your approach won't break micro-code
>>>> update application in current/previous distributions.
>>>
>>> I've tested the following distributions today on a Dell PE 1850:  Ubuntu, SuSe,
>>> Linux Mint, and of course Fedora.  I do not see any issues with either the
>>> microcode update or the dell_rbu driver.  Unfortunately I do not have access to
>>
>> Actually I am wondering if your tests are enough because kernel
>> can't break user-space, which means lots of previous old version
>> distributions should surely be covered, :-)
> 
> I've tested an old version of Suse and a few older RHEL versions for kicks.  No
> problems.  I'm testing an older version of Ubuntu ATM and will update with
> details (it doesn't look like it does anything different FWIW so I'm not worried).
> 
>>
>> If you keep HOTPLUG, only change to request_firmware_nowait(),
>> that should be OK since the loading protocol between userspace and
>> kernel won't change wrt. microcode updating.
>>
>>> a system that uses the lattice-ecp3-config, however, from code inspection it
>>> looks like the driver looks at a specific place for the FW update and then
>>> applies it via the call function in request_firmware_nowait() so it looks like
>>> it is solid too.
>>>
>>> I think maybe this patchset should be split into two separate submits, one for
>>> the microcode and the second to figure out if the code really should wait
>>> indefinitely.  AFAICT neither use case in the kernel expects an indefinite wait.
>>
>> If you switch to HOTPLUG, you needn't worry about waiting indefinitely,
>> need you?
> 
> Nope ... I'll modify the code and retest.  

After all this I completely forgot the problem I'm trying to solve here.  The
issue is that with HOTPLUG & request_microcode_nowait(), if the microcode image
is not found (that is the file is not found on disk), then EACH cpu waits 1
minute and it takes 2 hours for a 120 cpu box to load the microcode module.

Which is terrible... so HOTPLUG doesn't work here.

Let me back up Ming and see if you have a better solution for me.  I have a
system that does not have the x86 microcode loaded on disk.  I use the microcode
module which calls request_firmware_nowait() to load the microcode image and I
want it done as fast as possible.  The microcode loader does not have a uevent
so I'm not waiting on userspace for completion.

How do I avoid the 60 second delay/cpu introduced in the microcode path?  I
don't see one.  If I use HOTPLUG I'm waiting 60 seconds.  If I use NOHOTPLUG
AFAICT the loading function never will return.  AFAICT the same issue arises
with the dell_rbu code -- it appears to never load the dell_rbu firmware.

P.
