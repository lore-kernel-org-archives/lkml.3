Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaI2LFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:05:47 -0400
Received: from mx0.aculab.com ([213.249.233.131]:59694 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751396AbaI2LFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:05:45 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Kees Cook'" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Tom Herbert <therbert@google.com>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>,
        stephen hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] tun: make sure interface usage can not overflow
Thread-Topic: [PATCH] tun: make sure interface usage can not overflow
Thread-Index: AQHP23O5ZibDxwfCgkiMJV4jx9aoxJwX8m+w
Date: Mon, 29 Sep 2014 11:04:00 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1749FC70@AcuExch.aculab.com>
References: <20140928232753.GA31180@www.outflux.net>
In-Reply-To: <20140928232753.GA31180@www.outflux.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook
> This makes the size argument a const, since it is always populated by
> the caller.

There is almost no point making parameters 'const.
('const foo *' makes sense).

> Additionally double-checks to make sure the copy_from_user
> can never overflow, keeping CONFIG_DEBUG_STRICT_USER_COPY_CHECKS happy:
> 
>    In function 'copy_from_user',
>        inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1871:7:
>        ... copy_from_user() buffer size is not provably correct

If 'ifreq_len' could be too big then you want to error the ioctl, not panic.
If it can't be too big you don't need the check.

	David

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/tun.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index acaaf6784179..a1f317cba206 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1855,7 +1855,7 @@ unlock:
>  }
> 
>  static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
> -			    unsigned long arg, int ifreq_len)
> +			    unsigned long arg, const size_t ifreq_len)
>  {
>  	struct tun_file *tfile = file->private_data;
>  	struct tun_struct *tun;
> @@ -1869,6 +1869,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
>  	int ret;
> 
>  	if (cmd == TUNSETIFF || cmd == TUNSETQUEUE || _IOC_TYPE(cmd) == 0x89) {
> +		BUG_ON(ifreq_len > sizeof(ifr));
>  		if (copy_from_user(&ifr, argp, ifreq_len))
>  			return -EFAULT;
>  	} else {
> --
> 1.9.1
> 
> 
> --
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


