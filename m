Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161066Ab3CVQrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:47:05 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44932 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab3CVQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAG6tG3xyZYWgB2nUwwu8mmkSJza-cXym6iHivOUSJuYf3pV5_w@mail.gmail.com>
References: <CAJsYZ5ksvPCR2O39=sj9zeptfppP1w6FM08rw8Aw+L+2dEPCnQ@mail.gmail.com>
	<20130320165339.GA28307@kroah.com>
	<CAJsYZ5n40mBCd6x7baQ6MLw1HBAa3cfebm+Aa533uxYVP86o9Q@mail.gmail.com>
	<CAJtyJaVnUZXkWdma8YydpU6tEF2KEhrWz+uq6D142gDwX3fATg@mail.gmail.com>
	<CAG6tG3xyZYWgB2nUwwu8mmkSJza-cXym6iHivOUSJuYf3pV5_w@mail.gmail.com>
Date: Fri, 22 Mar 2013 22:17:02 +0530
Message-ID: <CAJsYZ5n84Jcb+zXiJAh10tmoxeTX2ySKY8HTVLs=r6Fd_8+CXg@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_mmap and ashmem_read
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: Robert Love <rlove@google.com>
Cc: Bjorn Bringert <bringert@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't want to hold ashmem_mutex across the VFS calls. It is only
> needed to protect the ashmem-internal structures.

In the ashmem_read function, after the VFS call the asma structure
gets updated again. So one option is to drop the lock before invoking
the VFS call and then take it again once it returns.
But if a given thread invokes ashmem_read and sleeps, is there a
scenario where some other task can come and access asma->file->f_pos ?
If yes, the we'll be returning the older f_pos value. I'm not sure
whether this is expected behavior. Since we are not done with the read
yet, we can report the old f_pos, I think.  So is the below pseudo
code OK?

static ssize_t ashmem_read(struct file *file, char __user *buf,
                           size_t len, loff_t *pos)
{
        struct ashmem_area *asma = file->private_data;
        int ret = 0;

        mutex_lock(&ashmem_mutex);
        ....
        mutex_unlock(&ashmem_mutex);
        ret = asma->file->f_op->read(asma->file, buf, len, pos);
        if (ret < 0) {
                return ret;
        }

       mutex_lock(&ashmem_mutex);
       asma->file->f_pos = *pos;
out:
        mutex_unlock(&ashmem_mutex);
        return ret;
}

If this is OK, then similar changes can be done for ashmem_lseek as well.
