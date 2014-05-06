Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313AbaEFICW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:02:22 -0400
Received: from mout.gmx.net ([212.227.17.20]:59884 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934069AbaEFICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:02:17 -0400
Message-ID: <53689692.8050304@gmx.at>
Date: Tue, 06 May 2014 10:00:18 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tty: Fix lockless tty buffer race
References: <1399042572-6533-1-git-send-email-peter@hurleysoftware.com> <1399042572-6533-2-git-send-email-peter@hurleysoftware.com> <5363B446.7010101@hurleysoftware.com>
In-Reply-To: <5363B446.7010101@hurleysoftware.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:4HyIbkr0nJIp/jAFe8Z1jFPxM5DvHQPuyMc2nox+nbD+Fyp6yg0
 Yk17y8XyLAS8XggNvY6j4LqVuCYSoUMOeLlB2u3HszMdKpaGuOgjpVSs7kvEKwEp+LQIl9L
 i/tMZYpgeCDYn3O2vvWGM1U18OjNXJppOHA8s97vppX+qRnwkx9HRWPMXJe3zLhatnXE4hn
 FMViB2TLVxjohv6Zj5nbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-02 17:05, Peter Hurley wrote:
> On 05/02/2014 10:56 AM, Peter Hurley wrote:
>> Commit 6a20dbd6caa2358716136144bf524331d70b1e03,
>> "tty: Fix race condition between __tty_buffer_request_room and flush_to_ldisc"
>> correctly identifies an unsafe race condition between
>> __tty_buffer_request_room() and flush_to_ldisc(), where the consumer
>> flush_to_ldisc() prematurely advances the head before consuming the
>> last of the data committed. For example:
>>
>>             CPU 0                     |            CPU 1
>> __tty_buffer_request_room            | flush_to_ldisc
>>    ...                                |   ...
>>                                       |   count = head->commit - head->read
>>    n = tty_buffer_alloc()             |
>>    b->commit = b->used                |
>>    b->next = n                        |
>>                                       |   if (!count)                /* T */
>>                                       |     if (head->next == NULL)  /* F */
>>                                       |     buf->head = head->next
>>
>> In this case, buf->head has been advanced but head->commit may have
>> been updated with a new value.
>>
>> Instead of reintroducing an unnecessary lock, fix the race locklessly.
>> Read the commit-next pair in the reverse order of writing, which guarantees
>> the commit value read is the latest value written if the head is
>> advancing.

This is a fine solution! I'll verify this against my previous experimental setup
(3.12.x and 3.12.x-rt25), but I dont't expect any problems.

>>
>> Reported-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
>> Cc: <stable@vger.kernel.org> # 3.12.x+
> 
> The patch submitted by Manfred notes the commits which introduced the
> race [1], but attributes those commits to the 3.11 cycle. Those commits
> were merged in the 3.12 cycle.

You are right. I'm sorry for this.


Regars,
Manfred
