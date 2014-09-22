Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaIVPzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:55:32 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62914 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaIVPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:55:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
Date: Mon, 22 Sep 2014 17:54:42 +0200
Message-ID: <3102396.6rAQmqkXXM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140922171506.31d59a76@bbrezillon>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com> <3036415.u40f3Xnhod@wuerfel> <20140922171506.31d59a76@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Rg/vgKfy7JX9gpzV80Cl+fQGBoQ+ROKvpCLLj+U6m4S
 CXz3iEOOPyOnXfG2weAb+sBalz8SDtNe02C4op2TPzN9XrHwFV
 8xfXxmmzs/cZW12PdOMteySiXv5MVJidB8KSYfx5EIGDK8KHSu
 iWlAtXlPtzkQXE/clTFumtJ2zg8vfy81uH4K2QeuonDGRY8nk1
 PgbU+WozHJ3L5iqt910UIQsMzJMT6+KSZ5W/QuDKPW90XYf0ih
 7yAzbefVHMx2z26um8UKPkk+g0o3aVYQGbsPN5oC9VKEb9xeZi
 nEjIEpQFmTESnVxrWmh8cpaWAfv4cqXX4x9JYAQtzHP9T582wf
 MqYg9telIABHjNT4q+zE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2014 17:15:06 Boris BREZILLON wrote:
> > > +
> > > +   /* TODO(djkurtz): fetch the mapping start/size from somewhere */
> > > +   mapping = arm_iommu_create_mapping(&platform_bus_type, 0x10000000,
> > > +                                      SZ_1G);
> > > +   if (IS_ERR(mapping)) {
> > > +           ret = PTR_ERR(mapping);
> > > +           goto err_config_cleanup;
> > > +   }
> > > +
> > > +   dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> > 
> > This is the default coherent mask. If you call this function, you
> > should normally check the return value, or call dma_set_mask first,
> > which you apparently don't do here, and in another place in this
> > patch.
> 
> By "This is the default mask" do you mean it shouldn't be called at
> all ? Cause I ran into some trouble when not calling this in my
> atmel-hlcdc driver.

We used to get this wrong in the of_platform code, but it should
work now.

> Actually, in my case the platform device is created by the MFD core
> which seems to let the coherent_dma_mask uninitialized.

That may well be different, but it seems like a good idea to allow
the MFD core to set this up as well.

In general, we expect that devices that are capable of doing DMA
start with a 32-bit mask for both dma_mask and dma_coherent_mask,
and a driver that requires a smaller masks or wants a larger mask
has to call the appropriate interface to set these, and check the
return value.

	Arnd
