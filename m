Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaC1QjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:39:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:37715 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaC1QjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,751,1389772800"; 
   d="scan'208";a="509772114"
Message-ID: <5335A824.2060204@linux.intel.com>
Date: Fri, 28 Mar 2014 18:49:40 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>,
        Mathias Nyman <mathias.nyman@intel.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
References: <1395772963-14127-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1395772963-14127-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 08:42 PM, Julius Werner wrote:
> The current XHCI driver recalculates the Context Entries field in the
> Slot Context on every add_endpoint() and drop_endpoint() call. In the
> case of drop_endpoint(), it seems to assume that the add_flags will
> always contain every endpoint for the new configuration, which is not
> necessarily correct if you don't make assumptions about how the USB core
> uses the add_endpoint/drop_endpoint interface (add_flags only contains
> endpoints that are new additions in the new configuration).
>
> Furthermore, EP0_FLAG is not consistently set in add_flags throughout
> the lifetime of a device. This means that when all endpoints are
> dropped, the Context Entries field can be set to 0 (which is invalid and
> may cause a Parameter Error) or -1 (which is interpreted as 31 and
> causes the driver to keep using the old, incorrect value).
>
> The only surefire way to set this field right is to also take all
> existing endpoints into account, and to force the value to 1 (meaning
> only EP0 is active) if no other endpoint is found. This patch implements
> that as a single step in the final check_bandwidth() call and removes
> the intermediary calculations from add_endpoint() and drop_endpoint().
>

Hi

I think this looks good in general, but before I really dig into it I'd 
like to know if this has triggered any problems so far? (e.g. slot 
context's context entries getting zeroed, or set to a smaller value than 
the last active endpoint context,  causing trouble)

-Mathias



