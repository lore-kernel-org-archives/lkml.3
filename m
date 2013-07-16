Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3GPVPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:15:45 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53743 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3GPVPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUMrztJ1aTfvfMZyOSRFhDM52Fa3pSS8EuW3ByYGMNMpg@mail.gmail.com>
References: <CAOULuOY5VMiiuYmesaGxVWWKtby4Cj9Pc9ctQZeOKfoUzV46dA@mail.gmail.com>
 <CALCETrVk=ovYjHwALtzB3E3nP4TMivhppM42yw7rMRpzA68cbw@mail.gmail.com>
 <20130715230418.GA2649@leaf> <CALCETrX_Qjmdo5JtRPzhW6kBaNgwAstG1g8p8pKNy4e+kPYdMQ@mail.gmail.com>
 <20130715232053.GB2649@leaf> <CALCETrUMrztJ1aTfvfMZyOSRFhDM52Fa3pSS8EuW3ByYGMNMpg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Jul 2013 14:15:22 -0700
Message-ID: <CALCETrWkja4k7AO1CFx=ev21Fg_6HO_unXbh=zGGdfPNRvLfcA@mail.gmail.com>
Subject: Re: BGRT Pointer in System RAM
To: Josh Triplett <josh@joshtriplett.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 4:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jul 15, 2013 at 4:20 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>> On Mon, Jul 15, 2013 at 04:08:13PM -0700, Andy Lutomirski wrote:
>>> On Mon, Jul 15, 2013 at 4:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>>> > On Mon, Jul 15, 2013 at 01:28:36PM -0700, Andy Lutomirski wrote:
>>> >>
>>> >> Interesting.  My BGRT says:
>>> >>
>>> >> [028h 0040   8]                Image Address : 0D06801800000001
>>> >>
>>> >> If I reverse the high and low 32-bit dwords, then I get an address in
>>> >> system RAM.
>>> >
>>> > Does that address in RAM start with a BMP header?
>>>
>>> No idea.  I'd presumably have to modify the driver to find out --
>>> otherwise something else will overwrite it.
>>
>> You could boot with a mem= command-line argument that reserves that
>> memory.
>
> I'll see what I can do.
>

I booted with mem=3G, and:

$ sudo dd bs=1 skip=4513853464 if=/dev/mem count=1
dd: reading ‘/dev/mem’: Bad address

The kernel log says nothing, which suggests that ioremap_cache is
failing.  I don't know why.

The address 4513853464 is 0x10D0BF018, which should be okay:

[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000045fffffff] usable
[    0.000000] e820: remove [mem 0xc0000000-0xfffffffffffffffe] usable

EFI agrees:
[    0.000000] efi: mem213: type=7, attr=0xf,
range=[0x0000000100000000-0x0000000460000000) (13824MB)

This could be related to the fact that mtrr cleanup is failing,
possibly due to bugs related to mem=.

That's about my tolerance for debugging something that doesn't really
deserve to work.

--Andy
