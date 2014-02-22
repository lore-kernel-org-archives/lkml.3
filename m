Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaBVO1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:27:47 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50528 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaBVO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:27:45 -0500
MIME-Version: 1.0
In-Reply-To: <5308BF5A.3040706@suse.de>
References: <20140220235118.191692546@linuxfoundation.org>
	<20140220235119.236520201@linuxfoundation.org>
	<CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
	<20140221202127.GA28780@kroah.com>
	<CAA_UwzLWGUpQghswiAjo2Ppw0tr3voNPPhekGoHiLTX9MDV3fw@mail.gmail.com>
	<5308BF5A.3040706@suse.de>
Date: Sat, 22 Feb 2014 15:27:45 +0100
Message-ID: <CANq1E4Q=9un+ZSy7uUEJPHgqCRKbLOw+PXR+jWxPSKrDLz7N=g@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
From: David Herrmann <dh.herrmann@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Ray Strode <halfline@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Feb 22, 2014 at 4:16 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/21/2014 11:18 PM, Ray Strode wrote:
>>
>> Hi,
>>
>> On Fri, Feb 21, 2014 at 3:21 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> Ray, Josh, can I get some more information about this?  Is this broken
>>> in Linus's tree?  Or did I get the backport wrong here?
>>
>> I don't think it's a problem with the backport specifically. To be
>> honest, i'm not even 100% sure it is that patch. It was just the only
>> patch that touched that code recently so it seemed likely.  I didn't
>> do builds to check for sure.
>>
>>> What is the value of the file before and after this patch?
>>
>> "tty0" in the past and "tty1" now
>>
>>> And what is plymouth doing with this file value, it was incorrect
>>> before, what was it using the value for?
>>
>> See the other (3.11) thread for my initial message, but basically
>> plymouth had code something like this pseudocode:
>>
>> /* disable splash if there are serial consoles */
>> if (!contents_of_file_equals("/sys/class/tty/console/active", "tty0")) {
>>          disable_splash_and_force_verbose_messages();
>> }
>>
>> since the file started saying tty1 that code started disabling the
>> splash for everyone in rawhide.
>>
> <sigh>
>
> And of course, checking for "!tty0" is the proper check for serial console.
> Which, of course, means we have to stay with a broken kernel interface for
> ever and ever.
>
> Innovation, here we come.
>
> </sigh>
>

How about this:

+               driver = cs[i]->device(cs[i], &index);
+                /* special case for tty0 which must not be resolved */
+               if (driver && (index > 0 || cs[i]->major != TTY_MAJOR)) {
+                       count += tty_line_name(driver, index, buf + count);
+                       count += sprintf(buf + count, "%c", i ? ' ':'\n');
+               } else
+                       count += sprintf(buf + count, "%s%d%c",
+                                        name, index, i ? ' ':'\n');

Regards
David
