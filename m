Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3GIIii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:38:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:59663 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3GIIie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1026,1363158000"; 
   d="scan'208";a="367306030"
Date: Tue, 9 Jul 2013 11:44:02 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130709084402.GF4898@intel.com>
References: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130708134216.GB6402@ab42.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708134216.GB6402@ab42.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:42:17PM +0200, Christian Ruppert wrote:
> On Mon, Jul 08, 2013 at 02:45:26PM +0300, Mika Westerberg wrote:
> > The DesignWare I2C controller has high count (HCNT) and low count (LCNT)
> > registers for each of the I2C speed modes (standard and fast). These
> > registers are programmed based on the input clock speed in the driver.
> > 
> > However, that is not always the most accurate way. For example on Intel
> > BayTrail we have 100MHz input clock and calculated *CNT values result as
> > measured by one of our team:
> > 
> >  Standard mode: 100.25kHz
> >  Fast mode    : 315.41kHZ
> > 
> > The fast mode speed is over 20% lower than what is expected.
> 
> We have observed similar issues and I am wondering if this effect is due
> to the overly-pessimistic formulas in i2c_dw_scl_lcnt and
> i2c_dw_scl_hcnt. The comments in these functions are a bit confusing and
> I don't pretend having fully understood what the intention is. I'm
> having the impression that defining the arguments tf in function of the
> hardware would be the "correct" way to achieve better clock accuracy.

Well, that's not the only timing parameter specified in the I2C spec. We
also have tr among other things (even though the dw driver doesn't use it).

> > It might be
> > that there are things like strenght of the pull-up resistors, bus
> > capacitance etc. that are very platform specific and have an effect on the
> > clock signal.
> 
> I believe tf is supposed to model these things. I just haven't clearly
> understood how. In my understanding, transition times should be
> subtracted rather than added to cycle times or am I getting something
> fundamentally wrong here?

I'm not sure, honestly :-) I believe tf is the same tf that is in the I2C
spec, meaning fall time of both SCL and SDA signals and the spec measures
one clock cycle to be from end of the first tf to the end of the second
(fig. 27 in the I2C spec). If I'm reading it right then it means adding
instead of substracting.

Do you have any suggestions how we could use tf here? At least on Intel
hardware we have an ACPI method that returns directly the optimum *CNT
values.
