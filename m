Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaCQTMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:12:16 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:62519 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaCQTMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <87ob15maa6.fsf@nemi.mork.no>
References: <1394952550-9308-1-git-send-email-benchan@chromium.org>
 <1394952550-9308-2-git-send-email-benchan@chromium.org> <87ob15maa6.fsf@nemi.mork.no>
From: Ben Chan <benchan@chromium.org>
Date: Mon, 17 Mar 2014 12:11:52 -0700
X-Google-Sender-Auth: fsqgwYmJ1kxCJ4Nb3DwFyvja48g
Message-ID: <CAC5Y2nN_w46FczgitbPjmXtk7q3rHpTxLddx0_GtStfzNXerXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: cdc_ncm: respect operator preferred MTU reported
 by MBIM
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Suarez <gsuarez@smithmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 2:42 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Is this *really* driver material, or should we just leave the IP MTU
> hint handling up to the userspace management application?
>
> There are no less than 3(!) different ways for a device to specify the
> MBIM MTU:
>
>  1) wMaxSegmentSize field of the "MBIM Control Model Functional
>       Descriptor"
>       (mandatory, pre-errata1, per-device, both IP and DSS)
>
>  2) IPv4Mtu/IPv6Mtu fields of the MBIM_IP_CONFIGURATION_INFO response to
>       MBIM_CID_IP_CONFIGURATION
>       (mandatory, pre-errata1, per-session, IP only)
>
>  3) wMTU field of the "MBIM Extended Functional Descriptor"
>       (optional, errata1, per-operator, IP only)
>
> I see the optional extended MBIM descriptor as no more than a hint, and
> given that MBIM_CID_IP_CONFIGURATION is mandatory I see no real use case
> at all.
>
> If the extended decriptor is there, and the application supports it,
> then fine - let the application base the default IP MTU on this
> value. But I cannot see anything possibly break for an application and
> driver which does not support it.  The fact that the USB-IF didn't
> bother to update the MBIM version number when they added this descriptor
> supports that claim IMHO.  It tells us that it is perfectly OK for any
> MBIM v1.0 compliant application/driver to not even parse this
> descriptor, because the application/driver can predate Errata1.  The
> descriptor was added out of the blue in something called an "Errata",
> and is IMHO best ignored until a proper new version of the standard is
> published.
>
> The driver currently set the MTU based on the wMaxSegmentSize from the
> mandatory MBIM descriptor.  AFAICS this is the only field the driver
> *can* use.  The MBIM management application may make use of the extended
> descriptor, because it will know about "operator" and the relation to
> "IP data streams".  The driver does not have this knowledge, and it must
> be capable of supporting non-IP streams (DSS) multiplexed over the same
> network device.
>
> AFAICS, the MTU information provided by the extended descriptor is
> completely redundant for all cases where it has a meaning (the mandatory
> MBIM_CID_IP_CONFIGURATION will provde the IPv4 and IPv6 per-session
> MTUs), and possily completely wrong for any other case (wMaxSegmentSize
> sets the maximum size for non-IP sessions)
>
> My advice is to leave parsing of this descriptor to userspace.  That is
> also the only place where we can make use of the
> bMaxOutstandingCommandMessages, which actually is useful information. I
> just don't understand why they had to make that part of a descriptor
> when they have defined a new dedicated and extensible management
> protocol....
>
> In case you disagree with the above (and do feel free to do so... I am
> often wrong), some minor nits regarding the actual implementation:
>

It's a bit messy how MTU is currently handled in MBIM. While wMTU may
seem optional and redundant, it addresses some issues with
wMaxSegmentSize and MBIM_CID_IP_CONFIGURATION, and hence why I suggest
using wMTU when available:

(1) wMaxSegmentSize

The MBIM 1.0 errata-1 spec does suggest that wMaxSegmentSize must be
at least 2048 and should not be used for determining IP MTU. However,
some MBIM devices follow Microsoft's guideline, which suggests using
wMaxSegmentSize to determine link MTU and its value should be between
1280 and 1500. The guideline may have been made before MBIM 1.0, but
it clearly contradicts and violates the current spec. Unfortunately,
it's followed by device vendors in practice. We could modify cdc_ncm
not to have the lower bound (i.e. CDC_MBIM_MIN_DATAGRAM_SIZE = 2048)
that it currently enforces. I don't feel like we should violate the
spec in the driver if there are alternative solutions.

(2) MBIM_CID_IP_CONFIGURATION

MBIM_CID_IP_CONFIGURATION doesn't necessarily contain MTU information
according to the spec. Bit 3 of IPv4ConfigurationAvailable /
IPv6ConfigurationAvailable of MBIM_IP_CONFIGURATION_INFO indicates
whether MTU information is available. As the Microsoft guideline also
suggests that MBIM_CID_IP_CONFIGURATION wouldn't be used for MTU
purpose, I wouldn't be too surprised that devices just don't bother to
notify MTU via MBIM_CID_IP_CONFIGURATION.

(3) wMTU

The MBIM extended functional descriptor is optional, but device
vendors do use it to indicate the MTU (mostly due to aforementioned
confusion around wMaxSegmentSize). Using the wMTU field wouldn't add
too much code or runtime overhead in kernel, so why don't we use it to
set up the initial MTU when available? We could handle it in
userspace, but I see the cdc_ncm driver is a better fit as it (like
other net drivers) already sets up mtu and leaving the wMTU case would
seem incomplete to me.

While (1) and (2) are fixable, it's hard to convince device vendors to
update their firmware just for that as carrier certifications impose a
heavy cost of firmware changes.


> wMTU access needs le16_to_cpu.

Good catch. I will fix it in patch v2.

>
> Could we move this final MTU correction from cdc_ncm_setup to
> cdc_ncm_bind_common to avoid bloating the device struct with another
> descriptor pointer we donæt really need to keep around?
>
> I know we look into descriptors in cdc_ncm_setup, because we have to,
> but ideally I would have loved to see cdc_ncm_setup dealing with *just*
> the NCM/MBIM specific control setup messages and cdc_ncm_bind_common
> dealing with all the functional descriptors.  That seems most logic to
> me (but is of course only my personal opinion and nothing else - I do
> not know what the original cdc_ncm author intended)
>

I understand the argument against the extra descriptor pointer. But I
think it's better to keep the mtu related code together so that one
can easily see how MTU is determined when trying to change or refactor
the code. I haven't looked into what cdc_ncm_setup was originally
intended for. If we'd like to avoid adding an extra pointer in
cdc_ncm_ctx, we could have cdc_ncm_bind passing a locally scoped
context to cdc_ncm_setup.

Thanks,
Ben
