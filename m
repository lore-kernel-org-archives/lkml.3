Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966758AbaFTLHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:07:43 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41315 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbaFTLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:07:41 -0400
MIME-Version: 1.0
Date: Fri, 20 Jun 2014 13:07:39 +0200
X-Google-Sender-Auth: IVzQYhbqmTOHv_3T6TYVGyNITTk
Message-ID: <CAMuHMdVhU6JZFzuPkx=wtLcPYc7wwaMFwCrZu=zG7PmCYssy-g@mail.gmail.com>
Subject: [-next] comedi I/O accessor name clashes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>, Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9c340ac934dbbfd46e776465b08391baac32d486
Author: H Hartley Sweeten <hsweeten@visionengravers.com>
Date:   Thu May 29 10:56:32 2014 -0700

    staging: comedi: ni_stc.h: add read/write callbacks to struct ni_private

--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -1421,6 +1421,13 @@ struct ni_board_struct {
 #define NUM_GPCT       2

 struct ni_private {
+       uint8_t (*readb)(struct comedi_device *, int reg);
+       uint16_t (*readw)(struct comedi_device *, int reg);
+       uint32_t (*readl)(struct comedi_device *, int reg);
+       void (*writeb)(struct comedi_device *, uint8_t value, int reg);
+       void (*writew)(struct comedi_device *, uint16_t value, int reg);
+       void (*writel)(struct comedi_device *, uint32_t value, int reg);
+
        uint16_t (*stc_readw)(struct comedi_device *, int reg);
        uint32_t (*stc_readl)(struct comedi_device *, int reg);
        void (*stc_writew)(struct comedi_device *, uint16_t value, int reg);

However, on several architectures, writel() and friends are macros, causing:

drivers/staging/comedi/drivers/ni_atmio.c:318:38: error: macro
"writew" passed 3 arguments, but takes just 2

m68k http://kisskb.ellerman.id.au/kisskb/buildresult/11346953/
s390 kisskb.ellerman.id.au/kisskb/buildresult/11347163/
sparc64 kisskb.ellerman.id.au/kisskb/buildresult/11347152/
xtensa http://kisskb.ellerman.id.au/kisskb/buildresult/11346651/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
