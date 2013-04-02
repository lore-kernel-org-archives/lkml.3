Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab3DBFKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:10:17 -0400
Received: from sauhun.de ([89.238.76.85]:55383 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab3DBFKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:10:14 -0400
Date: Tue, 2 Apr 2013 07:09:51 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6]  Make return type of i2c_del_adapter() (and
 i2c_del_mux_adapter()) void
Message-ID: <20130402050951.GA11487@the-dreams.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 07:16:43PM +0100, Lars-Peter Clausen wrote:
> Currently i2c_del_adapter() returns 0 on success and potentially an error code
> on failure. Unfortunately this doesn't mix too well with the Linux device driver
> model. An i2c_adapter is usually registered in a drivers probe callback and
> removed in the drivers remove callback. The Linux device driver model assumes
> that a device may disappear at any time, e.g. because it is on a hot-plug-able
> bus and the device is physically removed or because it is unbound from it's
> driver. This means that a driver's remove callback is not allowed to fail. This
> has lead to code fragments like the following:
> 
> 	rc = i2c_del_adapter(&board->i2c_adap);
> 	BUG_ON(rc);
> 
> Currently there are two code paths which can cause to i2c_del_adapter() to
> return an error code:
> 1) If the adapter that is passed to i2c_del_adapter() is not registered
> i2c_del_adapter() returns -EINVAL
> 2) If an I2C client, which is registered as a child to the adapter, implements
> the detach_adapter callback and detach_adapter returns an error the removal of
> the adapter is aborted and i2c_del_adapter() returns the error returned by the
> clients detach_adapter callback.
> 
> The first probably never happens unless there is a serious bug in the driver
> calling i2c_del_adapter(), but I think even then, for the sake of sanitizing the
> API we can argue that the purpose of i2c_del_adapter() is to remove the adapter
> from the system. If the adapter currently isn't registered this becomes a no-op
> and we can return success, without having to do anything. The second also never
> happens, since the detach_adapter callback has been deprecated for quite some
> time now and there are currently no drivers left which implement it.
> 
> So realisticly i2c_del_adapter() already always returns 0 and all code checking
> for errors is more or less dead code. And in fact the majority of the users of
> i2c_del_adapter() already ignore the return value, but there are still some
> drivers (both newer and older) which assume that i2c_del_adapter() might fail.
> This series aims at making it explicit that i2c_del_adapter() can not fail by
> making its return type void.
> 
> The series will start by making i2c_del_adapter() always return success. For
> this it will update the case, where a non-registered adapter is passed in, to
> return 0 instead of -EINVAL and remove all code related to the unused
> detach_adapter callback. Afterward the series will update all users of
> i2c_del_adapter() to ignore the return value (since it is always 0 now). And
> finally the series will change the return type of i2c_del_adapter() to void.
> 
> The same is true for i2c_del_mux_adapter() which is mostly just a wrapper
> around i2c_del_adapter(), so it is also updated in this series.

Thanks for doing this and thanks to Jean for the review. I pretty much
came to the same questions and conclusions.

Applied to for-next, thanks!

