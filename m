Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbaCDLmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:42:25 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:55108
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977AbaCDLmY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:42:24 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzc89bhe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch1155h)
X-WSS-ID: 0N1WTUG-07-H0J-02
X-M-MSG: 
Message-ID: <5315BC15.2050003@amd.com>
Date: Tue, 4 Mar 2014 12:42:13 +0100
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drm/radeon: silence GCC warning on 32 bit
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>	 <1391085212.5170.9.camel@x41> <1392930177.15264.5.camel@x220>	 <CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>	 <1392931493.15264.17.camel@x220> <20140221082021.GG22574@ulmo.nvidia.com> <1393925688.3038.22.camel@x220>
In-Reply-To: <1393925688.3038.22.camel@x220>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.03.2014 10:34, schrieb Paul Bolle:
> Building radeon_ttm.o on 32 bit x86 triggers a warning:
>      In file included from include/asm-generic/bug.h:13:0,
>                       from [...]/arch/x86/include/asm/bug.h:38,
>                       from include/linux/bug.h:4,
>                       from include/drm/drm_mm.h:39,
>                       from include/drm/drm_vma_manager.h:26,
>                       from include/drm/ttm/ttm_bo_api.h:35,
>                       from drivers/gpu/drm/radeon/radeon_ttm.c:32:
>      drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_gtt_read':
>      include/linux/kernel.h:712:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>        (void) (&_min1 == &_min2);  \
>                       ^
>      drivers/gpu/drm/radeon/radeon_ttm.c:938:22: note: in expansion of macro 'min'
>         ssize_t cur_size = min(size, PAGE_SIZE - off);
>                            ^
>
> Silence this warning by using min_t(). Since cur_size will never be
> negative and its upper bound is PAGE_SIZE, we can change its type to
> size_t and use min_t(size_t, [...]) here.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
> v2: use min_t() as Ilia suggested, and convert cur_size to size_t, as
> Thierry suggested.
>
> Still compile tested only (on 32 and 64 bit x86).
>
>   drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
> index 77f5b0c..1ce6ba6 100644
> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
> @@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
>   	while (size) {
>   		loff_t p = *pos / PAGE_SIZE;
>   		unsigned off = *pos & ~PAGE_MASK;
> -		ssize_t cur_size = min(size, PAGE_SIZE - off);
> +		size_t cur_size = min_t(size_t, size, PAGE_SIZE - off);
>   		struct page *page;
>   		void *ptr;
>   


