Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663Ab3IDN57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:57:59 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:64869 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3IDN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:57:57 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJwKkjb5r7Rwb0vUtI=
X-RZG-CLASS-ID: mo00
Date: Wed, 4 Sep 2013 15:57:54 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Message-ID: <20130904135754.GA2010@aepfle.de>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1372786290-12641-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, K. Y. Srinivasan wrote:

> The current code picked the highest version advertised by the host. WS2012 R2
> has implemented a protocol version for KVP that is not compatible with prior
> protocol versions of KVP. Fix the bug in the current code by explicitly specifying
> the protocol version that the guest can support.

> -void vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
> +bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
>  				struct icmsg_negotiate *negop, u8 *buf,
> -				int max_fw_version, int max_srv_version)
> +				int fw_version, int srv_version)

> +fw_error:
> +	if (!found_match) {
> +		negop->icframe_vercnt = 0;
> +		negop->icmsg_vercnt = 0;
> +	} else {
> +		negop->icframe_vercnt = 1;
> +		negop->icmsg_vercnt = 1;
> +	}
> +
> +	negop->icversion_data[0].major = icframe_major;
> +	negop->icversion_data[0].minor = icframe_minor;
> +	negop->icversion_data[1].major = icmsg_major;
> +	negop->icversion_data[1].minor = icmsg_minor;
> +	return found_match;
>  }

The new vmbus_prep_negotiate_resp function modifies the *negop buffer if
no match is found. If called twice from hv_kvp_onchannelcallback, the
second call uses the modified buffer from the the first call. As a
result the matching will fail for both calls. If I leave the buffer
alone, kvp works again on ws2008.

I suggest to let callers deal with error handling. Also as a cleanup,
vmbus_prep_negotiate_resp does not make use of the negop passed to it.
So that arg can be removed.


Olaf
