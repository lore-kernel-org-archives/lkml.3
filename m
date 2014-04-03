Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaDCK6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:58:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50200 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbaDCK6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:58:08 -0400
Date: Thu, 3 Apr 2014 11:58:04 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: Get and put regulator of_node
Message-ID: <20140403105804.GP1665@opensource.wolfsonmicro.com>
References: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140402142356.GE2269@sirena.org.uk> <20140402160438.GO1665@opensource.wolfsonmicro.com> <20140402165354.GG2269@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402165354.GG2269@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 05:53:54PM +0100, Mark Brown wrote:
> To make this correct we need to at least ensure that the node passed
> into the regulator API is valid and referenced at that time so there
> should only be an issue for the core if the reference is dropped after
> that.  In the above case the device model is holding a reference since
> this is the of_node for the device itself so taking the reference won't
> hurt but is redundant.  In cases where we have more than one regulator
> and are using of_regulator_match() then things are more tricky.
> Something needs to drop the references it returns (which isn't happening
> at all at the minute).

>From what I can see of_regulator_match isn't taking any
references at the minute? for_each_child_of_node will get a
reference but it will also put that when we process the next
child. We copy the pointer to the child into match->of_node
but don't manually increment the reference at all. So
of_regulator_match has no effect on the reference count of the
of_node.

>  Doing it while doing the match and register
> seems simple and neat from an error handling point of view so having the
> core take an additional reference during the registration would join up
> with that.

The main issue I have is that devm_regualtor_register is a bit
awkward. With regulator_register you will always be calling
regulator_unregister so you can put the of_node there but with
devm there isn't really a good place to put the of_node.

Would perhaps a sensible thing here be to add an of_node_get to
of_regulator_match, since we seem to be expecting that to
increase the ref count. And then just add an of_node_put to
regulator_unregister. And for anything directly using
regulator_register/devm_regulator_register they should add a
manual of_node_get?

Thanks,
Charles
