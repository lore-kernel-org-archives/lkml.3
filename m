Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaFLGjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:39:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:19039 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaFLGjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,462,1400050800"; 
   d="scan'208";a="556163373"
From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>
CC: "Kp, Jeeja" <jeeja.kp@intel.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: RE: [PATCH] ALSA: compress: Fix the mismatch size of struc between
 share lib(32bit) and kernel(64bit)
Thread-Topic: [PATCH] ALSA: compress: Fix the mismatch size of struc between
 share lib(32bit) and kernel(64bit)
Thread-Index: AQHPg61TuZUznRPgu0+aM92ZHyEd3Ztn2liAgACJJQCABJ9yUA==
Date: Thu, 12 Jun 2014 06:39:03 +0000
Message-ID: <FA47D36D6EC9FE4CB463299737C09B9901C34AA2@shsmsx102.ccr.corp.intel.com>
References: <1402346792.30956.17.camel@wxm-ubuntu>
 <s5hwqcqwnne.wl%tiwai@suse.de> <20140609153544.GA25075@intel.com>
In-Reply-To: <20140609153544.GA25075@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Takashi

> -----Original Message-----
> From: Koul, Vinod
> Sent: Monday, June 09, 2014 11:36 PM
> To: Takashi Iwai
> Cc: Wang, Xiaoming; Kp, Jeeja; dhowells@redhat.com; arnd@arndb.de;
> tglx@linutronix.de; mtk.manpages@gmail.com;
> paulmck@linux.vnet.ibm.com; davej@redhat.com;
> linux-kernel@vger.kernel.org; Zhang, Dongxing
> Subject: Re: [PATCH] ALSA: compress: Fix the mismatch size of struc between
> share lib(32bit) and kernel(64bit)
> 
> On Mon, Jun 09, 2014 at 09:24:53AM +0200, Takashi Iwai wrote:
> > At Mon, 09 Jun 2014 16:46:32 -0400,
> > Wang, Xiaoming wrote:
> > >
> > >
> > > The size of struct snd_compr_avail is 0x1c in 32bit kernel, while it
> > > is 0x20 in 64bit kernel 0x4 bytes added because of alignment. It is
> > > OK when 32bit kernel met 32bit user space.
> > > There exist stack corruption if 64bit kernel met 32bit user space,
> > > because the size of struct snd_compr_avail is 0x1c in 32bit user
> > > space which is smaller than it will get from kernel. The extra 4
> > > bytes can corrupt the stack, and introduce unpredictable error.
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
> I think former should be safe for now. Anyway we have only 1 driver using
> this in mainline so fallout shouldn't be widespread!
Can you accept we add __attribute__((packed, aligned(4))) for struct snd_compr_avail
Which include the struct snd_compr_tstamp and fix the sizeof struct snd_compr_avail
to 0x1c both in 32bit and 64 bit kernel?
> 
> --
> ~Vinod
> >
> >
> > thanks,
> >
> > Takashi
> >
> > > ---
> > >  include/uapi/sound/compress_offload.h |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/include/uapi/sound/compress_offload.h
> > > b/include/uapi/sound/compress_offload.h
> > > index 5759810..766b416 100644
> > > --- a/include/uapi/sound/compress_offload.h
> > > +++ b/include/uapi/sound/compress_offload.h
> > > @@ -70,6 +70,7 @@ struct snd_compr_tstamp {
> > >  	__u32 pcm_frames;
> > >  	__u32 pcm_io_frames;
> > >  	__u32 sampling_rate;
> > > +	__u32 reserved[1];
> > >  };
> > >
> > >  /**
> > > --
> > > 1.7.1
> > >
> 
> --
