Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaLHU2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:28:10 -0500
Received: from nm43-vm7.bullet.mail.bf1.yahoo.com ([216.109.114.238]:37979
	"EHLO nm43-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbaLHU2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:28:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.ca;
	b=aDEITuaoJ8zH5hK4RIgKlfHjP+iUCRp5vY7eSffkdtKrdsRtQVOTiiwgrMKVhJUL9QBtc7WzL0mz+bnKuXYWxzaIrl1qvoxkDksFj3fZno+P79dibpyek2qRAFQj2E8AB8Wb19TEgSkMDTHbS7KfF8PLGd+7wKRqECTTID1fIifcl1Er/FYay7zvGeInm2E1tBkLjC/pvKA2w7QQ4WwU7a0xcD8/q4ZGln4Lx8lVKwdsyOrLpHHX+VpIV4ne6d0d6tyqBqTQKWLOsq4ApOQYZp+kj6jVW2X1ZFFYZJCYjr1a725IYdlkad5gemM6OlECzlE3/IjBadYJ7d4RUGryNQ==;
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 646512.13460.bm@omp1052.mail.bf1.yahoo.com
X-YMail-OSG: Cy2Y_ZcVM1mNrncXfl5oDxFLoHSfyDhrKVHoXMdXP2FlCJE2yx3zGg9.Gn1.IQR
 .i9qBfY3n7UUAnN_qBdCpAzcXXnvJFUx4vGhhmPJ8NOhXrc9DToWm9JUsYjFf_zYHCzKORDJBHfA
 dMhShyaTm1Fr4ovBWuDVMMdBSahzTJVge2E55V4m_hcUNyA2j5Dy8quFrmqvgBH0cP913uy86gwy
 JUWwF2M6.rvmzfCW79m0eRT49gT.q4rJGNLe7dsdNqbpciDG1KY9ONcxVL2RiuU_gOTRh9MU9wk3
 ZhkvHURUjxQmFppE6P4604qsx_fLeBKi8jNE81PI6vNQ9cYWfG7naG751woahduBUYbMqyEnWRYV
 vgXhbMztghUIMwMTiLaDspRzTtlYOGRGM0bk1SX7eZX_i1Joca_SQXlI1cDnCxVFhKYgjLZPaaPb
 tyNalBBjb2_NOD68l.qr28Qkjpl_zhOB9.ddMh1wZwPawZV8gj9zg.R3HadKpp0H2FcOld7CzjC6
 qgjwRgiEAuoyva0GZjBikhIM_CpX_T5BB7ur_CYd6WiZD
Date: Mon, 8 Dec 2014 20:28:00 +0000 (UTC)
From: Denis Du <dudenis2000@yahoo.ca>
Reply-To: Denis Du <dudenis2000@yahoo.ca>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <694700710.6880446.1418070480521.JavaMail.yahoo@jws10627.mail.bf1.yahoo.com>
Subject: [PATCH] TTY: missing a lock to access the ldisk buffer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guys:
I found that the 3.12 kernel tty layer will lose or corrupt data when having a full-duplex communication, especcially in high baudrate, for example 230k for my OMAP5 uart. Eventually I found there is a lock missing between copy data to ldisc layer buffer and copy data from the same buffer to user space. I believe this issue have been existing since 3.8 kernel(since this kernel , it start to remove most of the spin-locks) and I didn't find any fix even through 3.17 kernel. This patch was tested to be works great with no any data loss again.


I did try to use the existed lock atomic_read_lock, but it doesn’t work. 



Signed-off-by: Hui Du <dudenis2000@yahoo.ca>


---

--- drivers/tty/n_tty.c    2014-10-16 16:39:35.909350338 -0400
+++ drivers/tty/n_tty.c    2014-10-16 16:49:00.004930469 -0400
@@ -124,6 +124,7 @@

struct mutex atomic_read_lock;
struct mutex output_lock;
+    struct mutex read_buf_lock;
};

static inline size_t read_cnt(struct n_tty_data *ldata)
@@ -1686,9 +1687,11 @@
char *fp, int count)
{
int room, n;
+    struct n_tty_data *ldata = tty->disc_data;

down_read(&tty->termios_rwsem);

+    mutex_lock(&ldata->read_buf_lock);
while (1) {
room = receive_room(tty);
n = min(count, room);
@@ -1703,6 +1706,7 @@

tty->receive_room = room;
n_tty_check_throttle(tty);
+    mutex_unlock(&ldata->read_buf_lock);
up_read(&tty->termios_rwsem);
}

@@ -1713,7 +1717,7 @@
int room, n, rcvd = 0;

down_read(&tty->termios_rwsem);
-
+    mutex_lock(&ldata->read_buf_lock);
while (1) {
room = receive_room(tty);
n = min(count, room);
@@ -1732,6 +1736,7 @@

tty->receive_room = room;
n_tty_check_throttle(tty);
+    mutex_unlock(&ldata->read_buf_lock);
up_read(&tty->termios_rwsem);

return rcvd;
@@ -1880,6 +1885,7 @@
ldata->overrun_time = jiffies;
mutex_init(&ldata->atomic_read_lock);
mutex_init(&ldata->output_lock);
+    mutex_init(&ldata->read_buf_lock);

tty->disc_data = ldata;
reset_buffer_flags(tty->disc_data);
@@ -1945,6 +1951,8 @@
size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);

retval = 0;
+
+    mutex_lock(&ldata->read_buf_lock);
n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
n = min(*nr, n);
if (n) {
@@ -1960,6 +1968,7 @@
*b += n;
*nr -= n;
}
+    mutex_unlock(&ldata->read_buf_lock);
return retval;
}

@@ -1990,6 +1999,8 @@
size_t tail;
int ret, found = 0;
bool eof_push = 0;
+ 
+    mutex_lock(&ldata->read_buf_lock);

/* N.B. avoid overrun if nr == 0 */
n = min(*nr, read_cnt(ldata));
@@ -2049,6 +2060,8 @@
ldata->line_start = ldata->read_tail;
tty_audit_push(tty);
}
+
+    mutex_unlock(&ldata->read_buf_lock);
return eof_push ? -EAGAIN : 0;
}
