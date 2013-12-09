Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab3LIPnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:43:49 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57732 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932636Ab3LIPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:43:48 -0500
Message-ID: <52A5E531.9010909@hurleysoftware.com>
Date: Mon, 09 Dec 2013 10:43:45 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12] Broken terminal due to echo bufferring
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 09:55 PM, Mikulas Patocka wrote:
> Hi
>
> I discovered that kernel 3.12 has broken terminal handling.
>
> I created this program to show the problem:
> #include <stdio.h>
> #include <unistd.h>
>
> int main(void)
> {
>          int c;
>          while ((c = getchar()) != EOF) {
>                  if (c == '\n') write(1, "prompt>", 7);
>          }
>          return 0;
> }
>
> Each time the user presses enter, the program prints "prompt>". Normally,
> when you press enter, you should see:
>
> prompt>
> prompt>
> prompt>
> prompt>_
>
> However, with kernel 3.12.4, you occasionally see
>
> prompt>
> prompt>
> prompt>prompt>
> _
>
> This bug happens randomly, it is timing-dependent. I am using single-core
> 600MHz processor with preemptible kernel, the bug may or may not happen on
> other computers.
>
> This bug is caused by Peter Hurley's echo buffering patches
> (cbfd0340ae1993378fd47179db949e050e16e697). The patches change n_tty.c so
> that it accumulates echoed characters and sends them out in a batch.
> Something like this happens:
>
> * The user presses enter
> * n_tty.c adds '\n' to the echo buffer using echo_char_raw
> * n_tty.c adds '\n' to the input queue using put_tty_queue
> * A process is switched
> * Userspace reads '\n' from the terminal input queue
> * Userspace writes the string "prompt>" to the terminal
> * A process is switched back
> * The echo buffer is flushed
> * '\n' from the echo buffer is printed.
>
>
> Echo bufferring is fundamentally wrong idea - you must make sure that you
> flush the echo buffer BEFORE you add a character to input queue and BEFORE
> you send any signal on behalf of that character. If you delay echo, you
> are breaking behavior of various programs because the program output will
> be interleaved with the echoed characters.

There is nothing fundamentally broken with buffering echoes; it's just that
there is a bug wrt when to process the echoes (ie, when to force the output).

In the example you provided, the write() should cause the echoes to flush
but doesn't because the commit marker hasn't been advanced.

The commit marker wasn't advanced _yet_ because there is a race window between
the reader being woken as a result of the newline and the flush_echoes()
which happens with every received input.

Either closing the race window or advancing the commit marker prior to
write() output will fix the problem; right now, I'm looking at which is least
painful.

Regards,
Peter Hurley



