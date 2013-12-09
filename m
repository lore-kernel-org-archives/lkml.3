Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365Ab3LICzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:55:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760359Ab3LICzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:55:43 -0500
Date: Sun, 8 Dec 2013 21:55:37 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3.12] Broken terminal due to echo bufferring
Message-ID: <alpine.LRH.2.02.1312082127020.19329@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I discovered that kernel 3.12 has broken terminal handling.

I created this program to show the problem:
#include <stdio.h>
#include <unistd.h>

int main(void)
{
        int c;
        while ((c = getchar()) != EOF) {
                if (c == '\n') write(1, "prompt>", 7);
        }
        return 0;
}

Each time the user presses enter, the program prints "prompt>". Normally, 
when you press enter, you should see:

prompt>
prompt>
prompt>
prompt>_

However, with kernel 3.12.4, you occasionally see

prompt>
prompt>
prompt>prompt>
_

This bug happens randomly, it is timing-dependent. I am using single-core 
600MHz processor with preemptible kernel, the bug may or may not happen on 
other computers.

This bug is caused by Peter Hurley's echo buffering patches 
(cbfd0340ae1993378fd47179db949e050e16e697). The patches change n_tty.c so 
that it accumulates echoed characters and sends them out in a batch. 
Something like this happens:

* The user presses enter
* n_tty.c adds '\n' to the echo buffer using echo_char_raw
* n_tty.c adds '\n' to the input queue using put_tty_queue
* A process is switched
* Userspace reads '\n' from the terminal input queue
* Userspace writes the string "prompt>" to the terminal
* A process is switched back
* The echo buffer is flushed
* '\n' from the echo buffer is printed.


Echo bufferring is fundamentally wrong idea - you must make sure that you 
flush the echo buffer BEFORE you add a character to input queue and BEFORE 
you send any signal on behalf of that character. If you delay echo, you 
are breaking behavior of various programs because the program output will 
be interleaved with the echoed characters.

Here I'm sending a simple patch that disables echo buffering and restores 
correct behavior. I think you should remove the echo buffering code at 
all.

Mikulas

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com

---
 drivers/tty/n_tty.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: linux-3.12.4/drivers/tty/n_tty.c
===================================================================
--- linux-3.12.4.orig/drivers/tty/n_tty.c	2013-12-09 03:05:49.756728836 +0100
+++ linux-3.12.4/drivers/tty/n_tty.c	2013-12-09 03:21:10.785156100 +0100
@@ -783,21 +783,10 @@ static size_t __process_echoes(struct tt
 static void commit_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	size_t nr, old, echoed;
-	size_t head;
-
-	head = ldata->echo_head;
-	old = ldata->echo_commit - ldata->echo_tail;
-
-	/* Process committed echoes if the accumulated # of bytes
-	 * is over the threshold (and try again each time another
-	 * block is accumulated) */
-	nr = head - ldata->echo_tail;
-	if (nr < ECHO_COMMIT_WATERMARK || (nr % ECHO_BLOCK > old % ECHO_BLOCK))
-		return;
+	size_t echoed;
 
 	mutex_lock(&ldata->output_lock);
-	ldata->echo_commit = head;
+	ldata->echo_commit = ldata->echo_head;
 	echoed = __process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
