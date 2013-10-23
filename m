Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3JWK0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:26:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48082 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3JWK0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:26:21 -0400
Date: Wed, 23 Oct 2013 18:26:09 +0800
From: Ming Lei <ming.lei@canonical.com>
To: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tom.leiming@gmail.com, gregkh@linuxfoundation.org
Subject: Re: userspace firmware load fails with current linux-next
Message-ID: <20131023182609.6646b5c0@tom-ThinkPad-T410>
In-Reply-To: <20131023110618.7bd07899@ipc1.ka-ro>
References: <20131023110618.7bd07899@ipc1.ka-ro>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 23 Oct 2013 11:06:18 +0200
Lothar Waßmann <LW@KARO-electronics.de> wrote:

> Hi,
> 
> with the current linux-next loading firmware from userspace fails
> because when writing to /sys/class/firmware/*/data the return code is
> always 0 (meaning to the userspace too that no data was written).
> Thus the userspace tool (mdev) keeps writing the same block of data
> over and over again.
> 
> A cursory check of the latest updates to /drivers/base/firmware* didn't
> reveal anything that could be the cause of this misbehaviour.
> 
> Interestingly when changing the .size member of the
> struct bin_attribute firmware_attr_data in drivers/base/firmware_class.c
> (which is now '0') to e.g. PAGE_SIZE firmware loading works again.

Thank you for the report and analysis.

> 
> Since .size was at '0' since the beginning of the .git universe there
> must have been a fundamental change in the guts of the kernel handling
> sysfs attribute files.

It may be introduced by Tejun's recent change.

> 
> Is this behavioural change intended?

I think no.

> Do all sysfs attributes that are created with zero size need to be
> changed?

I think no, since drivers have no idea of size of their firmwares. 

> Or is it an unintended side effect of some recent change?

Maybe yes, could you test below patch?

Tejun, looks we need to keep special attention on zero size of bin file
as before, could you comment at the patch?

--
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5d818df..366ae8d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -277,7 +277,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
 	char *buf;
 
-	if (sysfs_is_bin(of->sd)) {
+	if (sysfs_is_bin(of->sd) && size) {
 		loff_t size = file_inode(file)->i_size;
 
 		if (size <= *ppos)



Thanks,
-- 
Ming Lei
