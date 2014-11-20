Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaKTKGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:06:49 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:56199 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbaKTKGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:06:46 -0500
Date: Thu, 20 Nov 2014 10:06:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clk: Propagate prepare and enable when reparenting
 orphans
Message-ID: <20141120100633.GP4042@n2100.arm.linux.org.uk>
References: <1415408818-28028-1-git-send-email-dianders@chromium.org>
 <20141120023050.12298.26964@quantum>
 <CAD=FV=VZJ_iSFoW39kbahFSZ_Ta4Qf7zxaCnJMWFVWhXzsLrWw@mail.gmail.com>
 <20141120074514.GB30434@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120074514.GB30434@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:45:14PM -0800, Dmitry Torokhov wrote:
> On Wed, Nov 19, 2014 at 09:15:41PM -0800, Doug Anderson wrote:
> > I will defer to your wisdom here.  I agree that these are the two
> > primary solutions and I've picked one, but I have no idea which will
> > be more of a PITA in the long run.
> > 
> > Note: I'm not sure that anyone expects EPROBE_DEFER to be returned
> > from a clk_enable() (do they?).  It almost seems like the right answer
> > is to fail to allow anyone to clk_get() any clock that doesn't have a
> > path to root.
> 
> EPROBE_DEFER only makes sense in driver's probe paths and so I would be
> very against adding it to clk_enable() which is called from many places
> in the kernel. If we decide to go with EPROBE_DEFER then returning it
> from clk_get() seems like a much better choice since it is normally
> called during probing.

Absolutely correct.  EINVAL would be better for clk_prepare() since it
isn't something that can be recovered from by just retrying a bit later.

You're absolutely correct that EPROBE_DEFER has no business being returned
in any path other than a driver's probe function; it is not a user visible
error code, it is a special internal Linux error code which only the driver
model understands to mean "add this device to the deferred probe list and
try again a while later."  Userspace, especially, should never see this
error code.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
