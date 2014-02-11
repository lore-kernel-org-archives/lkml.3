Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaBKQuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:50:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49896 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaBKQun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:50:43 -0500
Date: Tue, 11 Feb 2014 10:48:26 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when
 CONFIG_OF isn't set
Message-ID: <20140211164825.GC841@joshc.qualcomm.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20140211144108.GB841@joshc.qualcomm.com>
 <1596542.hkJp71u3OJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596542.hkJp71u3OJ@avalon>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:55:35PM +0100, Laurent Pinchart wrote:
> Hi Josh,
> 
> On Tuesday 11 February 2014 08:41:08 Josh Cartwright wrote:
> > On Tue, Feb 11, 2014 at 01:36:51PM +0100, Laurent Pinchart wrote:
> > > when CONFIG_OF is disabled of_match_node is defined as a macro that
> > > evaluates to NULL. This breaks compilation of drivers that dereference
> > > the function's return value directly. Fix it by turning the macro into a
> > > static inline function that returns NULL.
> > 
> > Just this past week I did the same thing, but noticed that it breaks the
> > following usecase:
> > 
> > 	#ifdef CONFIG_OF
> > 	static const struct of_device_id foobar_matches[] = {
> > 		{ .compatible = "foobar,whatsit", },
> > 		{ },
> > 	};
> > 	#endif
> > 
> > 	static int probeme(struct platform_device *pdev)
> > 	{
> > 		struct of_device_id *id;
> > 
> > 		id = of_match_node(foobar_matches, pdev->dev.of_node);
> > 		if (id) {
> > 			/* ... */
> > 		}
> > 		return 0;
> > 	}
> > 
> > When !CONFIG_OF and with your change, this will fail to build due to
> > foobar_matches being undefined.
> 
> Good point. What would you think about
> 
> #define of_match_node(_matches, _node)  ((const struct of_device_id *)NULL)

I've just sent out a patchset that cleans up at least a couple of users
that directly do of_match_node(matches, np)->data using
of_find_matching_node_and_match.  Not sure if that will fix the usage
you have in mind, though.

I am a bit weary about having an of_match_node() user that both directly
dereferences the result (i.e. of_match_node(matches, np)->data) _and_
builds when !CONFIG_OF; most likely due to a traumatic childhood event
where demons flew out my nose.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
