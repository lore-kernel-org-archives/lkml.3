Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBGJC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:02:27 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:64878 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBGJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:02:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140206162908.GA7443@kroah.com>
References: <1391696863-62767-1-git-send-email-hare@suse.de>
 <20140206152947.GA19335@kroah.com> <52F3ADD4.7020907@suse.de> <20140206162908.GA7443@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 7 Feb 2014 10:02:02 +0100
Message-ID: <CAPXgP11BPt+bcHNELwucyXz+ZticDpZbs1Ae=c0qVeWKb69pnA@mail.gmail.com>
Subject: Re: [PATCHv2] tty: Set correct tty name in 'active' sysfs attribute
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hannes Reinecke <hare@suse.de>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        dh.herrmann@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 5:29 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Feb 06, 2014 at 04:44:20PM +0100, Hannes Reinecke wrote:
>> On 02/06/2014 04:29 PM, Greg Kroah-Hartman wrote:
>> > On Thu, Feb 06, 2014 at 03:27:43PM +0100, Hannes Reinecke wrote:
>> >> The 'active' sysfs attribute should refer to the currently
>> >> active tty devices the console is running on, not the currently
>> >> active console.
>> >
>> > That's not what Documentation/ABI/sysfs-tty says:
>> >                  Shows the list of currently configured
>> >                  console devices, like 'tty1 ttyS0'.
>> >                  The last entry in the file is the active
>> >                  device connected to /dev/console.
>> >                  The file supports poll() to detect virtual
>> >                  console switches.
>> >
>> The problem is indeed with 'console devices'. There is no such
>> thing; you only have tty devices where the console is running on.
>>
>> >> The console structure doesn't refer to any device in sysfs,
>> >> only the tty the console is running on has.
>> >
>> > That sentance doesn't make sense.
>> >
>> >> So we need to print out the tty names in 'active', not
>> >> the console names.
>> >
>> > But that doesn't match the documentation.
>> >
>> > What exactly are you trying to "fix" here?  What is the problem that the
>> > current file has that is broken?  And as you are changing what this file
>> > means, what will break if the information in the file changes?
>> >
>> systemd is using the 'active' sysfs attribute to figure out on which
>> _tty_ device to start a getty on.
>> As soon as the console name and the tty name are different
>> you have no means of figuring out which _device_ to open.
>> AFAICS the console 'device' (ie the current entry in 'active')
>> doesn't have _any_ equivalent in sysfs; it just so happens that for
>> most console drivers the tty driver name is identical.
>> But this is not a requirement, and fails for drivers which have a
>> different device for the console and the tty.
>>
>> EG on S/390 the 3270 tty has the devices
>>
>> /dev/3270/tty1
>>
>> but the console driver announces the name 'tty3270'.
>> So as per current rules the 'active' attribute contains
>>
>> tty32700
>>
>> which correct as per documentation, but doesn't have _any_
>> equivalent in sysfs.
>>
>> Martin has the grubby details here.
>>
>> But of course, the documentation should be updated to match the new
>> behavior.
>
> Ok, care to send an updated version, that fixes the Documentation as
> well?  If Kay agrees that this is the correct solution, I'll be glad to
> take it.

Sounds good to me. The intention clearly was to point to the device in use,
which we can find then.

I would not expect problems with this change. For common uses it is the
same name already and nothing visibly should change, and for the ones
where it isn't the same, I expect it is not too useful to find the driver
name.

Thanks,
Kay
