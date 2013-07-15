Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab3GOP1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:27:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28793 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab3GOP1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:27:51 -0400
Date: Mon, 15 Jul 2013 11:27:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Julien Grall <julien.grall@linaro.org>
Cc: stefano.stabellini@eu.citrix.com, ian.campbell@citrix.com,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH] xen/control: protect functions with
 CONFIG_HIBERNATE_CALLBACKS to avoid warning
Message-ID: <20130715152714.GD5774@phenom.dumpdata.com>
References: <1373898275-15765-1-git-send-email-julien.grall@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1373898275-15765-1-git-send-email-julien.grall@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:24:35PM +0100, Julien Grall wrote:
> If CONFIG_HIBERNATE_CALLBACKS is not set gcc will issue warnings:
> drivers/xen/manage.c:46:13: warning: 'xen_hvm_post_suspend' defined but not used [-Wunused-function]
> drivers/xen/manage.c:52:13: warning: 'xen_pre_suspend' defined but not used [-Wunused-function]
> drivers/xen/manage.c:59:13: warning: 'xen_post_suspend' defined but not used [-Wunused-function]

Have you checked the upstream kernel?
I see this:

commit 65e053a7038c608f89272d4fb1f899890c579f0a
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Thu Jun 27 14:28:38 2013 +0100

    xen: ifdef CONFIG_HIBERNATE_CALLBACKS xen_*_suspend
    
    xen_hvm_post_suspend, xen_pre_suspend, xen_post_suspend are only used if
    CONFIG_HIBERNATE_CALLBACKS is defined, resulting in:
    
    drivers/xen/manage.c:46:13: warning: ‘xen_hvm_post_suspend’ defined but not used [-Wunused-function]
    drivers/xen/manage.c:52:13: warning: ‘xen_pre_suspend’ defined but not used [-Wunused-function]
    drivers/xen/manage.c:59:13: warning: ‘xen_post_suspend’ defined but not used [-Wunused-function]
    
    If the kernel config is missing CONFIG_HIBERNATE_CALLBACKS.
    
    Simply ifdef CONFIG_HIBERNATE_CALLBACKS the three functions.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>
> ---
>  drivers/xen/manage.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 412b96c..7680276 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -36,6 +36,7 @@ enum shutdown_state {
>  /* Ignore multiple shutdown requests. */
>  static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
>  
> +#ifdef CONFIG_HIBERNATE_CALLBACKS
>  struct suspend_info {
>  	int cancelled;
>  	unsigned long arg; /* extra hypercall argument */
> @@ -63,7 +64,6 @@ static void xen_post_suspend(int cancelled)
>  	xen_mm_unpin_all();
>  }
>  
> -#ifdef CONFIG_HIBERNATE_CALLBACKS
>  static int xen_suspend(void *data)
>  {
>  	struct suspend_info *si = data;
> -- 
> 1.7.10.4
> 
