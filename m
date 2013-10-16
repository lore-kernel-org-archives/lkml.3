Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761216Ab3JPX5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:57:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:34450 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3JPX5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,509,1378882800"; 
   d="scan'208";a="420302738"
Date: Wed, 16 Oct 2013 16:57:30 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH v2] usb: hub: Clear Port Reset Change during init/resume
Message-ID: <20131016235730.GK7082@xanatos>
References: <1381872227-24757-1-git-send-email-jwerner@chromium.org>
 <525DB456.1040006@cogentembedded.com>
 <CAODwPW-wKtN9JhoJCs+LoBx4Pj65+pozKv=ycLQJfsL1k28zEQ@mail.gmail.com>
 <1381884300-403-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381884300-403-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 05:45:00PM -0700, Julius Werner wrote:
> This patch adds the Port Reset Change flag to the set of bits that are
> preemptively cleared on init/resume of a hub. In theory this bit should
> never be set unexpectedly... in practice it can still happen if BIOS,
> SMM or ACPI code plays around with USB devices without cleaning up
> correctly. This is especially dangerous for XHCI root hubs, which don't
> generate any more Port Status Change Events until all change bits are
> cleared, so this is a good precaution to have (similar to how it's
> already done for the Warm Port Reset Change flag).

Did you run into an issue where port status change events weren't being
generated because the Port Reset flag was set?  I'm trying to figure out
if this addresses a real issue you hit (and thus should be queued for
stable), or if this is just a precaution.

I do agree this is a good fix.  ISTR that with some xHCI vendors, when
the host is reset, the hardware will drive a port reset down all ports.
That may cause the port reset and even warm port reset bits to be set.
I have a vague recollection that some implementations might not even
wait for the port reset to complete before saying the reset is done.  We
can't tell which hosts will and won't drive a reset, so we rely on the
USB core to clear those bits if they are set.

So perhaps instead of the BIOS/SMM/ACPI code leaving the ports in an
unclean state, the root cause of your issue is actually the call to
xhci_reset?  You can check the port status before that call to find out.

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/core/hub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index e6b682c..c3dd64c 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1130,6 +1130,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>  			usb_clear_port_feature(hub->hdev, port1,
>  					USB_PORT_FEAT_C_ENABLE);
>  		}
> +		if (portchange & USB_PORT_STAT_C_RESET) {
> +			need_debounce_delay = true;
> +			usb_clear_port_feature(hub->hdev, port1,
> +					USB_PORT_FEAT_C_RESET);
> +		}
>  		if ((portchange & USB_PORT_STAT_C_BH_RESET) &&
>  				hub_is_superspeed(hub->hdev)) {
>  			need_debounce_delay = true;
> -- 
> 1.7.12.4
> 
