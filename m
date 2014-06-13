Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaFMNcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:32:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:16893 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaFMNcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:32:33 -0400
X-IronPort-AV: E=Sophos;i="5.01,471,1400025600"; 
   d="scan'208";a="143137048"
Message-ID: <539AFD6D.40204@citrix.com>
Date: Fri, 13 Jun 2014 14:32:29 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] xenpv: don't BUG when failing to setup NMI callback
References: <1402658788-24477-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1402658788-24477-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/14 12:26, Vitaly Kuznetsov wrote:
> 
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -593,8 +593,17 @@ void xen_enable_syscall(void)
>  void xen_enable_nmi(void)
>  {
>  #ifdef CONFIG_X86_64
> -	if (register_callback(CALLBACKTYPE_nmi, (char *)nmi))
> +	int ret;
> +
> +	ret = register_callback(CALLBACKTYPE_nmi, (char *)nmi);
> +	if (ret == -EINVAL) {
> +		/* Hypervisor probably forbids us to register NMI callback,
> +		   that is expected when running on top of Xen-3.1 and older */
> +		pr_warn("xen: failed to register NMI callback\n");
> +	} else if (ret != 0) {
> +		/* Other hypervisor failure */
>  		BUG();

I don't think we ever want to BUG() if this hypercall fails.  Just print
a warning.

David
