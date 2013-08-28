Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3H1SAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:00:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43748 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3H1SAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:00:41 -0400
Date: Wed, 28 Aug 2013 13:00:25 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH RFC v2 3/5] spmi: add generic SPMI controller binding
 documentation
Message-ID: <20130828180025.GA808@joshc.qualcomm.com>
References: <cover.1377202730.git.joshc@codeaurora.org>
 <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org>
 <5217DB0C.7000101@wwwdotorg.org>
 <20130827170120.GR4035@joshc.qualcomm.com>
 <521D2047.8030300@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521D2047.8030300@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 03:55:19PM -0600, Stephen Warren wrote:
> On 08/27/2013 11:01 AM, Josh Cartwright wrote:
> ...
> > If we want to ensure for the generic bindings that we are fulling
> > characterizing/describing the SPMI bus, then we'll additionally need to
> > tackle an additional identified assumption:
> >
> >   4. One master per SPMI bus.  (The SPMI spec allows for up to 4
> >      masters)
> >
> > On the Snapdragon 800 series, there exists only one software-controlled
> > master, but it is conceivably possible to have a setup with two
> > software-controlled masters on the same SPMI bus.
> >
> > This necessarily means that the description of the slaves and the
> > masters will need to be decoupled; I'm imagining a generic binding
> > supporting multiple masters would look something like this:
>
> Is there a need to represent the other masters in the DT? Sure they're
> there in HW, but if there's no specific way for the
> CPU-to-which-the-DT-applies to actually interact with those other
> masters (except perhaps by experiencing some arbitration delays) then
> presumably there's no need to represent the other masters in DT?

My example is contrived, but there is nothing in the SPMI spec
preventing two masters from being controllable by the same
CPU-to-which-the-DT-applies, sharing the same underlying bus.

I would also expect this configuration to be uncommon, I'm checking with
some folks with more SPMI experience to make sure they agree.

Interestingly, i2c as far as I can tell has also made the same
assumption.  There doesn't appear to be any way to express a
multi-master i2c setup where both masters are controlled by the same OS.

> > 	master0: master@0 {
> > 		compatible = "...";
> > 		#spmi-master-cells = <0>;
> > 		spmi-mid = <0>;
> > 
> > 		...
> > 	};
> > 
> > 	master2: master@2 {
> > 		compatible = "...";
> > 		#spmi-master-cells = <0>;
> > 		spmi-mid = <2>;
> > 
> > 		...
> > 	};
> > 
> > 	spmi_bus {
> > 		compatible = "...";
> > 
> > 		spmi-masters = <&master0 &master2>;
> > 
> > 		foo@0 {
> > 			compatible = "...";
> > 			reg = <0 ...>;
> > 		};
> > 
> > 		foo@8 {
> > 			compatible = "...";
> > 			reg = <8 ...>;
> > 		};
> > 	};
> > 
> > (This will also necessitate a change in the underlying SPMI driver
> > model, in the current implementation, a SPMI master 'owns' a particular
> > device.  This is not a valid assumption to make.)
> > 
> > Would this property-containing-phandle-vector be considered the
> > canonical way of representing nodes with multiple parents in the device
> > tree?
> 
> I don't think I've seen anything like this before, although that
> in-and-of-itself doesn't make it wrong.
> 
> Another approach might be to encode master-vs-slave into a cell in the
> reg property? Something like:
> 
> cell 0 - address type (0: master, 1: unique ID, 2: group ID, ...)
> cell 1 - address value
> 
> I haven't thought much about that; perhaps there are disadvantages doing
> that.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
