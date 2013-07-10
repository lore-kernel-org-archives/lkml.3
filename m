Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3GJEYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 00:24:15 -0400
Received: from mail-gh0-f179.google.com ([209.85.160.179]:57117 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJEYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 00:24:14 -0400
Message-ID: <51DCE1EA.60404@gmail.com>
Date: Tue, 09 Jul 2013 22:24:10 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        joe.lawrence@stratus.com, myron.stowe@redhat.com, bhelgaas@google.com
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
References: <20130709012611.GA22371@amd.pavel.ucw.cz> <20130709041321.GA30555@kroah.com> <20130709094906.GA3870@amd.pavel.ucw.cz>
In-Reply-To: <20130709094906.GA3870@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:49 AM, Pavel Machek wrote:
> On Mon 2013-07-08 21:13:21, Greg KH wrote:
>> On Tue, Jul 09, 2013 at 03:26:11AM +0200, Pavel Machek wrote:
>>> Hi!
>>>
>>> My thinkpad has rather high ping latencies... and perhaps it is due to
>>> PCIE ASPM.
>>
>> Why would that be the problem?  The odds that the PCIE bus is the issue
>> seems strange to me.
>
> Aha: I guess that's why the file is not writable:
>
> pavel@amd:~$ dmesg | grep -i aspm
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it

IIRC, this message is somewhat misleading. When that FADT flag is set by 
the BIOS, the kernel doesn't so much disable ASPM as disable the 
kernel's control over ASPM. I believe this was to match Windows behavior.

> e1000e 0000:02:00.0: Disabling ASPM L0s L1

And given that, I think this message may also be misleading, as the 
kernel won't touch the device's ASPM state. Force-enabling ASPM may 
actually be allowing the driver to disable ASPM on the device.

I seem to recall a recent thread on this about another device.. maybe we 
need to allow drivers to explicitly disable ASPM if it's enabled even if 
the FADT flag is set?

> pavel@amd:~$ cat /sys/module/pcie_aspm/parameters/policy
> [default] performance powersave
> pavel@amd:~$
> root@amd:~# echo -n performance >
> /sys/module/pcie_aspm/parameters/policy
> -su: echo: write error: Operation not permitted
> root@amd:~#
>
> But:
> 1) it should not list unavailable options
>
> 2) operation not permitted seems like wrong error code for
> operation not supported.
>
> 									Pavel
>

