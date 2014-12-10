Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaLJSl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:41:27 -0500
Received: from nm42-vm2.bullet.mail.gq1.yahoo.com ([67.195.87.153]:59210 "EHLO
	nm42-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414AbaLJSlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:41:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.ca;
	b=unoTgJR0WHEhv8agx7HgpVn/DpMwmkC5bmxF1HzAhwz/XTMX1obNl/QrNIamPqOfQHhFNtEG8l3neY27X12s7LAnMNdtLZPN1jbsqpaVqmlVwDh6Y74GXP5rdkKQkzArZhpOx872OEuOk43DD2ATOZuN8tdmLCAY6lX/mBLFDrc6faL8iNGfto9RYEEaJU5EWJk8LSSNBLGmCFEXmbQCioWrVzl+RHLi1LJi3FElin8SXryE6KmgsfmqLS1xlCfNcfZkG81oR9e24rRhNbJvTu1s6E6H0Spikr2k6BZxexl384g+0qxErUapMqp5lU6bOnk3vrZUQRtwC1TdereH9A==;
X-Yahoo-Newman-Id: 549234.47065.bm@smtp232.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-4
X-YMail-OSG: 3rcE7SYVM1nHIMOc2NrC9i0qJzyoDwR0tHOwKVKy85CYE3E
 ZCkpRa09opNLohZMa6BJrrApEKjXSyAR8Zyoah6MSRfQb5PLZPTWALcG9iz2
 ed0WchZqCfvjKN1EJx9OeIJdR4gA0HYIecmJNz3qk9fmVDG0iWB5VaTUM_f0
 EkMQrkwaRgXThsAgeXhWemm3E0Ndjr1vqw1XdaaqRSzsTDaG6t_mCP2h9uAz
 tEDKg1beG94mjETlVRrijtkP1inExXvjXAh7pYMArXiAd.7m8B1cgJHoN.mm
 _kfxRVAD4w6q9K0rBnrL4iFUcQC0TiqRiN4onbpcvcqazY8PpsY8OcmiuXoM
 Vcu3AarvEkoC6YoIAKNcBbn5.e9eWU8Ckgs1JZlucih9y1n5rwDKL0qt8L9e
 4YbM21e._vYfsX.fUZjmxXgV9_2GwLLIXBN0PL6RfkMEiKQQv50qLUz8hGh3
 fbdBGk_1lNmLkPr8RRb7Ba2mH_d044zyAGdnnwZZ4U0GJoxf2.MKjrQlDVNT
 b0H7GhRQ3hUqJO8UF6oU.otxMN2qnrIKAfs4wOHcSIYkZbdX.dstUsPVawpi
 EUeorL3NXhToXghX5yQOnyOJ76AV4JcYp
X-Yahoo-SMTP: erUHay2swBAHy3fhG3khiNpFvMLWTM_N
Message-ID: <5488931C.4040308@yahoo.ca>
Date: Wed, 10 Dec 2014 13:38:20 -0500
From: Denis Du <dudenis2000@yahoo.ca>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, jslaby@suse.cz, jmmahler@gmail.com
CC: linux-kernel@vger.kernel.org
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

This patch was built for the latest kernel, but I cannot test it. 
Somebody may give a test.

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



