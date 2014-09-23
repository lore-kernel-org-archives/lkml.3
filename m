Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaIWQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:31:11 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58488 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaIWQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:31:09 -0400
Message-ID: <5421A045.5020804@samsung.com>
Date: Wed, 24 Sep 2014 01:31:01 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>, acourbot@nvidia.com,
        tomeu@tomeuvizoso.net, Olof Johansson <olof@lixom.net>,
        swarren@nvidia.com, drake@endlessm.com,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 1/5] ARM: firmware: Introduce suspend and resume operations
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com> <1409062228-14690-2-git-send-email-t.figa@samsung.com>
In-Reply-To: <1409062228-14690-2-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 23:10, Tomasz Figa wrote:
> This patch extends the firmware_ops structure with two new callbacks:
> .suspend() and .resume(). The former is intended to ask the firmware to
> save all its volatile state and suspend the system, without returning
> back to the kernel in between. The latter is to be called early by
> very low level platform suspend code after waking up to restore low
> level hardware state, which can't be restored in non-secure mode.
>
> While at it, outdated version of the structure is removed from the
> documentation and replaced with a reference to the header file.
>
> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
> Acked-by: Alexandre Courbot<acourbot@nvidia.com>
> ---
>   Documentation/arm/firmware.txt  | 28 +++++-----------------------
>   arch/arm/include/asm/firmware.h |  8 ++++++++
>   2 files changed, 13 insertions(+), 23 deletions(-)
>
> diff --git a/Documentation/arm/firmware.txt b/Documentation/arm/firmware.txt
> index c2e468f..da6713a 100644
> --- a/Documentation/arm/firmware.txt
> +++ b/Documentation/arm/firmware.txt
> @@ -7,32 +7,14 @@ world, which changes the way some things have to be initialized. This makes
>   a need to provide an interface for such platforms to specify available firmware
>   operations and call them when needed.
>
> -Firmware operations can be specified using struct firmware_ops
> -
> -	struct firmware_ops {
> -		/*
> -		* Enters CPU idle mode
> -		*/
> -		int (*do_idle)(void);
> -		/*
> -		* Sets boot address of specified physical CPU
> -		*/
> -		int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);
> -		/*
> -		* Boots specified physical CPU
> -		*/
> -		int (*cpu_boot)(int cpu);
> -		/*
> -		* Initializes L2 cache
> -		*/
> -		int (*l2x0_init)(void);
> -	};
> -
> -and then registered with register_firmware_ops function
> +Firmware operations can be specified by filling in a struct firmware_ops
> +with appropriate callbacks and then registering it with register_firmware_ops()
> +function.
>
>   	void register_firmware_ops(const struct firmware_ops *ops)
>
> -the ops pointer must be non-NULL.
> +The ops pointer must be non-NULL. More information about struct firmware_ops
> +and its members can be found in arch/arm/include/asm/firmware.h header.
>
>   There is a default, empty set of operations provided, so there is no need to
>   set anything if platform does not require firmware operations.
> diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
> index 2c9f10d..5904f59 100644
> --- a/arch/arm/include/asm/firmware.h
> +++ b/arch/arm/include/asm/firmware.h
> @@ -41,6 +41,14 @@ struct firmware_ops {
>   	 * Initializes L2 cache
>   	 */
>   	int (*l2x0_init)(void);
> +	/*
> +	 * Enter system-wide suspend.
> +	 */
> +	int (*suspend)(void);
> +	/*
> +	 * Restore state of privileged hardware after system-wide suspend.
> +	 */
> +	int (*resume)(void);
>   };
>
>   /* Global pointer for current firmware_ops structure, can't be NULL. */

Hi Russell,

I've applied this in samsung tree for exynos stuff, if you have any 
objection, please kindly let me know.

Thanks,
Kukjin
