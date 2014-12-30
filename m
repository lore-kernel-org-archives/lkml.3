Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaL3XhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 18:37:17 -0500
Received: from mout.gmx.net ([212.227.15.18]:65289 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaL3XhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 18:37:15 -0500
Date: Wed, 31 Dec 2014 00:37:26 +0100
From: Sebastian Herbszt <herbszt@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Sebastian Herbszt <herbszt@gmx.de>
Subject: blk-mq: should elv_iosched_store return ENXIO/EINVAL?
Message-ID: <20141231003726.00002588@localhost>
X-Mailer: Claws Mail 3.9.2-55-g74b05b (GTK+ 2.16.6; i586-pc-mingw32msvc)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:TuXrY5Fo/WQszYOxJy9yV/fqdxMNbwGdZTnKn4Pj8zbkxvrZhPl
 neuaVgEith2Wikx2VexQBbp4Qfvok6+hBXnFJoTTPOyKE6YguPJA1vja1xOI9Q3SN1hFW1M
 GRm2yKckHT0VZQdv6pHXXfErwnU9u5t8zvbS5jvEiCpn7CWREcHRPq1Aw7JRgO5l5MJGDSJ
 TgufEeRsBaIby1rJwm5HA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

setting an invalid elevator without blk-mq results in an error:

# cat /sys/block/sda/queue/scheduler
noop deadline [cfq]
# echo foo > /sys/block/sda/queue/scheduler
-bash: echo: write error: Invalid argument
# dmesg
[  328.767088] elevator: type foo not found
[  328.767097] elevator: switch to foo
 failed

With blk-mq no error is returned:

# cat /sys/block/sda/queue/scheduler
none
# echo foo > /sys/block/sda/queue/scheduler
# echo $?
0


block/elevator.c got

 988 ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 989                           size_t count)
 990 {
 991         int ret;
 992
 993         if (!q->elevator)
 994                 return count;
 995
 996         ret = __elevator_change(q, name);

and

 952 static int __elevator_change(struct request_queue *q, const char *name)
 953 {
 954         char elevator_name[ELV_NAME_MAX];
 955         struct elevator_type *e;
 956
 957         if (!q->elevator)
 958                 return -ENXIO;
 959
 960         strlcpy(elevator_name, name, sizeof(elevator_name));
 961         e = elevator_get(strstrip(elevator_name), true);
 962         if (!e) {
 963                 printk(KERN_ERR "elevator: type %s not found\n", elevator_name);
 964                 return -EINVAL;
 965         }


So !q->elevator is checked in elv_iosched_store and __elevator_change.

Should elv_iosched_store return ENXIO or EINVAL or should __elevator_change
handle this?

Sebastian
