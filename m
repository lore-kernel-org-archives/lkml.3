Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3F0PuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:50:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:41800 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753258Ab3F0PuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:50:23 -0400
Message-ID: <51CC5F34.3030705@sgi.com>
Date: Thu, 27 Jun 2013 08:50:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com> <51C9D4ED.5070805@sgi.com> <51C9DEC1.6030602@zytor.com> <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com> <51C9E523.7000803@zytor.com> <51C9E83A.8070700@sgi.com> <CAE9FiQWzzQeBMRizdL4Ym2AM424yF9+CEZ3vt5Maunb6tfxKyQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWzzQeBMRizdL4Ym2AM424yF9+CEZ3vt5Maunb6tfxKyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/26/2013 11:37 PM, Yinghai Lu wrote:
> On Tue, Jun 25, 2013 at 11:58 AM, Mike Travis <travis@sgi.com> wrote:
>> experimenting as soon as I can.  Our 32TB system is being
>> brought back to 16TB (we found a number of problems as we
>> get closer and closer to the 64TB limit), but that's still
>> a significant size.
> 
> Hi, Mike,
> 
> Can you post e820 memory map on system that have 32TiB or more?
> 
> Is there one range size more than 16TiB? like [16TiB, 32TiB)...
> 
> Thanks
> 
> Yinghai
> 

Here is (was) the 32T system with 2048 cores with HT disabled:

BIOS-e820: 0000000000000000 - 000000000007f000 (usable)
BIOS-e820: 000000000007f000 - 0000000000080000 (reserved)
BIOS-e820: 0000000000080000 - 00000000000a0000 (usable)
BIOS-e820: 0000000000100000 - 000000007ad54000 (usable)
BIOS-e820: 000000007ad54000 - 000000007ad55000 (reserved)
BIOS-e820: 000000007ad55000 - 000000007ad68000 (usable)
BIOS-e820: 000000007ad68000 - 000000007afa8000 (reserved)
BIOS-e820: 000000007afa8000 - 000000007bcb7000 (usable)
BIOS-e820: 000000007bcb7000 - 000000007bdb7000 (reserved)
BIOS-e820: 000000007bdb7000 - 000000007beb7000 (unusable)
BIOS-e820: 000000007beb7000 - 000000007bfb7000 (reserved)
BIOS-e820: 000000007bfb7000 - 000000007d1b7000 (ACPI NVS)
BIOS-e820: 000000007d1b7000 - 000000007e000000 (ACPI data)
BIOS-e820: 000000007e000000 - 000000007e318000 (usable)
BIOS-e820: 000000007e318000 - 000000007ef49000 (ACPI data)
BIOS-e820: 000000007ef49000 - 000000007f000000 (usable)
BIOS-e820: 0000000100000000 - 0000001e00000000 (usable)
BIOS-e820: 0000002000000000 - 0000003dff000000 (usable)
BIOS-e820: 0000004000000000 - 0000005dff000000 (usable)
BIOS-e820: 0000006000000000 - 0000007dff000000 (usable)

....
BIOS-e820: 00000e0000000000 - 00000e1dff000000 (usable)
BIOS-e820: 00000e2000000000 - 00000e3dff000000 (usable)
BIOS-e820: 00000e4000000000 - 00000e5dff000000 (usable)
BIOS-e820: 00000e6000000000 - 00000e7dff000000 (usable)

Note that on UV, there is some memory reserved at the end
of each node that is used for the directory RAM by the
UV HUB.  That is why the ranges are not contiguous.  I'd
have to double check with the BIOS guys, but I don't believe
they would have collapsed ranges across nodes even if the
directory RAM did not exist.

-Mike
