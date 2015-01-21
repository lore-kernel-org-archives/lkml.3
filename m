Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbbAUWyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:54:14 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49020 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:54:04 -0500
Message-ID: <54C02E08.4080405@hurleysoftware.com>
Date: Wed, 21 Jan 2015 17:54:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        oleg@redhat.com
Subject: Re: Linux 3.19-rc5
References: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>	 <20150119190216.7ce58d74@neptune.home>	 <CA+55aFw7aoShsqS_ro5DASbseXFLQs_sE=dwLp_tTNAvD9Y09w@mail.gmail.com>	 <20150121213733.7522f087@neptune.home>	 <20150121223701.0c580f7b@neptune.home> <1421878320.4903.17.camel@stgolabs.net>
In-Reply-To: <1421878320.4903.17.camel@stgolabs.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 05:12 PM, Davidlohr Bueso wrote:
> On Wed, 2015-01-21 at 22:37 +0100, Bruno Prémont wrote:
>> On Wed, 21 January 2015 Bruno Prémont wrote:
>>> On Tue, 20 January 2015 Linus Torvalds wrote:
>>>> On Tue, Jan 20, 2015 at 6:02 AM, Bruno Prémont wrote:
>>>>>
>>>>> No idea yet which rc is the offender (nor exact patch), but on my not
>>>>> so recent UP laptop with a pccard slot I have 2 pccardd kernel threads
>>>>> converting my laptop into a heater.

[...]

>> Bisecting to the end did point me at (the warning traces produced in great
>> quantities might not be the very same issue as the abusive CPU usage, but
>> certainly look very related):
>>   [CCing people on CC for the patch]
>>
>> commit 8eb23b9f35aae413140d3fda766a98092c21e9b0
>> Author: Peter Zijlstra <peterz@infradead.org>
>> Date:   Wed Sep 24 10:18:55 2014 +0200

[...]

>> Which does produce the following trace (hand-copied most important parts of it):
>>   Warning: CPU 0 PID: 68 at kernel/sched/core.c:7311 __might_sleep+0x143/0x170
>>   do not call blocking ops when !TASK_RUNNING; state=1 set at [<c1436390>] pccardd+0xa0/0x3e0
>>   ...
>>   Call trace:
>>     ...
>>     __might_sleep+0x143/0x170
>>     ? pccardd+0xa0/0x3e0
>>     ? pccardd+0xa0/0x3e0
>>     mutex_lock+0x17/0x2a
>>     pccardd+0xe9/0x3e0
>>     ? pcmcia_socket_uevent+0x30/0x30
>>
>> pccardd() is located in drivers/pcmcia/cs.c and seems to be of the structure
>> Peter's patch wants to warn about.
> 
> Yeah setting current to interruptable so early in the game is bogus. It
> should be set after unlocking the skt_mutex.

Yeah, but the debug check is triggering worse behavior, requiring
bisecting back to the debug commit.

How does the might_sleep() check here guarantee the task won't sleep?

Regards,
Peter Hurley

