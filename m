Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbbA0DQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:16:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbA0DQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:16:07 -0500
Message-ID: <54C702F2.8050303@redhat.com>
Date: Mon, 26 Jan 2015 22:16:02 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: inverse mapping from a struct console to device
References: <54C6984A.20501@redhat.com> <20150126202031.GA14511@kroah.com>
In-Reply-To: <20150126202031.GA14511@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 03:20 PM, Greg KH wrote:
> On Mon, Jan 26, 2015 at 02:40:58PM -0500, Jon Masters wrote:

>> I've a quick question. I have prototype code that parses an ACPI table
>> known as the SPCR (Serial Port Console Redirection - exists on both x86
>> and ARM systems). It finds the correct serial device (but it's not a
>> Linux specific DT-style solution so there's no "console=" parameter
>> embedded in it or something) to use for the preferred console (I have
>> effectively the device object connected with the acpi_handle of the
>> underlying serial device, which I map on by walking the ACPI namespace
>> down from the root until I find the _ADR of the specified SPCR address).
>>
>> One of the problems that I have is that I want to make the decision
>> about whether a console should be automatically configured once we get
>> to register_console, because that's where the existing logic is, and
>> it's one path I can be sure everyone is going to call (serial drivers
>> have a number of different APIs that they use during registration).
>>
>> Once I'm in register_console, I have only the console struct to play
>> with. I can get from that to the tty_driver (by walking the tty driver
>> list and finding the back reference), but that still doesn't give me
>> what I want. I can add a reference to the underlying device in one of
>> these structs, but I would like to have additional opinions before I go
>> and make something hackish folks will balk at later. So, am I missing
>> something obvious? I hope I am because this seems slightly weird.
> 
> I really don't understand what you are wanting to do here.  Who wants to
> "automatically configure" a console?

On ARM systems, we've several possible serial devices that could be in
use. We don't want to have to specify the console on the kernel command
line at install/boot time. Additionally, we want to (later)
automatically configure earlycon parameters. Fortunately there's an ACPI
table known as the SPCR which provides information about the preferred
serial uart, including type/address/interrupt/etc. SPCR exists on x86
systems too, and in fact has been used by Windows for over a decade to
handle the setup of its SAC (Special Administration Console). The
license on the underlying SPCR spec has been opened in the past couple
of years to cover other OS implementations using it.

Currently, we internally have a hack that sets up the console as a
preferred console, but it's not a long term solution. For that, I had
the SPCR made a requirement in the ARM SBBR specification. Windows on
x86 doesn't use the GSIV (ACPI interrupt) from my understanding so I
preemptively asked that it be made a requirement that this be populated,
along with requiring revision 2+ of the table. That way, we can propose
patches to use the SPCR for setup that might be useful on x86 (and if
limiting to revision 2+ it won't break existing systems as essentially
no PC class system reports that revision of the table yet).

For the rest - Mark Rutland's followup and my reply covers it I think.

Thanks,

Jon.

