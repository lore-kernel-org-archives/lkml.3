Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbaCQLec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:34:32 -0400
Received: from canardo.mork.no ([148.122.252.1]:33816 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915AbaCQLeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:34:05 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Chan <benchan@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Suarez <gsuarez@smithmicro.com>
Subject: Re: [PATCH 2/2] net: cdc_ncm: respect operator preferred MTU reported by MBIM
Organization: m
References: <1394952550-9308-1-git-send-email-benchan@chromium.org>
	<1394952550-9308-2-git-send-email-benchan@chromium.org>
Date: Mon, 17 Mar 2014 10:42:09 +0100
In-Reply-To: <1394952550-9308-2-git-send-email-benchan@chromium.org> (Ben
	Chan's message of "Sat, 15 Mar 2014 23:49:10 -0700")
Message-ID: <87ob15maa6.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this *really* driver material, or should we just leave the IP MTU
hint handling up to the userspace management application?

There are no less than 3(!) different ways for a device to specify the
MBIM MTU:

 1) wMaxSegmentSize field of the "MBIM Control Model Functional
      Descriptor"
      (mandatory, pre-errata1, per-device, both IP and DSS)

 2) IPv4Mtu/IPv6Mtu fields of the MBIM_IP_CONFIGURATION_INFO response to
      MBIM_CID_IP_CONFIGURATION
      (mandatory, pre-errata1, per-session, IP only)
 
 3) wMTU field of the "MBIM Extended Functional Descriptor"
      (optional, errata1, per-operator, IP only)

I see the optional extended MBIM descriptor as no more than a hint, and
given that MBIM_CID_IP_CONFIGURATION is mandatory I see no real use case
at all.

If the extended decriptor is there, and the application supports it,
then fine - let the application base the default IP MTU on this
value. But I cannot see anything possibly break for an application and
driver which does not support it.  The fact that the USB-IF didn't
bother to update the MBIM version number when they added this descriptor
supports that claim IMHO.  It tells us that it is perfectly OK for any
MBIM v1.0 compliant application/driver to not even parse this
descriptor, because the application/driver can predate Errata1.  The
descriptor was added out of the blue in something called an "Errata",
and is IMHO best ignored until a proper new version of the standard is
published.

The driver currently set the MTU based on the wMaxSegmentSize from the
mandatory MBIM descriptor.  AFAICS this is the only field the driver
*can* use.  The MBIM management application may make use of the extended
descriptor, because it will know about "operator" and the relation to
"IP data streams".  The driver does not have this knowledge, and it must
be capable of supporting non-IP streams (DSS) multiplexed over the same
network device.

AFAICS, the MTU information provided by the extended descriptor is
completely redundant for all cases where it has a meaning (the mandatory
MBIM_CID_IP_CONFIGURATION will provde the IPv4 and IPv6 per-session
MTUs), and possily completely wrong for any other case (wMaxSegmentSize
sets the maximum size for non-IP sessions)

My advice is to leave parsing of this descriptor to userspace.  That is
also the only place where we can make use of the
bMaxOutstandingCommandMessages, which actually is useful information. I
just don't understand why they had to make that part of a descriptor
when they have defined a new dedicated and extensible management
protocol....

In case you disagree with the above (and do feel free to do so... I am
often wrong), some minor nits regarding the actual implementation:


Ben Chan <benchan@chromium.org> writes:

> According to "Universal Serial Bus Communications Class Subclass
> Specification for Mobile Broadband Interface Model, Revision 1.0,
> Errata-1" published by USB-IF, the wMTU field of the MBIM extended
> functional descriptor indicates the operator preferred MTU for IP data
> streams.
>
> This patch modifies cdc_ncm_setup to ensure that the MTU value set on
> the usbnet device does not exceed the operator preferred MTU indicated
> by wMTU if the MBIM device exposes a MBIM extended functional
> descriptor.
>
> Signed-off-by: Ben Chan <benchan@chromium.org>
> ---
>  drivers/net/usb/cdc_ncm.c   | 15 +++++++++++++++
>  include/linux/usb/cdc_ncm.h |  1 +
>  2 files changed, 16 insertions(+)
>
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index dbff290..0b036ed 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -261,6 +261,13 @@ out:
>  	/* set MTU to max supported by the device if necessary */
>  	if (dev->net->mtu > ctx->max_datagram_size - eth_hlen)
>  		dev->net->mtu = ctx->max_datagram_size - eth_hlen;
> +
> +	/* do not exceed operater preferred MTU */
> +	if (ctx->mbim_extended_desc &&
> +		ctx->mbim_extended_desc->wMTU != 0 &&
> +		dev->net->mtu > ctx->mbim_extended_desc->wMTU)
> +		dev->net->mtu = ctx->mbim_extended_desc->wMTU;

wMTU access needs le16_to_cpu.

> +
>  	return 0;
>  }
>  
> @@ -399,6 +406,14 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
>  			ctx->mbim_desc = (const struct usb_cdc_mbim_desc *)buf;
>  			break;
>  
> +		case USB_CDC_MBIM_EXTENDED_TYPE:
> +			if (buf[0] < sizeof(*(ctx->mbim_extended_desc)))
> +				break;
> +
> +			ctx->mbim_extended_desc =
> +				(const struct usb_cdc_mbim_extended_desc *)buf;
> +			break;
> +
>  		default:
>  			break;
>  		}
> diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
> index c3fa807..bdf05fb 100644
> --- a/include/linux/usb/cdc_ncm.h
> +++ b/include/linux/usb/cdc_ncm.h
> @@ -93,6 +93,7 @@ struct cdc_ncm_ctx {
>  
>  	const struct usb_cdc_ncm_desc *func_desc;
>  	const struct usb_cdc_mbim_desc *mbim_desc;
> +	const struct usb_cdc_mbim_extended_desc *mbim_extended_desc;
>  	const struct usb_cdc_ether_desc *ether_desc;
>  
>  	struct usb_interface *control;


Could we move this final MTU correction from cdc_ncm_setup to
cdc_ncm_bind_common to avoid bloating the device struct with another
descriptor pointer we donæt really need to keep around?

I know we look into descriptors in cdc_ncm_setup, because we have to,
but ideally I would have loved to see cdc_ncm_setup dealing with *just*
the NCM/MBIM specific control setup messages and cdc_ncm_bind_common
dealing with all the functional descriptors.  That seems most logic to
me (but is of course only my personal opinion and nothing else - I do
not know what the original cdc_ncm author intended)


Bjørn
