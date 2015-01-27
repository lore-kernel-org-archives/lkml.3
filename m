Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbbA0DGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbA0DGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:06:43 -0500
Message-ID: <54C700BB.5030200@redhat.com>
Date: Mon, 26 Jan 2015 22:06:35 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        leif.lindholm@linaro.org, grant.likely@linaro.org
Subject: Re: inverse mapping from a struct console to device
References: <54C6984A.20501@redhat.com> <20150126205056.GA17169@leverpostej>
In-Reply-To: <20150126205056.GA17169@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 03:50 PM, Mark Rutland wrote:
> On Mon, Jan 26, 2015 at 07:40:58PM +0000, Jon Masters wrote:
>> Hi Folks,
>>
>> TLDR: I need a back reference from a console struct to its device. I
>> can't see an easy way to do this right now without adding one?
> 
> I don't think that's quite what you need. All you need is to be able to
> refer to the SPCR at serial probe time (more on that below), when you
> should have the data you want.

Hmm. I wanted to do it in console_register due to the existing logic for
adding a preferred console there. But that's a silly reason.

>> I've a quick question. I have prototype code that parses an ACPI table
>> known as the SPCR (Serial Port Console Redirection - exists on both x86
>> and ARM systems). It finds the correct serial device (but it's not a
>> Linux specific DT-style solution so there's no "console=" parameter
>> embedded in it or something)
> 
> In DT we have /chosen/stdout-path which offers analagous functionality.
> It is independent of the command line, and has a standard set of
> parameters (<baud>{<parity>{<bits>{<flow>}}}).

Hmm. I thought it was embedding a Linux specific console parameter, but
I see when I actually check the code and the Documentation (sorry) that
it is indeed similar in capability. Which is awesome. I'll do similar.

> To make this work we check against the stdout-path when we register the
> UART. Take a look at of_console check (called from uart_add_one_port).

Great. Thanks. I looked at modifying uart_add_one_port, but I wasn't
convinced it was called by every serial driver (for example, the
sbsauart driver). I don't know the tty/serial code as well as I'd like.
But I'll implement it the same way as in the OF case for the moment, and
if we need to fix up a driver or two we can always do that.

> Assuming your UART probing looks similar for ACPI, you can have an
> analagous function that goes and checks uport->dev.acpi_dev_node against
> entires in the SPCR, configuring the UART as required at this point at
> registration time.

> This requires that you parse the SPCR earlier, but presumably the SPCR
> is simple enough that this is possible (no AML, for instance).

I already parse it as an initcall early in boot and indeed have it prior
to the port being registered.

> Is there some reason that approach is unworkable?

Apparently not, just need to check a couple of drivers.

Thanks Mark. I'll post a patch later for SPCR setup.

Jon.

