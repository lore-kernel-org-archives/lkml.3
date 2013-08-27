Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3H0RBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:01:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51094 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3H0RBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:01:46 -0400
Date: Tue, 27 Aug 2013 12:01:20 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
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
Message-ID: <20130827170120.GR4035@joshc.qualcomm.com>
References: <cover.1377202730.git.joshc@codeaurora.org>
 <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org>
 <5217DB0C.7000101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5217DB0C.7000101@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen-

Thanks for the comments.

On Fri, Aug 23, 2013 at 03:58:36PM -0600, Stephen Warren wrote:
> On 08/22/2013 01:59 PM, Josh Cartwright wrote:
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> > I'm introducing this as an RFC, because there are set of assumptions
> > made in this binding spec, that currently hold true for the supported
> > controller/addressing scheme for the Snapdragon 800 series, but don't
> > necessarily hold true for SPMI in general.
> > 
> >   1. No use of Group Slave Identifiers (GSIDs)
> >      (SPMI allows for a slave to belong to zero or more groups specified
> >      by GSID, however this feature isn't currently implemented)
> > 
> >   2. No specification of Master Identifier (MID)
> >      (A "system integrator" allocates to each master a 2-bit MID, this
> >      currently isn't being specified, as it isn't needed by software for
> >      the PMIC Arb; not sure if this is of use to other SPMI controllers)
> > 
> >   3. Single SPMI master per controller
> > 
> > Effectively, only a subset of possible SPMI configurations are specified
> > in this document.
> > 
> > So, if it's considered necessary to provide a generic SPMI binding
> > specification, is it acceptable to only define a subset at this time,
> > expanding only when necessary, or shall I expand the definition to at
> > least address 1 & 2, even though they are of no use in the current
> > implementation?
> 
> It's best to define the whole thing from the start if possible. It's
> easier to ensure the whole binding is consistent, and nothing has been
> left out.

That makes sense.  I think I'll go down this route for v3 of this
patchset:

For #1 above, extend the 'reg' property of a slave node to include the
group slave ID's in which the slave is a member.  The first 'reg' entry
will remain the slave's Unique Slave Identifier (USID) as before.

For #2, add additional required 'spmi-mid' property in the
controller/master node that describes the 2-bit Master Identifier (MID).

For #3, rename the SPMI API's s/controller/master/.  The current
controller/master terminology difference is confusing and unnecessary.

> However, it's probably OK to define a subset binding initially and then
> expand it later, as long as some thought it put into how it can be
> expanded in a way that is 100% compatible: old DTs will still operate
> with new kernels and perhaps even new DTs will still operate with old
> kernels.
>
> That said, if the thought is put in to ensure that's possible, it's
> probably just as easy to define the whole binding from the start.

That all makes sense.

If we want to ensure for the generic bindings that we are fulling
characterizing/describing the SPMI bus, then we'll additionally need to
tackle an additional identified assumption:

  4. One master per SPMI bus.  (The SPMI spec allows for up to 4
     masters)

On the Snapdragon 800 series, there exists only one software-controlled
master, but it is conceivably possible to have a setup with two
software-controlled masters on the same SPMI bus.

This necessarily means that the description of the slaves and the
masters will need to be decoupled; I'm imagining a generic binding
supporting multiple masters would look something like this:

	master0: master@0 {
		compatible = "...";
		#spmi-master-cells = <0>;
		spmi-mid = <0>;

		...
	};

	master2: master@2 {
		compatible = "...";
		#spmi-master-cells = <0>;
		spmi-mid = <2>;

		...
	};

	spmi_bus {
		compatible = "...";

		spmi-masters = <&master0 &master2>;

		foo@0 {
			compatible = "...";
			reg = <0 ...>;
		};

		foo@8 {
			compatible = "...";
			reg = <8 ...>;
		};
	};

(This will also necessitate a change in the underlying SPMI driver
model, in the current implementation, a SPMI master 'owns' a particular
device.  This is not a valid assumption to make.)

Would this property-containing-phandle-vector be considered the
canonical way of representing nodes with multiple parents in the device
tree?

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
