Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaCQV1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:27:37 -0400
Received: from canardo.mork.no ([148.122.252.1]:40494 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaCQV1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:27:35 -0400
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
	<87ob15maa6.fsf@nemi.mork.no>
	<CAC5Y2nN_w46FczgitbPjmXtk7q3rHpTxLddx0_GtStfzNXerXQ@mail.gmail.com>
Date: Mon, 17 Mar 2014 22:27:18 +0100
In-Reply-To: <CAC5Y2nN_w46FczgitbPjmXtk7q3rHpTxLddx0_GtStfzNXerXQ@mail.gmail.com>
	(Ben Chan's message of "Mon, 17 Mar 2014 12:11:52 -0700")
Message-ID: <87d2hkldmx.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Chan <benchan@chromium.org> writes:

> It's a bit messy how MTU is currently handled in MBIM. While wMTU may
> seem optional and redundant, it addresses some issues with
> wMaxSegmentSize and MBIM_CID_IP_CONFIGURATION, and hence why I suggest
> using wMTU when available:
>
> (1) wMaxSegmentSize
>
> The MBIM 1.0 errata-1 spec does suggest that wMaxSegmentSize must be
> at least 2048 and should not be used for determining IP MTU. However,
> some MBIM devices follow Microsoft's guideline, which suggests using
> wMaxSegmentSize to determine link MTU and its value should be between
> 1280 and 1500. The guideline may have been made before MBIM 1.0, but
> it clearly contradicts and violates the current spec. Unfortunately,
> it's followed by device vendors in practice. We could modify cdc_ncm
> not to have the lower bound (i.e. CDC_MBIM_MIN_DATAGRAM_SIZE = 2048)
> that it currently enforces. I don't feel like we should violate the
> spec in the driver if there are alternative solutions.
>
> (2) MBIM_CID_IP_CONFIGURATION
>
> MBIM_CID_IP_CONFIGURATION doesn't necessarily contain MTU information
> according to the spec. Bit 3 of IPv4ConfigurationAvailable /
> IPv6ConfigurationAvailable of MBIM_IP_CONFIGURATION_INFO indicates
> whether MTU information is available. As the Microsoft guideline also
> suggests that MBIM_CID_IP_CONFIGURATION wouldn't be used for MTU
> purpose, I wouldn't be too surprised that devices just don't bother to
> notify MTU via MBIM_CID_IP_CONFIGURATION.
>
> (3) wMTU
>
> The MBIM extended functional descriptor is optional, but device
> vendors do use it to indicate the MTU (mostly due to aforementioned
> confusion around wMaxSegmentSize). Using the wMTU field wouldn't add
> too much code or runtime overhead in kernel, so why don't we use it to
> set up the initial MTU when available? We could handle it in
> userspace, but I see the cdc_ncm driver is a better fit as it (like
> other net drivers) already sets up mtu and leaving the wMTU case would
> seem incomplete to me.
>
> While (1) and (2) are fixable, it's hard to convince device vendors to
> update their firmware just for that as carrier certifications impose a
> heavy cost of firmware changes.

This sounds all reasonable to me. Thanks for taking the time to explain
it in such detail. I did know that some vendors set wMaxSegmentSize too
low, but had no idea that vendors were using the extended descriptor
instead of MBIM_CID_IP_CONFIGURATION.

If so, then yes, it does make sense for the driver to base the default
MTU on this descriptor.

>> wMTU access needs le16_to_cpu.
>
> Good catch. I will fix it in patch v2.

Tip: I found this because my test script/makefile includes
"C=1 CF=-D__CHECK_ENDIAN__"

I find that very useful when dealing with USB on a little endian system,
like most of us have.  It's all too easy to miss a conversion otherwise.

>> Could we move this final MTU correction from cdc_ncm_setup to
>> cdc_ncm_bind_common to avoid bloating the device struct with another
>> descriptor pointer we donæt really need to keep around?
>>
>> I know we look into descriptors in cdc_ncm_setup, because we have to,
>> but ideally I would have loved to see cdc_ncm_setup dealing with *just*
>> the NCM/MBIM specific control setup messages and cdc_ncm_bind_common
>> dealing with all the functional descriptors.  That seems most logic to
>> me (but is of course only my personal opinion and nothing else - I do
>> not know what the original cdc_ncm author intended)
>>
>
> I understand the argument against the extra descriptor pointer. But I
> think it's better to keep the mtu related code together so that one
> can easily see how MTU is determined when trying to change or refactor
> the code. I haven't looked into what cdc_ncm_setup was originally
> intended for. If we'd like to avoid adding an extra pointer in
> cdc_ncm_ctx, we could have cdc_ncm_bind passing a locally scoped
> context to cdc_ncm_setup.

No, the extra pointer doesn't matter much. Just keep it as it is.


Bjørn
