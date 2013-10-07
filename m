Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JGVSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:18:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37153 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3JGVSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:18:39 -0400
Date: Mon, 7 Oct 2013 16:17:56 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/5] spmi: add generic SPMI controller binding
 documentation
Message-ID: <20131007211756.GA1036@joshc.qualcomm.com>
References: <cover.1377202730.git.joshc@codeaurora.org>
 <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org>
 <5217DB0C.7000101@wwwdotorg.org>
 <20130827170120.GR4035@joshc.qualcomm.com>
 <521D2047.8030300@wwwdotorg.org>
 <CAJAp7Oi-bPytsLtsppdanOi_p0Y5vfBriGB-B5by7w5Z7SGU-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJAp7Oi-bPytsLtsppdanOi_p0Y5vfBriGB-B5by7w5Z7SGU-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Bjorn-

On Sat, Oct 05, 2013 at 11:11:36PM -0700, Bjorn Andersson wrote:
> On Tue, Aug 27, 2013 at 2:55 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 08/27/2013 11:01 AM, Josh Cartwright wrote:
> > ...
> > cell 0 - address type (0: master, 1: unique ID, 2: group ID, ...)
>
> I think it would make sense to have the master id as a property of the
> bus,

Except that SPMI supports bus configurations with multiple masters.
Unless by 'bus' you meant 'bus controller' here?

> as you could consider this to indicate different buses and then
> usid, gsid and base being part of the reg.
>
> > cell 1 - address value
>
> I did hack up Josh patchset to read a reg touple of <usid, base>
> instead of just usid. I stored the second value in the spmi_device
> struct for easy access, but maybe it should be done like on
> codeaurora; in a resource?
> I believe this looks nice, but as I haven't read the mipi spec I
> wonder, will there be a case where you don't have an offset/base?
> Should it just be made optional?

The SPMI spec says nothing about partitioning up the slave address to
support multiple functions.  AFAICT, this is a Qualcomm-created
construct (QPNP) for the 8x41 PMICs.  It's difficult to tell at this
point whether or not other vendors might implement a similarly
partitioned scheme.

I suspect the intent is that implementations make use of logical slave
ID for each function in a multi-function device.

> Can we make the address <usid, [base]> and have the code populate a
> resource based on a reg-names property? That way it would be possible
> to extend it to support gsid in case we want to (would require
> reg-names though).

It is certainly possible, and, as you've seen, is how the current
codeaurora.org tree implements SPMI.  But, I'm actually actively trying
to avoid doing so, as it conflates Qualcomm-implementation details and
what is actually in the spec (and not just the address space
partitioning, but also the of_spmi.c[2] parsing must know about
interrupts, which are _also_ completely outside the SPMI spec).

Instead what I hope to do for v3 is either:
  A) Make QPNP its own bus type (for which I have a prototyped
     implementation).  A PMIC driver sits on the SPMI bus and registers
     itself as a QPNP controller.  QPNP controllers have very
     simple 8-bit register read/write operations used by QPNP devices.
  B) Effectively the same as A, but gets rid of a special QPNP bus type
     and uses mfd/platform devices, similar to other in-tree PMIC drivers
     (currently working on prototyping this approach)

> With the hack to Josh's patchset I quickly ported qpnp-revision and
> qpnp-vibrator, and it seems to work quite nicely.

Great! Thanks for testing.

  Josh

1: https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/spmi
2: https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/of/of_spmi.c

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
