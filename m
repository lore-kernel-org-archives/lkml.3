Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3HFX1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:27:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:9649 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3HFX1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:27:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,828,1367996400"; 
   d="scan'208";a="278620939"
Message-ID: <52018664.1080103@intel.com>
Date: Tue, 06 Aug 2013 16:27:32 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/9] pci: Tune secondary bus reset timing
References: <20130805193200.9260.38729.stgit@bling.home> <20130805193753.9260.35206.stgit@bling.home>
In-Reply-To: <20130805193753.9260.35206.stgit@bling.home>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 12:37 PM, Alex Williamson wrote:
> The PCI spec indicates that with stable power, reset needs to be
> asserted for a minimum of 1ms (Trst).  Seems like we should be able
> to assume power is stable for a runtime secondary bus reset.  The
> current code has always used 100ms with no explanation where that
> came from.  The aer_do_secondary_bus_reset() function uses 2ms, but
> that seems to be a misinterpretation of the PCIe spec, where hot
> reset is implemented by TS1 ordered sets containing the hot reset
> command.  After a 2ms delay the state machine enters the detect state,
> but to generate a link down, only two consecutive TS1 hot reset
> ordered sets are requred.  1ms should be plenty for that.

The reason for doing a 2ms sleep is because the are supposed to be
sending the Hot Reset TS1 Ordered-Sets continuously for 2ms per all of
the documents I have read.  The 1ms number you quote is the minimum time
for a conventional PCI bus.  I'm not completely sure of that applies as
well to PCIe, nor does it represent the maximum recommended value.

If we stop early we risk not resetting the full device tree on the
secondary bus which is the bug I was resolving by adding the 2ms delay. 
Previously we saw that some devices were only getting their PCIe link
retrained without performing a hot reset when the bit was not held for
long enough.  I would prefer to keep this at 2 ms in order to account
for the fact that PCIe has to go though link recovery states before it
can perform the hot reset.

Thanks,

Alex


