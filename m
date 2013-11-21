Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3KUCwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:52:04 -0500
Received: from blu0-omc1-s15.blu0.hotmail.com ([65.55.116.26]:5858 "EHLO
	blu0-omc1-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab3KUCwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:52:00 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 21:52:00 EST
X-TMN: [rtUYxAn5iF75IuZf7D9eTqJse2VvDlzT]
X-Originating-Email: [gancuimian@hotmail.com]
Message-ID: <BLU171-DS35B00C010728ACFB2F8DF9D3E10@phx.gbl>
From: YuLicheng <gancuimian@hotmail.com>
To: <linux-doc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <roel.kluin@gmail.com>
Subject: kref doc: Why kref kernel doc omits kref_put when kthread_run fail
Date: Thu, 21 Nov 2013 10:42:18 +0800
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="gb2312"; reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3505.912
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3505.912
X-OriginalArrivalTime: 21 Nov 2013 02:42:18.0285 (UTC) FILETIME=[4B7B5DD0:01CEE663]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The document is /Documentation/kerf.txt, and I'm referring to v3.12:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/kref.txt?id=v3.12

Part of the first example in the document is attached below.
In my_data_handler(), kref_init() already put 1 to refcount, and kref_get()
next made the refcount 2. But if kthread_run() fails, only one kref_put() 
will
take place (right after the out tag), it renders the refcount to be 1 at 
last,
and the data will never be freed.

int my_data_handler(void)
{
        int rv = 0;
        struct my_data *data;
        struct task_struct *task;
        data = kmalloc(sizeof(*data), GFP_KERNEL);
        if (!data)
                return -ENOMEM;
        kref_init(&data->refcount);

        kref_get(&data->refcount);
        task = kthread_run(more_data_handling, data, "more_data_handling");
        if (task == ERR_PTR(-ENOMEM)) {
                rv = -ENOMEM;
                goto out;
        }

        .
        . do stuff with data here
        .
out:
        kref_put(&data->refcount, data_release);
        return rv;
}

I also noticed that there once was a kref_put() before "goto out" in the doc
before some point of 2009, but it was removed by a patch that claimed that 
this
kref_put() was redudent.
The patch commit is:
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/Documentation/kref.txt?id=8f1ecc9fbc5b223e4f5d5bb8bcd6f5672c4bc4b6

Is this a bug or maybe I missed something?


        Licheng 

