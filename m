Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaLHQUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:20:47 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:55070 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaLHQUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:20:45 -0500
Date: Mon, 8 Dec 2014 11:20:29 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:atm Remove two FIXMES in the function,
 top_off_fp for the file, firestream.c
Message-ID: <20141208112029.2ca0c2bd@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1417923348-13807-1-git-send-email-xerofoify@gmail.com>
References: <1417923348-13807-1-git-send-email-xerofoify@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any reason to promote qe_tmp to a u64.  I think you can
just remove the comment.  Anyone trying to build this into a 64-bit
kernel will see errors from the virt_to_bus()/bus_to_virt() usage.

fp->n seems to only be manipulated in interrupt context (after driving
initialization) so it doesn't need locking or to be atomic.

On Sat,  6 Dec 2014 22:35:48 -0500
Nicholas Krause <xerofoify@gmail.com> wrote:

> Removes two FIXMES in the function.top_off_fp. The first being that of needing the variable, qe_tmp needing to be a
> u64 type and not u32 as encoding will not work if using a 32 bit register rather then 64 bit as stated in the first
> fix me comment. In addition the second being a no longer needed comment due to not needing to atomically increment
> the variable, n as passed to the function by the pointer of fp, as part of a structure of type,freepool.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/atm/firestream.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
> index 82f2ae0..06c23f6 100644
> --- a/drivers/atm/firestream.c
> +++ b/drivers/atm/firestream.c
> @@ -1477,7 +1477,7 @@ static void top_off_fp (struct fs_dev *dev, struct freepool *fp,
>  	struct FS_BPENTRY *qe, *ne;
>  	struct sk_buff *skb;
>  	int n = 0;
> -	u32 qe_tmp;
> +	u64  qe_tmp;
>  
>  	fs_dprintk (FS_DEBUG_QUEUE, "Topping off queue at %x (%d-%d/%d)\n", 
>  		    fp->offset, read_fs (dev, FP_CNT (fp->offset)), fp->n, 
> @@ -1505,14 +1505,8 @@ static void top_off_fp (struct fs_dev *dev, struct freepool *fp,
>  		ne->skb = skb;
>  		ne->fp = fp;
>  
> -		/*
> -		 * FIXME: following code encodes and decodes
> -		 * machine pointers (could be 64-bit) into a
> -		 * 32-bit register.
> -		 */
> -
>  		qe_tmp = read_fs (dev, FP_EA(fp->offset));
> -		fs_dprintk (FS_DEBUG_QUEUE, "link at %x\n", qe_tmp);
> +		fs_dprintk(FS_DEBUG_QUEUE, "link at %llx\n", qe_tmp);
>  		if (qe_tmp) {
>  			qe = bus_to_virt ((long) qe_tmp);
>  			qe->next = virt_to_bus(ne);
> @@ -1521,7 +1515,7 @@ static void top_off_fp (struct fs_dev *dev, struct freepool *fp,
>  			write_fs (dev, FP_SA(fp->offset), virt_to_bus(ne));
>  
>  		write_fs (dev, FP_EA(fp->offset), virt_to_bus (ne));
> -		fp->n++;   /* XXX Atomic_inc? */
> +		fp->n++;
>  		write_fs (dev, FP_CTU(fp->offset), 1);
>  	}
>  

