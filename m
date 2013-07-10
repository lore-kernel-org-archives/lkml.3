Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3GJSdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:33:39 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:59381 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755083Ab3GJSdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:33:37 -0400
X-TM-IMSS-Message-ID: <2948f8af000c2c44@nsa.gov>
Message-ID: <51DDA8E0.4030001@tycho.nsa.gov>
Date: Wed, 10 Jul 2013 14:33:04 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 2/2] SELinux: Increase ebitmap_node size for 64-bit
 configuration
References: <1370466902-21144-1-git-send-email-Waiman.Long@hp.com> <1370466902-21144-2-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1370466902-21144-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 05:15 PM, Waiman Long wrote:
> Currently, the ebitmap_node structure has a fixed size of 32 bytes. On
> a 32-bit system, the overhead is 8 bytes, leaving 24 bytes for being
> used as bitmaps. The overhead ratio is 1/4.
>
> On a 64-bit system, the overhead is 16 bytes. Therefore, only 16 bytes
> are left for bitmap purpose and the overhead ratio is 1/2. With a
> 3.8.2 kernel, a boot-up operation will cause the ebitmap_get_bit()
> function to be called about 9 million times. The average number of
> ebitmap_node traversal is about 3.7.
>
> This patch increases the size of the ebitmap_node structure to 64
> bytes for 64-bit system to keep the overhead ratio at 1/4. This may
> also improve performance a little bit by making node to node traversal
> less frequent (< 2) as more bits are available in each node.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>   security/selinux/ss/ebitmap.h |    8 +++++++-
>   1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/security/selinux/ss/ebitmap.h b/security/selinux/ss/ebitmap.h
> index e7eb3a9..712c8a7 100644
> --- a/security/selinux/ss/ebitmap.h
> +++ b/security/selinux/ss/ebitmap.h
> @@ -16,7 +16,13 @@
>
>   #include <net/netlabel.h>
>
> -#define EBITMAP_UNIT_NUMS	((32 - sizeof(void *) - sizeof(u32))	\
> +#ifdef CONFIG_64BIT
> +#define	EBITMAP_NODE_SIZE	64
> +#else
> +#define	EBITMAP_NODE_SIZE	32
> +#endif
> +
> +#define EBITMAP_UNIT_NUMS	((EBITMAP_NODE_SIZE-sizeof(void *)-sizeof(u32))\
>   					/ sizeof(unsigned long))
>   #define EBITMAP_UNIT_SIZE	BITS_PER_LONG
>   #define EBITMAP_SIZE		(EBITMAP_UNIT_NUMS * EBITMAP_UNIT_SIZE)
>

