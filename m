Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaABPBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:01:18 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48667 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaABPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:01:16 -0500
Message-ID: <52C57F3B.9070509@cogentembedded.com>
Date: Thu, 02 Jan 2014 19:01:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: Re: [PATCH, RFC 21/30] isdn: divert, hysdn: fix interruptible_sleep_on
 race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-22-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-22-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-01-2014 16:07, Arnd Bergmann wrote:

> These two drivers use identical code for their procfs status
> file handling, which contains a small race against status
> data becoming available while reading the file.

> This uses wait_event_interruptible instead to fix this
> particular race and eventually get rid of all sleep_on
> instances. There seems to be another race involving
> multiple concurrent readers of the same procfs file, which
> I don't try to fix here.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: netdev@vger.kernel.org
> ---
>   drivers/isdn/divert/divert_procfs.c | 7 ++++---
>   drivers/isdn/hysdn/hysdn_proclog.c  | 7 ++++---
>   2 files changed, 8 insertions(+), 6 deletions(-)

> diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
> index fb4f1ba..1c5dc34 100644
> --- a/drivers/isdn/divert/divert_procfs.c
> +++ b/drivers/isdn/divert/divert_procfs.c
> @@ -86,12 +86,13 @@ isdn_divert_read(struct file *file, char __user *buf, size_t count, loff_t *off)
>   	struct divert_info *inf;
>   	int len;
>
> -	if (!*((struct divert_info **) file->private_data)) {
> +	if (!(inf = *((struct divert_info **) file->private_data))) {

    checkpatch.pl shouldn't approve assignment inside *if*. Though you're 
moving it from the existing code, it wouldn't hurt to fix it.

>   		if (file->f_flags & O_NONBLOCK)
>   			return -EAGAIN;
> -		interruptible_sleep_on(&(rd_queue));
> +		wait_event_interruptible(rd_queue, (inf =
> +			*((struct divert_info **) file->private_data)));

    Parens around assignment are hardly useful.

>   	}
> -	if (!(inf = *((struct divert_info **) file->private_data)))
> +	if (!inf)
>   		return (0);
>
>   	inf->usage_cnt--;	/* new usage count */
> diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
> index b61e8d5..7b5fd8f 100644
> --- a/drivers/isdn/hysdn/hysdn_proclog.c
> +++ b/drivers/isdn/hysdn/hysdn_proclog.c
> @@ -175,14 +175,15 @@ hysdn_log_read(struct file *file, char __user *buf, size_t count, loff_t *off)
>   	int len;
>   	hysdn_card *card = PDE_DATA(file_inode(file));
>
> -	if (!*((struct log_data **) file->private_data)) {
> +	if (!(inf = *((struct log_data **) file->private_data))) {

    Here too checkpatch.pk should complain...

>   		struct procdata *pd = card->proclog;
>   		if (file->f_flags & O_NONBLOCK)
>   			return (-EAGAIN);
>
> -		interruptible_sleep_on(&(pd->rd_queue));
> +		wait_event_interruptible(pd->rd_queue, (inf =
> +				*((struct log_data **) file->private_data)));

    And parens hardly needed.

WBR, Sergei

