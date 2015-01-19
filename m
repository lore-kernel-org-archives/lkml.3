Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbASWLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 17:11:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbbASWL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 17:11:29 -0500
Date: Tue, 20 Jan 2015 00:11:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
Message-ID: <20150119221124.GA18301@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
 <20150115213256.GA4813@redhat.com>
 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
 <1421665620.3610.13.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421665620.3610.13.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:07:00PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > BTW: is there a tool (or pciutils patch) which can decode the virtio
> > capabilities?
> 
> Searched for a patch today, and all google found me was this mail asking
> for one :-o
> 
> So I went ahead and coded one up.  Attached.
> 
> While hacking it up I've noticed spec doesn't match reality.  The
> "Virtio Structure PCI Capabilities" section here ...
> 
> http://docs.oasis-open.org/virtio/virtio/v1.0/cs01/virtio-v1.0-cs01.html#x1-690004
> 
> ... doesn't match what qemu is doing.  Huh?

Wow! And I made the same bug in the guest too.
Good catch, will fix both up.

> 
> Also note:
> 
> [root@fedora ~]# ~kraxel/projects/pciutils/lspci -vvsa
> 00:0a.0 Communication controller: Red Hat, Inc Virtio console
> [ ... ]
> 	Capabilities: [64] VirtIO: Notify
> 		BAR=2 offset=00003000 size=00400000
> 		multiplier=00010000
> [ ... ]
> 
> Why multiplier is 64k instead of 4k?  Just a tyops?
> 
> 
> cheers,
>   Gerd
> 

Just in case :) I'll make it smaller, will address your concerns
about BAR size in a simple way.


> >From 0d5d99c20b079c986128c3d98c4bbaba51ebe65c Mon Sep 17 00:00:00 2001
> From: Gerd Hoffmann <kraxel@redhat.com>
> Date: Mon, 19 Jan 2015 11:46:37 +0100
> Subject: [PATCH] add virtio vendor caps
> 
> ---
>  Makefile         |  2 +-
>  ls-caps-vendor.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ls-caps.c        |  9 ++++++++-
>  lspci.h          |  4 ++++
>  4 files changed, 70 insertions(+), 2 deletions(-)
>  create mode 100644 ls-caps-vendor.c
> 
> diff --git a/Makefile b/Makefile
> index 8d49afa..39a07d1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -69,7 +69,7 @@ force:
>  lib/config.h lib/config.mk:
>  	cd lib && ./configure
>  
> -lspci: lspci.o ls-vpd.o ls-caps.o ls-ecaps.o ls-kernel.o ls-tree.o ls-map.o common.o lib/$(PCILIB)
> +lspci: lspci.o ls-vpd.o ls-caps.o ls-caps-vendor.o ls-ecaps.o ls-kernel.o ls-tree.o ls-map.o common.o lib/$(PCILIB)
>  setpci: setpci.o common.o lib/$(PCILIB)
>  
>  LSPCIINC=lspci.h pciutils.h $(PCIINC)
> diff --git a/ls-caps-vendor.c b/ls-caps-vendor.c
> new file mode 100644
> index 0000000..5f8b3e1
> --- /dev/null
> +++ b/ls-caps-vendor.c
> @@ -0,0 +1,57 @@
> +/*
> + *	The PCI Utilities -- Show Vendor-specific Capabilities
> + *
> + *	Copyright (c) 2014 Gerd Hoffmann <kraxel@redhat.com>
> + *
> + *	Can be freely distributed and used under the terms of the GNU GPL.
> + */
> +
> +#include <stdio.h>
> +#include <string.h>
> +
> +#include "lspci.h"
> +
> +void
> +show_vendor_caps_virtio(struct device *d, int where, int cap)
> +{
> +  int length = BITS(cap, 0, 8);
> +  int type = BITS(cap, 8, 5);
> +  int bar = BITS(cap, 13, 3);
> +  char *tname;
> +
> +  if (length < 12)
> +    return;
> +  if (!config_fetch(d, where, length))
> +    return;
> +
> +  switch (type) {
> +  case 1:
> +      tname = "CommonCfg";
> +      break;
> +  case 2:
> +      tname = "Notify";
> +      break;
> +  case 3:
> +      tname = "ISR";
> +      break;
> +  case 4:
> +      tname = "DeviceCfg";
> +      break;
> +  default:
> +      tname = "<unknown>";
> +      break;
> +  }
> +
> +  printf("VirtIO: %s\n", tname);
> +
> +  if (verbose < 2)
> +    return;
> +
> +  printf("\t\tBAR=%d offset=%08x size=%08x\n", bar,
> +         get_conf_long(d, where+4),
> +         get_conf_long(d, where+8));
> +  if (type != 2 || length < 16)
> +    return;
> +  printf("\t\tmultiplier=%08x\n",
> +         get_conf_long(d, where+12));
> +}
> diff --git a/ls-caps.c b/ls-caps.c
> index 7de55ef..438b580 100644
> --- a/ls-caps.c
> +++ b/ls-caps.c
> @@ -1315,7 +1315,14 @@ show_caps(struct device *d, int where)
>  	      cap_ht(d, where, cap);
>  	      break;
>  	    case PCI_CAP_ID_VNDR:
> -	      printf("Vendor Specific Information: Len=%02x <?>\n", BITS(cap, 0, 8));
> +              switch (get_conf_word(d, PCI_VENDOR_ID)) {
> +              case 0x1af4: /* Red Hat, devices 0x1000 -> 0x107f are virtio */
> +                show_vendor_caps_virtio(d, where, cap);
> +                break;
> +              default:
> +                printf("Vendor Specific Information: Len=%02x <?>\n", BITS(cap, 0, 8));
> +                break;
> +              }
>  	      break;
>  	    case PCI_CAP_ID_DBG:
>  	      cap_debug_port(cap);
> diff --git a/lspci.h b/lspci.h
> index 86429b2..5ca9899 100644
> --- a/lspci.h
> +++ b/lspci.h
> @@ -70,6 +70,10 @@ void show_caps(struct device *d, int where);
>  
>  void show_ext_caps(struct device *d);
>  
> +/* ls-caps-vendor.c */
> +
> +void show_vendor_caps_virtio(struct device *d, int where, int cap);
> +
>  /* ls-kernel.c */
>  
>  void show_kernel_machine(struct device *d UNUSED);
> -- 
> 1.8.3.1
> 

