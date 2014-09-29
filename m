Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaI2JKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:10:12 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45767 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2JKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:10:10 -0400
Message-ID: <542921EA.4050709@gmail.com>
Date: Mon, 29 Sep 2014 11:10:02 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>, Doug Ledford <dledford@redhat.com>
CC: mtk.manpages@gmail.com,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>
Subject: Document POSIX MQ /proc/sys/fs/mqueue files
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug, David,

I think you two were the last ones to make significant 
changes to the semantics of the files in /proc/sys/fs/mqueue,
so I wonder if you (or anyone else who is willing) might
take a look at the man page text below that I've written
(for the mq_overview(7) page) to describe past and current
reality, and let me know of improvements of corrections.

By the way, Doug, your commit ce2d52cc1364 appears to have
changed/broken the semantics of the files in the /dev/mqueue 
filesystem. Formerly, the QSIZE field in these files showed
the number of bytes of real user data in all of the queued
messages. After that commit, QSIZE now includes kernel 
overhead bytes, which does not seem very useful for user 
space. Was that change intentional? I see no mention of the
change in the commit message, so it sounds like it was not 
intended.

Cheers,

Michael

>From mq_overview(7) draft:

   /proc interfaces
       The following interfaces can be used to limit the amount of  ker‐
       nel  memory  consumed  by  POSIX  message  queues  and to set the
       default attributes for new message queues:

       /proc/sys/fs/mqueue/msg_default (since Linux 3.5)
              This file  defines  the  value  used  for  a  new  queue's
              mq_maxmsg setting when the queue is created with a call to
              mq_open(3) where attr is specified as NULL.   The  default
              value for this file is 10.  The minimum and maximum are as
              for /proc/sys/fs/mqueue/msg_max.  If  msg_default  exceeds
              msg_max,  a  new queue's default mq_maxmsg value is capped
              to the msg_max limit.  Up until Linux 2.6.28, the  default
              mq_maxmsg  was  10;  from  Linux  2.6.28 to Linux 3.4, the
              default was the value defined for the msg_max limit.

       /proc/sys/fs/mqueue/msg_max
              This file can be used to view and change the ceiling value
              for the maximum number of messages in a queue.  This value
              acts as a ceiling on the attr->mq_maxmsg argument given to
              mq_open(3).   The  default  value  for msg_max is 10.  The
              minimum value is 1 (10 in  kernels  before  2.6.28).   The
              upper  limit is HARD_MSGMAX.  The msg_max limit is ignored
              for  privileged  processes  (CAP_SYS_RESOURCE),  but   the
              HARD_MSGMAX ceiling is nevertheless imposed.

              The  definition  of  HARD_MSGMAX has changed across kernel
              versions:

              *  Up to Linux 2.6.32: 131072 / sizeof(void *)

              *  Linux 2.6.33 to 3.4: (32768 * sizeof(void *) / 4)

              *  Since Linux 3.5: 65,536

       /proc/sys/fs/mqueue/msgsize_default (since Linux 3.5)
              This file defines the value used for a new queue's mq_msg‐
              size  setting  when  the  queue  is created with a call to
              mq_open(3) where attr is specified as NULL.   The  default
              value  for this file is 8192.  The minimum and maximum are
              as   for   /proc/sys/fs/mqueue/msgsize_max.     If    msg‐
              size_default  exceeds  msgsize_max,  a new queue's default
              mq_msgsize value is capped to the msgsize_max  limit.   Up
              until  Linux 2.6.28, the default mq_msgsize was 8192; from
              Linux 2.6.28 to Linux  3.4,  the  default  was  the  value
              defined for the msgsize_max limit.

       /proc/sys/fs/mqueue/msgsize_max
              This  file  can  be used to view and change the ceiling on
              the maximum message size.  This value acts as a ceiling on
              the  attr->mq_msgsize  argument  given to mq_open(3).  The
              default value for msgsize_max is 8192 bytes.  The  minimum
              value  is  128 (8192 in kernels before 2.6.28).  The upper
              limit for msgsize_max has varied across kernel versions:

              *  Before Linux 2.6.28, the upper limit is INT_MAX.

              *  From Linux 2.6.28 to 3.4, the limit is 1,048,576.

              *  Since Linux 3.5, the limit is 16,777,216 (HARD_MSGSIZE‐
                 MAX).

              The  msgsize_max  limit  is ignored for privileged process
              (CAP_SYS_RESOURCE), but, since Linux  3.5,  the  HARD_MSG‐
              SIZEMAX ceiling is enforced for privileged processes.

       /proc/sys/fs/mqueue/queues_max
              This  file  can be used to view and change the system-wide
              limit on the number of message queues that can be created.
              The default value for queues_max is 256.  The semantics of
              this limit have changed across kernel versions as follows:

              *  Before Linux 3.5, this limit could be  changed  to  any
                 value  in  the  range 0 to INT_MAX, but privileged pro‐
                 cesses (CAP_SYS_RESOURCE) can exceed the limit.

              *  Since Linux 3.5, there is a ceiling for this  limit  of
                 1024     (HARD_QUEUESMAX).      Privileged    processes
                 (CAP_SYS_RESOURCE) can exceed the queues_max limit, but
                 the  HARD_QUEUESMAX  limit  is enforced even for privi‐
                 leged processes.

              *  Starting with Linux 3.14, the HARD_QUEUESMAX ceiling is
                 removed: no ceiling is imposed on the queues_max limit,
                 and privileged processes (CAP_SYS_RESOURCE) can  exceed
                 the limit.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
