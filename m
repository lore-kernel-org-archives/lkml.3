Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3I0Vtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:49:43 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62061 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3I0Vtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:49:41 -0400
Message-ID: <5245FD71.3080408@linaro.org>
Date: Fri, 27 Sep 2013 22:49:37 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, ian.campbell@citrix.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc-console: Make it work with HVM guests.
References: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 10:25 PM, Konrad Rzeszutek Wilk wrote:

> @@ -641,7 +641,20 @@ struct console xenboot_console = {
>
>   void xen_raw_console_write(const char *str)
>   {
> -	dom0_write_console(0, str, strlen(str));
> +	ssize_t len = strlen(str);
> +	int rc = 0;
> +
> +	if (xen_domain()) {
> +		dom0_write_console(0, str, len);
> +		if (rc == -ENOSYS && xen_hvm_domain())
> +			goto outb_print;
> +
> +	} else if (xen_cpuid_base()) {
> +		int i;
> +outb_print:
> +		for (i = 0; i < len; i++)
> +			outb(str[i], 0xe9);
> +	}
>   }

xen_cpuid_base and outb(0xe9) is x86 specific and won't compile on ARM.
You need to add ifdef around.

-- 
Julien Grall
