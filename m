Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaJNLT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:19:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38516 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaJNLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:19:56 -0400
Date: Tue, 14 Oct 2014 14:19:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014111915.GV23154@mwanda>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a couple small style nits.

On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 3b9c9ef..1d8390c 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -51,11 +51,30 @@
>  #define HB_WS2008_MAJOR	1
>  #define HB_WS2008_VERSION	(HB_WS2008_MAJOR << 16 | HB_MINOR)
>  
> +#define  TIMESAMPLE_INTERVAL 5000000000L  /* 5s in nanosecond */

If you wanted you could say:

#define  TIMESAMPLE_INTERVAL  (5 * NSEC_PER_SEC)

> +
> +/*host sends time sample for every 5s.So the max polling interval
> + *is 128*5 = 640s.
> +*/

The comment still has problems throughout.  Read
Documentation/CodingStyle.

> +#define  TIME_ADJ_MAX_INTERVAL 128 /*Max polling interval */
> +
>  static int sd_srv_version;
>  static int ts_srv_version;
>  static int hb_srv_version;
>  static int util_fw_version;
>  
> +/*host sends time sample for every 5s.So the initial polling interval
> + *is 5s.
> +*/
> +static s32 adj_interval = 1;

Prefer mundane types instead there is a reason.  This should be int
because it's not specified in a hardware spec.  I know you are being
consistent with the surrounding code, but the surrounding code is bad so
don't emulate it.

> +
> +/*The host_time_sync module parameter is used to control the time
> +  sync between host and guest.
> +*/
> +static bool host_time_sync;
> +module_param(host_time_sync, bool, (S_IRUGO | S_IWUSR));
> +MODULE_PARM_DESC(host_time_sync, "If the guest sync time with host");

Maybe say: "Synchronize time with the host"?

> +
>  static void shutdown_onchannelcallback(void *context);
>  static struct hv_util_service util_shutdown = {
>  	.util_cb = shutdown_onchannelcallback,
> @@ -163,15 +182,61 @@ static void shutdown_onchannelcallback(void *context)
>  /*
>   * Set guest time to host UTC time.
>   */
> -static inline void do_adj_guesttime(u64 hosttime)
> +static inline void do_adj_guesttime(u64 hosttime, bool forceSync)

I'm surprise checkpatch.pl does't complain about this CamelCase.

regards,
dan carpenter

