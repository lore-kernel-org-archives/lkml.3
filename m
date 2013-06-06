Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3FFVX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:23:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:10213 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab3FFVX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:23:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,817,1363158000"; 
   d="scan'208";a="349333439"
Date: Thu, 6 Jun 2013 14:26:20 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Message-ID: <20130606212620.GA13620@bingao-desk1.fm.intel.com>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
 <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v4l2, the camera sensor i2c devices are taken over by v4l2 master
driver, i.e. ISP driver, and are not expected to be accessed from
user sapce by ioctl. So ISP driver has to register them by itself to
get all related information for further communication. Please check
v4l2_i2c_new_subdev_board() in drivers/media/video/v4l2-common.c for details.

The platform code can definitely disallow calling i2c_register_board_info()
to register them but keep the i2c devices list and then let ISP driver register
them. But, problems come when a single kernel is going to run on two platforms
- one platform has ACPI5 and the other has SFI. The dynamic unregister and then
register based on this new helper will not have dependency on firmware interface -
the same platform code will work for all platforms.

On Thu, Jun 06, 2013 at 11:32:06PM +0300, Andy Shevchenko wrote:
> On Thu, Jun 6, 2013 at 9:33 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
> > There is a requirement to get the i2c_client pointer dynamically without
> > knowing the bus and slave address. But we do know the client name,
> > i.e. the name in the i2c_board_info. This patch is to fit this requirement.
> >
> > A good example is that an ISP(Imaging Signal Processor) driver needs
> > register i2c camera sensor devices via v4l2, so it has to unregister
> > all i2c clients that were previously registered by calling
> > i2c_register_board_info(), and then re-register. For this case we
> > can use this helper to get i2c_client by passing the client name.
> 
> Why ISP driver would like to register sensor drivers in the first place?
> That seems the task of platform code, or DT, or ACPI5
> 
> Why do you need to re-register them at run time?
> 
> --
> With Best Regards,
> Andy Shevchenko
