Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3JWKoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:44:13 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:49936 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3JWKoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:44:12 -0400
Date: Wed, 23 Oct 2013 12:43:33 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tom.leiming@gmail.com,
        gregkh@linuxfoundation.org
Subject: Re: userspace firmware load fails with current linux-next
Message-ID: <20131023124333.356d0e15@ipc1.ka-ro>
In-Reply-To: <20131023182609.6646b5c0@tom-ThinkPad-T410>
References: <20131023110618.7bd07899@ipc1.ka-ro>
	<20131023182609.6646b5c0@tom-ThinkPad-T410>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ming Lei wrote:
> On Wed, 23 Oct 2013 11:06:18 +0200
> Lothar Waßmann <LW@KARO-electronics.de> wrote:
> 
[...]
> > Or is it an unintended side effect of some recent change?
> 
> Maybe yes, could you test below patch?
> 
> Tejun, looks we need to keep special attention on zero size of bin file
> as before, could you comment at the patch?
> 
> --
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 5d818df..366ae8d 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -277,7 +277,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
>  	ssize_t len = min_t(size_t, count, PAGE_SIZE);
>  	char *buf;
>  
> -	if (sysfs_is_bin(of->sd)) {
> +	if (sysfs_is_bin(of->sd) && size) {
>  		loff_t size = file_inode(file)->i_size;
>  
>  		if (size <= *ppos)
> 
> 
> 
The patch as is produces a build error, because 'size' is only defined
after the 'if' statement.

The modified patch below works for me.

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 5d818df..709d6f5 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -277,7 +277,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
 	ssize_t len = min_t(size_t, count, PAGE_SIZE);
 	char *buf;
 
-	if (sysfs_is_bin(of->sd)) {
+	if (sysfs_is_bin(of->sd) && file_inode(file)->i_size) {
 		loff_t size = file_inode(file)->i_size;
 
 		if (size <= *ppos)



Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
