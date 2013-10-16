Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972Ab3JPQjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:39:22 -0400
Received: from mail.tpi.com ([74.45.170.26]:33575 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab3JPQjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:39:21 -0400
Message-ID: <525EC13E.1080304@tpi.com>
Date: Wed, 16 Oct 2013 09:39:26 -0700
From: Tim Gardner <timg@tpi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
CC: linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>
Subject: Re: [PATCH 2/2 linux-next] cifs: Make big endian multiplex ID sequences
 monotonic on the wire
References: <1381936190-67628-1-git-send-email-timg@tpi.com>	<1381936190-67628-2-git-send-email-timg@tpi.com> <CADT32e+hGPe5WpNk-Bh-GVotQM2+-J458D1GNaRp55s3vcQWSw@mail.gmail.com>
In-Reply-To: <CADT32e+hGPe5WpNk-Bh-GVotQM2+-J458D1GNaRp55s3vcQWSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 09:25 AM, Shirish Pargaonkar wrote:
> On Wed, Oct 16, 2013 at 10:09 AM, Tim Gardner <timg@tpi.com> wrote:
>> The multiplex identifier (MID) in the SMB header is only
>> ever used by the client, in conjunction with PID, to match responses
>> from the server. As such, the endianess of the MID is not important.
>> However, When tracing packet sequences on the wire, protocol analyzers
>> such as wireshark display MID as little endian. It is much more informative
>> for the on-the-wire MID sequences to match debug information emitted by the
>> CIFS driver.  Therefore, one should write and read MID in the SMB header
>> assuming it is always little endian.
>>
>> Observed from wireshark during the protocol negotiation
>> and session setup:
>>
>>         Multiplex ID: 256
>>         Multiplex ID: 256
>>         Multiplex ID: 512
>>         Multiplex ID: 512
>>         Multiplex ID: 768
>>         Multiplex ID: 768
>>
>> After this patch on-the-wire MID values begin at 1 and increase monotonically.
>>
>> Introduce get_next_mid64() for the internal consumers that use the full 64 bit
>> multiplex identifier.
>>
>> Introduce the helpers get_mid() and compare_mid() to make the endian
>> translation clear.
>>
>> Cc: Steve French <sfrench@samba.org>
>> Signed-off-by: Tim Gardner <timg@tpi.com>
>> ---
>>
>> I'm looking at some of this code in excrutiating detail because I'm having trouble
>> with a backport of CIFS from 3.9.7 on an embedded 2.6.31 powerpc. Its failing the RawNTLMSSP
>> authentication and is almost certainly an endian issue. x86 on the same code base works
>> quite well. Am I making a rash assumption that CIFS in 3.9 stable worked on big endian ?
> 
> Do you have this commit  fdf96a907c1fbb93c633e2b7ede3b8df26d6a4c0 ?
> This might help if you do not have it in your code base.
> 

Yep - I found that one pretty early on. It solved a powerpc issue with
session startup to an x86 Linux CIFS server. The current failing session
startup is to an Apple 10.8.5 (Lion) server (serverNOS=@(#)PROGRAM:smbd
 PROJECT:smbx-136.20.1).

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
