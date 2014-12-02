Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaLBUem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:34:42 -0500
Received: from mout.gmx.net ([212.227.17.20]:59991 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671AbaLBUel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:34:41 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Anton Blanchard <anton@samba.org>,
        "Hon Ching (Vicky) Lo" <honclo@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if driver_data is bad
Date: Tue, 2 Dec 2014 21:39:58 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20140920072942.27c28768@kryten>
In-Reply-To: <20140920072942.27c28768@kryten>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201412022139.58754.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:PAF+SHwUucIf2ZMPrUBHrShlmtRab11Zqm5ilxQn4I/z+Aawf+y
 38emvw4D5e9EjpmBAL+OJGs4vBeplrBSCC2ZMeFgb8Zx/7FALTqEpXr6wz0zkTd+2E+r0C6
 8NIQDySNG1H8rl1+pLEDjzWoG3D+KJPZKZxgKuIwyZVg+2c+dAUHVEhKwvJVNBiHUzkDz3B
 50dx2+lZVximAMWFGl65g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

is this patchset still needed after Vicky's patch 
"[tpmdd-devel] Fix NULL return in tpm_ibmvtpm_get_desired_dma"
https://patchwork.ozlabs.org/patch/402315/

Ashley raised some concerns.

Since merge window is coming up, a fast reply is appreciated.


Thanks,
Peter

Am Freitag, 19. September 2014, 23:29:42 schrieb Anton Blanchard:
> I'm looking at an oops in tpm_ibmvtpm_get_desired_dma:
> 
>   28:	00 00 20 39 	li      r9,0
>   2c:	10 00 01 e8 	ld      r0,16(r1)
>   30:	28 00 69 80 	lwz     r3,40(r9)
> 
> We set r9 to 0 then load r9+40. The problem is actually in
> ibmvtpm_get_data, it can return NULL but the rest of the driver
> never expects it.
> 
> Add a BUG_ON in ibmvtpm_get_data. We still need to identify the root
> cause but at least this makes it obvious what went wrong.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c
> b/drivers/char/tpm/tpm_ibmvtpm.c index af74c57..0d1eeba 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -63,9 +63,9 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1,
> u64 w2) static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device
> *dev) {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	if (chip)
> -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> -	return NULL;
> +
> +	BUG_ON(!chip);
> +	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
>  }
> 
>  /**

