Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaENWvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:51:39 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:64703 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaENWvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140514212347.083a57f9@endymion.delvare>
References: <20140514112347.3f630565@endymion.delvare> <CAGTjWtAjfzr=7K_0k=MKRXTxiWDSGOOYrzY0tA-7z=BpLVM-gA@mail.gmail.com>
 <20140514212347.083a57f9@endymion.delvare>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 May 2014 15:51:17 -0700
Message-ID: <CAGTjWtAJEP4o3AFVD2=YN9A0p3REeSTS9APqzjkzxpq6yrmntA@mail.gmail.com>
Subject: Re: Purpose of dmi-sysfs kernel module
To: Jean Delvare <jdelvare@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, May 14, 2014 at 12:23 PM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Mike,
>
> On Wed, 14 May 2014 08:52:36 -0700, Mike Waychison wrote:
>> On Wed, May 14, 2014 at 2:23 AM, Jean Delvare <jdelvare@suse.de> wrote:
>> > Sorry for joining the party a little late but I am just discovering the
>> > dmi-sysfs kernel module. I have to admit that I am very curious about
>> > why it was needed. What does it let you achieve that you couldn't
>> > already do with dmidecode [1]?
>>
>> The downside to using dmidecode is that (at least at the time), it
>> involved requiring giving access to /dev/mem to the binary so that it
>> could grub around in raw memory looking for the records.
>
> This is still the case indeed.
>
>> dmi-sysfs
>> provides an alternative that allows for kernel-parsed entries to be
>> exposed to userland without having to expose /dev/mem and raw IO which
>> is insecure.
>
> Thanks for the explanation. But if access to /dev/mem was your only
> concern, your solution seems somewhat overkill. You could have just
> exposed the raw SMBIOS entry point and DMI table through sysfs, pretty
> much like ACPI does, and leave the rest to dmidecode (or libsmbios.)
> That would have avoided reimplementing part of dmidecode and creating
> yet another interface to DMI data.

I tried to make dmi-sysfs be as dumb as possible, which is why the
code doesn't try very hard to actually interpret the individual
entries, and instead only exposes them as "raw" files.  The only
"specialized" type (that actually decodes the entry in kernel-land) is
type 15, as this entry provides a level of indirection to get at the
system log (which is either elsewhere in raw /dev/mem memory, or only
accessible behind IO ports).  Again, in this case, only the raw system
event log is exposed and the kernel makes no attempt to parse this
log, it only exposes the raw read-only bytes.

> I'm not maintaining dmi-sysfs, I'm not even using it so far, so I don't
> really care, but to be honest I am quite surprised that it was accepted
> into the kernel.

Well, it solves some real problems for us while locking down userland
access to /dev/mem and iopl.

I have had several folks ask me in the past as to why dmidecode
doesn't work when these facilities are removed from userland, and
dmi-sysfs has proven to be a workable alternative for most.  That
said, dmidecode is the de facto method people use for getting at this
data, and I have no intention on replacing it -- rather, I was hoping
that at some point dmidecode could be updated to understand how to
read the raw sysfs file in lieu of requiring superuser privileges, but
I haven't had the opportunity or need to make this happen myself.

Mike Waychison
