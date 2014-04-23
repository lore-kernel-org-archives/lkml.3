Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaDWXSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaDWXSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:18:21 -0400
Message-ID: <1398295096.2673.17.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
From: Adam Williamson <awilliam@redhat.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dougvj@gmail.com
Date: Wed, 23 Apr 2014 16:18:16 -0700
In-Reply-To: <20140423122344.GX30677@intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	 <5353A1F6.60602@linux.intel.com> <5353B8A4.1080900@linux.intel.com>
	 <1398007690.2674.0.camel@adam.happyassassin.net>
	 <5354BA59.2000008@linux.intel.com> <53551D0F.40906@linux.intel.com>
	 <CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
	 <1398230210.2704.8.camel@adam.happyassassin.net>
	 <20140423083430.GV30677@intel.com> <20140423122344.GX30677@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 15:23 +0300, Mika Westerberg wrote:
> On Wed, Apr 23, 2014 at 11:34:30AM +0300, Mika Westerberg wrote:
> > On Tue, Apr 22, 2014 at 10:16:50PM -0700, Adam Williamson wrote:
> > > Well, I can't actually concur. See my results in
> > > https://bugzilla.kernel.org/show_bug.cgi?id=68291#c44 .
> > > 
> > > 1. A kernel with neither patch applied (and no hid-rmi driver) results
> > > in a working touchscreen.
> > > 2. A kernel with only v3 of Doug's patch from
> > > https://bugzilla.kernel.org/show_bug.cgi?id=67921 results in a working
> > > touchscreen.
> > > 3. A kernel with both v3 of Doug's patch and this IRQ descriptor
> > > conflict "fix" results in a broken touchscreen.
> > > 
> > > Seems to me there really is some kind of problem with this patch...
> > 
> > Can you try so that you have both patches applied and then this one? I'm
> > suspecting that the ACPI GPIO operation region support might do something
> > unexpected in this case.
> 
> I'm able to reproduce this problem here now and it seems not related to the
> ACPI GPIO operation regions.
> 
> This patch changes call to irq_domain_add_linear() to
> irq_domain_add_simple() and somehow that changes the behaviour so that I
> get non-working touchscreen:
> 
> ...
> [   37.434998] i2c_hid i2c-ATML1000:00: failed to reset device.
> [   37.435009] i2c_hid i2c-ATML1000:00: i2c_hid_set_power
> [   37.435021] i2c_hid i2c-ATML1000:00: __i2c_hid_command: cmd=fb 00 01 08
> [   38.439897] i2c_hid i2c-ATML1000:00: can't add hid device: -61
> [   38.440749] i2c_hid: probe of i2c-ATML1000:00 failed with error -61
> 
> It never gets an interrupt when the device reset is ready.
> 
> Jin, do you have any idea what is going on?

Well, hum - I did an encore:

4. A kernel with this IRQ descriptor conflict 'fix' but *without* Doug's
patch results in a working touch screen.

So unless I made a mistake somewhere, it looks like it's really the
combination of patches that causes trouble. Neither
http://dougvj.net/baytrail_gpio_quirk_v3.patch nor this patch alone
breaks the touch screen, but the combination of the two does.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

