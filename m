Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaHNWHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:07:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:23398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbaHNWHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:07:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,865,1400050800"; 
   d="scan'208";a="558767726"
Date: Thu, 14 Aug 2014 15:07:40 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Claudio Bizzarri <claudio.bizzarri@gmail.com>, Matt <jackdachef@gmail.com>,
        kraxel@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>
Subject: Re: Kernel 3.16.0 USB crash
Message-ID: <20140814220740.GA32475@xanatos>
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
 <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com>
 <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com>
 <53EC8579.1030008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53EC8579.1030008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Mathias Nyman.  He is now the USB 3.0 maintainer.

Sarah Sharp

On Thu, Aug 14, 2014 at 11:46:33AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/14/2014 10:39 AM, Claudio Bizzarri wrote:
> > Ciao,
> > 
> > thank you very much for replay, you are right: it's UAS module. Now I'm
> > using Ubuntu 14.04 with kernel 3.16.1 from
> > http://kernel.ubuntu.com/~kernel-ppa/mainline/, there is no /proc/config.gz,
> > but but there is a config file in /boot:
> > 
> > b0@hp850ssd:~⟫ grep USB_UAS /boot/config-3.16.1-031601-generic
> > CONFIG_USB_UAS=m
> > 
> > When I attach my external USB disk I've 30 seconds before my laptop freeze,
> > here is my dmesg output, disk is not mounted:
> 
> Hmm, this sounds like a similar problem we've been having with JMicron UAS
> bridges over USB-2.
> 
> Can you collect "lsusb -v" output for the drive in question when connected
> through an usb-3 port (the uas module does not need to be loaded).
> 
> Also can you try the following patch, and see if that makes uas work ? :
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 511b229..6cdc1b9 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -1033,6 +1033,7 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
>  						    3, 256, GFP_NOIO);
>  		if (devinfo->qdepth < 0)
>  			return devinfo->qdepth;
> +		devinfo->qdepth = 32;
>  		devinfo->use_streams = 1;
>  	}
> 
> 
> This is in essence the fix we've done for using these devices with uas over usb-2,
> I would have expected this to not be be necessary at superspeed since there the number
> of streams the device supports is part of the usb descriptors, but maybe the device
> claims to support more streams then it can actually handle.
> 
> Note I'm on vacation next week, so don't expect another reply from me in this thread
> for at least a week.
> 
> Regards,
> 
> Hans
