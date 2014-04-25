Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaDYQ1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:27:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35640 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaDYQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:10:07 -0400
Message-ID: <535A88D5.3030008@gmail.com>
Date: Fri, 25 Apr 2014 21:39:57 +0530
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Clarification needed on use of put_user inside a loop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

function put_user() is used to transfer small bytes of data (1-8 byte) 
from kernel space to user space and before transferring, it checks for 
the user's access over that memory area (in user space of-course) using 
function access_ok(). function __put_user() is used for same purpose but 
it skips checking permission part.

Hence when transferring data involves loops then checking permission 
(using access_ok()) once should be good to go then after we can simply 
transfer data using __put_user(), instead of using put_user() itself in 
loop.

I have  found some codes in the driver which use put_user() in loop. Can 
we avoid the overhead of checking the same memory area( where put_user() 
writes) again n again using __put_user() in side loop and checking 
permission using access_ok before entering the loop?

Below is one of the codes I found.
File Name:sound/pci/hda/patch_hdmi.c

Code
-----------
for (i = 0; i < ARRAY_SIZE(channel_allocations); i++, cap++) { //line 
number 1928
                         int chs_bytes = chs * 4;
                         int type = 
spec->ops.chmap_cea_alloc_validate_get_type(cap, chs);
                         unsigned int tlv_chmap[8];

                         if (type < 0)
                                 continue;
                         if (size < 8)
                                 return -ENOMEM;
                         if (put_user(type, dst) ||
                             put_user(chs_bytes, dst + 1))
                                 return -EFAULT;
                         dst += 2;
                         size -= 8;
                         count += 8;
                         if (size < chs_bytes)
                                 return -ENOMEM;
                         size -= chs_bytes;
                         count += chs_bytes;
                         spec->ops.cea_alloc_to_tlv_chmap(cap, 
tlv_chmap, chs);
                         if (copy_to_user(dst, tlv_chmap, chs_bytes))
                                 return -EFAULT;
                         dst += chs;
                 }
---------------------------
Please revert with comment on whether I am correct or not. If yes, I'll 
submit the patches for upgrading codes to skip the overhead of checking 
memory area for permission.

Regards,
Kumar Gaurav
