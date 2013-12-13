Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3LMRbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:31:08 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41263 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3LMRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:31:06 -0500
MIME-Version: 1.0
In-Reply-To: <52AB3D86.2040706@linux.com>
References: <CAAdffVGw9Fz1AzAWs5y2943R3JsTvaCvQN1kipCdpeK+Guv_JQ@mail.gmail.com>
	<52AB3D86.2040706@linux.com>
Date: Sat, 14 Dec 2013 01:31:05 +0800
Message-ID: <CAAdffVHtRc4Ew9f8DMdQf7jC3+saSg1V6OVoAChhMN2WpCo2OA@mail.gmail.com>
Subject: Re: [PATCH] scsi: integer overflow in megadev_ioctl()
From: Yu Chen <chyyuu@gmail.com>
To: Levente Kurusa <levex@linux.com>
Cc: linux-kernel@vger.kernel.org, megaraidlinux@lsi.com,
        xiaoqixue_1 <xiaoqixue_1@163.com>,
        =?GB2312?B?t7bOxMG8?= <fanwlexca@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you!  The new patch
-------------------------------------------------------------
[PATCH] scsi: integer overflow in megadev_ioctl()

There is a potential integer overflow in megadev_ioctl() if
userspace passes in a large u32 variable uioc.adapno.
Theint variable adapno would < 0, leading to a error
array access for hdb_soft_state[adapno], or a error
copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,..)

Reported-by: Wenliang Fan <fanwlexca@gmail.com>
Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
Signed-off-by: Yu Chen <chyyuu@gmail.com>
---
 drivers/scsi/megaraid.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 41bbc21..0b90c54 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3099,7 +3099,10 @@ megadev_ioctl(struct file *filep, unsigned int
cmd, unsigned long arg)
  /*
  * Which adapter
  */
- if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
+ adapno = GETADAP(uioc.adapno);
+ if( adapno < 0 )
+ return (-EINVAL);
+ if( adapno >= hba_count )
  return (-ENODEV);

  if( copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,
@@ -3113,8 +3116,10 @@ megadev_ioctl(struct file *filep, unsigned int
cmd, unsigned long arg)
  /*
  * Which adapter
  */
-                adapno = GETADAP(uioc.adapno);
- if( adapno >= hba_count || adapno < 0 )
+ adapno = GETADAP(uioc.adapno);
+ if( adapno < 0 )
+ return (-EINVAL);
+ if( adapno >= hba_count )
  return (-ENODEV);

  adapter = hba_soft_state[adapno];
@@ -3161,7 +3166,10 @@ megadev_ioctl(struct file *filep, unsigned int
cmd, unsigned long arg)
  /*
  * Which adapter
  */
- if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
+ adapno = GETADAP(uioc.adapno);
+ if( adapno < 0 )
+ return (-EINVAL);
+ if( adapno >= hba_count )
  return (-ENODEV);

  adapter = hba_soft_state[adapno];
-- 
1.8.3.2

2013/12/14 Levente Kurusa <levex@linux.com>:
> Hi,
>
> On 12/13/2013 05:55 PM, Yu Chen wrote:
>>  drivers/scsi/megaraid.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>> index 816db12..41bbc21 100644
>> --- a/drivers/scsi/megaraid.c
>> +++ b/drivers/scsi/megaraid.c
>> @@ -3113,7 +3113,8 @@ megadev_ioctl(struct file *filep, unsigned int
>> cmd, unsigned long arg)
>>   /*
>>   * Which adapter
>>   */
>> - if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
>> +                adapno = GETADAP(uioc.adapno);
>> + if( adapno >= hba_count || adapno < 0 )
>>   return (-ENODEV);
>
> Wouldn't returning -EINVAL be better? For hba_count I understand that
> -ENODEV is returned but for adapno being a passed variable, I would
> suggest returning -EINVAL.
>
> --
> Regards,
> Levente Kurusa



-- 
Best Regards
==============================================
Yu Chen
Ph.D.  Associate Professor
System Software&Software Engineering Group,
Dept. of Computer Science and Technology
Tsinghua University, Beijing 100084, P.R. China
E-Mail: mailto:yuchen@tsinghua.edu.cn  chyyuu@gmail.com
==============================================
