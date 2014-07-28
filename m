Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaG1IYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:24:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:32883 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaG1IYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:24:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="576413162"
Message-ID: <53D60896.5050703@intel.com>
Date: Mon, 28 Jul 2014 16:23:50 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, mnipxh <mnipxh@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm.c: fix a memory leak in gsmld_open
References: <53D6067C.4000702@intel.com>
In-Reply-To: <53D6067C.4000702@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, All
	thanks for reading. Below is my trigger.

----------------------------------------
#define WARN(x) do{		\
	KLOG_ERROR("XINHUI",x);	\
}while(0)

int main()
{
	KLOG_ERROR("XINHUI", "hello world :)\n");
	long fp[4];
	int i = 0;
	int next[4]={1,2,3,0};

	do{
		char path[64] = "dev/tty30";
		path[strlen(path) - 1] = '0' + i;

		fp[i] = open(path, O_RDWR);
		if (fp[i] == -1){
			WARN("mlk tty open fails\n");
			return 0;
		}
	}while(++i < 4);

	i = 0;
	do{
		int p = 21;
		int ret = ioctl(fp[i], TIOCSETD , &p);
		if (ret != 0) {
			WARN("mlk tty ioctl fails\n");
		}
		i = next[i];
	}while(1);
/* never run here, just ctrl^C */

	return 0 ;
}
----------------------------------------

without this patch, running my own tests.

my result:

PROCRANK:
.....
RAM: 1993076K total, 147968K free, 708K buffers, 108340K cached, 332K shmem, 1092232K slab
AWESOME!

cat /proc/slabinfo
.....
kmalloc-2048      509700 509700   2048   16    8 : tunables    0    0    0 : slabdata  32285  32285      0
.....
AWESOME!!

thanks,

xinhui

于 2014年07月28日 16:14, xinhui.pan 写道:
> If gsmld_attach_gsm fails, the gsm is not used anymore.
> tty core will not call gsmld_close to do the cleanup work.
> tty core just restore to the tty old ldisc.
> That always causes memory leak.
> 
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> Reported-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_gsm.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 81e7ccb..6cb1a6d 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -2368,6 +2368,7 @@ static void gsmld_close(struct tty_struct *tty)
>  static int gsmld_open(struct tty_struct *tty)
>  {
>  	struct gsm_mux *gsm;
> +	int ret;
>  
>  	if (tty->ops->write == NULL)
>  		return -EINVAL;
> @@ -2382,7 +2383,13 @@ static int gsmld_open(struct tty_struct *tty)
>  
>  	/* Attach the initial passive connection */
>  	gsm->encoding = 1;
> -	return gsmld_attach_gsm(tty, gsm);
> +
> +	ret = gsmld_attach_gsm(tty, gsm);
> +	if (ret != 0) {
> +		gsm_cleanup_mux(gsm);
> +		mux_put(gsm);
> +	}
> +	return ret;
>  }
>  
>  /**
> 
