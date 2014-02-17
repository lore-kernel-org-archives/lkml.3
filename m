Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaBQATq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:19:46 -0500
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:55348 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbaBQATp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:19:45 -0500
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Date: Sun, 16 Feb 2014 19:19:41 -0500
Subject: Re: [PATCH] printk: Fix discarding of records
Thread-Topic: [PATCH] printk: Fix discarding of records
Thread-Index: Ac8rdfR5i1XleUpcSTeOStTazDXN/A==
Message-ID: <CF26BC6D.2E80E%dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
 <CF26B239.2E7B4%dbanerje@akamai.com>
 <CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
In-Reply-To: <CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/14, 6:59 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
wrote:

>On Sun, Feb 16, 2014 at 3:23 PM, Banerjee, Debabrata
><dbanerje@akamai.com> wrote:
>>
>> The explanation is: the loops look identical but they are not. When a
>> record is printed first, its size can expand due to adding the prefix
>>and
>> timestamp. The second loop is calculating len with the first line
>>printed
>> possibly changing every iteration.
>
>That still makes zero sense.
>
>The size should damn well not change, because we *should* be calling
>it with the exact same flags. If the size changes, something is wrong.

The problem is that it starts discarding records from the top of the list,
and the size of the first line is based on the previous line. When we
discard the *first* line off the list, then the size of the next line can
change since it is the new first line. My v1 patch was flawed because it
didn't consider just the first line.

>So my suspicion is that the *real* bug is that
>
>    prev = 0;
>
>before that *third* loop, because it means that the first time through
>that loop (when we did *not* reset "seq/idx" to the beginning, we use
>the wrong "prev" value.

No that can't be right, the prev value after every loop is the msg->flags
from the *last* line in the list, which has no relation to the *first*, so
reusing it for the top of the next loop is nonsense. seq is not reset
because the second loop seeks to the seq where the third loop starts
printing.

I think I really fixed it properly with my v2 patch, please take a look.

-Debabrata

