Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3BTUjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:39:20 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35826 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934521Ab3BTUjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:39:17 -0500
Message-ID: <1361389581.29360.14.camel@falcor1>
Subject: Re: [PATCH -next] security/integrity/ima: make part_pack_uuid()
 always visible
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        axboe@kernel.dk
Date: Wed, 20 Feb 2013 14:46:21 -0500
In-Reply-To: <51252454.1050609@infradead.org>
References: <20130219170309.efb90173fcd879bf32a7e89b@canb.auug.org.au>
	 <512418A5.9010006@infradead.org> <1361379050.29360.12.camel@falcor1>
	 <51252454.1050609@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022020-7182-0000-0000-00000564DC06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 11:30 -0800, Randy Dunlap wrote:
> On 02/20/13 08:50, Mimi Zohar wrote:
> > On Tue, 2013-02-19 at 16:28 -0800, Randy Dunlap wrote:
> >> On 02/18/13 22:03, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20130218:
> >>>
> >>
> >> on x86_64:
> >>
> >>   CC      security/integrity/ima/ima_policy.o
> >> security/integrity/ima/ima_policy.c: In function 'ima_parse_rule':
> >> security/integrity/ima/ima_policy.c:538:4: error: implicit declaration of function 'part_pack_uuid' [-Werror=implicit-function-declaration]
> >> cc1: some warnings being treated as errors
> >> make[4]: *** [security/integrity/ima/ima_policy.o] Error 1
> >>
> >>
> >> Full randconfig file is attached.
> > 
> > part_pack_uuid() is only defined for CONFIG_BLOCK in
> > include/linux/genhd.h.  One solution would be to add a stub function
> > definition in include/linux/genhd.h, the other option would be to ifndef
> > CONFIG_BLOCK in C code.
> 
> ITYM #ifdef CONFIG_BLOCK to call part_pack_uuid().
> Yes, either of those would work.
> How about a third option -- just make part_pack_uuid() always visible
> and not just a stub?  Patch is below.

That works too.

Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

thanks,

Mimi

> ---
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build error when CONFIG_BLOCK is not enabled
> by making the static inline function part_pack_uuid()
> visible independent of CONFIG_BLOCK's setting.
> 
> security/integrity/ima/ima_policy.c:538:4: error: implicit declaration of function 'part_pack_uuid' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Mimi Zohar <zohar@us.ibm.com>
> ---
>  include/linux/genhd.h |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> --- linux-next-20130220.orig/include/linux/genhd.h
> +++ linux-next-20130220/include/linux/genhd.h
> @@ -213,24 +213,6 @@ static inline struct gendisk *part_to_di
>  	return NULL;
>  }
> 
> -static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	int i;
> -	for (i = 0; i < 16; ++i) {
> -		*to++ = (hex_to_bin(*uuid_str) << 4) |
> -			(hex_to_bin(*(uuid_str + 1)));
> -		uuid_str += 2;
> -		switch (i) {
> -		case 3:
> -		case 5:
> -		case 7:
> -		case 9:
> -			uuid_str++;
> -			continue;
> -		}
> -	}
> -}
> -
>  static inline int disk_max_parts(struct gendisk *disk)
>  {
>  	if (disk->flags & GENHD_FL_EXT_DEVT)
> @@ -720,4 +702,22 @@ static inline dev_t blk_lookup_devt(cons
> 
>  #endif /* CONFIG_BLOCK */
> 
> +static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
> +{
> +	int i;
> +	for (i = 0; i < 16; ++i) {
> +		*to++ = (hex_to_bin(*uuid_str) << 4) |
> +			(hex_to_bin(*(uuid_str + 1)));
> +		uuid_str += 2;
> +		switch (i) {
> +		case 3:
> +		case 5:
> +		case 7:
> +		case 9:
> +			uuid_str++;
> +			continue;
> +		}
> +	}
> +}
> +
>  #endif /* _LINUX_GENHD_H */
> 



