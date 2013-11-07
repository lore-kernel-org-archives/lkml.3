Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3KGMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:09:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3KGMJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:09:25 -0500
Date: Thu, 7 Nov 2013 20:09:06 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi earlyprintk fix
Message-ID: <20131107120906.GB4116@dhcp-16-126.nay.redhat.com>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131106092335.GA3952@dhcp-16-126.nay.redhat.com>
 <20131106093832.GC22856@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106093832.GC22856@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 at 09:38am, Matt Fleming wrote:
> On Wed, 06 Nov, at 05:23:35PM, Dave Young wrote:
> > On 11/04/13 at 08:58pm, Dave Young wrote:
> > > On 11/04/13 at 10:37am, Matt Fleming wrote:
> > > > On Sun, 03 Nov, at 08:16:47PM, Dave Young wrote:
> > > > > 
> > > > > there's below one line shift problem:
> > > > > 
> > > > >                      ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
> > > > > [    0.000000] efi:  
> > > > > 
> > > > > In fact check efi_y and the lfb_height should be compared at the begin of the
> > > > > loop of early_efi_write
> > > >  
> > > > Hmm... this is interesting. I can't produce this on any of my machines.
> > > > Where did you see this? What hardware?
> > > 
> > > It's my laptop Thinkpad T420, the screen scolls very fast, I use boot_delay=500
> > > to verify it with my patch for moving boot_delay param an early param.
> > > 
> > > Even without boot_delay, there's always a line at bottom with only the prefix:
> > > "efi:"
> > 
> > I will do further debug if I got time on this. It's really helpful for having efi
> > earlyprintk, thanks for your excellent idea of printing to efi fb!
> 
> Thanks. I suspect the code in early_efi_setup() that sets up efi_y is
> somehow wrong.

Here is my debug message about the efifb params (all hex values):
[    0.000000] efi fb lfb width: 280
[    0.000000] efi fb lfb height: 1e0
[    0.000000] efi fb lfb base: e0000000
[    0.000000] efi fb lfb linelength: a00
[    0.000000] efi fb font height: 10
[    0.000000] efi fb font width: 8

The problem looks related to the pr_cont(), here is what I observed:
[    0.000000] efi: EFI v2.00 by Lenovo
                    ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
[    0.000000] efi: 

After relooking the code, below fix is more reasonable than my original one,
But I still confused why it only happens on this machine.

--- efi.orig/arch/x86/platform/efi/early_printk.c
+++ efi/arch/x86/platform/efi/early_printk.c
@@ -95,6 +95,7 @@ early_efi_write(struct console *con, con
 	while (num) {
 		unsigned int linemax;
 		unsigned int h, count = 0;
+		bool linebreak = false;
 
 		for (s = str; *s && *s != '\n'; s++) {
 			if (count == num)
@@ -135,14 +136,16 @@ early_efi_write(struct console *con, con
 			efi_y += font->height;
 			str++;
 			num--;
+			linebreak = true;
 		}
 
 		if (efi_x >= si->lfb_width) {
 			efi_x = 0;
 			efi_y += font->height;
+			linebreak = true;
 		}
 
-		if (efi_y + font->height >= si->lfb_height) {
+		if (linebreak && (efi_y + font->height >= si->lfb_height)) {
 			u32 i;
 
 			efi_y -= font->height;
