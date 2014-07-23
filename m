Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaGWOck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:32:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58355 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbaGWOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:32:38 -0400
X-Sasl-enc: TTKrUeugAZLvDGUMKZRlQ6aYTuWn5eK5TGu4Nt8kDrtB 1406125954
Message-ID: <1406125952.26440.7.camel@localhost>
Subject: Re: Reading large amounts from /dev/urandom broken
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: tytso@mit.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jul 2014 16:32:32 +0200
In-Reply-To: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

thanks for the heads up!

On Mi, 2014-07-23 at 16:52 +0300, Andrey Utkin wrote:
> Dear developers, please check bugzilla ticket
> https://bugzilla.kernel.org/show_bug.cgi?id=80981 (not the initial
> issue, but starting with comment#3.
> 
> Reading from /dev/urandom gives EOF after 33554431 bytes.  I believe
> it is introduced by commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc,
> with the chunk
> 
> nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
> 
> which is described in commit message as "additional paranoia check to
> prevent overly large count values to be passed into urandom_read()".
> 
> I don't know why people pull such large amounts of data from urandom,
> but given today there are two bugreports regarding problems doing
> that, i consider that this is practiced.

Ted, we should roll back the min_t change and just account for SIZE_MAX
bytes in case we overflow the nbytes << (ENTROPY_SHIFT + 3) calculation.

Or something alike?

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 71529e1..f11a6cc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1006,7 +1006,10 @@ retry:
 		WARN_ON(1);
 		entropy_count = 0;
 	}
-	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	if (ibytes > SIZE_MAX >> (ENTROPY_SHIFT + 3))
+		nfrac = SIZE_MAX;
+	else
+		nfrac = ibytes << (ENTROPY_SHIFT + 3);
 	if ((size_t) entropy_count > nfrac)
 		entropy_count -= nfrac;
 	else
@@ -1386,7 +1389,6 @@ urandom_read(struct file *file, char __user *buf,
size_t nbytes, loff_t *ppos)
 			    "with %d bits of entropy available\n",
 			    current->comm, nonblocking_pool.entropy_total);
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
 	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),


