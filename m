Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3BDR4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:56:48 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:22735 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3BDR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:56:47 -0500
Message-ID: <510FF659.8030905@tilera.com>
Date: Mon, 4 Feb 2013 12:56:41 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] tile: revert pr_info to printk in <asm/io.h>
References: <201302012043.r11KhFXi024365@farm-0021.internal.tilera.com> <1359758038.17807.18.camel@joe-AO722>
In-Reply-To: <1359758038.17807.18.camel@joe-AO722>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/2013 5:33 PM, Joe Perches wrote:
> On Fri, 2013-02-01 at 12:34 -0500, Chris Metcalf wrote:
>> Using pr_info in a header exposes us to potential trouble from
>> subsystems that define pr_fmt.  This change fixes:
>>
>>   In file included from include/linux/scatterlist.h:10,
>>                    from include/scsi/scsi.h:12,
>>                    from drivers/infiniband/ulp/srp/ib_srp.c:46:
>>   arch/tile/include/asm/io.h: In function ‘ioport_map’:
>>   arch/tile/include/asm/io.h:296: error: expected ‘)’ before ‘PFX’
> Interesting.
>
>> diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
> []
>> @@ -292,7 +292,7 @@ static inline long ioport_panic(void)
>>  
>>  static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
>>  {
>> -	pr_info("ioport_map: mapping IO resources is unsupported on tile.\n");
>> +	printk("ioport_map: mapping IO resources is unsupported on tile.\n");
> It'd be nicer to add an appropriate KERN_<LEVEL> here.
>
> My preference would be to change ib_srp.c (and ib_srpt) like:
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index d5088ce..59bf409 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -30,7 +30,7 @@
>   * SOFTWARE.
>   */
>  
> -#define pr_fmt(fmt) PFX fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/module.h>
>  #include <linux/init.h>
>

Makes sense to me, and it does fix the compile failure.  I've pulled my original change from my tree and instead, for the change above (assuming Joe is implicitly providing a Signed-off-by on this patch):

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

