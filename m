Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaECPUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 11:20:17 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51840 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751404AbaECPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 11:20:15 -0400
Date: Sat, 3 May 2014 11:20:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: xiao jin <jin.xiao@intel.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yanmin.zhang@intel.com>,
        <juan.zou@intel.com>, <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] USB: ehci-hub: wait for RESUME finished when hub try to
 clear SUSPEND
In-Reply-To: <1399089145-21351-1-git-send-email-jin.xiao@intel.com>
Message-ID: <Pine.LNX.4.44L0.1405031107350.16021-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2014, xiao jin wrote:

> We use usb ehci to connect with modem and run stress test on ehci
> remote wake. Sometimes usb disconnect. We add more debug ftrace
> (Kernel version: 3.10) and list the key log to show how problem
> happened.
> 
> <idle>-0     [000] d.h2 26879.385095: ehci_irq: irq status 1008c PPCE FLR PCD
> <idle>-0     [000] d.h2 26879.385099: ehci_irq: rh_state[2] hcd->state[132] pstatus[0][238014c5] suspended_ports[1] reset_done[0]
> <...>-12873 [000] d..1 26879.393536: ehci_hub_control: GetStatus port:1 status 238014c5 17  ERR POWER sig=k SUSPEND RESUME PE CONNECT
> <...>-12873 [000] d..1 26879.393549: ehci_hub_control: typeReq [2301] wIndex[1] wValue[2]
> <...>-12873 [000] d..1 26879.393553: ehci_hub_control: [ehci_hub_control]line[891]  port[0] hostpc_reg [44000202]->[44000202]
> <idle>-0     [001] ..s. 26879.403122: ehci_hub_status_data: wgq[ehci_hub_status_data] ignore_oc[0] resuming_ports[1]
> <...>-12873 [000] d..1 26879.413379: ehci_hub_control: [ehci_hub_control]line[907]  port[0] write portsc_reg[238014c5] reset_done[2105769]
> <...>-12873 [000] d..1 26879.453173: ehci_hub_control: GetStatus port:1 status 23801885 17  ERR POWER sig=j SUSPEND PE CONNECT
> <...>-12873 [000] .... 26879.473158: check_port_resume_type: port 1 status 0000.0507 after resume, -19
> <...>-12873 [000] .... 26879.473160: usb_port_resume: status = -19 after check_port_resume_type
> <...>-12873 [000] .... 26879.473161: usb_port_resume: can't resume, status -19
> <...>-12873 [000] .... 26879.473162: hub_port_logical_disconnect: logical disconnect on port 1

This is a little difficult to understand...

> There is a in-band remote wakeup and controller run in k-state. Then kernel

What do you mean by "in-band"?

> driver(ClearPortFeature/USB_PORT_FEAT_SUSPEND) write RESUME|LS(k-state) bit
> into controller.

Why did it do that?  Did the kernel try to resume the port at the same 
time as the device issued a remote wakeup request?  In other words, was 
there a race between resume and remote wakeup?

>  It makes controller status weird.

Why?  Your log shows that the RESUME bit was already turned on, so
writing a 1 to it shouldn't make any difference.  (And the LS(k-state) 
bit is RO, so writing a 1 to it shouldn't matter.)

>  It's defined in EHCI
> controller spec(Revision 1.0), "If it has enabled remote wake-up, a K-state
> on the bus will turn the transceiver clock and generate an interrupt. The
> software will then have to wait 20 ms for the resume to complete and the
> port to go back to an active state."

Where in the spec did you find that quote?  It's not present in my copy
of the EHCI Rev 1.0 spec.

>  In this case Kernel should wait for
> the wakeup finished, then judge what should do next step.
> 
> We have some thought and give a patch. This patch is to wait for controller
> RESUME finished when hub try to clear port SUSPEND feature.
> 
> Signed-off-by: xiao jin <jin.xiao@intel.com>
> Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/host/ehci-hub.c  |    7 +++++++
>  include/linux/usb/ehci_def.h |    5 +++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 7ae0c4d..09a8b6b 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -935,6 +935,13 @@ static int ehci_hub_control (
>  				break;
>  			}
>  #endif
> +			if ((temp & PORT_RESUME)
> +				&& ((temp & PORT_LS_MASK) == PORT_K_STATE)) {
> +				ehci_handshake(ehci, status_reg,
> +					PORT_RESUME, 0, 20000 /* 20msec */);
> +				temp = ehci_readl(ehci, status_reg);
> +				temp &= ~PORT_RWC_BITS;
> +			}
>  			if (!(temp & PORT_SUSPEND))
>  				break;
>  			if ((temp & PORT_PE) == 0)
> diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
> index daec99a..0f0f919 100644
> --- a/include/linux/usb/ehci_def.h
> +++ b/include/linux/usb/ehci_def.h
> @@ -149,6 +149,11 @@ struct ehci_regs {
>  #define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
>  #define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
>  /* 11:10 for detecting lowspeed devices (reset vs release ownership) */
> +#define PORT_LS_MASK	(0x3<<10)	/* line status */
> +#define PORT_SE0_STATE	(0<<10)
> +#define PORT_K_STATE	(1<<10)
> +#define PORT_J_STATE	(2<<10)
> +#define PORT_UNDEFINED_STATE	(3<<10)
>  /* 9 reserved */
>  #define PORT_LPM	(1<<9)		/* LPM transaction */
>  #define PORT_RESET	(1<<8)		/* reset port */

This is definitely wrong.  For one thing, you mustn't have a 20-ms
delay with interrupts disabled.  For another, the spec states (Table
2-16, the entry for bits 11:10) that the Line Status value is valid
only when the port enable bit is 0, so you shouldn't rely on it.  
Lastly, there really is no need to do anything, because the remote
wakeup will finish all by itself.

Try the patch below instead.

Alan Stern



Index: usb-3.15/drivers/usb/host/ehci-hub.c
===================================================================
--- usb-3.15.orig/drivers/usb/host/ehci-hub.c
+++ usb-3.15/drivers/usb/host/ehci-hub.c
@@ -935,7 +935,8 @@ static int ehci_hub_control (
 				break;
 			}
 #endif
-			if (!(temp & PORT_SUSPEND))
+			/* Port not suspended, or remote wakeup in progress? */
+			if (!(temp & PORT_SUSPEND) || (temp & PORT_RESUME))
 				break;
 			if ((temp & PORT_PE) == 0)
 				goto error;

