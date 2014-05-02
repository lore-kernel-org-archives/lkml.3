Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaEBPFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:05:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59515 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751636AbaEBPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:05:45 -0400
Message-ID: <5363B446.7010101@hurleysoftware.com>
Date: Fri, 02 May 2014 11:05:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Manfred Schlaegl <manfred.schlaegl@gmx.at>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tty: Fix lockless tty buffer race
References: <1399042572-6533-1-git-send-email-peter@hurleysoftware.com> <1399042572-6533-2-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1399042572-6533-2-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 10:56 AM, Peter Hurley wrote:
> Commit 6a20dbd6caa2358716136144bf524331d70b1e03,
> "tty: Fix race condition between __tty_buffer_request_room and flush_to_ldisc"
> correctly identifies an unsafe race condition between
> __tty_buffer_request_room() and flush_to_ldisc(), where the consumer
> flush_to_ldisc() prematurely advances the head before consuming the
> last of the data committed. For example:
>
>             CPU 0                     |            CPU 1
> __tty_buffer_request_room            | flush_to_ldisc
>    ...                                |   ...
>                                       |   count = head->commit - head->read
>    n = tty_buffer_alloc()             |
>    b->commit = b->used                |
>    b->next = n                        |
>                                       |   if (!count)                /* T */
>                                       |     if (head->next == NULL)  /* F */
>                                       |     buf->head = head->next
>
> In this case, buf->head has been advanced but head->commit may have
> been updated with a new value.
>
> Instead of reintroducing an unnecessary lock, fix the race locklessly.
> Read the commit-next pair in the reverse order of writing, which guarantees
> the commit value read is the latest value written if the head is
> advancing.
>
> Reported-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
> Cc: <stable@vger.kernel.org> # 3.12.x+

The patch submitted by Manfred notes the commits which introduced the
race [1], but attributes those commits to the 3.11 cycle. Those commits
were merged in the 3.12 cycle.

Regards,
Peter Hurley

[1] commits e8437d7ecbc50198705331449367d401ebb3181f,
"tty: Make driver-side flip buffers lockless", and
e9975fdec0138f1b2a85b9624e41660abd9865d4,
"tty: Ensure single-threaded flip buffer consumer with mutex"
