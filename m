Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbaKFL76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:59:58 -0500
Received: from ns.omicron.at ([212.183.10.25]:51329 "EHLO ns.omicron.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaKFL74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:59:56 -0500
X-Greylist: delayed 1162 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2014 06:59:55 EST
From: Christian Riesch <christian.riesch@omicron.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>
CC: Christian Riesch <christian.riesch@omicron.at>,
        Peter Hurley <peter@hurleysoftware.com>, <stable@vger.kernel.org>
Subject: [PATCH] n_tty: Add memory barrier to fix race condition in receive path
Date: Thu, 6 Nov 2014 12:39:59 +0100
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of put_tty_queue() causes a race condition
when re-arranged by the compiler.

On my build with gcc 4.8.3, cross-compiling for ARM, the line

	*read_buf_addr(ldata, ldata->read_head++) = c;

was re-arranged by the compiler to something like

	x = ldata->read_head
	ldata->read_head++
	*read_buf_addr(ldata, x) = c;

which causes a race condition. Invalid data is read if data is read
before it is actually written to the read buffer.

This race condition was introduced with commit
6d76bd2618535c581f1673047b8341fd291abc67 ("n_tty: Make N_TTY ldisc receive
path lockless").

This patch adds memory barriers to resolve this race condition.

Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: <stable@vger.kernel.org>
---

Hi all,

I noticed that since an upgrade to kernel 3.12 my ARM device communicating
via serial port with a GPS receiver module reports frequent communication
errors.

After several attempts to resolve these problems I created a small
test setup. This setup utilizes a small microcontroller that just sends
data via serial port to the ARM processor using 9600o1.

The code on the microcontroller looks like this:

    char c = 48;
    while (1) {
        if c > 126 then c = 48
        send character c
        c++
    }

On the ARM/Linux side I ran the serial port in non-canonical mode,
received the data and checked if the data is what we expect it to be:

    struct termios tio;
    memset(&tio, 0, sizeof(tio));
    tio.c_cflag = CREAD | CLOCAL | B9600 | CS8 | PARENB | PARODD;
    tio.c_iflag = INPCK;
    tio.c_cc[VTIME] = 0;
    tio.c_cc[VMIN] = 0;
    tcsetattr(fd, TCSANOW, &tio);

    ...
    c = 48;
    while (1) {
        ...
        poll(pfds, 1, 1000);
        if (pfds[0].revents & POLLIN) {
            ret = read(fd, buf, 200);
            for (i = 0; i < ret; i++) {
                c++;
                if (c > 126)
                    c = 48;
                if (c != buf[i]) {
                    printf("expected %d - received %d, ret = %d, i = %d\n",
                        c, buf[i], ret, i);
                    c = buf[i];
                }
            }
        }
    }

I ran this test for about 5 days, the result was:

expected 51 - received 63, ret = 11, i = 10
expected 64 - received 52, ret = 13, i = 0
expected 64 - received 76, ret = 11, i = 10
expected 77 - received 65, ret = 5, i = 0
expected 105 - received 117, ret = 18, i = 17
expected 118 - received 106, ret = 6, i = 0
expected 120 - received 53, ret = 16, i = 15
expected 54 - received 121, ret = 8, i = 0
expected 105 - received 117, ret = 3, i = 2
expected 118 - received 106, ret = 5, i = 0
expected 79 - received 91, ret = 20, i = 19
expected 92 - received 80, ret = 4, i = 0
expected 72 - received 84, ret = 15, i = 14
expected 85 - received 73, ret = 9, i = 0
expected 54 - received 66, ret = 13, i = 12
expected 67 - received 55, ret = 3, i = 0
expected 86 - received 98, ret = 25, i = 24
expected 99 - received 87, ret = 15, i = 0
expected 86 - received 98, ret = 14, i = 13
expected 99 - received 87, ret = 42, i = 0
expected 93 - received 105, ret = 34, i = 33
expected 106 - received 94, ret = 6, i = 0
expected 92 - received 104, ret = 16, i = 15
expected 105 - received 93, ret = 8, i = 0
expected 53 - received 65, ret = 8, i = 7
expected 66 - received 54, ret = 8, i = 0

The first line shows that we expected buf[i] to be 51, actually we
received 63. We therefore set c = 63, consequently we expect 64 as the
next character. But we receive 52, so everything is back to normal. So
no bytes are missing, no additional bytes are received, there is just
a single byte with a wrong content.

We see that always the last byte in buf is affected, i.e. buf[ret - 1].

Furthermore we see that the wrong byte is always off by 12, i.e. instead
of 51 we received 63 (63 - 51 = 12), instead of 64 we received 76
(76 - 64 = 12) etc.

The race that I described above in the commit message exactly results in
such a behavior.

In the example below read_head was already incremented but the new content
has not yet been written to ldata->read_buf.

48 49 50 51 64 65 66 67
            ^^
            read_head

The receive buffer is 4096 bytes, and we are sending a character
sequence that repeats every 126 - 47 = 79 bytes. Therefore the offset between
the old data and the new data is 4096 mod 79 = 67.

Instead of the new value 52, we still read the old value 52 - 67 (with
wrapping around from 48 to 127) = 64 = 52 + 12.

I have now applied my proposed fix below, I will run a test for the new
few days and report if this finally solved my problem.

However, since I am not familiar with memory barriers, I would like to
ask you for comments if this is the correct way to solve this problem.

Thank you!

Regards, Christian


 drivers/tty/n_tty.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 89c4cee..831137e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -321,7 +321,13 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
 
 static inline void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 {
-	*read_buf_addr(ldata, ldata->read_head++) = c;
+	*read_buf_addr(ldata, ldata->read_head) = c;
+	/*
+	 * make sure read_head is incremented _after_ data is written
+	 * from the buffer.
+	 */
+	smp_wmb();
+	ldata->read_head++;
 }
 
 /**
@@ -1539,6 +1545,11 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
 	n = min_t(size_t, count, n);
 	memcpy(read_buf_addr(ldata, head), cp, n);
+	/*
+	 * make sure read_head is incremented _after_ data is written
+	 * from the buffer, here ...
+	 */
+	smp_wmb();
 	ldata->read_head += n;
 	cp += n;
 	count -= n;
@@ -1547,6 +1558,8 @@ n_tty_receive_buf_real_raw(struct tty_struct *tty, const unsigned char *cp,
 	n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
 	n = min_t(size_t, count, n);
 	memcpy(read_buf_addr(ldata, head), cp, n);
+	/* ... and here again. */
+	smp_wmb();
 	ldata->read_head += n;
 }
 
@@ -1947,6 +1960,11 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		is_eof = n == 1 && read_buf(ldata, tail) == EOF_CHAR(tty);
 		tty_audit_add_data(tty, read_buf_addr(ldata, tail), n,
 				ldata->icanon);
+		/*
+		 * make sure read_tail is incremented _after_ data is read
+		 * from the buffer.
+		 */
+		smp_mb();
 		ldata->read_tail += n;
 		/* Turn single EOF into zero-length read */
 		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
-- 
1.7.9.5

