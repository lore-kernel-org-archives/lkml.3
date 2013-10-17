Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3JQMNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:13:01 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52736 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754603Ab3JQMNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:13:00 -0400
Date: Thu, 17 Oct 2013 13:12:28 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Majunath Goudar <csmanjuvijay@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Majunath Goudar <manju.goudar@lge.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>, nataraja.km@lge.com
Subject: Re: [PATCH] ARM: CCI : Fix implicit declaration of function error
Message-ID: <20131017121227.GC2442@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 03:52:27PM +0530, Majunath Goudar wrote:
> This patch adds a inline dummy implementations of_find_matching_node()
> in "#ifdef CONFIG_OF" else part. Without this patch,build system can
> lead to issues. This was discovered during randconfig testing,in which
> ARM_CCI was enabled w/o CONFIG_OF being enabled,leading to the following error:

Without fetching config info from the DT, the CCI driver is not usable,
so it makes no sense to build this driver without CONFIG_OF.

Your previous patch [1] looked sensible, but I don't see any responses
on lakml.  Are you still pursuing that patch, or is this patch intended
as a replacement?


Dummy functions for things like of_find_matching_node() might be useful
for drivers that can fall back to other config mechanisms if OF is
unavailable, but that is a separate discussion.

arm-cci is not such a driver, and any such drivers that exist toady
must be coping without the dummy OF functions.

Cheers
---Dave

[1]  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/202996.html
([PATCH] BUS: CCI : Fix arm-cci implicit declarations dependence errors.)

> 
> CC      drivers/bus/arm-cci.o
> drivers/bus/arm-cci.c: In function ‘cci_probe’:
> drivers/bus/arm-cci.c:971:2: error: implicit declaration of function
> ‘of_find_matching_node’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/bus/arm-cci.o] Error 1
> make[1]: *** [drivers/bus] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Manjunath Goudar <manju.goudar@lge.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/of.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index f95aee3..2c57aa2 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -340,6 +340,13 @@ int of_device_is_stdout_path(struct device_node *dn);
>  
>  #else /* CONFIG_OF */
>  
> +static inline struct device_node *of_find_matching_node(
> +	struct device_node *from,
> +	const struct of_device_id *matches)
> +{
> +	return NULL;
> +}
> +
>  static inline const char* of_node_full_name(struct device_node *np)
>  {
>  	return "<no-node>";
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
