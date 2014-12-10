Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaLJSlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:41:21 -0500
Received: from nm32-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.55]:48987 "EHLO
	nm32-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414AbaLJSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:41:20 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2014 13:41:20 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.ca;
	b=dOjmRjKFJtEtDkcJUqcg8YK/fWKnKXXo6HqXqq92ioUBUrNrmep9Ylmvim75oKemTGYkh3MrLpiYu3lXo6yaNTiChI4fzjctcJHUKv6/QUV7ziVDrlnlsHLcvC3fmMUqdBae5+KnE7ZJQ4kEywoyC/0Fvltzvh18yOUHxijjYcB3bAleGM630eAbTj3+e6/7vSZJbPmfwFuKfFCVdbA65agRylx/2EgAtj9wyUTxflk5F01TpkXUCIaF2EwH4X5+FYXXUuW8xiJ1Dw6FGupjDhloNfJkX/GSMmc/UVFRtrZKj+7xIoqG06Z2SyMslal1vA149cljy1ISuaN2Dge8+g==;
X-Yahoo-Newman-Id: 980847.46211.bm@smtp202.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-4
X-YMail-OSG: csCznGQVM1nR0NBu71P6o85ogX9fZKbIZMAequzTf0aNKpE
 k1l.apg0ZA4Ta6x6LakDWiVhev.rwkhASe0SGH3VueT1iYUHlVa07MrHQHqS
 vrkkgByXS_BsBKOWrv4WT2tzJSoB6YWvX0JhksJKBI.vkI7zuVl6rKtvKWx1
 IcIeV05FDNRw3hFoWQGSnEDjq1TCAC2EHfkWTh9SDVNEhCWoTGJWWEBK_Hy0
 nXuakVnZpZvqgSndxHTBeQnLPKFHV8_4ZdiqkcXlslz3bLzxFf1kd4xWl8Ii
 4zB9cylCbjY8CUS._lqqXtjhktgHNSZFoxVwxDIkbSlop0O17H2adZPvejJM
 VxAK1rvPbHvgDXMmT0pWjZnPnoEyWYeQsHnkXb6h_nJK4PW8tiGibiXwSONC
 tFe7qoo_Ws6jIuHVPLtOjkCaO6uW9enQM0yJMUbMwrqt0xLVUFKJdM8H9hPG
 _tjEXNy5p9BksKSQ6tH4Q_xMCU4umLJd7Ffy9hTBILguDAjxRTjs7GI5iZZt
 RVwXPhoPYBJHInBHdkHPV6CyxtO2adrvaQeWhRNM8fNNa5gHTzPGdGxw8vgb
 8DjjS_fI4nInpxpWIfCWuXPDvnx9d4RkS
X-Yahoo-SMTP: erUHay2swBAHy3fhG3khiNpFvMLWTM_N
Message-ID: <548891BF.9020108@yahoo.ca>
Date: Wed, 10 Dec 2014 13:32:31 -0500
From: Denis Du <dudenis2000@yahoo.ca>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] TTY: Fix the missing lock for the TTY ldisc buffer
X-Forwarded-Message-Id: 
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guys:
It was found that the 3.12 kernel tty layer will lose or corrupt data 
when have a full-duplex communication, especially in high baud rate, for 
example 230k for my OMAP5 uart. Eventually I found there is lock missing 
between copy data to ldisc layer buffer and copy data from the same 
buffer to user space. I believe this issue existed since 3.8 
kernel(since this kernel , it start to remove most of the spin-locks) 
and I didn't find any fix even through 3.17 kernel. This patch was 
tested to be works great with no any data loss again on 3.12 kernel.

This patch was built fro the latest kernel, but I cannot test 
it.Somebody may give a test.

I did try to use the existed lock atomic_read_lock, but it doesn’t work.



Signed-off-by: Hui Du <dudenis2000@yahoo.ca>


---
  drivers/tty/n_tty.c |    9 ++++++++-
  1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 2e900a9..6e5c6ae 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -125,6 +125,7 @@ struct n_tty_data {
  
  	struct mutex atomic_read_lock;
  	struct mutex output_lock;
+	struct mutex read_buf_lock;
  };
  
  static inline size_t read_cnt(struct n_tty_data *ldata)
@@ -1691,7 +1692,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
  	int room, n, rcvd = 0;
  
  	down_read(&tty->termios_rwsem);
-
+	mutex_lock(&ldata->read_buf_lock);
  	while (1) {
  		room = receive_room(tty);
  		n = min(count, room);
@@ -1710,6 +1711,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
  
  	tty->receive_room = room;
  	n_tty_check_throttle(tty);
+	mutex_unlock(&ldata->read_buf_lock);
  	up_read(&tty->termios_rwsem);
  
  	return rcvd;
@@ -1876,6 +1878,7 @@ static int n_tty_open(struct tty_struct *tty)
  	ldata->overrun_time = jiffies;
  	mutex_init(&ldata->atomic_read_lock);
  	mutex_init(&ldata->output_lock);
+	mutex_init(&ldata->read_buf_lock);
  
  	tty->disc_data = ldata;
  	reset_buffer_flags(tty->disc_data);
@@ -1939,6 +1942,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
  	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
  
  	retval = 0;
+	mutex_lock(&ldata->read_buf_lock);
  	n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
  	n = min(*nr, n);
  	if (n) {
@@ -1954,6 +1958,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
  		*b += n;
  		*nr -= n;
  	}
+	mutex_unlock(&ldata->read_buf_lock);
  	return retval;
  }
  
@@ -1992,6 +1997,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
  	bool eof_push = 0;
  
  	/* N.B. avoid overrun if nr == 0 */
+	mutex_lock(&ldata->read_buf_lock);
  	n = min(*nr, read_cnt(ldata));
  	if (!n)
  		return 0;
@@ -2052,6 +2058,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
  			ldata->push = 0;
  		tty_audit_push(tty);
  	}
+	mutex_unlock(&ldata->read_buf_lock);
  	return eof_push ? -EAGAIN : 0;
  }
  
-- 
1.7.10.4



