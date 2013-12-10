Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3LJKsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:48:23 -0500
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:52408
	"EHLO qmta10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab3LJKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:48:21 -0500
To: mpatocka@redhat.com, peter@hurleysoftware.com
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
References: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312092103290.11182@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: edbrowse/3.4.9
Subject: [PATCH 3.12] Broken terminal due to echo bufferring
Date: Tue, 10 Dec 2013 05:48:19 -0500
Message-ID: <20131110054819.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| An involved discussion about race conditions and asynchronous events,
| which is beyond me.
| Please continue; I'm sure you will figure it out,
| and perhaps educate me along the way.
| But this thread began with the following program that revealed,
| I believe, the same echo crlf bug that I pointed out.

> #include <stdio.h>
> #include <unistd.h>
> 
> int main(void)
> {
> int c;
> while ((c = getchar()) != EOF) {
> if (c == '\n') write(1, "prompt>", 7);
> }
> return 0;
> }

Peter sent me a patch which fixed my bug, in its console switch form.
And also seemed to fix the bug whenever I was in a cooked mode program.
So I was happy.
For grins I compiled this program, to see if it also
ran properly.
It does, while it is running.
Prompt and newline come out in sequence, in order,
and everything looks right.
Hit control d, for EOF, as the program expects, and all is well.
But hit ^c for interrupt, and as Tilly says,
"All hell done broke loose now."
The tty spills out a bunch of accumulated text that it has displayed in the past.
Don't know where it comes from, or why.
I ran the program several times, interrupt,
and the same thing happened each time, even the same stored output,
as though it were a 4k block that was retained from somewhere.
Try it and see (with Peter's latest patches).

I may try some variants: this program running in raw mode,
using read and write so we don't have half of it using stdio,
other standard cooked mode programs that are ^c interruptable.

I guess the tty is an incredibly complicated beast.

Karl Dahlke
