Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaBFPoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:44:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaBFPoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:44:22 -0500
Message-ID: <52F3ADD4.7020907@suse.de>
Date: Thu, 06 Feb 2014 16:44:20 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        dh.herrmann@gmail.com, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv2] tty: Set correct tty name in 'active' sysfs attribute
References: <1391696863-62767-1-git-send-email-hare@suse.de> <20140206152947.GA19335@kroah.com>
In-Reply-To: <20140206152947.GA19335@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 04:29 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 06, 2014 at 03:27:43PM +0100, Hannes Reinecke wrote:
>> The 'active' sysfs attribute should refer to the currently
>> active tty devices the console is running on, not the currently
>> active console.
> 
> That's not what Documentation/ABI/sysfs-tty says:
>                  Shows the list of currently configured                         
>                  console devices, like 'tty1 ttyS0'.                            
>                  The last entry in the file is the active                       
>                  device connected to /dev/console.                              
>                  The file supports poll() to detect virtual                     
>                  console switches.                         
> 
The problem is indeed with 'console devices'. There is no such
thing; you only have tty devices where the console is running on.

>> The console structure doesn't refer to any device in sysfs,
>> only the tty the console is running on has.
> 
> That sentance doesn't make sense.
> 
>> So we need to print out the tty names in 'active', not
>> the console names.
> 
> But that doesn't match the documentation.
> 
> What exactly are you trying to "fix" here?  What is the problem that the
> current file has that is broken?  And as you are changing what this file
> means, what will break if the information in the file changes?
> 
systemd is using the 'active' sysfs attribute to figure out on which
_tty_ device to start a getty on.
As soon as the console name and the tty name are different
you have no means of figuring out which _device_ to open.
AFAICS the console 'device' (ie the current entry in 'active')
doesn't have _any_ equivalent in sysfs; it just so happens that for
most console drivers the tty driver name is identical.
But this is not a requirement, and fails for drivers which have a
different device for the console and the tty.

EG on S/390 the 3270 tty has the devices

/dev/3270/tty1

but the console driver announces the name 'tty3270'.
So as per current rules the 'active' attribute contains

tty32700

which correct as per documentation, but doesn't have _any_
equivalent in sysfs.

Martin has the grubby details here.

But of course, the documentation should be updated to match the new
behavior.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
