Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbaEKWjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:39:44 -0400
Received: from mail.eperm.de ([89.247.134.16]:36857 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbaEKWjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:39:42 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] Add in-kernel /dev/random equivalent
Date: Mon, 12 May 2014 00:36:01 +0200
Message-ID: <1937020.H2HvEFgXrB@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.3-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1929063.BgsACCXYyd"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1929063.BgsACCXYyd
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

as discussed in thread [1], an in-kernel equivalent to the blocking 
/dev/random device behavior is suggested. This in-kernel blocking access to 
the RNG can be used to seed deterministic random number generators with random 
numbers that are directly backed by the underlying noise sources.

The following patch implements this concept by adding a third output pool, the 
kernel_pool that is only accessible inside the kernel. That kernel_pool feeds 
the blocking operation API calls to obtain random numbers.

Please find a test kernel module attached. You can unload it even while the 
collection process is ongoing.

[1] https://lkml.org/lkml/2014/4/27/174

Stephan Mueller (2):
  Addition of kernel_pool
  Asynchronous and syncronous API for accessing kernel_pool

 drivers/char/random.c  | 163 
+++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/random.h |  16 +++++
 2 files changed, 166 insertions(+), 13 deletions(-)

-- 
1.9.0
--nextPart1929063.BgsACCXYyd
Content-Disposition: attachment; filename="lrng-asym.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="lrng-asym.c"

/* Test module for verifying the correct operation of the
 * SP800-90A DRBG
 *
 * Use: compile, load into the kernel and observe dmesg
 *
 * Written by: Stephan Mueller <smueller@chronox.de>
 * Copyright (c) 2014
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 *                          NO WARRANTY
 *
 *  BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
 *  FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
 *  OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
 *  PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
 *  OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
 *  TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
 *  PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
 *  REPAIR OR CORRECTION.
 *
 *  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
 *  WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
 *  REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
 *  INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
 *  OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
 *  TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
 *  YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
 *  PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGES.
 */

#include <linux/random.h>
#include <linux/module.h>
#include <linux/slab.h> /* needed for kzalloc */

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
MODULE_DESCRIPTION("Test module for verifying the correct operation of async LRNG operation");

static struct random_work my_work;
static struct random_work my_work1;
static struct random_work my_work2;
static struct random_work my_work3;
static struct random_work my_work4;
static struct random_work my_work5;
static struct random_work my_work6;
static struct random_work my_work7;
static struct random_work my_work8;
static struct random_work my_work9;
#define LEN 1024
static char buffer[LEN];

void lrng_cb(void *buf, ssize_t buflen)
{
	printk("received %d bytes\n", (int)buflen);
}

static void cn(struct random_work *work)
{
	get_blocking_random_bytes_cancel(work);
	cancel_work_sync(&work->rw_work);
}

static int __init lrng_init(void)
{
	get_blocking_random_bytes_cb(NULL, &my_work, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work1, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work2, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work3, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work4, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work5, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work6, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work7, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work8, buffer, LEN, lrng_cb);
	get_blocking_random_bytes_cb(NULL, &my_work9, buffer, LEN, lrng_cb);

	/* cancel one work to see that work can be canceled independent from
	 * others */
	cn(&my_work);
	return 0;
}

void __exit lrng_exit(void)
{
	cn(&my_work1);
	cn(&my_work2);
	cn(&my_work3);
	cn(&my_work4);
	cn(&my_work5);
	cn(&my_work6);
	cn(&my_work7);
	cn(&my_work8);
	cn(&my_work9);
}

module_init(lrng_init);
module_exit(lrng_exit);


--nextPart1929063.BgsACCXYyd--

