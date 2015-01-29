Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbbA2Nb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:31:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177AbbA2NbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:31:17 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH 2/3] hv: vmbus_post_msg: retry the hypercall on HV_STATUS_INVALID_CONNECTION_ID
References: <1422529361-28228-1-git-send-email-decui@microsoft.com>
Date: Thu, 29 Jan 2015 14:30:57 +0100
In-Reply-To: <1422529361-28228-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Thu, 29 Jan 2015 03:02:41 -0800")
Message-ID: <87bnlh7lym.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> I got the hypercall error code on Hyper-V 2008 R2 when keeping running
> "rmmod hv_netvsc; modprobe hv_netvsc; rmmod hv_utils; modprobe hv_utils"
> in a Linux guest.
>
> Without the patch, the driver can occasionally fail to load.
>
> CC: "K. Y. Srinivasan" <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  arch/x86/include/uapi/asm/hyperv.h | 1 +
>  drivers/hv/connection.c            | 9 +++++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/hyperv.h b/arch/x86/include/uapi/asm/hyperv.h
> index 90c458e..b9daffb 100644
> --- a/arch/x86/include/uapi/asm/hyperv.h
> +++ b/arch/x86/include/uapi/asm/hyperv.h
> @@ -225,6 +225,7 @@
>  #define HV_STATUS_INVALID_HYPERCALL_CODE	2
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>  #define HV_STATUS_INVALID_ALIGNMENT		4
> +#define HV_STATUS_INVALID_CONNECTION_ID		18
>  #define HV_STATUS_INSUFFICIENT_BUFFERS		19

The gap beween 4 and 18 tells me there are other codes here ;-) Are they
all 'permanent failures'?

>
>  typedef struct _HV_REFERENCE_TSC_PAGE {
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index c4acd1c..8bd05f3 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -440,6 +440,15 @@ int vmbus_post_msg(void *buffer, size_t buflen)
>  		ret = hv_post_message(conn_id, 1, buffer, buflen);
>
>  		switch (ret) {
> +		case HV_STATUS_INVALID_CONNECTION_ID:
> +			/*
> +			 * We could get this if we send messages too
> +			 * frequently or the host is under low resource
> +			 * conditions: let's wait 1 more second before
> +			 * retrying the hypercall.
> +			 */
> +			msleep(1000);
> +			break;

In case it is our last try (No. 10) we will return '18' from the
function. I suggest we set ret = -ENOMEM here as well.

>  		case HV_STATUS_INSUFFICIENT_BUFFERS:
>  			ret = -ENOMEM;

Or should we treat these two equally? There is a smaller (100ms) sleep
between tries already, we can consider changing it instead.

>  		case -ENOMEM:

-- 
  Vitaly
