Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaFMOTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:19:51 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55952 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFMOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:19:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] ALSA: compress: Fix the mismatch size of struc between share lib(32bit) and kernel(64bit)
Date: Fri, 13 Jun 2014 16:19:32 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        jeeja.kp@intel.com, dhowells@redhat.com, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, dongxing.zhang@intel.com
References: <1402346792.30956.17.camel@wxm-ubuntu> <s5hwqcqwnne.wl%tiwai@suse.de> <20140609153544.GA25075@intel.com>
In-Reply-To: <20140609153544.GA25075@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201406131619.32976.arnd@arndb.de>
X-Provags-ID: V02:K0:/z5k9591NtwUTYAIOj98znAsk4AhlpGBBzU+Ryd2y20
 osNTQ1d/kCgAJDYFzZN59/k1OBHwrEL8RN0HoXaFoKjCGg8r1H
 PY//EEyGFSJHAbDcvcFY202brUIOvD9OCTty7FZrPY4oZT9VFx
 fdgNnN3Q/WxG4B6/QTrFQJDbPvSCp2cXuyR3gYRJ19XC6u71BC
 8duK8hoohdj1kzUAW1h3WtjA80aztMak/6nCCGQ2s18fTFtxMg
 cYTwR2qWGlYcwShNmc/9/sWf+qWzVTqloKTPjc7s18tj+ibdiS
 XyMNl6xA+higwepIVpZSq3/B3tRMQC0QCkr3JcGdZgp9VIcJ+n
 8bkROnRtRo40DCxwTd8w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2014, Vinod Koul wrote:
> On Mon, Jun 09, 2014 at 09:24:53AM +0200, Takashi Iwai wrote:
> > At Mon, 09 Jun 2014 16:46:32 -0400,
> > Wang, Xiaoming wrote:
> > > 
> > > 
> > > The size of struct snd_compr_avail is 0x1c in 32bit kernel,
> > > while it is 0x20 in 64bit kernel 0x4 bytes added because of
> > > alignment. It is OK when 32bit kernel met 32bit user space.
> > > There exist stack corruption if 64bit kernel met 32bit user
> > > space, because the size of struct snd_compr_avail is 0x1c
> > > in 32bit user space which is smaller than it will get from
> > > kernel. The extra 4 bytes can corrupt the stack, and
> > > introduce unpredictable error.
> > > 
> > > Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> > > Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> > 
> > This would break the existing 32bit systems, so I don't think we can
> > take this approach.
> > 
> > Either break the 64bit systems (which aren't deployed yet much, so
> > far) by adding packed attribute, or implement 32/64 bit conversion in
> > compat_ioctl fop.
> I think former should be safe for now. Anyway we have only 1 driver using this
> in mainline so fallout shouldn't be widespread!

I guess since the driver was only merged for 3.16, we don't
really have to worry about the ABI breakage anyway, but you can
still use that approach if you have reason to stay compatible with
existing used space built against out-of-tree drivers.

Anyway, if you use the __packed attribute, best apply it only to
the individual __u64 member(s), not the entire struct, otherwise
you might change user space programs in a subtle way when the alignment
changes from 4 to 1 byte. 

	Arnd
