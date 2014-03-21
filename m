Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbaCULrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:47:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39369 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155AbaCULrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:47:42 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <532C1808.6090409@samsung.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com> <1883687.VdfitvQEN3@ samsung.com> <avalon@samsung.com> <20140320172302.CD320C4067A@trevor. secretlab.ca> <532C1808.6090409@samsung.com>
Date: Fri, 21 Mar 2014 11:47:35 +0000
Message-Id: <20140321114735.3E132C4052A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 11:44:24 +0100, Andrzej Hajda <a.hajda@samsung.com> wrote:
> On 03/20/2014 06:23 PM, Grant Likely wrote:
> > On Tue, 11 Mar 2014 14:16:37 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> >> On Tuesday 11 March 2014 14:59:20 Tomi Valkeinen wrote:
> >>> So depending on the use case, the endpoints would point to opposite
> >>> direction from the encoder's point of view.
> >>>
> >>> And if I gathered Grant's opinion correctly (correct me if I'm wrong),
> >>> he thinks things should be explicit, i.e. the bindings for, say, an
> >>> encoder should state that the encoder's output endpoint _must_ contain a
> >>> remote-endpoint property, whereas the encoder's input endpoint _must
> >>> not_ contain a remote-endpoint property.
> >>
> >> Actually my understand was that DT links would have the same direction as the 
> >> data flow. There would be no ambiguity in that case as the direction of the 
> >> data flow is known. What happens for bidirectional data flows still need to be 
> >> discussed though. And if we want to use the of-graph bindings to describe 
> >> graphs without a data flow, a decision will need to be taken there too.
> > 
> > On further thinking, I would say linkage direction should be in the
> > direction that would be considered the dependency order... I'm going to
> > soften my position though. I think the generic pattern should still
> > recommend unidirection links in direction of device dependency, but
> 
> I am not sure what you mean by 'device dependency' but I am sure it will
> not be difficult to present problematic cases, maybe circular
> dependencies, two-way dependencies, etc.

My understanding has been that the link data would be used determine
when the controller driver can be brought up and active. Certainly both
sides of a link need to be 'live' before the link can be used. The
kernel must have a way to resolve the question of "who starts first?",
whether it be the situation of the consumer starts before the producer,
or the situation of two components need to start before the controller
driver can start. That is the dependency chain I'm talking about.

> The only problem of unidirectional links from programming point of view
> is that destination port/interface should be exposed using some
> framework and driver of source link should grab it using the same
> framework, using port/endpoint node for identification. In case of
> bi-directional links the same process should happen but DT do not
> dictates who should expose and who grabs.
> 
> So from programming point of view it should be easy to handle
> unidirectional links regardless of the direction. So I guess the best
> is to use data flow direction as it seems to be the most natural.

right.

> 
> 
> > I'm okay with allowing the bidirection option if the helper functions
> > are modified to validate the target endpoint. I think it needs to test
> > for the following:
> > - Make sure the endpoint either:
> >   - does not have a backlink, or
> >   - the backlink points back to the origin node
> > - If the target is an endpoint node, then make sure the parent doesn't
> >   have a link of any kind
> > - If the target is a port node, make sure it doesn't have any endpoint
> >   children nodes at all.
> 
> I think link validation can be done at dts compile time.

I'm firm on the opinion that the checking must also happen at runtime.
The biggest part of my objection has been how easy it would be to get a
linkage out of sync, and dtc is not necessarily the last tool to touch
the dtb before the kernel gets booted. I want the kernel to flat out
reject any linkage that is improperly formed.

g.

> 
> Regards
> Andrzej
> 
> > 
> > g.
> > 
> > 
> 

