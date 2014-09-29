Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaI2XGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:06:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55734 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751946AbaI2XGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:06:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@infradead.org>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] dell-wmi: Fix access out of memory
Date: Tue, 30 Sep 2014 01:26:03 +0200
Message-ID: <3073358.myrKz9QbdW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140929213028.GB34181@vmdeb7>
References: <1411996251-13455-1-git-send-email-pali.rohar@gmail.com> <20140929213028.GB34181@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 29, 2014 02:30:29 PM Darren Hart wrote:
> On Mon, Sep 29, 2014 at 03:10:51PM +0200, Pali Rohár wrote:
> > Without this patch driver dell-wmi is trying to access elements of dynamically
> > allocated array without checking array size. This can lead to memory corruption
> > or kernel panic. This patch adds missing checks for array size.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Looks good to me. Rafael, any concerns?

Not anything obvious.

> 
> Cc: linux-acpi

Thanks!


> > ---
> > This patch should be probably applied to stable kernel trees as it fixing
> > possible memory corruption.
> > ---
> >  drivers/platform/x86/dell-wmi.c |   12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
> > index 390e8e3..25721bf 100644
> > --- a/drivers/platform/x86/dell-wmi.c
> > +++ b/drivers/platform/x86/dell-wmi.c
> > @@ -163,18 +163,24 @@ static void dell_wmi_notify(u32 value, void *context)
> >  		const struct key_entry *key;
> >  		int reported_key;
> >  		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
> > +		int buffer_size = obj->buffer.length/2;
> >  
> > -		if (dell_new_hk_type && (buffer_entry[1] != 0x10)) {
> > +		if (buffer_size >= 2 && dell_new_hk_type && buffer_entry[1] != 0x10) {
> >  			pr_info("Received unknown WMI event (0x%x)\n",
> >  				buffer_entry[1]);
> >  			kfree(obj);
> >  			return;
> >  		}
> >  
> > -		if (dell_new_hk_type || buffer_entry[1] == 0x0)
> > +		if (buffer_size >= 3 && (dell_new_hk_type || buffer_entry[1] == 0x0))
> >  			reported_key = (int)buffer_entry[2];
> > -		else
> > +		else if (buffer_size >= 2)
> >  			reported_key = (int)buffer_entry[1] & 0xffff;
> > +		else {
> > +			pr_info("Received unknown WMI event\n");
> > +			kfree(obj);
> > +			return;
> > +		}
> >  
> >  		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
> >  							reported_key);
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
