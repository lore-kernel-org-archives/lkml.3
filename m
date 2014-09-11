Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaIKVC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:02:56 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:50807 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaIKVCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:02:55 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>
CC: Robert Baldyga <r.baldyga@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] usb: dwc2: Revert patches causing problems
Thread-Topic: [PATCH 0/2] usb: dwc2: Revert patches causing problems
Thread-Index: AQHPzb9uAjbYlQN8gkubjUs9hysZ/5v8S7ZQgAACbVCAABuy4A==
Date: Thu, 11 Sep 2014 21:02:39 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844D6745@US01WEMBX2.internal.synopsys.com>
References: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
  <A2CA0424C0A6F04399FB9E1CD98E0304844D66E5@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844D66E5@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Paul Zimmerman
> Sent: Thursday, September 11, 2014 1:10 PM
> 
> > From: Paul Zimmerman
> > Sent: Thursday, September 11, 2014 12:11 PM
> >
> > > From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> > > Sent: Thursday, September 11, 2014 5:53 AM
> > >
> > > These two patches breaks dwc2 driver. The first one causes build break,
> > > the second breaks gadget at Samsung platforms.
> > >
> > > Best regards
> > > Robert Baldyga
> > >
> > > Robert Baldyga (2):
> > >   Revert "usb: dwc2: Update Kconfig to support dual-role"
> > >   Revert "usb: dwc2: move "samsung,s3c6400-hsotg" into common platform"
> > >
> > >  drivers/usb/dwc2/Kconfig    | 63 +++++++++++++++++++--------------------------
> > >  drivers/usb/dwc2/Makefile   | 21 +++++++--------
> > >  drivers/usb/dwc2/gadget.c   |  1 +
> > >  drivers/usb/dwc2/platform.c |  1 -
> > >  4 files changed, 38 insertions(+), 48 deletions(-)
> >
> > Yep, I can confirm the build breakage. Greg, we should revert these two
> > before you send your update for the next -rc, if it's not too late.
> >
> > Dinh, before resending the series, please test that each individual
> > patch does not break the build.
> 
> FYI, I see the build breakage when using ARM multi_v7_defconfig,
> with the mass-storage gadget enabled and dwc2 enabled for
> peripheral-only mode:
> 
>   CC      init/version.o
>   LD      init/built-in.o
> drivers/built-in.o: In function `dwc2_hc_set_even_odd_frame':
> :(.text+0x21ca0c): undefined reference to `dwc2_hcd_get_frame_number'
> drivers/built-in.o: In function `dwc2_handle_common_intr':
> :(.text+0x21f5dc): undefined reference to `dwc2_hcd_start'
> :(.text+0x21f660): undefined reference to `dwc2_hcd_start'
> :(.text+0x21f7c4): undefined reference to `dwc2_hcd_start'
> :(.text+0x21f974): undefined reference to `dwc2_hcd_disconnect'

Hi Dinh,

This change, after applying your first patch, fixes the build breakage
for me:


--- a/drivers/usb/dwc2/Makefile
+++ b/drivers/usb/dwc2/Makefile
@@ -2,9 +2,9 @@ ccflags-$(CONFIG_USB_DWC2_DEBUG)	+= -DDEBUG
 ccflags-$(CONFIG_USB_DWC2_VERBOSE)	+= -DVERBOSE_DEBUG
 
 obj-$(CONFIG_USB_DWC2)			+= dwc2.o
-dwc2-y					:= core.o core_intr.o
 
 ifneq ($(filter y,$(CONFIG_USB_DWC2_HOST) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
+	dwc2-y				+= core.o core_intr.o
 	dwc2-y				+= hcd.o hcd_intr.o
 	dwc2-y				+= hcd_queue.o hcd_ddma.o
 endif


I didn't test whether the resulting drivers actually work, though.
Maybe you could make that modification to your first patch, and then
add back the move of core.o and core_intr.o to a later patch when
the code is ready for it?

-- 
Paul

