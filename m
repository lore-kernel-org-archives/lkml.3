Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaFQDIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:08:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:61777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbaFQDIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,491,1400050800"; 
   d="scan'208";a="529579893"
Date: Tue, 17 Jun 2014 08:36:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        jeeja.kp@intel.com, dhowells@redhat.com, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, dongxing.zhang@intel.com
Subject: Re: [PATCH] ALSA: compress: Fix the mismatch size of struc between
 share lib(32bit) and kernel(64bit)
Message-ID: <20140617030636.GE22053@intel.com>
References: <1402346792.30956.17.camel@wxm-ubuntu>
 <s5hwqcqwnne.wl%tiwai@suse.de>
 <20140609153544.GA25075@intel.com>
 <201406131619.32976.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201406131619.32976.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:19:32PM +0200, Arnd Bergmann wrote:
> On Monday 09 June 2014, Vinod Koul wrote:
> > On Mon, Jun 09, 2014 at 09:24:53AM +0200, Takashi Iwai wrote:
> > > At Mon, 09 Jun 2014 16:46:32 -0400,
> > > Wang, Xiaoming wrote:
> > > > 
> > > > 
> > > > The size of struct snd_compr_avail is 0x1c in 32bit kernel,
> > > > while it is 0x20 in 64bit kernel 0x4 bytes added because of
> > > > alignment. It is OK when 32bit kernel met 32bit user space.
> > > > There exist stack corruption if 64bit kernel met 32bit user
> > > > space, because the size of struct snd_compr_avail is 0x1c
> > > > in 32bit user space which is smaller than it will get from
> > > > kernel. The extra 4 bytes can corrupt the stack, and
> > > > introduce unpredictable error.
> > > > 
> > > > Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> > > > Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> > > 
> > > This would break the existing 32bit systems, so I don't think we can
> > > take this approach.
> > > 
> > > Either break the 64bit systems (which aren't deployed yet much, so
> > > far) by adding packed attribute, or implement 32/64 bit conversion in
> > > compat_ioctl fop.
> > I think former should be safe for now. Anyway we have only 1 driver using this
> > in mainline so fallout shouldn't be widespread!
> 
> I guess since the driver was only merged for 3.16, we don't
> really have to worry about the ABI breakage anyway, but you can
> still use that approach if you have reason to stay compatible with
> existing used space built against out-of-tree drivers.
The qcom has on out of tree driver, but not sure if they have used on 64bit so
they might not be impacted.

> Anyway, if you use the __packed attribute, best apply it only to
> the individual __u64 member(s), not the entire struct, otherwise
> you might change user space programs in a subtle way when the alignment
> changes from 4 to 1 byte. 
then wouldn't it make sense to call out the aligned as well to ensure that it is
aligning to what we want. Then we should add aligned (4) everywhere as mostly we
need 4 byte aligned here

-- 
~Vinod
