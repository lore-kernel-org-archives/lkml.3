Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaI2XQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:16:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaI2XQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:16:33 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <3073358.myrKz9QbdW@vostro.rjw.lan>
References: <1411996251-13455-1-git-send-email-pali.rohar@gmail.com> <20140929213028.GB34181@vmdeb7> <3073358.myrKz9QbdW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] dell-wmi: Fix access out of memory
From: Darren Hart <dvhart@infradead.org>
Date: Mon, 29 Sep 2014 16:16:23 -0700
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Message-ID: <55C20A75-AB0A-4A4E-9E91-3428B5F868BB@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On September 29, 2014 4:26:03 PM PDT, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
>On Monday, September 29, 2014 02:30:29 PM Darren Hart wrote:
>> On Mon, Sep 29, 2014 at 03:10:51PM +0200, Pali Rohár wrote:
>> > Without this patch driver dell-wmi is trying to access elements of
>dynamically
>> > allocated array without checking array size. This can lead to
>memory corruption
>> > or kernel panic. This patch adds missing checks for array size.
>> > 
>> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> 
>> Looks good to me. Rafael, any concerns?
>
>Not anything obvious.

Queued, thanks.

>
>> 
>> Cc: linux-acpi
>
>Thanks!
>
>
>> > ---
>> > This patch should be probably applied to stable kernel trees as it
>fixing
>> > possible memory corruption.
>> > ---
>> >  drivers/platform/x86/dell-wmi.c |   12 +++++++++---
>> >  1 file changed, 9 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/drivers/platform/x86/dell-wmi.c
>b/drivers/platform/x86/dell-wmi.c
>> > index 390e8e3..25721bf 100644
>> > --- a/drivers/platform/x86/dell-wmi.c
>> > +++ b/drivers/platform/x86/dell-wmi.c
>> > @@ -163,18 +163,24 @@ static void dell_wmi_notify(u32 value, void
>*context)
>> >  		const struct key_entry *key;
>> >  		int reported_key;
>> >  		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
>> > +		int buffer_size = obj->buffer.length/2;
>> >  
>> > -		if (dell_new_hk_type && (buffer_entry[1] != 0x10)) {
>> > +		if (buffer_size >= 2 && dell_new_hk_type && buffer_entry[1] !=
>0x10) {
>> >  			pr_info("Received unknown WMI event (0x%x)\n",
>> >  				buffer_entry[1]);
>> >  			kfree(obj);
>> >  			return;
>> >  		}
>> >  
>> > -		if (dell_new_hk_type || buffer_entry[1] == 0x0)
>> > +		if (buffer_size >= 3 && (dell_new_hk_type || buffer_entry[1] ==
>0x0))
>> >  			reported_key = (int)buffer_entry[2];
>> > -		else
>> > +		else if (buffer_size >= 2)
>> >  			reported_key = (int)buffer_entry[1] & 0xffff;
>> > +		else {
>> > +			pr_info("Received unknown WMI event\n");
>> > +			kfree(obj);
>> > +			return;
>> > +		}
>> >  
>> >  		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
>> >  							reported_key);
>> 
>> 

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
