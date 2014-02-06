Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaBFV1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:27:38 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64501 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbaBFV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:27:37 -0500
Message-ID: <1391722055.22187.7.camel@x220>
Subject: Re: [PATCH 3.13 054/140] mei: use hbm idle state to prevent
 spurious resets
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Date: Thu, 06 Feb 2014 22:27:35 +0100
In-Reply-To: <20140204211038.509274283@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
	 <20140204211038.509274283@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2014 21:27:35.0492 (UTC) FILETIME=[40AE5040:01CF2382]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 13:10 -0800, Greg Kroah-Hartman wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> commit 66ae460b13c31a176b41550259683c841a62af3e upstream.
> 
> When reset is caused by hbm protocol mismatch or timeout
> we might end up in an endless reset loop and hbm protocol
> will never sync
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/misc/mei/hbm.c       |   19 +++++++++++++++++++
>  drivers/misc/mei/hbm.h       |    1 +
>  drivers/misc/mei/init.c      |   12 ++++++++----
>  drivers/misc/mei/interrupt.c |   25 +++++++++++++++----------
>  4 files changed, 43 insertions(+), 14 deletions(-)
> 
> --- a/drivers/misc/mei/hbm.c
> +++ b/drivers/misc/mei/hbm.c
> [...]
> @@ -577,6 +588,14 @@ void mei_hbm_dispatch(struct mei_device
>  	mei_read_slots(dev, dev->rd_msg_buf, hdr->length);
>  	mei_msg = (struct mei_bus_message *)dev->rd_msg_buf;
>  
> +	/* ignore spurious message and prevent reset nesting
> +	 * hbm is put to idle during system reset
> +	 */
> +	if (dev->hbm_state == MEI_HBM_IDLE) {
> +		dev_dbg(&dev->pdev->dev, "hbm: state is idle ignore spurious messages\n");
> +		return 0;
> +	}
> +
>  	switch (mei_msg->hbm_cmd) {
>  	case HOST_START_RES_CMD:
>  		version_res = (struct hbm_host_version_response *)mei_msg;

This chunk triggers this, obviously correct, warning:
    drivers/misc/mei/hbm.c: In function 'mei_hbm_dispatch':
    drivers/misc/mei/hbm.c:596:3: warning: 'return' with a value, in function returning void [enabled by default
       return 0;
       ^

I know that v3.13.2 has just been released. Would it be worth the
trouble to submit a clean up patch (v3.13 specific, as in v3.14-rc1 this
function returns int)?


Paul Bolle

