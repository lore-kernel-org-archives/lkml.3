Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3HPWPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:15:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53186 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3HPWPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:15:02 -0400
Date: Fri, 16 Aug 2013 15:21:10 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH RFC 1/3] spmi: Linux driver framework for SPMI
Message-ID: <20130816202110.GJ4035@joshc.qualcomm.com>
References: <cover.1376596224.git.joshc@codeaurora.org>
 <02deef1d90121011ab1df90ad704ef0ee36e2584.1376596224.git.joshc@codeaurora.org>
 <20130816184921.GB31510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816184921.GB31510@kroah.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:49:21AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2013 at 01:37:09PM -0700, Josh Cartwright wrote:
> > +++ b/drivers/spmi/spmi.c
> > @@ -0,0 +1,449 @@
[..]
> > +static void spmi_ctrl_release(struct device *dev)
> > +{
> > +	struct spmi_controller *ctrl = to_spmi_controller(dev);
> > +	complete(&ctrl->dev_released);
> 
> When is this memory going to be freed?
> 
> Ah, you think it will be when you remove the device later on:
> 
> > +int spmi_del_controller(struct spmi_controller *ctrl)
> > +{
> > +	struct spmi_controller *found;
> > +
> > +	if (!ctrl)
> > +		return -EINVAL;
> > +
> > +	/* Check that the ctrl has been added */
> > +	mutex_lock(&board_lock);
> > +	found = idr_find(&ctrl_idr, ctrl->nr);
> > +	mutex_unlock(&board_lock);
> > +
> > +	if (found != ctrl)
> > +		return -EINVAL;
> > +
> > +	spmi_dfs_del_controller(ctrl);
> > +
> > +	/* Remove all the clients associated with this controller */
> > +	mutex_lock(&board_lock);
> > +	bus_for_each_dev(&spmi_bus_type, NULL, ctrl, spmi_ctrl_remove_device);
> > +	idr_remove(&ctrl_idr, ctrl->nr);
> > +	mutex_unlock(&board_lock);
> > +
> > +	init_completion(&ctrl->dev_released);
> > +	device_unregister(&ctrl->dev);
> > +	wait_for_completion(&ctrl->dev_released);
> 
> But you just leaked memory, right?
> 
> You should never have to wait for this to happen, why did you need to
> add this?  Why not just a simple call to kfree() in the release
> function?

Unfortunately, the reason why this was necessary may be lost to history.  :(

I'll do some testing with the completion removed and a simple kfree() in
the release and see if there is any fallout.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
